//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "late_macros.h"

#import "LTTrackingEvent.h"

#import <Foundation/Foundation.h>

static const NSUInteger LTEventTrackerMaximumNumberOfEventsInBuffer = 1000;

@interface LTEventTracker : NSObject

LT_SINGLETON_INTERFACE_FOR_CLASS(LTEventTracker, sharedInstance);

@property (nonatomic, strong) NSMutableArray* events;

-(void)deleteAllEvents;
-(void)trackEvent:(LTTrackingEventType)eventType withData:(NSString*)data;

@end
