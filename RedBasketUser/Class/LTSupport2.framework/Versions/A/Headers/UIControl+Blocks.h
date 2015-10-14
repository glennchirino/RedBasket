//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

@interface UIControl (Blocks)

-(void)LT_addHandlerForControlEvents:(UIControlEvents)events usingBlock:(NSObjectVoidBlock)block;
-(void)LT_removeHandlerForControlEvents:(UIControlEvents)events;

@end

@interface UIControl (AudioEvents)

-(void)LT_addAudioEventWithKey:(NSString*)key forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;
-(void)LT_removeAudioEventWithKey:(NSString*)key forControlEvents:(UIControlEvents)controlEvents UI_APPEARANCE_SELECTOR;

@end