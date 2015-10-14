//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTViewController.h"

@interface LTWebViewController : LTViewController <UIWebViewDelegate>

@property(nonatomic,strong) UIWebView* webView;
@property(nonatomic,strong) NSURL* url;
@property(nonatomic,strong) NSURL* baseURL;
@property(nonatomic,strong) NSString* html;
@property(nonatomic,assign) BOOL linksOpenExtern;
@property(nonatomic,strong) UIColor* webViewDecorationOverlayColor;

+(id)webViewControllerWithURL:(NSURL*)url;
+(id)webViewControllerWithURL:(NSURL*)url openLinksExtern:(BOOL)yesno;
+(id)webViewControllerWithURLByCopyingContent:(NSURL*)url fromStartTag:(NSString*)start toEndTag:(NSString*)end andInsertInto:(NSString*)body openLinksExtern:(BOOL)yesno;

+(id)webViewControllerWithHTML:(NSString*)html;
+(id)webViewControllerWithHTML:(NSString*)html openLinksExtern:(BOOL)yesno;

@end
