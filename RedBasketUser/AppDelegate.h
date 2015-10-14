//
//  AppDelegate.h
//  RedBasketUser
//
//  Created by Glenn on 4/7/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager * locationManager;
    UIView * notificationView;
    UILabel * messageLabel;
    
    ServerManager * serverManager;

     NSTimer *expireTimer;
}

@property(assign, nonatomic) BOOL isIphone4;

@property(assign , nonatomic) NSInteger  selectedCellIndex;
@property(assign , nonatomic) NSInteger  beforeSelectedCellIndex;

@property(assign, nonatomic) BOOL isLoginFlag;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString * deviceTokenStr;

@property(strong, nonatomic) NSString * activeSocialNetwork;

@property(strong, nonatomic) NSString * pushedStore_ID;

@property(strong, nonatomic) NSString * userFB_ID;
@property(strong, nonatomic) NSString * userName;
@property(assign, nonatomic) BOOL  push_flag;
@property(strong, nonatomic) NSString * userContactEmail;

@property(strong, nonatomic) NSArray * storeList;
@property(strong , nonatomic)NSArray * distanceArray;
@property(strong, nonatomic) NSDictionary * selectedStore;
@property(strong, nonatomic) NSString * orderNumber;
@property(strong, nonatomic) NSString * orderNumberStr;
@property(strong, nonatomic) NSDictionary * justOrderData;

@property (strong, nonatomic) NSString * activeStoreExpireTimeStr;

- (void)onPhoneCall ;

-(void)startExpireTimer;
-(void)stopExpireTimer;

@end

