//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

// A UITableView with support for a dedicated empty view

#import <UIKit/UIKit.h>

#import "TPKeyboardAvoidingTableView.h"

@interface LTTableView : TPKeyboardAvoidingTableView

@property(strong,nonatomic) IBOutlet UIView* tableEmptyView;

@property(nonatomic,readonly) BOOL showsEmptyView;
@property(assign,nonatomic) BOOL disableTouchesWhenShowingEmptyView;

@end
