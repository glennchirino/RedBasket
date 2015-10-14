 //
//  SideMenuTableViewController.h
//  Derm
//
//  Created by glenn on 1/29/15.
//  Copyright (c) 2015 glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView * menuTableView;
        
    BOOL menuVisibleFlag;
}


+(DownMenuViewController *)sharedMenuViewController;
-(void)showMenuAnimated:(BOOL)flag;
-(void)hideMenuAnimated:(BOOL)flag;
-(BOOL)isMenuVisible;
@end
