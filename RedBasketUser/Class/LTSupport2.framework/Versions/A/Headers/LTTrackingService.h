//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "late_macros.h"

@interface LTTrackingService : NSObject

LT_SINGLETON_INTERFACE_FOR_CLASS(LTTrackingService, sharedInstance);

-(void)sendToken:(NSString*)token;

@end
