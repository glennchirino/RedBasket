//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const LTExclusiveTouchViewShouldCancel = @"LTExclusiveTouchViewShouldCancel";

@interface LTWindow : UIWindow

@property(assign,nonatomic) UIView* temporaryExclusiveTouchView;
@property(strong,nonatomic) NSArray* passthroughViews;

@end
