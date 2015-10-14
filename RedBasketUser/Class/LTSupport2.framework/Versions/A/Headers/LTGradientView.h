//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTGradientView : UIView

@property(nonatomic,copy) NSArray* colors;
@property(nonatomic,copy) NSArray* locations;
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;

+(id)gradientViewWithColors:(NSArray*)colors;
+(id)gradientViewWithColors:(NSArray*)colors locations:(NSArray*)locations;
+(id)gradientViewWithColors:(NSArray*)colors locations:(NSArray*)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
