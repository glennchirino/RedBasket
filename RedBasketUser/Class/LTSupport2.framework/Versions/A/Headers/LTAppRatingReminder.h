//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LTAppRatingReminderSleeping,
    LTAppRatingReminderDone
} LTAppReminderState;

@interface LTAppRatingReminder : NSObject
{
    NSUInteger          limit;
    LTAppReminderState  state;
}

@property(nonatomic,assign) NSUInteger          limit;
@property(nonatomic,assign) LTAppReminderState  state;

+(LTAppRatingReminder*)sharedAppRatingReminderForAppID:(NSString*)newId withDelay:(float)delay maxStarts:(NSUInteger)limit;

@end
