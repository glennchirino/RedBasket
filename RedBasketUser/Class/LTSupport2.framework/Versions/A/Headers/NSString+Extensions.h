//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LaTe)

-(NSString*)LT_stringByStrippingHTML;
-(NSString*)LT_stringByAddingUrlPercentEscapes;
-(NSString*)LT_stringByConvertingEntitiesInString;
-(NSString*)LT_stringByStrippingWhitespace;
-(NSString*)LT_stringByStrippingNonAsciiCharacters;
-(BOOL)LT_hasSubString:(NSString*)substring;
-(BOOL)LT_hasCaseInsensitiveSubString:(NSString*)substring;
-(NSString*)LT_stringOrPlaceholder:(NSString*)placeholder;
-(NSString*)LT_stringByTruncatingPostfixWithLength:(NSUInteger)num;
-(NSString*)LT_stringByLastPathComponent;                                       // same [NSString lastPathComponent] ??;
-(NSString*)LT_subStringBetween:(NSString*)prefix andSuffix:(NSSet*)suffixes;
-(NSString*)LT_stringBySeparatingCapitalizedWordWithSeparator:(NSString*)separator;

-(id)LT_JSONValue;

@end

@interface NSString (RegularExpressions)

-(BOOL)LT_matchesRegularExpression:(NSRegularExpression*)regex;
-(BOOL)LT_isValidEmailAddress;

@end

@interface NSString (DeviceHardware)

+(NSString*)LT_platform;
+(NSString*)LT_friendlyPlatform;
+(NSString*)LT_friendlyPlatformForPlatform:(NSString*)platform;

@end

#import <UIKit/UIKit.h>

@interface NSString (UIKitAdditionsLate)

-(void)LT_drawCenteredInRect:(CGRect)rect withFont:(UIFont*)font;

@end

@interface NSString (UniqueDeviceIdentification)

+(NSString*)LT_stringByComputingUniqueDeviceIdentification;

@end

@interface NSString (InfoPlistConvenience)

+(NSString*)LT_appBundleBuild;
+(NSString*)LT_appBundleName;
+(NSString*)LT_appBundleIdentifier;
+(NSString*)LT_appBundleVersion;

@end

@interface NSString (MD5)

-(NSString*)LT_md5sum;

@end

@interface NSString (SHA1)

-(NSString*)LT_sha1Base64;

@end
