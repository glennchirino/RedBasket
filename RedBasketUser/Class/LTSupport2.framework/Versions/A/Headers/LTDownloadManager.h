//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "late_macros.h"

typedef void(^LTDownloadManagerBlock)(NSData* data);

@protocol LTDownloadManagerDelegate <NSObject>

-(void)downloadProgress:(unsigned long long)bytesReceived object:(id)object;
-(void)downloadFinishedForObject:(id)object;
-(void)downloadFailedForObject:(id)object;

@end

@interface LTDownloadManagerConnection : NSObject

@property(nonatomic,retain) NSURLConnection* connection;
@property(nonatomic,retain) NSString* filename;
@property(nonatomic,retain) NSFileHandle* fileHandle;
@property(nonatomic,assign) unsigned long long bytesReceived;
@property(nonatomic,assign) id<LTDownloadManagerDelegate> delegate;
@property(nonatomic,assign) id userdata;
@property(nonatomic,copy) LTDownloadManagerBlock block;
@property(nonatomic,retain) NSMutableData* data;

@end

#ifndef __IPHONE_5_0
@protocol NSURLConnectionDataDelegate
@end
#endif

@interface LTDownloadManager : NSObject <NSURLConnectionDataDelegate>

LT_SINGLETON_INTERFACE_FOR_CLASS(LTDownloadManager, sharedDownloadManager)

-(void)download:(NSURL*)url object:(id)object toFile:(NSString*)filename delegate:(id<LTDownloadManagerDelegate>)delegate;
-(void)downloadRequest:(NSURLRequest*)url object:(id)object toFile:(NSString*)filename delegate:(id<LTDownloadManagerDelegate>)delegate;

-(void)download:(NSURL*)url usingBlock:(LTDownloadManagerBlock)block;
-(void)downloadRequest:(NSURLRequest*)request usingBlock:(LTDownloadManagerBlock)block;

-(void)upload:(NSURL*)url string:(NSString*)string usingBlock:(LTDownloadManagerBlock)block;

@end



