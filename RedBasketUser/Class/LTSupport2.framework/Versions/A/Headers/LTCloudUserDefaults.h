//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* LTCloudUserDefaultsHaveChangedNotification;

@interface LTCloudUserDefaults : NSObject

@property(nonatomic,retain) NSString* whitelistPrefix;

// forwarders
-(NSString*)stringForKey:(NSString*)aKey;
-(BOOL)boolForKey:(NSString*)aKey;
-(NSInteger)integerForKey:(NSString*)aKey;
-(void)setString:(NSString*)aString forKey:(NSString*)aKey;
-(void)setBool:(BOOL)aBool forKey:(NSString*)aKey;
-(void)setInteger:(NSInteger)anInteger forKey:(NSString*)aKey;

// compatibility with NSUserDefaults
+(LTCloudUserDefaults*)standardUserDefaults;
-(NSDictionary*)dictionaryRepresentation;

// actual work horses
-(void)setObject:(id)anObject forKey:(NSString*)aKey;
-(id)objectForKey:(NSString*)aKey;
-(void)removeObjectForKey:(NSString*)aKey;

-(void)synchronize;

@end
