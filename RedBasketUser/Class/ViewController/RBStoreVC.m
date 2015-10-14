//
//  RBStoreVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBStoreVC.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "BasicMapAnnotation.h"
#import "RBStoreListVC.h"
#import "RBLoginVC.h"

@interface RBStoreVC ()<MKMapViewDelegate, ServerManagerDelegate, UIAlertViewDelegate>
{
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet UIImageView * lunchImageView;
    
    IBOutlet MKMapView * mapView;
    
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * addressLabel;
    
    
    IBOutlet UIView * descriptionPanel;
    
    IBOutlet UILabel * expireTimeLabel;
    IBOutlet UILabel * specialTitleLabel;
    IBOutlet UILabel * specialPriceLabel;
    IBOutlet UILabel * specialDescriptionLabel;
    IBOutlet UILabel * expireDateLabel;
    IBOutlet UIButton *orderButton;
    
    IBOutlet UIImageView * storeImageView;
    
    BOOL expiredFlag;
    IBOutlet UIImageView * expiredImageView;
  
}

@end

@implementation RBStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    mapView.delegate = self;
    mapView.showsUserLocation = NO;

    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    
    if (appDelegate.isIphone4) {
        expiredImageView.image = [UIImage imageNamed:@"expired_iphone4.png"];
    }else{
        expiredImageView.image = [UIImage imageNamed:@"expired.png"];
    }
    
    [self initMapView];
    [self initStorePage];
    
    if (self.pushed_flag) {
        [self getUserData];
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEpireLabel) name:UPDATE_EXPIRE_TIMER object:nil];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [mapView removeAnnotations:mapView.annotations];
    if (appDelegate.selectedStore == nil) {
        return;
    }
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
    [annotationView setFrame:CGRectMake(0, 0, 30, 30)];
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)view
{
      [appDelegate onPhoneCall];
    
    [mapView deselectAnnotation:view.annotation animated:NO];
}

-(void)initStorePage
{
    if (appDelegate.selectedStore == nil) {
        [lunchImageView setHidden:NO];
        return;
    }
 
    NSString * publishDateStr = [appDelegate.selectedStore objectForKey:@"published_time"];
    
    NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone * localTimeZone = [NSTimeZone localTimeZone];
    
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSLog(@"%@", currentTimeZone);
    NSLog(@"%@", localTimeZone);
    NSString * formatStr2 = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatStr2];
    [formatter2 setTimeZone:utcTimeZone];
    NSDate * publishDate = [formatter2 dateFromString:publishDateStr];
  
    int expire_time = [appDelegate.selectedStore objectForKey:@"expire_time"] != nil ?[[appDelegate.selectedStore objectForKey:@"expire_time"] intValue] : 0 ;
    int expire_day = [appDelegate.selectedStore objectForKey:@"expire_day"] != nil ?[[appDelegate.selectedStore objectForKey:@"expire_day"] intValue ]: 0;
    
    NSDate * expireDate = [publishDate dateByAddingTimeInterval:(expire_time * 60 + expire_day *24 *  60 * 60)];
    
    NSString * formatStr = @"hh:mm a MM/dd/yyyy";
    [formatter2 setDateFormat:formatStr];
    [formatter2 setTimeZone:localTimeZone];
    
    appDelegate.activeStoreExpireTimeStr =[formatter2 stringFromDate:expireDate];
    
    [lunchImageView setHidden:YES];
    
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
    
    nameLabel.text = name;
    addressLabel.text = address;
    
    
    NSString * special_title =   [appDelegate.selectedStore objectForKey:@"special_title"] ;
    if (special_title == nil || [special_title isEqual:[NSNull null]]) {
        special_title = @"";
    }
    
    
    NSNumber * priceNumber =   [appDelegate.selectedStore objectForKey:@"special_price"] ;
    float price = 0.00;
    NSString * priceStr = @"FREE";
    if (priceNumber != nil && ![priceNumber isEqual:[NSNull null]]) {
        price = [priceNumber floatValue];
        if (price != 0) {
            priceStr = [NSString stringWithFormat:@"$%.2f", price];
        }
        
    }
    
    
    NSString * description =   [appDelegate.selectedStore objectForKey:@"special_description"] ;
    if (description == nil || [description isEqual:[NSNull null]]) {
        description = @"";
    }
    
    description = [description stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    expiredFlag = YES;
    
  
    NSString *expireStr;
    expireStr = @"Offer Expired";
    
    if ([priceStr isEqualToString:@"FREE"]) {
        expiredFlag = NO;
         expireStr = [NSString stringWithFormat:@"Only %@ Left", [appDelegate.selectedStore objectForKey:@"offer_token_limit"]];
    }else{
        expireStr =  [self fetchExpireTimeStr];
        
    }
    
    [self updateOrderButton];
    
    expireTimeLabel.text =  expireStr;
    
    specialTitleLabel.text = special_title;
    specialPriceLabel.text = priceStr;
    specialDescriptionLabel.text = description;
    expireDateLabel.text = [NSString stringWithFormat:@"Offer Expires %@", appDelegate.activeStoreExpireTimeStr];
    UIFont * font = specialDescriptionLabel.font;
    
    float  textHeight = [self findHeightForText:description havingWidth:specialDescriptionLabel.frame.size.width andFont:font];
    
    CGRect frame1 = specialDescriptionLabel.frame;
    CGRect frame2 = descriptionPanel.frame;
    CGRect frame4 = expireDateLabel.frame;
    
    frame4.origin.y = frame4.origin.y - frame1.size.height + textHeight +2;
    
    frame2.size.height = (frame2.size.height - specialDescriptionLabel.frame.size.height) + textHeight;
    frame2.origin.y = orderButton.frame.origin.y - frame2.size.height;
    
    frame1.size.height = textHeight;
    
    CGRect frame3 = expireTimeLabel.frame;
    frame3.origin.y = frame2.origin.y - frame3.size.height;
    
    [descriptionPanel setFrame:frame2];
    [specialDescriptionLabel setFrame:frame1];
    [expireTimeLabel setFrame:frame3];
    [expireDateLabel setFrame:frame4];
    
    NSString * imagePath =   [appDelegate.selectedStore objectForKey:@"image_path"] ;
    
    [storeImageView setImage:[UIImage imageNamed:@"default_restaurant.png"]];
    
    if (imagePath == nil || [imagePath isEqual:[NSNull null]]) {
    }else{
        [storeImageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_IP,imagePath]]];
    }
    
}

