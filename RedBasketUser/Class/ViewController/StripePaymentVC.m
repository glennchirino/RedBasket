//
//  StripePaymentVC.m
//  RedBasketMerchant
//
//  Created by webastral on 14/07/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "StripePaymentVC.h"
#import <AFNetworking/AFNetworking.h>
#import "Stripe.h"
#import "RWCheckoutInputCell.h"
#import "Constants.h"
#import "ServerManager.h"
#import "AppDelegate.h"
#import "RBReceiptVC.h"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_O2tE6AHcK8RA2XETvU5Q2O4v"
#define STRIPE_TEST_POST_URL @"http://app.redbasket.net/api/Stripe/transaction.php?"

@interface StripePaymentVC ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, ServerManagerDelegate>
{
    NSString * description;
    NSDecimalNumber *totalammount;
    AppDelegate  *appDelegate;
    double tax;
    NSInteger monthstripe;
    NSInteger yearmonth;
    int currentTokenCount;
}
@property(nonatomic, assign) BOOL orderDetailFlag;
@property(nonatomic, assign) BOOL redeemedFlag;
@property(nonatomic, assign) BOOL isFreeSpecial;
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) STPCard* stripeCard;
@end

@implementation StripePaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"%@",appDelegate.selectedStore);
    //stripe method card expiry month array
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
                        @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
                        @"10 - October", @"11 - November", @"12 - December"];
    
    float currentammount=[[NSUserDefaults standardUserDefaults]floatForKey:@"currentcount"];
    NSInteger marcentAmmount= [[NSUserDefaults standardUserDefaults]integerForKey:@"marcentammount"];

    _pricelabel.text=[NSString stringWithFormat:@"$ %.2f",currentammount];
}
#pragma mark  Stripe payment method
- (IBAction)completeButtonTapped:(id)sender {
    //1
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    
    //2
    if ([self validateCustomerInfo])
    {
        [self postStripeToken];
    }
}

