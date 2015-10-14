//
//  AudioStreamer.m
//  (C) 2010-2013 Lauer, Teuber GbR
//
//  Based on code of Matt Gallagher and Mike Jablonski.
//  Copyright 2008-2009 Matt Gallagher. All rights reserved.
//  Copyright 2009 Mike Jablonski.
//  Copyright 2010, 2011, 2012, 2013 Dr. Michael Lauer.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#ifdef TARGET_OS_IPHONE			
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif // TARGET_OS_IPHONE			

#include <pthread.h>
#include <AudioToolbox/AudioToolbox.h>

#define LOG_QUEUED_BUFFERS 0

#define kNumAQBufs 16			// Number of audio queue buffers we allocate.
								// Needs to be big enough to keep audio pipeline
								// busy (non-zero number of queued buffers) but
								// not so big that audio takes too long to begin
								// (kNumAQBufs * kAQBufSize of data must be
								// loaded before playback will start).
								//
								// Set LOG_QUEUED_BUFFERS to 1 to log how many
								// buffers are queued at any time -- if it drops
								// to zero too often, this value may need to
								// increase. Min 3, typical 8-24.

#define kAQDefaultBufSize 8192

//#define kAQDefaultBufSize 2048	// Number of bytes in each audio queue buffer
								// Needs to be big enough to hold a packet of
								// audio from the audio file. If number is too
								// large, queuing of audio before playback starts
								// will take too long.
								// Highly compressed files can use smaller
								// numbers (512 or less). 2048 should hold all
								// but the largest packets. A buffer size error
								// will occur if this number is too small.

#define kAQMaxPacketDescs 512	// Number of packet descriptions in our array

typedef enum
{
	AS_INITIALIZED = 0,
	AS_STARTING_FILE_THREAD,
	AS_WAITING_FOR_DATA,
	AS_FLUSHING_EOF,
	AS_WAITING_FOR_QUEUE_TO_START,
	AS_PLAYING,
	AS_BUFFERING,
	AS_STOPPING,
	AS_STOPPED,
	AS_PAUSED
} AudioStreamerState;

typedef enum
{
	AS_NO_STOP = 0,
	AS_STOPPING_EOF,
	AS_STOPPING_USER_ACTION,
	AS_STOPPING_ERROR,
	AS_STOPPING_TEMPORARILY
} AudioStreamerStopReason;

typedef enum
{
	AS_NO_ERROR = 0,
	AS_NETWORK_CONNECTION_FAILED,
	AS_FILE_STREAM_GET_PROPERTY_FAILED,
	AS_FILE_STREAM_SEEK_FAILED,
	AS_FILE_STREAM_PARSE_BYTES_FAILED,
	AS_FILE_STREAM_OPEN_FAILED,
	AS_FILE_STREAM_CLOSE_FAILED,
	AS_AUDIO_DATA_NOT_FOUND,
	AS_AUDIO_QUEUE_CREATION_FAILED,
	AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED,
	AS_AUDIO_QUEUE_ENQUEUE_FAILED,
	AS_AUDIO_QUEUE_ADD_LISTENER_FAILED,
	AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED,
	AS_AUDIO_QUEUE_START_FAILED,
	AS_AUDIO_QUEUE_PAUSE_FAILED,
	AS_AUDIO_QUEUE_BUFFER_MISMATCH,
	AS_AUDIO_QUEUE_DISPOSE_FAILED,
	AS_AUDIO_QUEUE_STOP_FAILED,
	AS_AUDIO_QUEUE_FLUSH_FAILED,
	AS_AUDIO_STREAMER_FAILED,
	AS_GET_AUDIO_TIME_FAILED,
	AS_AUDIO_BUFFER_TOO_SMALL,
	AS_PLAYLIST_PARSE_FAILED,
} AudioStreamerErrorCode;

extern NSString * const ASStatusChangedNotification;

@protocol AudioStreamerDelegate <NSObject>

@optional
-(BOOL)shouldStreamWithContentType:(NSString*)type;
-(void)receivedMetaInformation:(NSString*)meta;
-(void)receivedStreamBytes:(NSNumber*)bytes;
-(void)updatedBufferStatus:(float)status;
-(void)didStartRecording;
-(void)didStopRecording;
@end

@interface AudioStreamer : NSObject
{
	NSURL *url;

@private
	id<AudioStreamerDelegate> delegate;
    
	//
	// Special threading consideration:
	//	The audioQueue property should only ever be accessed inside a
	//	synchronized(self) block and only *after* checking that ![self isFinishing]
	//
	AudioQueueRef audioQueue;
	AudioFileStreamID audioFileStream;	// the audio file stream parser
	AudioStreamBasicDescription asbd;	// description of the audio
	NSThread *internalThread;			// the thread where the download and
										// audio file stream parsing occurs
	
