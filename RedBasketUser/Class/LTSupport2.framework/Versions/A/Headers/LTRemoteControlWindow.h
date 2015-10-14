//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTRemoteControlDelegate <NSObject>

@optional

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent*)event;
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event;
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*)event;
-(void)remoteControlReceivedWithEvent:(UIEvent*)event;

@end

@interface LTRemoteControlWindow : UIWindow

@end
