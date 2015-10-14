//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^LTUIViewBoolBlock)(UIView* view);
typedef void(^LTUIViewVoidBlock)(void);

typedef enum _LTShadowStyle
{
    LTShadowStyleRectangular,
    LTShadowStyleTrapezoid,
    LTShadowStyleEllipsoid,
    LTShadowStylePaperCurl
} LTShadowStyle;

/* Convenience */
void LTLineStroke( CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2 );

@interface UIView (Convenience)

+(id)LT_viewWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor;
-(void)LT_iterateThroughAllSubviewsOfClass:(Class)klass recursively:(BOOL)recursively usingBlock:(LTUIViewBoolBlock)block;
-(void)LT_iterateThroughAllSubviewsRecursively:(BOOL)recursively usingBlock:(LTUIViewBoolBlock)block;
-(void)LT_removeAllSubviews;
-(void)LT_removeAllGestureRecognizers;
-(id)LT_findFirstSubviewOfClass:(Class)klass;
-(UIView*)LT_findFirstSuperviewOfClass:(Class)klass;
-(UIView*)LT_findFirstResponder;
-(UIView*)LT_findNextSibling;
-(UIView*)LT_findNextSiblingOfClass:(Class)klass;
-(UIView*)LT_addSubviewWithBackgroundColor:(UIColor*)backgroundColor;

@end


@interface UIView (Extensions)

-(void)LT_setShadowPath:(UIBezierPath *)path radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset color:(UIColor*)color;
-(void)LT_setRectangularShadow;

-(void)LT_setShadowEffectWithStyle:(LTShadowStyle)style offset:(CGSize)offset inset:(CGFloat)inset blur:(CGFloat)blur;
-(void)LT_setFrameEffectWithColor:(UIColor*)color borderColor:(UIColor*)borderColor inset:(CGFloat)inset width:(CGFloat)width rounded:(CGFloat)rounded;

-(void)LT_setReflectionWithOffset:(NSUInteger)offset;
-(void)LT_removeReflection;

@end

@interface UIView (Positioning)

@property(nonatomic,assign) CGPoint position;
@property(nonatomic,readonly) CGRect LT_frame;

@end

@interface UIView (Screenshot)

-(void)LT_saveScreenshotInCameraRollWithVisualEffect:(BOOL)yesOrNo;

@end

@interface UIView (Keyboard)

-(void)LT_dismissKeyboard;
-(void)LT_registerForKeyboardAvoiding;
-(void)LT_unregisterForKeyboardAvoiding;

@end

@interface UIView (OffscreenDrawing)

-(CGContextRef)newBitmapContextSuitableForView;
-(void)LT_drawInRect:(CGRect)rect context:(CGContextRef)context flipped:(BOOL)isFlipped;

@end

@interface UIView (Fading)

-(void)LT_fadeOutAnimationWithDuration:(NSTimeInterval)interval;
-(void)LT_fadeInAnimationWithDuration:(NSTimeInterval)interval;

-(void)LT_fadeOutAnimationWithDuration:(NSTimeInterval)interval completionBlock:(LTUIViewVoidBlock)block;
-(void)LT_fadeInAnimationWithDuration:(NSTimeInterval)interval completionBlock:(LTUIViewVoidBlock)block;

@end

@interface UIView (Debug)

-(void)LT_dumpSubviewHierarchy;

@end

@interface UIView (ContentAnimation)

-(void)LT_animateContentChangeOnMainLayerByFadingWithDuration:(NSTimeInterval)duration;
-(void)LT_animateContentChangeOnMainLayerUsingTransition:(NSString*)transitionType subtype:(NSString*)subType withDuration:(NSTimeInterval)duration;

@end

