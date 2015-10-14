//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^NSStringBlock)(NSString* path);

@interface NSFileManager (Extensions)

+(void)LT_recursivelyEnumerateFilesStartingAtPath:(NSString*)path block:(NSStringBlock)block;

+(NSString*)LT_extendedFileAttributeAtPath:(NSString*)path forKey:(NSString*)key;
+(BOOL)LT_setExtendedFileAttributeAtPath:(NSString*)path value:(NSString*)value forKey:(NSString*)key;
+(BOOL)LT_removeExtendedFileAttributeAtPath:(NSString*)path forKey:(NSString*)key;

@end
