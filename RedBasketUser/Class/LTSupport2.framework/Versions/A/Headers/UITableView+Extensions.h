//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extensions)

-(void)LT_deselectSelectedRowAnimated:(BOOL)yesOrNo;
-(void)LT_setEmptyTableFooterView;

-(void)LT_scrollToRowAtIndexPath:(NSIndexPath*)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

-(NSInteger)LT_actualRowForIndexPath:(NSIndexPath*)indexPath;

@end
