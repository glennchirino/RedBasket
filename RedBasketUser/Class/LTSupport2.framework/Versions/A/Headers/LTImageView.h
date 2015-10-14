//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LT_AnimationBlock)();

@interface LTImageView : UIImageView

@property (assign, nonatomic) BOOL                  layerAnimationRunning;

-(void)layerAnimation:(NSArray*)images basePath:(NSString*)path;
-(void)layerAnimationStartWithCompetionBlock:(LT_AnimationBlock)block;

@end
