//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSerializableObject : NSObject <NSCoding, NSCopying>

-(void)encodeWithCoder:(NSCoder*)aCoder;
-(id)initWithCoder:(NSCoder*)aDecoder;

+(NSArray*)serializableProperties;

@end
