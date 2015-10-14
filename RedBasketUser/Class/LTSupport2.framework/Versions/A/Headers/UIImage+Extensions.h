//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTImageDrawingContextBlock)(CGContextRef context);

@interface UIImage (Shadow)
-(UIImage*)imageByAddingShadowWithDepth:(CGFloat)depth;
@end

@interface UIImage (Resizing)
-(UIImage*)imageByScalingToSize:(CGSize)size;
@end

@interface UIImage (Blur)
-(UIImage *)imageByBlurringWithGaussFactor:(int)gaussFactor pixelRadius:(int)pixelRadius;
@end

@interface UIImage (Text)
-(UIImage*)imageByDrawingText:(NSString*)text withFont:(UIFont*)font lineBreakMode:(UILineBreakMode)linebreakMode alignment:(UITextAlignment)alignment;

+(UIImage*)imageWithString:(NSString*)text withAttributes:(NSDictionary*)attributes inRect:(CGRect)rect;

@end

@interface UIImage (LTImageDrawing)
+(UIImage*)LT_imageByDrawingOnCanvasOfSize:(CGSize)size usingBlock:(LTImageDrawingContextBlock)block;
+(UIImage*)LT_imageWithSize:(CGSize)size color:(UIColor*)color;
+(UIImage*)LT_imageFromView:(UIView*)view;
@end

@interface UIImage (LTSupportBundle)
+(UIImage*)LT_imageFromSupportBundleNamed:(NSString*)name;
@end


@interface UIImage (MCDrawSubImage)
-(void)drawInRect:(CGRect)drawRect fromRect:(CGRect)fromRect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
@end

