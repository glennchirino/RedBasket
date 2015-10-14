//
//  LTStaticTableViewDataSource.h
//  LTSupport2
//
//  Created by Dr. Michael Lauer on 11.04.13.
//  Copyright (c) 2013 Lauer, Teuber. All rights reserved.
//

#import <LTSupport2/LTSupport2.h>

@interface LTPropertySheetTableViewDataSource : LTTableViewDataSource

@property(nonatomic,strong) id modelObject;

+(id)propertySheetTableViewDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)d reuseIdentifiers:(NSArray*)reuseIdentifiers modelObject:(id)modelObject;

@end
