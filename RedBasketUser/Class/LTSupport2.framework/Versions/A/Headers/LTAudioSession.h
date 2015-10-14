//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class LTAudioSession;

@protocol LTAudioSessionDelegate <NSObject>

@optional

-(void)audioSessionWillInterrupt:(LTAudioSession*)audioSession;
-(void)audioSessionDidInterrupt:(LTAudioSession*)audioSession;
-(BOOL)audioSessionShouldContinue:(LTAudioSession*)audioSession;
-(void)audioSessionWillContinue:(LTAudioSession*)audioSession;
-(void)audioSessionDidContinue:(LTAudioSession*)audioSession;
-(void)audioSession:(LTAudioSession*)audioSession didChangeRouteFrom:(NSString*)from to:(NSString*)to;

@end

@interface LTAudioSession : NSObject
{
}

@property(nonatomic,assign) id<LTAudioSessionDelegate> delegate;
@property(nonatomic,retain,readonly) NSString* route;

+(id)audioSessionWithCategory:(UInt32)audioCategory;
-(id)initWithCategory:(UInt32)audioCategory;

-(void)setActive;
-(void)setInactive;

@end

@interface LTDummyAudioSession : LTAudioSession
@end

