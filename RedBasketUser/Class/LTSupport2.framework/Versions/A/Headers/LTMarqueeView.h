//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTMarqueeViewScrollViewDelegate <NSObject>

@optional
-(void)userTouch;
-(void)userDrag;
-(void)userEndTouch;

@end

@interface LTMarqueeViewScrollView : UIScrollView

@property(weak,nonatomic) id <LTMarqueeViewScrollViewDelegate> marqueeViewDelegate;

@end

@interface LTMarqueeView : UIView <LTMarqueeViewScrollViewDelegate, UIScrollViewDelegate>

// forwarded UILabel properties
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) UITextAlignment textAlignment;
// forwarded LTLabel properties
@property (nonatomic, strong) UIColor *outlineColor;
@property (nonatomic) CGFloat outlineWidth;

@end
