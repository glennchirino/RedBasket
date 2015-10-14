//
//  LTPullToRefreshView.h
//  (C) Grant Paul (chpwn)
//  (C) Sonny Parlin - http://sonnyparlin.com/2011/12/pulltorefresh-ios-5-and-arc-tutorial/
//  (C) Dr. Michael Lauer
//
//  (based on EGORefreshTableHeaderView)
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
  LTPullToRefreshViewStateNormal = 0,
	LTPullToRefreshViewStateReady,
	LTPullToRefreshViewStateLoading
} LTPullToRefreshViewState;

@protocol LTPullToRefreshViewDelegate;

@interface LTPullToRefreshView : UIView
{
	UILabel* lastUpdatedLabel;
	UILabel* statusLabel;
//	CALayer* arrowImage;
	UIActivityIndicatorView* activityView;
}
@property (nonatomic, strong) 	CALayer* arrowImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<LTPullToRefreshViewDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)finishedLoading;
- (void)setState:(LTPullToRefreshViewState)state_;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end

@protocol LTPullToRefreshViewDelegate <NSObject>

@optional
- (void)pullToRefreshViewShouldRefresh:(LTPullToRefreshView *)view;
- (NSDate *)pullToRefreshViewLastUpdated:(LTPullToRefreshView *)view;
@end
