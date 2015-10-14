//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTArcTextLabel : UIView

@property(strong,nonatomic) UIFont* font;
@property(strong,nonatomic) UIColor* color;
@property(strong,nonatomic) NSString* text;
@property(assign,nonatomic) UITextAlignment textAlignment;
@property(assign,nonatomic) CGFloat radius;
@property(assign,nonatomic) CGFloat arcStart;
@property(assign,nonatomic) CGFloat arcSize;
@property(assign,nonatomic) CGFloat shiftH;
@property(assign,nonatomic) CGFloat shiftV;
@property(assign,nonatomic) BOOL clockwise;

@property(assign,nonatomic) BOOL debugMode;

@end
