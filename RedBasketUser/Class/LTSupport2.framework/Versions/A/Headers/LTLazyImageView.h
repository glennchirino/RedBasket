//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _LTLazyImageViewPlaceholderStyle
{
    LTLazyImageViewPlaceholderStyleNone,
    LTLazyImageViewPlaceholderStyleActivityIndicator,
    LTLazyImageViewPlaceholderStyleImage
} LTLazyImageViewPlaceholderStyle;
    
typedef enum _LTLazyImageViewAppearanceStyle
{
    LTLazyImageViewAppearanceStyleNone,
    LTLazyImageViewAppearanceStyleBounce,
    LTLazyImageViewAppearanceStyleFade
} LTLazyImageViewAppearanceStyle;

typedef enum _LTLazyImageViewColorStyle
{
    LTLazyImageViewColorNormal,
    LTLazyImageViewColorBlackWhite
} LTLazyImageViewColorStyle;


@protocol LTLazyImageViewDelegate <NSObject>

@optional
-(void)willLoadLTLazyImage;
-(void)didLoadLTLazyImage;
-(void)failedToLoadLTLazyImage;

-(void)willShowLTLazyImage;
-(void)didShowLTLazyImage;

@end


@interface LTLazyImageView : UIImageView

@property (assign, nonatomic) id <LTLazyImageViewDelegate> delegate;

@property(nonatomic,retain) NSURL* url;
@property(nonatomic,retain) NSURLRequest* urlRequest;

@property(nonatomic,assign) LTLazyImageViewPlaceholderStyle placeholderStyle;
@property(nonatomic,assign) LTLazyImageViewAppearanceStyle  appearanceStyle;
@property(nonatomic,assign) LTLazyImageViewColorStyle       colorStyle;

@property(nonatomic,assign) BOOL bottomAligned;
@property(nonatomic,assign) BOOL topAligned;
@property(nonatomic,assign) CGFloat shadowDepth;

@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,retain) UIImage* brokenImage;

@property(nonatomic,assign) BOOL notcached;
@property(nonatomic,assign) NSInteger refresh;

+(LTLazyImageView*)lazyImageViewWithURL:(NSURL*)aurl;

+(void)setCommonPlaceholderStyle:(LTLazyImageViewPlaceholderStyle)style;
+(void)setCommonAppearanceStyle:(LTLazyImageViewAppearanceStyle)style;
+(void)setCommonColorStyle:(LTLazyImageViewColorStyle)style;
+(void)setCommonPlaceholderImage:(UIImage*)img;
+(void)setCommonBrokenImage:(UIImage*)img;

+(void)flushCache;

@end