- (BOOL)validateCustomerInfo {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //1. Validate name & email
    if (self.nameTextField.text.length == 0 ||
        self.emailTextField.text.length == 0) {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)performStripeOperation {
    
    //1
    self.completeButton.enabled = NO;
}

//post stripe payment token
- (void)postStripeToken
{
    
    
    //2 post
    NSMutableDictionary* postRequestDictionary = [[NSMutableDictionary alloc] init];
    postRequestDictionary[@"amount"] = [NSString stringWithFormat:@"%ld", (long)totalCents];
    //postRequestDictionary[@"stripeToken"] = token;
    postRequestDictionary[@"desc"] = @"RedBasket App!";
    
    //3  set ammount
   NSInteger currentammount=[[NSUserDefaults standardUserDefaults]integerForKey:@"currentcount"];
   NSInteger marcentAmmount= [[NSUserDefaults standardUserDefaults]integerForKey:@"marcentammount"];
    
    //4 set tokens from cards
    __block NSString *token1,*token2;
    NSString * merchantPaypalEmai;
    NSString * merchantName;
    
    if (PAYPAL_LIVE_FLAG)
    {
        merchantPaypalEmai = [appDelegate.selectedStore objectForKey:@"paypalemail"];
        merchantName = [appDelegate.selectedStore objectForKey:@"contact_name"];
    }
    else
    {
        NSLog(@"%@",appDelegate.selectedStore);
        merchantPaypalEmai = @"glenn_test1@paypal.com";
        merchantPaypalEmai = [appDelegate.selectedStore objectForKey:@"paypalemail"];
        NSLog(@"%@",merchantPaypalEmai);
        NSLog(@"%@",[appDelegate.selectedStore objectForKey:@"paypalemail"]);
        merchantName = @"User";
    }
    
    NSArray *arry=[merchantPaypalEmai componentsSeparatedByString:@","];
    NSLog(@"%@",merchantPaypalEmai);
    NSString *stringcardNumber=[arry objectAtIndex:0];
    NSString *stringcardcvv=[arry objectAtIndex:1];
    NSString *stringcardexpirymonth=[arry objectAtIndex:2];
    NSString *stringcardexpiryyear=[arry objectAtIndex:3];



    // Testing Card <Receiver>
    STPCard *testCard = [[STPCard alloc] init];
    testCard.name = @"Test Receiver";
    testCard.number = stringcardNumber;
    testCard.cvc = stringcardcvv;
    testCard.expMonth =[stringcardexpirymonth integerValue];
    testCard.expYear = [stringcardexpiryyear integerValue];
    
    
    [Stripe createTokenWithCard:testCard
                 publishableKey:STRIPE_TEST_PUBLIC_KEY
                     completion:
     ^(STPToken* token, NSError* error)
     {
         if(error)
             [self handleStripeError:error];
         else
         {
             
             token1 = token.tokenId;
             // Testing Card <Sender>
             STPCard *testCard1 = [[STPCard alloc] init];
             testCard1.name = _nameTextField.text;
             testCard1.number =_cardNumber.text;
             testCard1.cvc = _CVCNumber.text;
             testCard1.expMonth = monthstripe;
             testCard1.expYear = yearmonth;
             
          
             [Stripe createTokenWithCard:testCard1
                          publishableKey:STRIPE_TEST_PUBLIC_KEY
                              completion:
              ^(STPToken* token, NSError* error)
              {
                  if(error)
                      [self handleStripeError:error];
                  else
                  {
                      token2 = token.tokenId;
                      //token1 = @"tok_16QZVQERr3JtFBh3ffkc3NT0";
                      //token2 = @"tok_16QZV0ERr3JtFBh3BtxvPMrx";
                      
                      NSString *postSr=[NSString stringWithFormat:@"http://app.redbasket.net/api/Stripe/merchanttransaction.php?usertoken=%@&name=%@&email=%@&userdesc=Purchase from RedBasket iOS app!&totalamount=%ld&merchanttoken=%@&merchantfullname=%@&merchantamount=%ld&transfer_desc=%@",token2,_nameTextField.text,_emailTextField.text,(long)currentammount,token1,@"dave dfuyfg",(long)marcentAmmount,@"Done"];
                      urlString=@"stripeUrlkey";
                      ServerManager * manager = [ServerManager sharedManager];
                      manager.delegate = self;
                      [manager postData:postSr forView:self.view];
                  }}];
         }
     }];
    
      self.completeButton.enabled = YES;
}
- (void)handleStripeError:(NSError *) error
{
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.completeButton.enabled = YES;
}

- (void)chargeDidSucceed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Payment Success"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    //server method to send token at the server
    ServerManager * manager = [ServerManager sharedManager];
    manager.delegate = self;
    urlString=@"psottoserver";
 //   [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)chargeDidNotSuceed
{
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


/* The methods below implement the user interface. You don't need to change anything. */

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Name";
        cell.textField.placeholder = @"Name";
        cell.imageview.image=[UIImage imageNamed:@"userImage"];
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        self.nameTextField = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 1) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
        cell.textField.placeholder = @"E-mail";
        cell.imageview.image=[UIImage imageNamed:@"Message"];
        
        self.emailTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    else if (section == 0 && row ==2) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Card";
        cell.textField.placeholder = @".... .... .... ....";
        cell.imageview.image=[UIImage imageNamed:@"Card"];
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.cardNumber = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 3) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Expiry";
        cell.textField.text = @"MM/YY";
        cell.imageview.image=[UIImage imageNamed:@"CreditCard"];
        
        cell.textField.textColor = [UIColor lightGrayColor];
        self.expirationDateTextField = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 4) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC";
        cell.textField.placeholder = @"123";
        cell.imageview.image=[UIImage imageNamed:@"cvc"];
        self.CVCNumber = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self configurePickerView];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark  UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%li", currentYear + row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    }
    else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); //Default to January if no selection
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:1 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); //Default to current year if no selection
    }
    monthstripe =[self.selectedMonth integerValue];
    yearmonth =[self.selectedYear integerValue];

    
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
    self.expirationDateTextField.textColor = [UIColor blackColor];
}

#pragma mark  UIPicker configuration
- (void)configurePickerView {
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    doneButton.tintColor=[UIColor whiteColor];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
}

- (void)pickerDoneButtonPressed
{
    [self.view endEditing:YES];
}

