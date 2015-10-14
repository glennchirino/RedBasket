//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Extensions)

-(void)LT_changeReturnKeyToDone;
-(void)LT_enableReturnKey;

@property(readonly,nonatomic) UITextField* textField;

@end
