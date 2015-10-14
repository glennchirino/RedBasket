//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/NSURL.h>

@interface NSURL (Escaping)

+(NSURL*)LT_URLByEscapingString:(NSString*)string;

@end

@interface NSURL (iCloudBackup)

-(BOOL)LT_addSkipBackupAttribute;

@end