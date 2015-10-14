//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTLabel : UILabel

@property(assign,nonatomic) UIViewContentMode verticalAlignment;

@property(assign,nonatomic) CGFloat outlineWidth;
@property(strong,nonatomic) UIColor* outlineColor;

@end
