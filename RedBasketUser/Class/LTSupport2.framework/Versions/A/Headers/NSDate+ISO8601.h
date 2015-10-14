//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

+(NSDate*)LT_dateFromISO8601:(NSString*)str;
-(NSString*)LT_stringByConvertingToISO8601;

@end
