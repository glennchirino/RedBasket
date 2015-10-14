//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#ifdef TARGET_OS_IPHONE
    #include <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>

#import "LTSupport2/LTActionSheet.h"

#ifndef __IPHONE_7_0
#define __IPHONE_7_0     70000
#endif

#ifndef __IPHONE_8_0
#define __IPHONE_8_0     80000
#define UIInterfaceOrientationUnknown UIDeviceOrientationUnknown
#endif

#define LT_NOT_YET_IMPLEMENTED { [LTActionSheet showInformativeMessage:@"Sorry, not yet implemented!" fromView:[[UIApplication sharedApplication].windows objectAtIndex:0] withAutoDismiss:2.0]; }

typedef void(^LTVoidBlock)(void);

static CGFloat PHONE5_HEIGHT    = 568.0f;
static CGFloat PHONE6_HEIGHT    = 667.0f;
static CGFloat PHONE6P_HEIGHT   = 736.0f;

static NSInteger _iosVersionCache = -1;

static BOOL isRunningOnPad()
{
    return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad );
}

static BOOL isRunningOnPhone()
{
    return !isRunningOnPad();
}

static BOOL isRunningOnPhone5(){
    if ( isRunningOnPad() )

    {
        return NO;
    }
    
    return [[UIScreen mainScreen] bounds].size.height == PHONE5_HEIGHT;
}

static BOOL isRunningOnPhone6()
{
    if ( isRunningOnPad() )
    {
        return NO;
    }

    return [[UIScreen mainScreen] bounds].size.height == PHONE6_HEIGHT;
}

static BOOL isRunningOnPhone6P()
{
    if ( isRunningOnPad() )
    {
        return NO;
    }
    return [[UIScreen mainScreen] bounds].size.height == PHONE6P_HEIGHT;
}

static void LT_SwizzleMethod(Class c, SEL orig, SEL modified)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, modified);
    if ( class_addMethod( c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod) ) )
    {
        class_replaceMethod( c, modified, method_getImplementation(origMethod), method_getTypeEncoding(origMethod) );
    }
    else
    {
        method_exchangeImplementations( origMethod, newMethod );
    }
}

static NSInteger iosVersion()
{
    if ( _iosVersionCache == -1 )
    {
        int index = 0;
        NSInteger version = 0;
        NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        NSEnumerator* enumer = [digits objectEnumerator];
        NSString* number;
        while (number = [enumer nextObject])
        {
            if ( index > 2 )
            {
                break;
            }
            NSInteger multipler = powf( 100, 2 - index );
            version += [number intValue] * multipler;
            index++;
        }        
        _iosVersionCache = version;
    }
    return _iosVersionCache;
}

static NSString* LT_NSStringFromUIInterfaceOrientation( UIInterfaceOrientation o )
{
    switch ( o )
    {
        case UIInterfaceOrientationUnknown: return @"UIInterfaceOrientationUnknown";
        case UIInterfaceOrientationPortrait: return @"UIInterfaceOrientationPortrait";
        case UIInterfaceOrientationPortraitUpsideDown: return @"UIInterfaceOrientationPortraitUpSideDown";
        case UIInterfaceOrientationLandscapeLeft: return @"UIInterfaceOrientationLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight: return @"UIInterfaceOrientationLandscapeRight";
    }
}

static void LT_RunIfSystemVersionIsGreaterOrEqualThan( NSUInteger version, LTVoidBlock block )
{
    if ( iosVersion() >= version )
    {
        block();
    }
}

static void LT_RunIfSystemVersionIsGreaterThan( NSUInteger version, LTVoidBlock block )
{
    if ( iosVersion() > version )
    {
        block();
    }
}

static void LT_RunIfSystemVersionIsLessThan( NSUInteger version, LTVoidBlock block )
{
    if ( iosVersion() < version )
    {
        block();
    }
}
