//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hashing)

- (NSString *)LT_MD5Sum;
- (NSString *)LT_SHA1Sum;
- (NSString *)LT_SHA256Sum;

@end
