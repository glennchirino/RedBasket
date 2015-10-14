//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface LTAppStoreProductViewController : NSObject < SKStoreProductViewControllerDelegate >

-(id)initWithParentViewController:(UIViewController*)controller;

@end
