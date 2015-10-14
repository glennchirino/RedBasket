//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTFormViewControllerDelegate
@optional
-(BOOL)lastTextFieldShouldReturn:(UITextField*)textField;
@end

@interface LTFormViewController : UIViewController <UITextFieldDelegate, LTFormViewControllerDelegate>

@property(assign,nonatomic) BOOL hideKeyboardWhenClickingOnView;
@property(strong,nonatomic) UIControl* formFields;

@end
