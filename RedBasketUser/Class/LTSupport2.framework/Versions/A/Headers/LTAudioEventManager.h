//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "late_macros.h"

#import "NSObject+BlockInvoke.h"

#import <Foundation/Foundation.h>

@interface LTAudioEventManager : NSObject

LT_SINGLETON_INTERFACE_FOR_CLASS( LTAudioEventManager, sharedManager )

-(void)registerSoundfile:(NSString*)path forKey:(NSString*)key;
-(void)playSoundfileForKey:(NSString*)key completionHandler:(NSObjectVoidBlock)block;
-(void)removeSoundfileForKey:(NSString*)key;

@end
