//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

@interface UIViewController (Extensions)

+(UINavigationController*)selectedNavigationController;

@property(nonatomic,readonly) UINavigationController* selectedNavigationController;

@end

@interface UIViewController (Keyboard)

-(void)LT_dismissKeyboard;

@end

@interface UIViewController (Navigation)

@property(nonatomic,readonly) UIViewController* previousViewController;

-(UIViewController*)LT_findFirstParentViewControllerOfType:(Class)classType;

@end

@interface UIViewController (ModalPresentation)

-(void)LT_presentModalViewController:(UIViewController*)modalViewController onNavigationControllerWithTitle:(NSString*)title;
-(void)LT_presentModalViewController:(UIViewController*)modalViewController onNavigationControllerWithTitle:(NSString*)title prompt:(NSString*)prompt tint:(UIColor*)tintColor;

@end