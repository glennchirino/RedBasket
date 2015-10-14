//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTChoiceViewControllerSelectionBlock)(id modelObject);
typedef void(^LTChoiceViewControllerCellCustomizationBlock)(UITableViewCell* tableViewCell);
typedef void(^LTChoiceViewControllerCellCustomizationBlockWithModel)(id tableViewCell, id model);
typedef void(^LTChoiceViewControllerTableViewCustomizationBlock)(UITableView* tableView);
typedef NSString*(^LTChoiceViewControllerIndexBlock)(id modelObject);

@interface LTChoiceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) NSArray* choices;
@property(strong,nonatomic) NSString* keyname;
@property(strong,nonatomic) LTChoiceViewControllerSelectionBlock block;
@property(strong,nonatomic) LTChoiceViewControllerIndexBlock indexBlock;

@property(strong,nonatomic) LTChoiceViewControllerCellCustomizationBlock cellCustomizationBlock;
@property(strong,nonatomic) LTChoiceViewControllerCellCustomizationBlockWithModel cellCustomizationBlockWithModel;
@property(strong,nonatomic) LTChoiceViewControllerTableViewCustomizationBlock tableViewCustomizationBlock;

+(id)choiceViewControllerWithChoices:(NSArray*)theChoices key:(NSString*)key usingBlock:(LTChoiceViewControllerSelectionBlock)bl;

-(void)registerNib:(NSString*)name withReuseIdentifier:(NSString*)reuseIdentifier;

@end
