//
//  RBOrderHistoryVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBOrderHistoryVC.h"
#import "AppDelegate.h"
#import "RBStoreListVC.h"
#import "RBReceiptVC.h"

@interface RBOrderHistoryVC ()<UITableViewDataSource, UITableViewDelegate,ServerManagerDelegate>
{
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet UITableView * orderHistoryTableView;
    
    NSArray  *orderHistory;
}

@end

@implementation RBOrderHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    
    orderHistory = [[NSArray alloc] init];
    
    orderHistoryTableView.delegate = self;
    orderHistoryTableView.dataSource = self;
    
    [orderHistoryTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self getOrderHistory];
}

- (IBAction)showMenu:(id)sender {
    
    if([menuViewController isMenuVisible])
    {
        [menuViewController hideMenuAnimated:YES];
    }else{
        [menuViewController showMenuAnimated:YES];
    }
    
}

-(IBAction)onListView:(id)sender
{
    appDelegate.selectedCellIndex = -1;
    RBStoreListVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RBStoreListVC"];
    [self.navigationController setViewControllers:@[controller] animated:YES];
}

-(IBAction)onDone:(id)sender
{
     appDelegate.selectedCellIndex = appDelegate.beforeSelectedCellIndex;
    [self.navigationController popViewControllerAnimated:YES];

}


////////  UITableView  Delegate And Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    
    UILabel * storeNameLabel = (UILabel *)[cell viewWithTag:123];
     UILabel * orderDateLabel = (UILabel *)[cell viewWithTag:124];
    [storeNameLabel setTextColor:[UIColor blackColor]];
   
    NSDictionary * tempDic = [orderHistory objectAtIndex:indexPath.row];
    NSString * storeName = [tempDic objectForKey:@"store_name"];
    [storeNameLabel setText:storeName];
    
    
    NSString * orderDateStr = [tempDic objectForKey:@"order_date"];
    NSString * formatStr2 = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatStr2];
    NSDate * orderDate =[formatter2 dateFromString:orderDateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString * dateString = [formatter stringFromDate:orderDate];
    [orderDateLabel setText:dateString];

    
    int flag = [[tempDic objectForKey:@"completed_flag"] intValue];
    
    if(flag == 0)
    {
         cell.contentView.backgroundColor = [UIColor whiteColor];

    }else{
          cell.contentView.backgroundColor = APP_PINK_COLOR;
    }
    
    
    return  cell;
  
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(orderHistory == nil)
        return 0;
    return [orderHistory count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.justOrderData = [orderHistory objectAtIndex:indexPath.row];
    
    RBReceiptVC * orderDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RBReceiptVC"];
    orderDetailVC.orderDetailFlag = YES;
    orderDetailVC.redeemedFlag = [[appDelegate.justOrderData objectForKey:@"completed_flag"] intValue];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}

-(void)getOrderHistory
{
    ServerManager *manager = [ServerManager sharedManager];
    manager.delegate = self;
    
    NSString * postString = [NSString stringWithFormat:@"user_fb_id=%@",appDelegate.userFB_ID];
    [manager fetchDataOnserverWithAction:GET_ORDERHISTORY forView:self.view forPostData:postString];
}


/// Server Manager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    if ([actionName isEqualToString:GET_ORDERHISTORY]) {
        
        orderHistory = [responseDic objectForKey:@"data"];
        [orderHistoryTableView reloadData];
    }
}

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    
}




@end
