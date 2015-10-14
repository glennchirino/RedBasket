//
//  RBHelpVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBHelpVC.h"
#import "AppDelegate.h"
#import "RBStoreListVC.h"

@interface RBHelpVC ()
{
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
      IBOutlet UIWebView *webView;
}

@end

@implementation RBHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
 
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    
    [self initHelpView];
    
}

-(void)initHelpView
{
    [webView setBounds:CGRectMake(15, 0, webView.frame.size.width - 25 , webView.frame.size.height)];
    
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    
    NSString * filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"usersidehelp" ofType:@"html"];
    
    NSString * htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
    
    [webView loadHTMLString:htmlString baseURL:nil];
    
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


@end
