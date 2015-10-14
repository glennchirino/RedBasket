//
//  UIBarButtonItem+LaTe.h
//  LTSupport2
//
//  Created by Michael Lauer on 09.07.12.
//  Copyright (c) 2012 Lauer, Teuber. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

@interface UIBarButtonItem (LaTe)

+(id)LT_barButtonSystemItem:(UIBarButtonSystemItem)systemItem withBlock:(NSObjectVoidBlock)block;

+(id)LT_barButtonItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style withBlock:(NSObjectVoidBlock)block;

+(id)LT_barButtonItemWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style withBlock:(NSObjectVoidBlock)block;

+(id)LT_barButtonItemWithView:(UIView*)view style:(UIBarButtonItemStyle)style withBlock:(NSObjectVoidBlock)block;

@end
