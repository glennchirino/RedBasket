//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LaTe)

+(UIColor*)LT_registerColorByName:(NSString*)name red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha __deprecated; 
+(UIColor*)LT_colorByName:(NSString*)name __deprecated;

+(UIColor*)LT_groupTableViewBackgroundColor;

-(UIColor*)LT_colorByAdjustingBrightnessTo:(CGFloat)brightness;

@end
