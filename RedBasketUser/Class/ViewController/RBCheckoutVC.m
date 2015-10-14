//
//  RBCheckoutVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBCheckoutVC.h"

#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "BasicMapAnnotation.h"
#import "RBStoreListVC.h"
#import "RBReceiptVC.h"

#import "PayPal.h"

#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"


typedef enum PaymentStatuses {
    PAYMENTSTATUS_SUCCESS,
    PAYMENTSTATUS_FAILED,
    PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface RBCheckoutVC ()<MKMapViewDelegate,PayPalPaymentDelegate,ServerManagerDelegate>
{
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet MKMapView * mapView;
    
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * addressLabel;
    
    IBOutlet UILabel * orderNumberLabel;
    
    IBOutlet UILabel * countLabel;
    
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * priceLabel;
    IBOutlet UILabel * taxLabel;
    IBOutlet UILabel * totalLabel;
    
    IBOutlet UILabel * freeSpecialLabel;
    IBOutlet UIButton * checkOutButton;
    IBOutlet UIView * checkOutView;
    
    IBOutlet UIButton * plusButton;
    IBOutlet UIButton * minusButton;
    
    
    NSInteger currentCount;
    double unitPrice;
    double tax;
    
    BOOL isFreeSpecial;
    
     PaymentStatus status;
    
}

@end

@implementation RBCheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    mapView.delegate = self;
    mapView.showsUserLocation = NO;
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
   
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    
    [self initMapView];
    [self initCheckoutView];
    
    
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

- (IBAction)onFBLink:(id)sender {
    
    NSString * urlString = [appDelegate.selectedStore objectForKey:@"pagelink"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

-(void)initMapView
{
    
    float  latitude = [[appDelegate.selectedStore objectForKey:@"latitude"] floatValue];
    float longitude =[[appDelegate.selectedStore objectForKey:@"longitude"] floatValue];
    
    BasicMapAnnotation *normalAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude] ;
    
    NSString * name =   [appDelegate.selectedStore objectForKey:@"name"] ;
    if (name == nil || [name isEqual:[NSNull null]]) {
        name = @"";
    }
    
    normalAnnotation.title = name;
    normalAnnotation.category = @"normal";
    
    [mapView addAnnotation:normalAnnotation];
    
    CLLocationCoordinate2D coordinate = {latitude, longitude};
    CLLocationCoordinate2D coordinate2 = {latitude - 0.0015, longitude};
    MKCoordinateRegion  mapViewRegion2 = MKCoordinateRegionMake(coordinate,    MKCoordinateSpanMake(1/128.0f, 1/128.0f));
    [mapView setRegion:mapViewRegion2];
    [mapView setCenterCoordinate:coordinate2];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"NormalAnnotation"] ;
    
    
    annotationView.canShowCallout = NO;
    
    UIImage * annotationImage = [UIImage imageNamed:@"phone_call.png"];
    
    annotationView.image = annotationImage;
    [annotationView setFrame:CGRectMake(0, 0, 28, 28)];
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)view
{
    [appDelegate onPhoneCall];
    [mapView deselectAnnotation:view.annotation animated:NO];
}

//-(void)initPaypal
//{
//    if (PAYPAL_LIVE_FLAG) {
//        [PayPal initializeWithAppID:PAYPAL_LIVE_APPID forEnvironment:ENV_LIVE];
//    }else{
//        [PayPal initializeWithAppID:PAYPAL_SANDBOX_APPID forEnvironment:ENV_SANDBOX];
//    }
//    
//    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
//    //[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
//    
//    [checkOutButton setAlpha:0.3f];
//    [checkOutButton setUserInteractionEnabled:NO];
//    
//     [NSThread detachNewThreadSelector:@selector(detectPaypalStatus) toTarget:self withObject:nil];
//}

/////////////////////                     ///////////////////

-(void) initCheckoutView
{
   
    [checkOutView.layer setCornerRadius:5];
    

    NSString * name =   [appDelegate.selectedStore objectForKey:@"name"] ;
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
    
    NSString *address = [NSString stringWithFormat:@"%@, %@", street, city];

    NSString * special_title =   [appDelegate.selectedStore objectForKey:@"special_title"] ;
    if (special_title == nil || [special_title isEqual:[NSNull null]]) {
        special_title = @"";
    }
    
    
    NSNumber * priceNumber =   [appDelegate.selectedStore objectForKey:@"special_price"] ;
    unitPrice = 0.00;
    isFreeSpecial = YES;
    if (priceNumber != nil && ![priceNumber isEqual:[NSNull null]]) {
        unitPrice = [priceNumber floatValue];
        if (unitPrice != 0) {
            isFreeSpecial = NO;
        }

    }
    
    currentCount = 1;
    
    nameLabel.text = name;
    addressLabel.text = address;
    
    orderNumberLabel.text = appDelegate.orderNumberStr;
    
    if(isFreeSpecial)
    {
        [freeSpecialLabel setHidden:YES];
        freeSpecialLabel.text = special_title;
        [checkOutButton setTitle:@"CheckOut" forState:UIControlStateNormal];
       
        [plusButton setUserInteractionEnabled:NO];
        [minusButton setUserInteractionEnabled:NO];
       
    }else{
        
       // [self initPaypal];
        [freeSpecialLabel setHidden:YES];
    
        [checkOutButton setTitle:@"Check Out" forState:UIControlStateNormal];
        
        [plusButton setUserInteractionEnabled:YES];
        [minusButton setUserInteractionEnabled:YES];
               
    }
    
    NSNumber * tax_rateNumber =   [appDelegate.selectedStore objectForKey:@"tax_rate"] ;
    tax = 0.00;
    if (tax_rateNumber != nil && ![tax_rateNumber isEqual:[NSNull null]]) {
        tax = [tax_rateNumber doubleValue] /100;
    }
    
    titleLabel.text = special_title;
    priceLabel.text = [NSString stringWithFormat:@"$%.2f", unitPrice];
    taxLabel.text = [NSString stringWithFormat:@"$%.2f", unitPrice * tax];
    
    countLabel.text = [NSString stringWithFormat:@"%ld",(long)currentCount];
    totalLabel.text = [NSString stringWithFormat:@"$%.2f",unitPrice *(1 +  tax)];
    
    
}

//-(void)detectPaypalStatus
//{
//    while ([PayPal initializationStatus] == STATUS_INPROGRESS) {
//        [NSThread sleepForTimeInterval:0.5];
//    }
//    
//    if ([PayPal initializationStatus] == STATUS_COMPLETED_SUCCESS) {
//        [checkOutButton setAlpha:1.0];
//        [checkOutButton setUserInteractionEnabled:YES];
//    }
//}


///// Plus And Minus Action
-(IBAction)onPlus:(id)sender
{
    currentCount ++;
    countLabel.text = [NSString stringWithFormat:@"%ld",(long)currentCount];
    taxLabel.text = [NSString stringWithFormat:@"$%.2f",unitPrice*currentCount*tax];
    totalLabel.text = [NSString stringWithFormat:@"$%.2f",unitPrice * currentCount * (1 + tax)];
}


-(IBAction)onMinus:(id)sender
{
    if (currentCount != 1) {
        currentCount --;
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)currentCount];
        taxLabel.text = [NSString stringWithFormat:@"$%.2f",unitPrice*currentCount*tax];
        totalLabel.text = [NSString stringWithFormat:@"$%.2f",unitPrice * currentCount*(1 + tax)];
        
    }
}


