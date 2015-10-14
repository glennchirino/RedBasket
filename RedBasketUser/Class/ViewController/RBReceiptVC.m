//
//  RBReceiptVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBReceiptVC.h"
#import "AppDelegate.h"
#import "RBStoreListVC.h"
#import "BarCodeView.h"

@interface RBReceiptVC ()
{
    
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet BarCodeView * barcodeView;
    IBOutlet UILabel * redeemedLabel;
    
    IBOutlet UILabel * paidDateLabel;
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * addressLabel;
    
    IBOutlet UILabel * orderNumberLabel;
    
    IBOutlet UILabel * userNameLabel;
    IBOutlet UILabel * expireDateLabel;
    
    IBOutlet UIView * specialOrderView;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * priceLabel;
    IBOutlet UILabel * countLabel;
    IBOutlet UILabel * taxLabel;
    IBOutlet UILabel * totalLabel;

    IBOutlet UILabel * freeSpecialLabel;
    IBOutlet UIButton * redeemButton;
}


@end

@implementation RBReceiptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
     [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    
    [self initReceiptView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    RBStoreListVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RBStoreListVC"];
    [self.navigationController setViewControllers:@[controller] animated:YES];
}

-(IBAction)onRedeemLater:(id)sender
{
    if (self.orderDetailFlag) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self onListView:nil];
    }
}

- (IBAction)onPhoneCall:(id)sender {
    
    [appDelegate onPhoneCall];
    
}


-(void)initReceiptView
{
    NSString * dateString;
    NSString *address;
    NSString * name;
    NSString * barcodeString;
    NSString * orderNumberString;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    if (!self.orderDetailFlag) {
        
        barcodeString = self.barcodeStr;
        dateString = [formatter stringFromDate:[NSDate date]];
        
        name =   [appDelegate.selectedStore objectForKey:@"name"] ;
        if (name == nil || [name isEqual:[NSNull null]]) {
            name = @"";
        }
        
        NSString * street =   [appDelegate.selectedStore objectForKey:@"street"] ;
        if (street == nil || [street isEqual:[NSNull null]]) {
            street = @"";
        }
        
        NSString * city =   [appDelegate.selectedStore objectForKey:@"city"] ;
        if (city == nil || [city isEqual:[NSNull null]]) {
            city = @"";
        }
        
       address = [NSString stringWithFormat:@"%@, %@", street, city];

        orderNumberString = appDelegate.orderNumberStr;
    }else{
        
        barcodeString = [appDelegate.justOrderData objectForKey:@"barcode"];
        
        NSString * orderDateStr = [appDelegate.justOrderData objectForKey:@"order_date"];
        NSString * formatStr2 = @"yyyy-MM-dd HH:mm:ss";
        NSDateFormatter * formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:formatStr2];
        NSDate * orderDate =[formatter2 dateFromString:orderDateStr];
        dateString = [formatter stringFromDate:orderDate];
        
        name =   [appDelegate.justOrderData objectForKey:@"store_name"] ;
        if (name == nil || [name isEqual:[NSNull null]]) {
            name = @"";
        }
        
        NSString * street =   [appDelegate.justOrderData objectForKey:@"street"] ;
        if (street == nil || [street isEqual:[NSNull null]]) {
            street = @"";
        }
        
        NSString * city =   [appDelegate.justOrderData objectForKey:@"city"] ;
        if (city == nil || [city isEqual:[NSNull null]]) {
            city = @"";
        }
        
        address = [NSString stringWithFormat:@"%@, %@", street, city];
        
        NSString * orderNumber = [appDelegate.justOrderData objectForKey:@"orderNumber"];
        
        orderNumberString= @"";
        if(orderNumber != nil || ![orderNumber isEqual:[NSNull null]]){
            orderNumberString =[NSString stringWithFormat:@"Order #%@-%@", [orderNumber substringToIndex:3],[orderNumber substringFromIndex:3]];
        }

        
    }
    
    [barcodeView setBarCode:barcodeString];
    
    if (appDelegate.isIphone4) {
            barcodeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0f, 1.4f);
    }else{
            barcodeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.2f, 1.6f);
    }
    
    
    paidDateLabel.text = dateString;
    
    nameLabel.text = name;
    addressLabel.text = address;
    
    orderNumberLabel.text = orderNumberString;
    userNameLabel.text = appDelegate.userName;
    expireDateLabel.text = appDelegate.activeStoreExpireTimeStr;
    
    NSString * special_title =   [appDelegate.justOrderData objectForKey:@"special_title"] ;
    NSString *unitPriceStr =  [appDelegate.justOrderData objectForKey:@"unit_price"] ;
    NSString *countStr =  [appDelegate.justOrderData objectForKey:@"count"] ;
    NSString * taxStr =   [appDelegate.justOrderData objectForKey:@"tax"] ;
    NSString * totalPriceStr =   [appDelegate.justOrderData objectForKey:@"total_price"] ;
    
    float unitPrice = [unitPriceStr floatValue];
    if (unitPrice == 0) {
        _isFreeSpecial = YES;
    }else{
        _isFreeSpecial = NO;
    }
        [specialOrderView setHidden:NO];
        [freeSpecialLabel setHidden:YES];
    
       titleLabel.text = special_title;
        priceLabel.text = [NSString stringWithFormat:@"$%@",unitPriceStr];
        taxLabel.text =  [NSString stringWithFormat:@"$%@",taxStr];
        countLabel.text = countStr;
        totalLabel.text =  [NSString stringWithFormat:@"$%@",totalPriceStr];

    if (self.orderDetailFlag) {
        [redeemButton setTitle:@"Back" forState:UIControlStateNormal];
    }else{
        [redeemButton setTitle:@"Redeem Later" forState:UIControlStateNormal];
    }
    
    [redeemedLabel setHidden:YES];
    if (self.redeemedFlag) {
        [redeemedLabel setHidden:NO];
    }
}

@end
