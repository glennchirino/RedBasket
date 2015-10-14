//
//  RBLoginVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/9/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBLoginVC.h"
#import "AppDelegate.h"

@interface RBLoginVC ()<FBLoginViewDelegate, ServerManagerDelegate>
{
    AppDelegate *appDelegate ;
    
    FBLoginView * fbLoginView;
    
    BOOL  signInFlag;
}

@end

@implementation RBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    signInFlag = NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    fbLoginView = [[FBLoginView alloc] initWithFrame:CGRectZero];
    
    [fbLoginView setHidden:YES];
    fbLoginView.delegate = self;
    fbLoginView.readPermissions = @[@"public_profile",@"publish_actions"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)facebookSignIn:(id)sender {
      
   appDelegate.activeSocialNetwork = @"facebook";
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    for(id object in fbLoginView.subviews){
        if([[object class] isSubclassOfClass:[UIButton class]]){
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)userSignin:(id<FBGraphUser>) fb_user
{
    if (signInFlag) {
        return;
    }
    signInFlag = YES;
    NSString *userID = fb_user.objectID;
    NSString * userName = [fb_user name];
    appDelegate.userName = userName;

    appDelegate.userFB_ID = userID;
    
    ServerManager *manager = [ServerManager sharedManager];
    manager.delegate = self;
    
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&name=%@&devicetoken=%@",userID,userName, appDelegate.deviceTokenStr];
    
    [manager fetchDataOnserverWithAction:USER_SIGNIN forView:self.view forPostData:postStr];
    
}

// Show Store page

-(void)showStorePage
{
   [self performSegueWithIdentifier:GOTO_LISTVIEW sender:self];
}

#pragma mark - Facebook Login Button Delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    if (user == nil) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Please user other Account"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
//    [NSLog(@"FacebookLogin %@", user.objectID);
    [self userSignin:user];
    
}


// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

//// Server Manager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    signInFlag = NO;
    if (responseDic) {
        NSString * flag = [responseDic objectForKey:@"flag"];
        if (flag) {
            if([flag isEqualToString:@"old"]){
                NSDictionary * tempDic = [responseDic objectForKey:@"data"];
                appDelegate.push_flag = [[tempDic objectForKey:@"push_flag"] boolValue];
                appDelegate.userContactEmail = [tempDic objectForKey:@"contact_email"] != nil ? [tempDic objectForKey:@"contact_email"]:@"";
            }
            
            appDelegate.isLoginFlag = YES;
            [self showStorePage];

        }
    }
}

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    signInFlag = NO;
}


@end
