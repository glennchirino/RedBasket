//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface LTSimpleQuicklookPreviewItem : NSObject <QLPreviewItem>

@property(strong,nonatomic) NSURL* url;
@property(strong,nonatomic) NSString* title;

+(LTSimpleQuicklookPreviewItem*)simpleQuicklookPreviewItemWithURL:(NSURL*)url title:(NSString*)title;

@end

@interface LTSimpleQuicklookDataSource : NSObject <QLPreviewControllerDataSource>

+(LTSimpleQuicklookDataSource*)simpleQuicklookDataSourceWithURLs:(NSArray*)urls titles:(NSArray*)titles;

@end
