//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extensions)

+(id)LT_labelWithFrame:(CGRect)aframe text:(NSString*)string;
+(id)LT_labelWithText:(NSString*)text font:(UIFont*)font textColor:(UIColor*)textColor;

-(void)LT_alignTop;
-(void)LT_alignBottom;

-(void)LT_setText:(NSString*)newText animated:(BOOL)animated;

-(void)LT_sizeToFitFixedWidth:(CGFloat)width;

@end
