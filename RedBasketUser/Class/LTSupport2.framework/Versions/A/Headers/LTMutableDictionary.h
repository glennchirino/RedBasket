//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTMutableDictionary : NSObject <NSFastEnumeration>
{
    CFMutableDictionaryRef _dict;
}

+(id)dictionary;
+(id)dictionaryWithContentsOfDictionary:(LTMutableDictionary*)otherDict;

-(id)objectForKey:(id)aKey;
-(void)setObject:(id)aObject forKey:(id)aKey;
-(void)removeObjectForKey:(id)aKey;
-(NSArray*)allKeys;

-(NSString*)description;
@end