// server Manager Delegate
-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    NSLog(@"%@",responseDic);
    if ([urlString isEqualToString:@"stripeUrlkey"])
    {
        NSLog(@"%@",responseDic);
        int resultval = [[responseDic objectForKey:@"success"] intValue];
        if (resultval==1)
        {
            // NSString *result = [responseDic objectForKey:@"msg"];
           // [self chargeDidSucceed];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:[responseDic valueForKey:@"msg"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //server method to send token at the server
            ServerManager * manager = [ServerManager sharedManager];
            manager.delegate = self;
            urlString=@"psottoserver";
            [self sendOrderRequest:responseDic[@"data"][@"card id"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                            message:[responseDic valueForKey:@"msg"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        if ([actionName isEqualToString:ADD_ORDER]) {
            
            NSString * flag = [responseDic objectForKey:@"success"];
            if (flag != nil && [flag isEqualToString:@"OK"])
            {
                NSString * barcode = [responseDic objectForKey:@"barcode"];
                
                // if (isFreeSpecial) {
                [self postSpecialToFacebook];
                //   }
                [self gotoReceiptView:barcode];
            }
        }
    }
}
-(void)gotoReceiptView:(NSString *)barcode
{
    RBReceiptVC * recepitVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RBReceiptVC"];
    recepitVC.barcodeStr = barcode;
    recepitVC.orderDetailFlag = NO;
    recepitVC.redeemedFlag = NO;
    recepitVC.isFreeSpecial = _isFreeSpecial;
    [self.navigationController pushViewController:recepitVC animated:YES];
    
}
-(void)postSpecialToFacebook
{
    NSString *strtitle= [[NSUserDefaults standardUserDefaults]valueForKey:@"titlevalue"];
    NSString *strPrice= [[NSUserDefaults standardUserDefaults]valueForKey:@"pricevalue"];

    NSString * postMessage = [NSString stringWithFormat:@"I just got %@ for %@ at %@\n  Install the free Red Basket app and get red hot deals from stores near you. ",strtitle, strPrice,self.nameTextField.text ];
    NSString * imagePath =   [appDelegate.selectedStore objectForKey:@"image_path"] ;
    NSString * photoUrl = [NSString stringWithFormat:@"%@/%@",SERVER_IP, imagePath];
    
    NSDictionary * photoParam = [[NSDictionary alloc] initWithObjectsAndKeys:postMessage , @"message", photoUrl,@"picture", nil];
    
    [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:photoParam HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
        
    }];
}

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    
}
#pragma mark server key
-(void)sendOrderRequest:(NSString *)payKey
{
    NSMutableDictionary *orderData = [[NSMutableDictionary alloc] init];
    
    [orderData setObject:appDelegate.orderNumber forKey:@"orderNumber"];
    tax =[[NSUserDefaults standardUserDefaults]floatForKey:@"taxCountData"];

    [orderData setObject:[appDelegate.selectedStore objectForKey:@"fb_id"] forKey:@"merchant_fb_id"];
    [orderData setObject:appDelegate.userFB_ID forKey:@"user_fb_id"];
    [orderData setObject:appDelegate.userName forKey:@"user_name"];
    [orderData setObject:[appDelegate.selectedStore objectForKey:@"paypalemail"] forKey:@"merchant_paypal"];
    
    [orderData setObject:payKey forKey:@"transactionId"];
    NSString *strtitle= @"test";//[[NSUserDefaults standardUserDefaults]valueForKey:@"titlevalue"];

    [orderData setObject:@"user1" forKey:@"user_paypal"];
    [orderData setObject:strtitle forKey:@"special_title"];
    NSInteger currentcount=  [[NSUserDefaults standardUserDefaults]floatForKey:@"currentcount"];
    double cal = [[[NSUserDefaults standardUserDefaults]valueForKey:@"unitprice"] doubleValue];
    
    if (_isFreeSpecial)
    {
        currentcount = 1;
        cal = 0.0;
        tax = 0;
    }
    [orderData setObject:[NSString stringWithFormat:@"%ld", (long)currentcount] forKey:@"count"];
    [orderData setObject:[NSString stringWithFormat:@"%.2f",cal] forKey:@"unit_price"];
    [orderData setObject:[NSString stringWithFormat:@"%.2f",cal * currentcount * tax] forKey:@"tax"];
    [orderData setObject:[NSString stringWithFormat:@"%.2f", cal * currentcount * (1 + tax)] forKey:@"total_price"];
    appDelegate.justOrderData = orderData;
    ServerManager * serverManager = [[ServerManager alloc] init];
    serverManager.delegate =self;
    NSMutableString * postring = [[NSMutableString alloc] initWithString:@""];
    int i = 0;
    
    for (NSString * key in [orderData allKeys]) {
        if (i != 0 ) {
            [postring appendString:@"&"];
        }
        
        i++;
        
        [postring appendString:[NSString stringWithFormat:@"%@=%@",key,[orderData objectForKey:key]]];
        
    }
    urlString=@"sendtoserver";
    ServerManager * manager = [ServerManager sharedManager];
    manager.delegate = self;
    NSString *urlStr= [NSString stringWithFormat:@"%@%@?%@",API_URL, ADD_ORDER, postring];

    [manager postData:urlStr forView:self.view];
    

    //[serverManager fetchDataOnserverWithAction:ADD_ORDER forView:self.view forPostData:postring];
}

#pragma mark CANCEL BUTTON CLICKED
-(IBAction)CancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
