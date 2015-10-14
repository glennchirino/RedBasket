//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTTrackingEventType)
{
    STARTUP_EVENT = 0,
    FOREGROUND_EVENT,
    BACKGROUND_EVENT,
    PING_EVENT,
    CRASH_EVENT,
    TOKEN_EVENT
};

@interface LTTrackingEvent : NSObject

@property (nonatomic, assign) LTTrackingEventType type;
@property (nonatomic, assign) NSTimeInterval dateOfOrigin;
@property (nonatomic, strong) NSString* data;

+(instancetype)trackingEventWithType:(LTTrackingEventType)type;
+(instancetype)trackingEventWithType:(LTTrackingEventType)type data:(NSString*)data;

-(id)proxyForJson;

@end
