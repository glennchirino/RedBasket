//
//  RBMapVC.m
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import "RBMapVC.h"
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "AppDelegate.h"
#import "SVPulsingAnnotationView.h"

@interface RBMapVC ()<MKMapViewDelegate>
{
    DownMenuViewController * menuViewController;
    AppDelegate * appDelegate;
    
    IBOutlet MKMapView * mapView;
    
    MKAnnotationView *_selectedAnnotationView;
    BasicMapAnnotation *_customAnnotation;
}
@end

@implementation RBMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    mapView.delegate = self;
    mapView.showsUserLocation = NO;
    
    
    menuViewController = (DownMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownMenuViewController"];
  
    [self.view addSubview:menuViewController.view];
    [self addChildViewController:menuViewController];
    [self.view bringSubviewToFront:menuViewController.view];
    
    [self initMapView];
    // Do any additional setup after loading the view.
}

-(void)initMapView
{
    
    [mapView removeAnnotations:mapView.annotations];
    
    for (NSInteger  i = 0  ; i<[appDelegate.storeList count]; i++) {
        NSDictionary * tempDic = [appDelegate.storeList objectAtIndex:i];
        
        NSString * name =   [tempDic objectForKey:@"name"] ;
        if (name == nil || [name isEqual:[NSNull null]]) {
            name = @"";
        }
        
        float  latitude = [[tempDic objectForKey:@"latitude"] floatValue];
        float longitude =[[tempDic objectForKey:@"longitude"] floatValue];
        
        BasicMapAnnotation *normalAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude] ;
        
        normalAnnotation.index = i;
        normalAnnotation.title = name;
        normalAnnotation.category = @"normal";
        [mapView addAnnotation:normalAnnotation];
        
    }
    
    //   CLLocationCoordinate2D coordinate = {37.9730234,-121.3018775};
    CLLocationCoordinate2D coordinate = appDelegate.currentLocation.coordinate;
    if(coordinate.latitude == 0 && coordinate.longitude == 0)
    {
        coordinate.latitude =  37.9730234;
        coordinate.longitude = -121.3018775;
    }
    // MKCoordinateRegion mapViewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000.0, 1000.0);
    
    BasicMapAnnotation *normalAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude] ;
    normalAnnotation.category = @"currentLocation";
    [mapView addAnnotation:normalAnnotation];
    
    MKCoordinateRegion  mapViewRegion2 = MKCoordinateRegionMake(coordinate,    MKCoordinateSpanMake(1/5.0, 1/5.0));
    [mapView setRegion:mapViewRegion2];
    [mapView setCenterCoordinate:coordinate];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id <MKAnnotation>)annotation {
    
    BasicMapAnnotation * tempAnnotation  = (BasicMapAnnotation *)annotation;
    
    if ([tempAnnotation.category isEqualToString:@"currentLocation"]) {
        
        static NSString *identifier = @"currentLocation";
        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(pulsingView == nil) {
            pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            pulsingView.canShowCallout = NO;
        }
        
        return pulsingView;
        
    }
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"NormalAnnotation"] ;
    
    annotationView.canShowCallout = YES;
    
    UIImage * annotationImage = [UIImage imageNamed:@"basket_marker.png"];
    
    annotationView.image = annotationImage;
    [annotationView setFrame:CGRectMake(0, 0, 28, 25)];
    
    UIButton * detailButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    detailButton.tag = tempAnnotation.index;
    
    [detailButton addTarget:self action:@selector(onDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView = detailButton;
    
    return annotationView;
}

-(void)onDetail:(UIButton *)sender
{
    appDelegate.selectedStore = [appDelegate.storeList objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:GOTO_MAP_STOREVIEW sender:self];
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

-(IBAction)backListView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
