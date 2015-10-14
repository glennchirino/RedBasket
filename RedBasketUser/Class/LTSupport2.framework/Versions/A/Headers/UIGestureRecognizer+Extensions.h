//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

@interface UIGestureRecognizer (Extensions)

-(void)LT_addBlock:(NSObjectVoidBlock)block;

@end


@interface UITapGestureRecognizer (Extensions)

+(id)LT_tapGestureRecognizerWithBlock:(NSObjectVoidBlock)block;

@end

@interface UISwipeGestureRecognizer (Extensions)

+(id)LT_swipeGestureRecognizerWithBlock:(NSObjectVoidBlock)block;

@end
