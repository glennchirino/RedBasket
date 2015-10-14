//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSimplePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

typedef void (^LTSimplePickerStringBlock)(NSString*);

@property(nonatomic,retain) NSString* prefix;
@property(nonatomic,retain) NSString* postfix;
@property(nonatomic,retain) NSArray* strings;
@property(nonatomic,retain) NSString* selectedString;
@property(nonatomic,copy) LTSimplePickerStringBlock block;

+(id)simplePickerViewWithFrame:(CGRect)frame strings:(NSArray*)aStrings block:(LTSimplePickerStringBlock)aBlock;

@end