	AudioQueueBufferRef audioQueueBuffer[kNumAQBufs];		// audio queue buffers
	AudioStreamPacketDescription packetDescs[kAQMaxPacketDescs];	// packet descriptions for enqueuing audio
	unsigned int fillBufferIndex;	// the index of the audioQueueBuffer that is being filled
	UInt32 packetBufferSize;
	size_t bytesFilled;				// how many bytes have been filled
	size_t packetsFilled;			// how many packets have been filled
	unsigned int metaDataInterval;		// how many data bytes between meta data
	unsigned int metaDataBytesRemaining;	// how many bytes of metadata remain to be read
	unsigned int dataBytesRead;			// how many bytes of data have been read

	BOOL inuse[kNumAQBufs];			// flags to indicate that a buffer is still in use
	NSInteger buffersUsed;

	NSDictionary* httpHeaders;		// holds HTTP headers
	NSString* streamType;
	NSMutableData* metaDataString;

	AudioStreamerState state;
	AudioStreamerErrorCode errorCode;
	OSStatus err;

	BOOL localFile;             // whether we're streaming from a local file
	BOOL parsedHeaders;         // whether we've parsed the headers yet
	BOOL foundIcyStart;         // true, if we have found an Icecast stream header
	BOOL foundIcyEnd;           // true, if we found the end of the Icecast stream header
	BOOL discontinuous;			// flag to indicate middle of the stream, will take extra-caution to look for the beginning of a packet
	
	pthread_mutex_t queueBuffersMutex;			// a mutex to protect the inuse flags
	pthread_cond_t queueBufferReadyCondition;	// a condition varable for handling the inuse flags

	CFReadStreamRef stream;
	NSNotificationCenter *notificationCenter;
	
	UInt32 bitRate;				// Bits per second in the file
	NSInteger dataOffset;		// Offset of the first audio packet in the stream
	long fileLength;		// Length of the file in bytes
	long seekByteOffset;	// Seek offset within the file in bytes
	UInt64 audioDataByteCount;  // Used when the actual number of audio bytes in
								// the file is known (more accurate than assuming
								// the whole file is audio)

	UInt64 processedPacketsCount;		// number of packets accumulated for bitrate estimation
	UInt64 processedPacketsSizeTotal;	// byte size of accumulated estimation packets

	UInt64 receivedStreamBytes; // number of raw bytes received from stream
	
	NSUInteger formatFailCounter;

	double seekTime;
	BOOL seekWasRequested;
	double requestedSeekTime;

	double sampleRate;			// Sample rate of the file (used to compare with
								// samples played by the queue for current playback
								// time)
	double packetDuration;		// sample rate times frames per packet
	double lastProgress;		// last calculated progress point
    float lastBufferFillLevel;  // buffer fill level (0.0 - 1.0)

    // recording
    AudioFileID recordFileID;
    NSString* recordingPath;
    UInt64 processedRecordingPacketsCount;
}

@property AudioStreamerErrorCode errorCode;
@property (readonly,retain) NSURL* url;
@property (readonly) AudioStreamerState state;
@property (readonly) AudioStreamerStopReason stopReason;
@property (readonly) NSString* friendlyState;
@property (readonly) double progress;
@property (readonly) float  bufferFillLevel;

@property (readonly) double duration;
@property (assign, getter=isMeteringEnabled) BOOL meteringEnabled;
@property (readwrite) UInt32 bitRate;
@property (readonly) UInt32 numberOfChannels;

@property (readonly) NSDictionary *httpHeaders;
@property (readonly) NSString* streamType;
@property (assign) BOOL silent;

@property (readonly,getter=isRecording) BOOL recording;
@property (retain,readonly) NSString* recordingPath;

- (id)initWithURL:(NSURL*)aURL delegate:(id<AudioStreamerDelegate>)target;
- (id)initWithLocalFileURL:(NSURL*)aURL delegate:(id<AudioStreamerDelegate>)target;

- (void)start;
- (void)stop;
- (void)pause;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (BOOL)isWaiting;
- (BOOL)isIdle;
- (void)seekToTime:(double)newSeekTime;
- (double)calculatedBitRate;
- (float)peakPowerForChannel:(NSUInteger)channelNumber;
- (float)averagePowerForChannel:(NSUInteger)channelNumber;

- (void)startRecordingToPath:(NSString*)recordFile withInfoDictionary:(NSDictionary*)dict;
- (void)stopRecording;

@end

