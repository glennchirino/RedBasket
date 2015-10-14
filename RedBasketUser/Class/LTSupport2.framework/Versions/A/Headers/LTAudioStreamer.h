//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AudioStreamer.h" /* for AudioStreamerDelegate */
#import "LTAudioSession.h" /* for LTAudioSessionDelegate */

#define LTAudioStreamerStatusChangedNotification @"LTAudioStreamerStatusChangedNotification"
#define LTAudioStreamerNowPlayingChangedNotification @"LTAudioStreamerNowPlayingChangedNotification"
#define LTAudioStreamerBufferFillLevelChangedNotification @"LTAudioStreamerBufferFillLevelChangedNotification"

typedef enum _LTAudioStreamerStatus
{
    LTAudioStreamerStatusInitialized = 0,
    LTAudioStreamerStatusConnecting,
    LTAudioStreamerStatusBuffering,
    LTAudioStreamerStatusPlaying,
    LTAudioStreamerStatusPaused,
    LTAudioStreamerStatusFailed,
} LTAudioStreamerStatus;

@class LTAudioStreamer;
@class LTAudioStreamerStation;

@protocol LTAudioStreamerDelegate <NSObject>

@optional

-(void)audioStreamer:(LTAudioStreamer*)streamer didReceiveStreamTitle:(NSString*)title;
-(void)audioStreamer:(LTAudioStreamer*)streamer didChangeStateTo:(NSString*)state;
-(void)audioStreamer:(LTAudioStreamer*)streamer didFailWithError:(NSError*)error;

@end

@interface LTAudioStreamer : NSObject <AudioStreamerDelegate, LTAudioSessionDelegate>

@property(nonatomic,retain) NSString* streamOrPlaylist;

@property(nonatomic,assign) BOOL failSilently;
@property(nonatomic,assign) id<LTAudioStreamerDelegate> delegate;

@property(nonatomic,readonly) NSUInteger bitRate;
@property(nonatomic,readonly) double progress;
@property(nonatomic,readonly) double duration;
@property(nonatomic,readonly) float bufferFillLevel;

@property(nonatomic,assign) BOOL silent;
@property(nonatomic,getter = isLevelMeteringEnabled) BOOL levelMeteringEnabled;
@property(nonatomic,assign,readonly,getter = isRecording) BOOL recording;
@property(nonatomic,retain) NSString* recordingPath;

@property(strong,nonatomic) LTAudioStreamerStation* nowPlaying;
@property(nonatomic,retain) NSString* url; // actual streaming URL, not necessarily the same as nowPlaying's URL
@property(assign,readonly,nonatomic) LTAudioStreamerStatus status;
@property(nonatomic,readonly) NSString* statusKey;

+(id)audioStreamer;
+(id)audioStreamerWithStreamOrPlaylist:(NSString*)aurl;
-(void)streamFromStreamOrPlaylist:(NSString*)aurl;
-(void)streamFromStation:(LTAudioStreamerStation*)station;

// level metering
-(float)averagePowerForChannel:(NSUInteger)channel;
-(float)peakPowerForChannel:(NSUInteger)channel;

// playback control
-(void)seekToTime:(double)seekTime;
-(void)pausePlayback;
-(void)resumePlayback;
-(void)togglePlayPause;
-(void)stop;
-(void)stopSilently;

// recording
-(void)startRecordingToPath:(NSString*)path;
-(void)stopRecording;

@end
