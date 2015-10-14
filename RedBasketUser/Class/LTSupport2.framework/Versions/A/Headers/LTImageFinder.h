//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LTImageFinderURIsBlock)(NSArray*);

@interface LTImageFinder : NSObject

/* SYNC API */
+(NSArray*)lookupImageURIsForQuery:(NSString*)query;

/* ASYNC API */
+(void)lookupImageURIsForQuery:(NSString*)query usingBlock:(LTImageFinderURIsBlock)block;

@end
