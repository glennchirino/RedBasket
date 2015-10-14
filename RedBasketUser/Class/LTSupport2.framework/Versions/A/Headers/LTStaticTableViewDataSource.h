//
//  LTStaticTableViewDataSource.h
//  LTSupport2
//
//  Created by Dr. Michael Lauer on 12.04.13.
//  Copyright (c) 2013 Lauer, Teuber. All rights reserved.
//

#import <LTSupport2/LTSupport2.h>

@interface LTStaticTableViewDataSource : LTTableViewDataSource

+(id)staticTableViewDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)d cells:(NSArray*)cells;

@end
