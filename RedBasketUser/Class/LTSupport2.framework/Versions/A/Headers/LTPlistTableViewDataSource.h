//
//  LTPlistTableViewDataSource.h
//  LTSupport2
//
//  Created by Dr. Michael Lauer on 28.03.13.
//  Copyright (c) 2013 Lauer, Teuber. All rights reserved.
//

#import <LTSupport2/LTSupport2.h>

@interface LTPlistTableViewDataSource : LTTableViewDataSource

@property(strong,nonatomic) NSString* plistFilename;

+(id)plistTableViewDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)d forPlist:(NSString*)filename;

@end
