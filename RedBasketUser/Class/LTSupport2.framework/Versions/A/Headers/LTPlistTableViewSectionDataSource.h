//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTTableViewDataSource.h"

@interface LTPlistTableViewSectionDataSource : LTTableViewDataSource

@property(strong,nonatomic) NSString* plistFilename;

+(id)plistTableViewSectionDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)d forPlist:(NSString*)filename;

@end
