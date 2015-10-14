//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTTableViewDataSource.h"

@interface LTMultiSectionsDataSource : LTTableViewDataSource

@property(strong,nonatomic) NSArray* sections;
@property(strong,nonatomic) NSMutableArray* sectionIndexArray;

+(id)multiSectionsDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)delegate sections:(NSArray*)sections;

-(id)initWithDelegate:(id<LTTableViewDataSourceDelegate>)delegate sections:(NSArray*)sections;

-(void)loadNextPageForSection:(NSUInteger)section;
-(void)removeAllPagesForSection:(NSUInteger)section;

-(NSUInteger)numberOfEntries;

@end
