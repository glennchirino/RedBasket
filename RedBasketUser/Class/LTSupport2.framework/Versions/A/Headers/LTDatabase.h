//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTDownloadManager.h"

@protocol LTDatabaseDelegate;

@interface LTDatabase : NSObject < LTDownloadManagerDelegate >

@property (strong, nonatomic) id<LTDatabaseDelegate>    delegate;
@property (copy, nonatomic) void (^progressBlock)(float);

@property (nonatomic, strong) NSMutableArray*           results;

+(LTDatabase*)databaseWithSourceURL:(NSURL*)sourceURL;

-(void)executeQuery:(NSString*)query withModellClass:(Class)modelClass;

// db file methods
-(void)checkUpdate;
-(void)loadUpdate;
-(void)skipUpdate;

@end


@protocol LTDatabaseDelegate <NSObject>

-(void)databaseReady;
-(void)databaseMissing;

@optional
-(void)databaseUpdateFound:(LTDatabase*)database;
-(void)databaseUpdateDidLoaded:(LTDatabase*)database;
-(void)databaseUpdateDidFail:(LTDatabase *)database;

@end
