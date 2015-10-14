//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

#import "TBXML.h"

@interface LTNetworking : NSObject

+(NSUInteger)setBusy;
+(NSUInteger)setIdle;
+(void)executeTaskInBackgroundWhileBlockingView:(UIView*)view showingBusyIndicatorDuring:(NSObjectVoidBlock)block;

+(NSData*)dataByDownloadingURL:(NSString*)surl;
+(NSString*)stringByDownloadingURL:(NSString*)surl;

-(void)downloadXMLRequest:(NSString*)request parseUsingBlock:(TBXMLIterateBlock)block;

-(UIImage*)imageByDownloadingURL:(NSString*)surl caching:(BOOL)yesOrNo;

@end
