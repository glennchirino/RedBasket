//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+BlockInvoke.h"

@interface LTInfrastructureClient : NSObject

+(NSString*)serverPath;
+(void)setServerPath:(NSString*)serverPath;
+(NSDictionary*)queryStrings;

+(void)ping;
+(void)sendEvents:(NSArray*)events usingCompletionHandler:(NSObjectVoidBlock)block;
+(void)sendToken:(NSString*)token;
+(void)sendTokenData:(NSData*)tokenData;
+(void)sendCrashReport:(NSData*)crashReport;

+(NSArray*)trackedApps;
+(NSDictionary*)trackedInfoForApp:(NSString*)bundleid;
+(NSArray*)trackedUsersForApp:(NSString*)bundleid;
+(NSArray*)trackedUserInfoForApp:(NSString*)bundleid mac:(NSString*)mac;
+(NSDictionary*)sessionAggregationForApps:(NSArray*)bundleids;
+(BOOL)determineJailbreak;

+(BOOL)handleCrashReporting;

+(NSUInteger)findUnsentLogFiles;
+(NSUInteger)sendUnsentLogFiles;

@end