// Check out Action

-(IBAction)onCheckOut:(id)sender
{
    if (isFreeSpecial)
    {
        [self  sendOrderRequest:@""];
    }
    else
    {
        
        [self setStripePaymentMethod];
        
        
//        PayPalInitializationStatus  statusValue = (PayPalInitializationStatus)[PayPal initializationStatus];
//        
//        if (statusValue == STATUS_COMPLETED_SUCCESS) {
//            
//        }else if(statusValue == STATUS_NOT_STARTED || status == STATUS_COMPLETED_ERROR){
//            [self RetryInitialization];
//        }else aqif(statusValue == STATUS_INPROGRESS)
//        {
//            return;
//        }
    }
}

- (void)setStripePaymentMethod {
    
//    PayPal * tempPayPal =  [PayPal getPayPalInst];
//    tempPayPal.delegate = self;
//    
//    tempPayPal.shippingEnabled = FALSE;
//    
//    tempPayPal.dynamicAmountUpdateEnabled = TRUE;
//    
//    tempPayPal.feePayer = FEEPAYER_EACHRECEIVER;
   // tempPayPal.feePayer = FEEPAYER_PRIMARYRECEIVER;
    
    //for a payment with multiple recipients, use a PayPalAdvancedPayment object
    
   // PayPalPayment *payment = [[PayPalPayment alloc] init] ;
   // payment.paymentCurrency = @"USD";
    
  //    payment.ipnUrl = [NSString stringWithFormat:@"%@/paypalIPN/IPNListner.php",SERVER_IP];
    //receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
    
//    payment.recipient = merchantPaypalEmai;
//    payment.description = @"RedBasket App";
//    payment.merchantName = merchantName;
    
    float  totalPrice = unitPrice * currentCount * (1 + tax);
    
    float  merchantAmount = totalPrice * 0.8;
    
    
    
//    
//            NSDecimalNumber *subTotal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",unitPrice * currentCount]];
//    
//        NSDecimalNumber *totalShipping = [NSDecimalNumber decimalNumberWithString:@"0.00"];
//    
//    NSDecimalNumber *totalTax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",unitPrice * currentCount * tax]];
//            
//            payment.invoiceData.invoiceItems = [NSMutableArray array];
//            PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
    
               [[NSUserDefaults standardUserDefaults]setFloat:tax forKey:@"taxCountData"];

            [[NSUserDefaults standardUserDefaults]setFloat:totalPrice forKey:@"currentcount"];

            [[NSUserDefaults standardUserDefaults]setInteger:merchantAmount forKey:@"marcentammount"];
    
            [self performSegueWithIdentifier:@"100Token" sender:self];

//            [payment.invoiceData.invoiceItems addObject:item];
    
//    [[PayPal getPayPalInst] checkoutWithPayment:payment];
}

