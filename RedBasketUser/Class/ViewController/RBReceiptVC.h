//
//  RBReceiptVC.h
//  RedBasketUser
//
//  Created by Glenn on 4/10/15.
//  Copyright (c) 2015 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBReceiptVC : UIViewController

@property(nonatomic, strong) NSString * barcodeStr;
@property(nonatomic, assign) BOOL orderDetailFlag;
@property(nonatomic, assign) BOOL redeemedFlag;
@property(nonatomic, assign) BOOL isFreeSpecial;

@end
