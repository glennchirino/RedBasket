//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTTableView.h"
#import "LTTableViewDataSource.h"

@interface LTTableViewController : UIViewController <LTTableViewDataSourceStatusDelegate>

@property(nonatomic,weak) IBOutlet LTTableView* tableView;
@property(nonatomic,strong) LTTableViewDataSource* dataSource;

@end
