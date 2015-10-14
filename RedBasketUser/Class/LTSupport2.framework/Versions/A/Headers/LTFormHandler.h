//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTFormHandler;

@protocol LTFormHandlerDelegate <NSObject>

@optional
-(void)formhandler:(LTFormHandler*)formhandler textField:(UITextField*)textfield didChangeTextTo:(NSString*)text;
-(void)formhandler:(LTFormHandler*)formhandler textFieldDidReturn:(UITextField*)textfield;

@end

@interface LTFormHandler : NSObject <UITextFieldDelegate>

@property(weak,nonatomic) UIViewController<LTFormHandlerDelegate>* delegate;
@property(weak,nonatomic) id updateTarget;
@property(weak,nonatomic) id returnTarget;
@property(assign,nonatomic) SEL updateAction;
@property(assign,nonatomic) SEL returnAction;

+(instancetype)formHandlerWithDelegate:(UIViewController<LTFormHandlerDelegate>*)delegate attachToTextFieldsInView:(UIView*)view;
-(void)setUpdateTarget:(id)target action:(SEL)selector;
-(void)setReturnTarget:(id)target action:(SEL)selector;
-(void)attachToTextFieldsInView:(UIView*)view;
-(void)detachFromTextFieldsInView:(UIView*)view;

@end
