//
//  RBPreferenceVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBPreferenceVC.h"
#import "AppDelegate.h"
#import "RBStoreListVC.h"

@interface RBPreferenceVC ()<UITextFieldDelegate, ServerManagerDelegate, UIAlertViewDelegate>
{
    
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet UIScrollView * preferenceScrollView;
    IBOutlet UITextField * emailaddressField;
    IBOutlet UISwitch * pushOfferSwitch;
    
    IBOutlet UIButton * cancelButton;
    IBOutlet UIButton * saveButton;
}

@end

@implementation RBPreferenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];

    emailaddressField.delegate = self;
    
    [cancelButton.layer setBorderWidth:2];
    [cancelButton.layer setBorderColor:APP_RED_COLOR.CGColor];
    [cancelButton.layer setCornerRadius:5];
    
    [saveButton.layer setBorderWidth:2];
    [saveButton.layer setBorderColor:APP_RED_COLOR.CGColor];
    [saveButton.layer setCornerRadius:5];
    
    [pushOfferSwitch setOn:appDelegate.push_flag];
    [emailaddressField setText:appDelegate.userContactEmail];
    
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
    appDelegate.selectedCellIndex = -1;
    RBStoreListVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RBStoreListVC"];
    [self.navigationController setViewControllers:@[controller] animated:YES];
}

-(IBAction)onCancel:(id)sender
{
     appDelegate.selectedCellIndex = appDelegate.beforeSelectedCellIndex;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onSave:(id)sender
{
    
    ServerManager * manager = [ServerManager sharedManager];
    manager.delegate = self;
    
    int flagInt = pushOfferSwitch.isOn?1:0;
    
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&push_flag=%i&contact_email=%@",appDelegate.userFB_ID, flagInt, emailaddressField.text];
    
    [manager fetchDataOnserverWithAction:SAVE_USER_PREFERENCE forView:self.view forPostData:postStr];
    
}

///  TextField Delegate   ////////

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [preferenceScrollView setContentOffset:CGPointMake(0, 120)];
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [preferenceScrollView setContentOffset:CGPointZero];
    [emailaddressField resignFirstResponder];
    return YES;
}


//// Server Manager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    if (responseDic) {
        NSString * flag = [responseDic objectForKey:@"success"];
        if (flag != nil && [flag isEqualToString:@"OK"]) {
            appDelegate.push_flag = pushOfferSwitch.isOn;
            appDelegate.userContactEmail = emailaddressField.text;
             appDelegate.selectedCellIndex = appDelegate.beforeSelectedCellIndex;
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Save Successfully!"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alertView.tag = 12345;
            [alertView show];
            
            return;
        }
    }
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Save Failed !"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12345) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
