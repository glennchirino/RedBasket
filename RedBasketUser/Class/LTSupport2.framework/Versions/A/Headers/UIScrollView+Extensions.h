//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extensions)

-(void)LT_scrollRectToVisibleCentered:(CGRect)visibleRect animated:(BOOL)animated;
+(id)LT_scrollViewWithContentView:(UIView*)contentView maxSize:(CGSize)maxSize;

@end
