//
//  SideMenuTableViewController.m
//  Derm
//
//  Created by glenn on 1/29/15.
//  Copyright (c) 2015 glenn. All rights reserved.
//

#import "DownMenuViewController.h"
#import "RBPreferenceVC.h"
#import "RBOrderHistoryVC.h"
#import "RBHelpVC.h"

#import "AppDelegate.h"
@interface DownMenuViewController ()
{
    FBLikeControl * likeControl;
    AppDelegate * appDelegate;
}
@end

@implementation DownMenuViewController


static DownMenuViewController * menuController = nil;

+(DownMenuViewController *)sharedMenuViewController
{
    @synchronized(self)
    {
        if (menuController==nil)
        {
            menuController=[[DownMenuViewController alloc]init];
        }
    }
    return menuController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [menuTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    menuVisibleFlag = NO;
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    
    
    likeControl = [[FBLikeControl alloc] init];
    likeControl.objectID = @"https://www.facebook.com/qwiklunch";
        
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tapGesture.delegate = self;
    
    [self.view addGestureRecognizer:tapGesture];
    
    
     [menuTableView setFrame:CGRectMake(menuTableView.frame.origin.x, 0, menuTableView.frame.size.width, 46  * 5)];
   
    
     [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return  5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger  cell_index = indexPath.row;
    
    NSString * cell_indentifier = [NSString stringWithFormat:@"menuCell%ld",(long)cell_index+1];
    UITableViewCell * cell = [menuTableView dequeueReusableCellWithIdentifier:cell_indentifier];
    
    return cell;
    
}

/// TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger  cell_index = indexPath.row;
    if(cell_index == appDelegate.selectedCellIndex)
    {
        [self hideMenuAnimated:YES];
        return;
    }
    
    if (self.parentViewController ==  nil || self.parentViewController.navigationController == nil) {
        return ;
    }
    
    UINavigationController * navController = (UINavigationController *)self.parentViewController.navigationController;
    
    [navController setNavigationBarHidden:NO];
    
    if (cell_index == 0) {
       
        RBPreferenceVC  * controller = [navController.storyboard instantiateViewControllerWithIdentifier:@"RBPreferenceVC"];
        
        [navController pushViewController:controller  animated:YES];
    }else if(cell_index == 1)
    {
        RBOrderHistoryVC  * controller = [navController.storyboard instantiateViewControllerWithIdentifier:@"RBOrderHistoryVC"];
        
        [navController pushViewController:controller  animated:YES];
        
    }else if(cell_index == 2)
    {
        RBHelpVC  * controller = [navController.storyboard instantiateViewControllerWithIdentifier:@"RBHelpVC"];
         
         [navController pushViewController:controller  animated:YES];
               
    }
    else if(cell_index== 3)
    {
        [self onFBLike];
        cell_index= appDelegate.selectedCellIndex;
    }
    else if(cell_index == 4){
        [self logOut];
    }
    
    appDelegate.beforeSelectedCellIndex = appDelegate.selectedCellIndex;
    appDelegate.selectedCellIndex = cell_index;

    [self hideMenuAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 46;
}

-(void)onFBLike
{
    
    appDelegate.activeSocialNetwork = @"facebook";

    NSString * urlString1 = @"fb://profile/435481249959952";
        
    NSString * urlString = @"https://www.facebook.com/pages/RedBasket/435481249959952";
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL  * url1  = [NSURL URLWithString:urlString1];
    NSURL  * url  = [NSURL URLWithString:urlString];
    
    if([[UIApplication sharedApplication] canOpenURL:url1])
    {
         [[UIApplication sharedApplication] openURL:url1];
    }else{
         [[UIApplication sharedApplication] openURL:url];
    }
    return;
  
}

-(void)logOut
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    FBSession.activeSession = nil;
    
   UINavigationController * navController = (UINavigationController *)self.parentViewController.navigationController;
    [navController dismissViewControllerAnimated:YES completion:nil];

}

-(void)showMenuAnimated:(BOOL)flag
{
    if (self.parentViewController ==  nil) {
        return ;
    }
    CGRect  parentFrame = self.parentViewController.view.frame;
    
    menuVisibleFlag = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    }];
}

-(void)hideMenuAnimated:(BOOL)flag
{
    
    if (self.parentViewController ==  nil) {
        return ;
    }
    
    menuVisibleFlag = NO;
    
    CGRect  parentFrame = self.parentViewController.view.frame;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:CGRectMake(0, 0, parentFrame.size.width, 0)];
    }];
    
}

-(BOOL)isMenuVisible
{
    return menuVisibleFlag;
}

/// Tap Gesture delegate

-(void)onTap:(UITapGestureRecognizer *)gesture
{
    [self hideMenuAnimated:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tapPoint = [touch locationInView:self.view];

    if(CGRectContainsPoint(menuTableView.frame, tapPoint))
    {
        return NO;
    }
    
    return YES;
}

@end
