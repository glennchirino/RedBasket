//
//  Copyright (c) 2011 Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

typedef BOOL (^LTViewControllerAutoRotationBlock)(UIInterfaceOrientation toInterfaceOrientation);

@interface LTViewController : UIViewController

-(void)addViewDidLoadHook:(NSObjectVoidBlock)block;

-(void)addViewWillAppearHook:(NSObjectVoidBlock)block;

-(void)addViewDidAppearHook:(NSObjectVoidBlock)block;

-(void)addViewWillDisappearHook:(NSObjectVoidBlock)block;

-(void)addViewDidDisappearHook:(NSObjectVoidBlock)block;

-(void)addViewDidUnloadHook:(NSObjectVoidBlock)block;

-(void)setAutorotationHook:(LTViewControllerAutoRotationBlock)block;

-(void)setViewDidLayoutSubviewsHook:(NSObjectVoidBlock)block;

@property(assign,nonatomic) BOOL shouldAutorotateReturn;
@property(assign,nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientationsMaskReturn;

@end
