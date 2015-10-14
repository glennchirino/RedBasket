//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTResourceCache : NSObject

+(UIFont*)registerFontByName:(NSString*)name font:(UIFont*)font;
+(UIColor*)registerColorByName:(NSString*)name color:(UIColor*)name;

+(UIFont*)fontByName:(NSString*)name;
+(UIColor*)colorByName:(NSString*)name;

+(UIImage*)imageForURL:(NSURL*)url;

@end
