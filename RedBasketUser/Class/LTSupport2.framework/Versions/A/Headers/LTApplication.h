//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

extern id<NSObject,UIApplicationDelegate> sharedAppDelegate;

// NOTE: It's important to _not_ claim that we are conforming to the UIApplicationDelegate, otherwise things go havoc with the default main window
@interface LTApplication : UIResponder

@end
