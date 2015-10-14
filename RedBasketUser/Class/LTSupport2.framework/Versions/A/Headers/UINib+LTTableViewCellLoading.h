//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib (LTTableViewCellLoading)

+(id)LT_loadLastObjectFromNibNamed:(NSString*)nibName owner:(id)owner options:(NSDictionary*)options;

@end