#pragma mark -
//#pragma mark PayPalPaymentDelegate methods
//
//-(void)RetryInitialization
//{
//    if (PAYPAL_LIVE_FLAG) {
//        [PayPal initializeWithAppID:PAYPAL_LIVE_APPID forEnvironment:ENV_LIVE];
//    }else{
//        [PayPal initializeWithAppID:PAYPAL_SANDBOX_APPID forEnvironment:ENV_SANDBOX];
//    }
//    
//    [NSThread detachNewThreadSelector:@selector(detectPaypalStatus) toTarget:self withObject:nil];
//    //DEVPACKAGE
//    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
//    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
//}

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
//- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
//    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
//    NSLog(@"severity: %@", severity);
//    NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
//    NSLog(@"category: %@", category);
//    NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
//    NSLog(@"errorId: %@", errorId);
//    NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
//    NSLog(@"message: %@", message);
//    
//    status = PAYMENTSTATUS_SUCCESS;
//    
//    //   NSDictionary * tempDic = [PayPal getPayPalInst].responseMessage;
//    
//    [self sendOrderRequest:payKey];
//}

-(void)sendOrderRequest:(NSString *)payKey
{
    NSMutableDictionary *orderData = [[NSMutableDictionary alloc] init];
    
    [orderData setObject:appDelegate.orderNumber forKey:@"orderNumber"];
    
    [orderData setObject:[appDelegate.selectedStore objectForKey:@"fb_id"] forKey:@"merchant_fb_id"];
    [orderData setObject:appDelegate.userFB_ID forKey:@"user_fb_id"];
    [orderData setObject:appDelegate.userName forKey:@"user_name"];
    [orderData setObject:[appDelegate.selectedStore objectForKey:@"paypalemail"] forKey:@"merchant_paypal"];
    
    [orderData setObject:payKey forKey:@"transactionId"];
    
    [orderData setObject:@"user1" forKey:@"user_paypal"];
    [orderData setObject:titleLabel.text forKey:@"special_title"];
    
    if (isFreeSpecial) {
        currentCount = 1;
        unitPrice = 0.0;
        tax = 0;
    }
    
    [orderData setObject:[NSString stringWithFormat:@"%ld", (long)currentCount] forKey:@"count"];
    [orderData setObject:[NSString stringWithFormat:@"%.2f",unitPrice] forKey:@"unit_price"];
    [orderData setObject:[NSString stringWithFormat:@"%.2f",unitPrice * currentCount * tax] forKey:@"tax"];
    
    [orderData setObject:[NSString stringWithFormat:@"%.2f", unitPrice * currentCount * (1 + tax)] forKey:@"total_price"];
    
    
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
    
    [serverManager fetchDataOnserverWithAction:ADD_ORDER forView:self.view forPostData:postring];
}

