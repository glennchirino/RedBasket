//
//  ServerManager.m
//  eMenu
//
//  Created by glenn on 12/24/14.
//  Copyright (c) 2014 glenn. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager
@synthesize delegate;

static ServerManager * shareInstance=nil;

+(ServerManager*)sharedManager
{
    @synchronized(self)
    {
        if (shareInstance==nil)
        {
            shareInstance=[[ServerManager alloc]init];
        }
    }
    return shareInstance;
}

- (void)postData:(NSString *) urlService forView:(UIView *)baseView
{
    [self hideHub];
    if (![MyNetHelper connectedToNetwork]) {
        [self showAlertWithTitle:@"Error!!" withMessage:@"Internet Connection is not available Please Check your Network connection"];
        
        [self.delegate  failToGetResponseWithError:nil withActionName:currentActionName];
        
        return;
    }
    
    currentActionName=urlService;
    
    //if there is a connection going on just cancel it.
    //[connection cancel];
    
    
    NSURL *url_str=[NSURL URLWithString:[urlService stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *dataRequest=[[NSMutableURLRequest alloc]initWithURL:url_str cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
    [dataRequest setHTTPMethod:@"GET"];
    [[[NSURLConnection alloc] initWithRequest:dataRequest delegate:self] start];
    
    
    //start the connection
    [connection start];
    
    if(baseView != nil)
    {
        [self showActivatorInitWithTitle:@"Loading" addWithView:baseView];
    }
    
}

#pragma mark- MBprogress HUD--


-(void)showActivatorInitWithTitle:(NSString *)message addWithView:(UIView *)myView
{
    activityIndicator = [[MBProgressHUD alloc] initWithView:myView];
    [myView addSubview:activityIndicator];
    activityIndicator.labelText = message;
    [activityIndicator show:YES];
    
}

#pragma mark -stop hud--
-(void)hideHub
{
    [activityIndicator hide:YES];
    [activityIndicator removeFromSuperViewOnHide];
}


-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
}


-(void)fetchDataOnserverWithAction:(NSString *)actionName forView:(UIView *)baseView forPostData:(NSString *)postStr
{
    if (![MyNetHelper connectedToNetwork]) {
         [self showAlertWithTitle:@"Error!!" withMessage:@"Internet Connection is not available Please Check your Network connection"];
        
        [self.delegate  failToGetResponseWithError:nil withActionName:currentActionName];
        
        return;
    }
    
    currentActionName = actionName;
    NSURL * url;
  
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MMddHHmmss"];
    NSString *dateStr = [formater stringFromDate:[NSDate new]];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@?_dc=%@",API_URL, actionName, dateStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url= [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setTimeoutInterval:5];
    [request setHTTPMethod:@"POST"];
  //  [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString * postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

    NSString * labelString = @"Loading";
    if(baseView != nil){
         [self showActivatorInitWithTitle:labelString addWithView:baseView];
    }
}

#pragma mark - NSUrlConnection Delegate  -
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@",self.currentURL);
    [self hideHub];

    if (![currentActionName isEqualToString:USER_LOCATION_UPDATE]) {
         [self showAlertWithTitle:@"Error" withMessage:@"Connection Failed"];
    }
   
    [self.delegate  failToGetResponseWithError:error withActionName:currentActionName];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = [[NSMutableData alloc] init];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideHub];
    
    NSString *str_Response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
  
    NSLog(@"Response : %@", str_Response);
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
     NSDictionary * dic_Response=[parser objectWithString:str_Response];
    
    [self.delegate  serviceResponse:dic_Response withActionName:currentActionName];
    
}

#pragma mark--CancelRequest---
-(void)cancelRequest
{
    [self hideHub];
    [connection cancel];
}


@end
