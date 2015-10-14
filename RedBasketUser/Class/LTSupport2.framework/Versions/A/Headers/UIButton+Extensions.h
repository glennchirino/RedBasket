//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

typedef void(^UIButtonToggledBlock)(BOOL selected);

@interface UIButton (Extensions)

+(id)LT_buttonWithType:(UIButtonType)buttonType usingBlock:(NSObjectVoidBlock)block;
+(id)LT_customButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;
+(id)LT_customButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage usingBlock:(NSObjectVoidBlock)block;

-(void)LT_setToggleMode:(BOOL)on;

@end
