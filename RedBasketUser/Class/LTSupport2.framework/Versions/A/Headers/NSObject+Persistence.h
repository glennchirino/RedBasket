//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Persistence)

// these methods operate in the temporary storage area
-(BOOL)LT_serializeToArchiveWithName:(NSString*)filename;
+(id)LT_initFromArchiveWithName:(NSString*)filename;
-(void)LT_removeArchiveWithName:(NSString*)basename;

// these methods operate in the documents storage area
-(BOOL)LT_serializeToDocumentsArchiveWithName:(NSString*)filename;
+(id)LT_initFromDocumentsArchiveWithName:(NSString*)filename;
-(void)LT_removeDocumentsArchiveWithName:(NSString*)basename;

-(NSData*)LT_serializeToData;
+(id)LT_initFromData:(NSData*)data;

@end
