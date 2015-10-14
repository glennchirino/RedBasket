//
//  Copyright 2010 Instinctive Code. Written by Matt Gemmell.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

-(UIImage*)imageTintedWithColor:(UIColor*)color;
-(UIImage*)imageTintedWithColor:(UIColor*)color fraction:(CGFloat)fraction;

@end
