//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extensions)

-(void)LT_setAnimationImagesWithFormat:(NSString*)fileName start:(NSUInteger)start stop:(NSUInteger)stop;
-(void)LT_alignBottom;

+(id)LT_imageViewWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage;

@end
