//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTMultiChoiceViewControllerTableViewCustomizationBlock)(UITableView* tableView);
typedef void(^LTMultiChoiceViewControllerCellCustomizationBlock)(UITableViewCell* tableViewCell);
typedef void(^LTMultiChoiceViewControllerLimitReachedBlock)(NSUInteger limit);
typedef void(^LTMultiChoiceViewControllerResultBlock)(NSArray* result);

@interface LTMultiChoiseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray*                  choices;
@property (strong, nonatomic) NSString*                 keyname;
@property (strong, nonatomic) NSMutableArray*           selectedChoices;

@property (assign, nonatomic) NSInteger          selectionLimit;

@property (strong, nonatomic) LTMultiChoiceViewControllerCellCustomizationBlock         cellCustomizationBlock;
@property (strong, nonatomic) LTMultiChoiceViewControllerTableViewCustomizationBlock    tableViewCustomizationBlock;
@property (strong, nonatomic) LTMultiChoiceViewControllerLimitReachedBlock              limitReachedBlock;
@property (strong, nonatomic) LTMultiChoiceViewControllerResultBlock                    resultBlock;

+(id)MultiChoiceViewControllerWithChoices:(NSArray*)theChoices key:(NSString*)key;

@end