-(void)updateOrderButton
{
    if (expiredFlag ) {
        [expiredImageView setHidden:NO];
        [orderButton setTitle:@"Back" forState:UIControlStateNormal];
        
    }else{
        [expiredImageView setHidden:YES];
        [orderButton setTitle:@"Order Now" forState:UIControlStateNormal];
    }
}

-(NSString *)fetchExpireTimeStr
{
    NSString * expireStr = @"Offer Expired";
    NSNumber * differentTime =   [appDelegate.selectedStore objectForKey:@"different_time"] ;
    NSNumber * expireTime = [appDelegate.selectedStore objectForKey:@"expire_time"] ;
    
    expiredFlag = YES;
    
    if (differentTime == nil || [differentTime isEqual:[NSNull null]] || expireTime == nil) {
       
        
    }else{
        int expire_time = [expireTime intValue];
        int different_time = [differentTime intValue];
        
        if (different_time > 0) {
            
            int time = expire_time * 60 - different_time;
            
            if (time > 0) {
                
                int hour = time / 3600;
                int min = (time%3600)/60;
                int sec = (time%3600)%60;
                
                NSString * hourStr = (hour > 9)?[NSString stringWithFormat:@"%d",hour]:[NSString stringWithFormat:@"0%d",hour];
                NSString * minStr = (min > 9)?[NSString stringWithFormat:@"%d",min]:[NSString stringWithFormat:@"0%d",min];
                NSString * secStr = (sec > 9)?[NSString stringWithFormat:@"%d",sec]:[NSString stringWithFormat:@"0%d",sec];
                
                expireStr = [NSString stringWithFormat:@"Offer Ends:   %@:%@:%@", hourStr, minStr, secStr];
                expiredFlag = NO;
            }
        }
    }
    
    return  expireStr;

}

- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    //CGFloat width = widthValue;
    if (text) {
        CGSize size;
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
        //iOS 6.0
        //            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

-(IBAction)orderNow:(id)sender
{
    if (expiredFlag) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MBProgressHUD * hud  =  [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hud.labelText = @"Ordering...";
    
    NSData * orderData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL, GET_ORDERNUMBER]]];
    
    NSString * orderNumberString = [[NSString alloc] initWithData:orderData encoding:NSASCIIStringEncoding];
    
    NSArray *tempArray = [orderNumberString componentsSeparatedByString:@"=="];
    
    if (tempArray != nil && [tempArray count] == 2 ) {
        
        appDelegate.orderNumber = [tempArray objectAtIndex:1];
        appDelegate.orderNumberStr = [NSString stringWithFormat:@"Order #%@-%@", [appDelegate.orderNumber substringToIndex:3],[appDelegate.orderNumber substringFromIndex:3]];
        [self performSegueWithIdentifier:GOTO_CHECKOUTVIEW sender:self];
    }else{
        appDelegate.orderNumber = @"";
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Can not Connect Server ! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    }

}


-(void)getUserData
{
    ServerManager * manager = [ServerManager sharedManager];
    manager.delegate = self;
    
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@", appDelegate.userFB_ID];
    
    [manager fetchDataOnserverWithAction:GET_USERDATA forView:self.view forPostData:postStr];
}

-(void)getStoreData
{
    ServerManager * manager = [ServerManager sharedManager];
    manager.delegate = self;
    
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@", appDelegate.pushedStore_ID];
    
    [manager fetchDataOnserverWithAction:GET_STOREDATA forView:self.view forPostData:postStr];
}

/// Server Manager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    NSString * flag = [responseDic objectForKey:@"success"];
    if (flag != nil && [flag isEqualToString:@"OK"]) {
        NSDictionary * data = [responseDic objectForKey:@"data"];
        if ([actionName isEqualToString:GET_USERDATA]) {
            appDelegate.userName = [data objectForKey:@"name"] != nil ?[data objectForKey:@"name"] : @"";
            appDelegate.userContactEmail = [data objectForKey:@"contact_email"] != nil ? [data objectForKey:@"contact_email"] : @"";
            appDelegate.push_flag = [data objectForKey:@"push_flag"] != nil ?[[data objectForKey:@"push_flag"] intValue] : NO;
            [self getStoreData];
        }else if([actionName isEqualToString:GET_STOREDATA])
        {
            appDelegate.selectedStore = data;
            [self initStorePage];
            [self initMapView];
        }
    }else{
         if ([actionName isEqualToString:GET_USERDATA]) {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Can not Load User Data"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             alertView.tag = 1234;
             [alertView show];
             
             return;
         }
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Can not Load Store Data"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234) {
        
        RBLoginVC * loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RBLoginVC"];
        [appDelegate.window setRootViewController:loginVC];
        
    }
}


-(void)updateEpireLabel
{
     if (![specialPriceLabel.text isEqualToString:@"FREE"]) {
         expireTimeLabel.text =  [self fetchExpireTimeStr];
     }
    
    [self updateOrderButton];
}

@end
