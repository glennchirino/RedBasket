//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+BlockInvoke.h"

@interface NSObject (PerformBlockExtensions)

-(void)LT_performAfterDelay:(NSTimeInterval)delay block:(NSObjectVoidBlock)block;

-(void)LT_performOnMainThreadAfterDelay:(NSTimeInterval)delay block:(NSObjectVoidBlock)block;

@end
