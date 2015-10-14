//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTKeychainWrapper : NSObject

@property(nonatomic,readonly) NSString* serviceName;

+(instancetype)keychainWrapperForServiceName:(NSString*)serviceName;
-(instancetype)initWithServiceName:(NSString*)serviceName;

-(NSString*)searchKeychainCopyMatchingIdentifier:(NSString*)identifier;
-(BOOL)createKeychainValue:(NSString*)value forIdentifier:(NSString*)identifier;
-(BOOL)deleteKeychainValueForIdentifier:(NSString*)identifier;

@end
