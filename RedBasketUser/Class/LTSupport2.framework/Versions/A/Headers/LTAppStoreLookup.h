//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTAppStoreLookup : NSObject

+(NSArray*)lookupInfoForStoreId:(NSString*)trackId;
+(NSArray*)lookupInfoForBundleId:(NSString*)trackId;

@end

@interface LTiTunesStoreSearch : NSObject

+(NSArray*)lookupInfoForTerm:(NSString*)term;

@end