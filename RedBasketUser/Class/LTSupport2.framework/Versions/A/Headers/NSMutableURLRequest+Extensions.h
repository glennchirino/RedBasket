//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Extensions)

-(void)LT_setBasicAuthHeaderForUser:(NSString*)username withPassword:(NSString*)password;

@end
