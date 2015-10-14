
//
//  RBStoreListVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/9/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBStoreListVC.h"
#import "AppDelegate.h"

@interface RBStoreListVC ()<UITableViewDataSource, UITableViewDelegate, ServerManagerDelegate>
{
        DownMenuViewController * menuViewController;
        AppDelegate * appDelegate;
    
       BOOL isProcess;
    
       IBOutlet UITableView * listTableView;

    NSMutableArray * activeCellArray;
}
@end

@implementation RBStoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    isProcess = NO;
    
    listTableView.delegate = self;
    listTableView.dataSource = self;
    
    appDelegate.storeList =  [[NSArray alloc] init];
    appDelegate.distanceArray = [[NSArray alloc] init];
    
    activeCellArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    [listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero ]];
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
  
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    [self.view bringSubviewToFront:menuViewController.view];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initStoreList) name:@"activeApp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEpireLabel) name:UPDATE_EXPIRE_TIMER object:nil];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self initStoreList];
}

-(void)initStoreList
{
    if (isProcess) {
        return;
    }
    
    isProcess = YES;
    
    NSDate * curDate = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * curDateStr = [formatter stringFromDate:curDate];
    curDateStr = @"10:10:00";
    NSString * postString = [NSString stringWithFormat:@"date=%@", curDateStr];
    
    ServerManager * serverManager = [[ServerManager alloc] init];
    serverManager.delegate = self;
    [serverManager fetchDataOnserverWithAction:GET_STORES forView:self.view forPostData:postString];
    
}


- (IBAction)showMenu:(id)sender {
    
    if([menuViewController isMenuVisible])
    {
        [menuViewController hideMenuAnimated:YES];
    }else{
        [menuViewController showMenuAnimated:YES];
    }
    
}

// Server Manager Delegate

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName
{
    NSArray * tempArray = [responseDic objectForKey:@"data"];
    
    if (tempArray == nil || [tempArray count] == 0)
    {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, there are no Stores in your city offering a RedBasket yet. Tell your favorite local Stores you want a RedBasket!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
        
        appDelegate.storeList = [[NSArray alloc] init];
    }else{
        appDelegate.storeList = [self sortAsDistance:tempArray];
    }
    
    
    [listTableView reloadData];
    [appDelegate startExpireTimer];
    
    isProcess = NO;
    
}


-(NSArray *)sortAsDistance:(NSArray *)array
{
    
    CLLocationDistance distance1;
    CLLocationDistance distance2;
    
    CLLocation  *curLocation =  appDelegate.currentLocation;
    return array;
    if (!curLocation) {
        appDelegate.distanceArray = nil;
        
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i  = 0 ; i<[array count]; i++) {
        
        NSDictionary * tempDic = [array objectAtIndex:i];
        float  latitude = 1.0;
        float  longitude = 1.0;
        
        NSString * latiObj = [tempDic objectForKey:@"latitude"];
        NSString * longObj = [tempDic objectForKey:@"longitude"];
        if (latiObj != nil && ![latiObj isEqual:[NSNull null]]) {
            latitude = [latiObj floatValue];
        }
        
        if (longObj != nil && ![longObj isEqual:[NSNull null]]) {
            longitude = [longObj floatValue];
        }
        
        CLLocation * tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude] ;
        distance1 = [curLocation distanceFromLocation:tempLocation];
        [tempArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",distance1],@"distance",[NSString stringWithFormat:@"%ld",(long)i],@"id", nil]];
    }
    
    for (NSInteger  i = 0  ; i<[tempArray count]; i++) {
        distance1 = [[[tempArray objectAtIndex:i] objectForKey:@"distance"] floatValue];
        
        for (NSInteger j = i+1; j<[tempArray count]; j++) {
            
            distance2 = [[[tempArray objectAtIndex:j] objectForKey:@"distance"] floatValue];
            
            if (distance1 >  distance2) {
                distance1 = distance2;
                NSDictionary * tempDic = [tempArray objectAtIndex:i];
                [tempArray replaceObjectAtIndex:i withObject:[tempArray objectAtIndex:j]];
                [tempArray replaceObjectAtIndex:j withObject:tempDic];
            }
        }
        
        [resultArray addObject:[array objectAtIndex:[[[tempArray objectAtIndex:i] objectForKey:@"id"] integerValue]]];
    }
    appDelegate.distanceArray =tempArray;
    return resultArray;
}


-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName
{
    appDelegate.storeList = [[NSArray alloc] init];
    [listTableView reloadData];
    isProcess = NO;
}

