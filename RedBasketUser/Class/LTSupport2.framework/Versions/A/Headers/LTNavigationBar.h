//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNavigationBar : UINavigationBar

@property(assign,nonatomic) CGFloat shadowDecorationHeight UI_APPEARANCE_SELECTOR;
@property(assign,nonatomic) NSUInteger solidMode UI_APPEARANCE_SELECTOR;
@property(strong,nonatomic) UIColor* bottomLineColor UI_APPEARANCE_SELECTOR;
@property(assign,nonatomic) NSUInteger hairlineMode UI_APPEARANCE_SELECTOR;

@end
