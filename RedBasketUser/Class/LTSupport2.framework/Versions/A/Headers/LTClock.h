//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTClock;

@protocol LTClockDelegate <NSObject>

@optional
-(void)minuteTickByClock:(LTClock*)clock;
-(void)alarmByClock:(LTClock*)clock;

@end


@interface LTClock : NSObject

@property (weak, nonatomic) id<LTClockDelegate> delegate;

@property (nonatomic, readonly) NSUInteger  minute;
@property (nonatomic, readonly) NSUInteger  hour;
@property (nonatomic, readonly) NSInteger   alarmMinute;

+(id)sharedClockWithDelegate:(id<LTClockDelegate>)adelegate;
+(id)sharedClock;

-(BOOL)isAlarmSet;
-(void)setAlarmMinute:(NSInteger)alarmMinute;
-(void)resetAlarm;

-(NSUInteger)getDifference;

@end