///  TableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    
    AsyncImageView * imageView = (AsyncImageView *)[cell viewWithTag:122];
    UILabel * expireTimeLabel = (UILabel *)[cell viewWithTag:123];
    
    UIView * descriptionView = (UIView *)[cell viewWithTag:120];
    UILabel * specialTitleLabel = (UILabel * )[cell viewWithTag:124];
    UILabel * specialPriceLabel = (UILabel *)[cell viewWithTag:125];
    UILabel *specialDescriptionLabel = (UILabel *)[cell viewWithTag:126];
    
    NSDictionary * tempDic = [appDelegate.storeList objectAtIndex:indexPath.row];
  
    NSString * specialTitle =   [tempDic objectForKey:@"special_title"] ;
    if (specialTitle == nil || [specialTitle isEqual:[NSNull null]]) {
        specialTitle = @"";
    }
    
    NSNumber  *specialPrice =  [tempDic objectForKey:@"special_price"] ;
    NSString * priceStr  = @"FREE";;
    if (specialPrice == nil || [specialPrice isEqual:[NSNull null]]) {
        specialPrice = [NSNumber numberWithDouble:0];
      
    }else{
        if ([specialPrice floatValue] != 0) {
               priceStr = [NSString stringWithFormat:@"$%.2f", [specialPrice floatValue]];
        }

    }
    
    NSString * specialDescription =   [tempDic objectForKey:@"special_description"] ;
    if (specialDescription == nil || [specialDescription isEqual:[NSNull null]]) {
        specialDescription = @"";
    }
    
    NSString * expireStr;
    
    if (![priceStr isEqualToString:@"FREE"]) {
            expireStr  = [self fetchExpireString:indexPath];
    }else{
        expireStr = [NSString stringWithFormat:@"%@ Tokens Left", [tempDic objectForKey:@"offer_token_limit"]];
    }
    specialDescription = [specialDescription stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
   
    expireTimeLabel.text =  expireStr;
    specialTitleLabel.text = specialTitle;
    specialPriceLabel.text = priceStr;
    specialDescriptionLabel.text = specialDescription;
  
    [imageView setImage:nil];
    NSString * imagePath =   [tempDic objectForKey:@"image_path"] ;
   
    if (imagePath == nil || [imagePath isEqual:[NSNull null]]) {
    }else{
        [imageView  setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_IP,imagePath]]];
    }
    
    UIFont * font = specialDescriptionLabel.font;
    
    float  textHeight = [self findHeightForText:specialDescription havingWidth:specialDescriptionLabel.frame.size.width andFont:font];
    
    CGRect frame1 = specialDescriptionLabel.frame;
    CGRect frame2 = descriptionView.frame;
    CGRect frame3 = expireTimeLabel.frame;
    
    frame2.size.height = (frame2.size.height - specialDescriptionLabel.frame.size.height) + textHeight;
    frame2.origin.y = 190 - frame2.size.height ;
    
    frame1.size.height = textHeight;
    frame3.origin.y = frame2.origin.y - frame3.size.height;
    
    [descriptionView setFrame:frame2];
    [specialDescriptionLabel setFrame:frame1];
    [expireTimeLabel setFrame:frame3];
    
    //    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:125];
    //     NSDictionary * tempDic2 = nil;
    //     [distanceLabel setHidden:NO];
    //    if (appDelegate.distanceArray != nil || [appDelegate.distanceArray count] > 0) {
    //        tempDic2 = [appDelegate.distanceArray objectAtIndex:indexPath.row];
    //        float distance = 0.0;
    //        NSString * distanceStr =   [tempDic2 objectForKey:@"distance"] ;
    //        if (distanceStr != nil && ![distanceStr isEqual:[NSNull null]]) {
    //            distance = [distanceStr floatValue];
    //        }
    //        distanceLabel.text = [NSString stringWithFormat:@"%.2fmi",distance/1609.34];
    //    }else{
    //        [distanceLabel setHidden:YES];
    //    }
    //
   
    return cell;
}


-(NSString *)fetchExpireString:(NSIndexPath *)indexPath
{
    NSDictionary * tempDic = [appDelegate.storeList objectAtIndex:indexPath.row];
    
    NSNumber * differentTime =   [tempDic objectForKey:@"different_time"] ;
    NSNumber * expireTime = [tempDic objectForKey:@"expire_time"] ;
    NSString *expireStr;
    expireStr = @"Offer Expired";
    if (differentTime == nil || [differentTime isEqual:[NSNull null]] || expireTime == nil) {
        
    }else{
        int expire_time = [expireTime intValue];
        int different_time = [differentTime intValue];
        
        if (different_time > 0) {
            
            int time = expire_time * 60- different_time;
            
            if (time > 0) {
                
                int hour = time / 3600;
                int min = (time%3600)/60;
                int sec = (time%3600)%60;
                
                NSString * hourStr = (hour > 9)?[NSString stringWithFormat:@"%d",hour]:[NSString stringWithFormat:@"0%d",hour];
                NSString * minStr = (min > 9)?[NSString stringWithFormat:@"%d",min]:[NSString stringWithFormat:@"0%d",min];
                NSString * secStr = (sec > 9)?[NSString stringWithFormat:@"%d",sec]:[NSString stringWithFormat:@"0%d",sec];
                
                expireStr = [NSString stringWithFormat:@"Offer expires %@:%@:%@", hourStr, minStr, secStr];
            }
        }
    }

    return expireStr;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.selectedStore = [appDelegate.storeList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:GOTO_STOREVIEW sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (appDelegate.storeList == nil) {
        return 0;
    }
    return [appDelegate.storeList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}



-(void)updateEpireLabel
{
    UITableViewCell *cell;
    NSArray * paths = [listTableView indexPathsForVisibleRows];
    for (NSIndexPath * path in paths) {
        cell = [listTableView cellForRowAtIndexPath:path];
         UILabel * expireTimeLabel = (UILabel *)[cell viewWithTag:123];
        UILabel * priceLabel = (UILabel *)[cell viewWithTag:125];
        
        if (![priceLabel.text isEqualToString:@"FREE"]) {
            expireTimeLabel.text = [self fetchExpireString:path];
        }
        
    }
    
}

@end
