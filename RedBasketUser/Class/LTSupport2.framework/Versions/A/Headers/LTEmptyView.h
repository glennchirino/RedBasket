//
//  Copyright 2009 Devin Ross as part of TAPKU library.
//  Copyright 2012 Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTEmptyView : UIView

@property(strong,nonatomic) UIImageView* imageView;
@property(strong,nonatomic) UILabel* titleLabel;
@property(strong,nonatomic) UILabel* subtitleLabel;
@property(strong,nonatomic) UIColor* tintColor;

+(id)emptyViewWithMask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString;

+(id)emptyViewWithTintColor:(UIColor*)tintColor mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString;

+(id)emptyViewWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString;
-(id)initWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString;
-(void)setImage:(UIImage*)image;

@end
