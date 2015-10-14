//
//  AppDelegate.m
//  RedBasketUser
//
//  Created by Glenn on 4/7/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "RBStoreVC.h"

@interface AppDelegate ()<CLLocationManagerDelegate,AVAudioPlayerDelegate>
    @property (strong, nonatomic) AVAudioSession *audioSession;
    @property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    CGSize iOSScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSScreenSize.height == 480) {
        self.isIphone4 = YES;
    }else{
        self.isIphone4 = NO;
    }
        
    
    serverManager = [[ServerManager alloc] init];
    
    self.isLoginFlag = NO;
    self.userFB_ID = @"";
    self.push_flag = NO;
    self.userContactEmail = @"";
    self.selectedCellIndex = -1;
       
    self.deviceTokenStr  = @"";
    [FBLoginView class];
    
    // Setting PushNotification\
    
    if (IS_OS_8_OR_LATER) {
        
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge) categories:nil];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }

    
    // Getting Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 2;
    locationManager.delegate = self;
    
    self.currentLocation = nil;
    if(IS_OS_8_OR_LATER){
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
    
    
    [locationManager startUpdatingLocation];
    
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.window.frame.size.width, 64)];
    [notificationView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 220, 35)];
    messageLabel.text = @"message";
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.numberOfLines = 20;
    [notificationView addSubview:messageLabel];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 22, 28,28)];
    imageView.image = [UIImage imageNamed:@"app_icon.png"];
    [imageView.layer setCornerRadius:5];
    [imageView setClipsToBounds:YES];
    
    [notificationView addSubview:imageView];
    
    [notificationView setClipsToBounds:YES];
    
    [self.window addSubview:notificationView];
    
    [self configureAudioSession];
    [self configureAudioPlayer];
    [self.backgroundMusicPlayer prepareToPlay];

    UILocalNotification * notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notification != nil) {
        
        [self gotoPushedPage:notification];
        
    }


    
    return YES;
}


#pragma mark - Private

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

- (void)configureAudioPlayer {
    
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"push_sound" ofType:@"mp3"];
    
    if (backgroundMusicPath == nil) {
        return;
    }

    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.backgroundMusicPlayer.numberOfLoops = 0;	// Negative number means loop forever
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.backgroundMusicPlayer stop];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
       [[NSNotificationCenter defaultCenter] postNotificationName:@"activeApp" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    // Attempt to extracct to token from the
    
    if ([self.activeSocialNetwork isEqualToString:@"facebook"]) {
        return  [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }else if([self.activeSocialNetwork isEqualToString:@"twitter"])
    {
        return YES;
    }
    
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = manager.location;
    
    if(self.isLoginFlag && ![self.userFB_ID isEqualToString:@""])
    {
        NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&latitude=%.6f@&longitude=%.6f",self.userFB_ID,self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
        [serverManager fetchDataOnserverWithAction:USER_LOCATION_UPDATE forView:nil forPostData:postStr];
    }
    
    //  [manager stopUpdatingLocation];
}

/// PUSH notification Service

#ifdef  __IPHONE_8_0

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]) {
        
    }else if([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = [[userInfo objectForKey:@"badge"] integerValue];
    UIApplicationState state = [application applicationState];
    
    if(state == UIApplicationStateActive)
    {
        messageLabel.text = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        [self.backgroundMusicPlayer play];
        [self.window bringSubviewToFront:notificationView];
        [UIView animateWithDuration:1 animations:^{
            
            [notificationView setFrame:CGRectMake(0, 0, self.window.frame.size.width, 64)];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:4 animations:^{
                [notificationView setFrame:CGRectMake(0, -64, self.window.frame.size.width, 64)];
            }];
            
        }];
        
        
    }else{
        [self gotoPushedPage:userInfo];
    }
}

-(void)gotoPushedPage:(NSDictionary *)userInfo
{
    NSString * store_fb_id = [[userInfo objectForKey:@"aps"] objectForKey:@"merchant_fb_id"];
    NSString * user_fb_id = [[userInfo objectForKey:@"aps"] objectForKey:@"user_fb_id"];
    
    self.userFB_ID = user_fb_id;
    self.pushedStore_ID = store_fb_id;
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController * initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    RBStoreVC * storeController = [storyBoard instantiateViewControllerWithIdentifier:@"RBStoreVC"];
    storeController.pushed_flag = YES;
    self.isLoginFlag = YES;
    self.selectedCellIndex = -1;
    
    [initViewController setViewControllers:@[storeController]];
    
    self.window.rootViewController = initViewController;
    
    [self.window makeKeyAndVisible];

}

// Push notification Register to Server

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is :%@", deviceToken);
    self.deviceTokenStr = [self hexadecimalString:deviceToken];
}


- (NSString *)hexadecimalString:(NSData *)data {
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength  * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}



- (void)onPhoneCall {
    
    NSString * phoneNumber = [self.selectedStore objectForKey:@"phonenumber"];
    
    if (phoneNumber == nil || [phoneNumber isEqualToString:@""]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Phone Number Invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    NSString * phoneURLStr = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL * phoneURL = [NSURL URLWithString:phoneURLStr];
    
    if (phoneURL == nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Phone Number Invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL: phoneURL];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You can not call in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

        
        -(void)startExpireTimer
        {
              [self stopExpireTimer];
            if (self.storeList == nil || [self.storeList count] == 0) {
                return;
            }
             expireTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRestTime) userInfo:nil repeats:YES];
        }
        
        -(void)stopExpireTimer
        {
            if (expireTimer != nil) {
                [expireTimer invalidate];
                expireTimer = nil;
                
            }
        }
        
        -(void)updateRestTime
        {
            for (int i =0 ; i<self.storeList.count; i++) {
                
                 NSDictionary * tempDic = [self.storeList objectAtIndex:i];
                
                NSNumber * differentTime =   [tempDic objectForKey:@"different_time"] ;
                
                if (differentTime == nil || [differentTime isEqual:[NSNull null]]) {
                    
                }else{
                    int different_time = [differentTime intValue];
                    
                    if (different_time > 0) {
                        
                        different_time ++;
                        [tempDic setValue:[NSNumber numberWithInt:different_time] forKey:@"different_time"];
                    }

            }
        }
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_EXPIRE_TIMER object:nil];
         
}
        

        

@end