-(void)postSpecialToFacebook
{
    
    NSString * postMessage = [NSString stringWithFormat:@"I just got %@ for %@ at %@\n  Install the free Red Basket app and get red hot deals from stores near you. ",titleLabel.text, priceLabel.text, nameLabel.text];
    NSString * imagePath =   [appDelegate.selectedStore objectForKey:@"image_path"] ;
    NSString * photoUrl = [NSString stringWithFormat:@"%@/%@",SERVER_IP, imagePath];
    
    NSDictionary * photoParam = [[NSDictionary alloc] initWithObjectsAndKeys:postMessage , @"message", photoUrl,@"picture", nil];
    
    [FBRequestConnection startWithGraphPath:@"/me/feed" parameters:photoParam HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
    }];
}

-(void)gotoReceiptView:(NSString *)barcode
{
    RBReceiptVC * recepitVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RBReceiptVC"];
    recepitVC.barcodeStr = barcode;
    recepitVC.orderDetailFlag = NO;
    recepitVC.redeemedFlag = NO;
    recepitVC.isFreeSpecial = isFreeSpecial;
    [self.navigationController pushViewController:recepitVC animated:YES];
    
}
//// ServerManager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
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

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
//- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
//    
//    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
//    NSLog(@"severity: %@", severity);
//    NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
//    NSLog(@"category: %@", category);
//    NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
//    NSLog(@"errorId: %@", errorId);
//    NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
//    NSLog(@"message: %@", message);
//    
//    status = PAYMENTSTATUS_FAILED;
//}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
//- (void)paymentCanceled {
//    status = PAYMENTSTATUS_CANCELED;
//}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
//- (void)paymentLibraryExit {
//    UIAlertView *alert = nil;
//    switch (status) {
//        case PAYMENTSTATUS_SUCCESS:
//            
//            break;
//        case PAYMENTSTATUS_FAILED:
//            alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
//                                               message:@"Your order failed. Touch \"Pay with PayPal\" to try again."
//                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [self RetryInitialization];
//            break;
//        case PAYMENTSTATUS_CANCELED:
//            alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
//                                               message:@""
//                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            break;
//    }
//    [alert show];
//}

//adjustAmountsForAddress:andCurrency:andAmount:andTax:andShipping:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use the advanced version first, but will use this one if that one is not implemented.

//- (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
//                                    andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
//    //do any logic here that would adjust the amount based on the shipping address
//    PayPalAmounts *newAmounts = [[PayPalAmounts alloc] init] ;
//    newAmounts.currency = @"USD";
//    newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
//    
//    //change tax based on the address
//    if ([inAddress.state isEqualToString:@"CA"]) {
//        newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .1]];
//    } else {
//        newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .08]];
//    }
//    newAmounts.shipping = (NSDecimalNumber *)inShipping;
//    
//    //if you need to notify the library of an error condition, do one of the following
//    //*outErrorCode = AMOUNT_ERROR_SERVER;
//    //*outErrorCode = AMOUNT_CANCEL_TXN;
//    //*outErrorCode = AMOUNT_ERROR_OTHER;
//    
//    return newAmounts;
//}

//adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use this version first, but will use the simple one if this one is not implemented.
//- (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
//                                 andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
//    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
//    for (PayPalReceiverAmounts *amounts in receiverAmounts) {
//        //leave the shipping the same, change the tax based on the state
//        if ([inAddress.state isEqualToString:@"CA"]) {
//            amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .1]];
//        } else {
//            amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .08]];
//        }
//        [returnArray addObject:amounts];
//    }
//    
//    //if you need to notify the library of an error condition, do one of the following
//    //*outErrorCode = AMOUNT_ERROR_SERVER;
//    //*outErrorCode = AMOUNT_CANCEL_TXN;
//    //*outErrorCode = AMOUNT_ERROR_OTHER;
//    
//    return returnArray;
//}


@end
