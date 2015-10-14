//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensions)

-(id)LT_randomObject;
-(NSArray*)LT_arrayByRemovingObjectAtIndex:(NSUInteger)index;
-(NSArray*)LT_arrayByAddingObject:(id)object;

+(NSArray*)LT_arrayWithObjectsInArrays:(NSArray*)array;

-(NSArray*)LT_filteredArrayIncludingObjectsOfClass:(Class)klass;
+(instancetype)LT_arrayWithContentsOfCsvFile:(NSString*)filename;

@end
