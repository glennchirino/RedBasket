//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNumberFormatter : NSNumberFormatter

@property(nonatomic,assign) NSString* abbreviationForThousands;
@property(nonatomic,assign) NSString* abbreviationForMillions;
@property(nonatomic,assign) NSString* abbreviationForBillions;

@end
