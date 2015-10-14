//
//  StripePaymentVC.h
//  RedBasketMerchant
//
//  Created by webastral on 14/07/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StripePaymentVC : UIViewController
{
    NSString *urlString;
    NSInteger totalCents;
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UIImageView* userImage;
@property (strong, nonatomic) UILabel* userNameLabel;


@property (strong, nonatomic) IBOutlet UILabel* pricelabel;
@property (strong, nonatomic) IBOutlet UIImageView* imagePayment;


@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

-(IBAction)CancelButtonClicked:(id)sender;
@end
