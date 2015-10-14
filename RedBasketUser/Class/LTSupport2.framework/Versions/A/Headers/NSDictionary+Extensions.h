//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extensions)

-(NSUInteger)LT_countEntriesUsingBlacklist:(NSRegularExpression*)blacklist;
-(NSDictionary*)LT_dictionaryFilteredUsingBlacklist:(NSRegularExpression*)blacklist;

-(NSDictionary*)LT_dictionaryFilteredUsingWhitelistPrefix:(NSString*)prefix;
-(NSDictionary*)LT_dictionaryFilteredUsingBlacklistPrefix:(NSString*)prefix;

-(id)LT_firstKeyForValue:(id)value;

@end
