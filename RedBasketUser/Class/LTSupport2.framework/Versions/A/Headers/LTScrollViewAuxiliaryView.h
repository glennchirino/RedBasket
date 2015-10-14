//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTScrollViewAuxiliaryView;

typedef void(^LTScrollViewAuxiliaryViewBlock)(LTScrollViewAuxiliaryView*);

typedef enum
{
    LTScrollViewAuxiliaryViewRolePullToReload,
    LTScrollViewAuxiliaryViewRolePullToLoadMore,
} LTScrollViewAuxiliaryViewRole;

typedef enum
{
    LTScrollViewAuxiliaryViewStateIdle,
    LTScrollViewAuxiliaryViewStatePulled,
    LTScrollViewAuxiliaryViewStateLoading,
} LTScrollViewAuxiliaryViewState;

@protocol LTScrollViewAuxiliaryViewDelegate <NSObject>

-(void)auxiliaryViewActionInitiated:(LTScrollViewAuxiliaryView*)view;

@end

@interface LTScrollViewAuxiliaryView : UIView

-(id)initForScrollView:(UIScrollView*)scrollView role:(LTScrollViewAuxiliaryViewRole)role usingBlock:(LTScrollViewAuxiliaryViewBlock)block;

-(void)setSubtitle:(NSString*)subtitle;
-(void)finishedLoading;

@end
