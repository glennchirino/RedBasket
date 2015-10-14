//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LTPieView : UIView

@property (assign, nonatomic) NSInteger     startDegree;
@property (assign, nonatomic) NSInteger     stopDegree;
@property (strong, nonatomic) UIColor*      pieColor;

-(id)initWithColor:(UIColor*)myColor;
-(BOOL)isVisible;

-(void)addColor:(UIColor*)color withValue:(NSUInteger)value;

@end
