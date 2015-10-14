//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <LTSupport2/LTSupport2.h>

@protocol TBXMLModellable <NSObject>

@required

-(NSArray*)tbxmlKeys;

@end

@protocol TBXMLCreatable <NSObject>

@required

-(id)initFromXML:(TBXMLElement*)node;

@end

@interface TBXML (LaTe)

+(TBXMLElement*)nodeForPath:(NSString*)path fromParent:(TBXMLElement*)parent;
+(NSString*)textForPath:(NSString*)path fromParent:(TBXMLElement*)parent;
+(void)iterateSiblingsWithName:(NSString*)name forNodePath:(NSString*)path fromParent:(TBXMLElement*)node withBlock:(TBXMLIterateBlock)block;

+(void)populateAttributesForInstance:(id<TBXMLModellable>)obj fromParent:(TBXMLElement*)node;

+(NSArray*) arrayWithTextsForSiblingsNamed:(NSString*)childName forNodePath:(NSString*)path fromParent:(TBXMLElement*)node;
+(NSArray*) arrayWithSiblingsNamed:(NSString*)childName forNodePath:(NSString*)path fromParent:(TBXMLElement*)node;
+(NSArray*) arrayOfInstancesOfClass:(Class)klass forSiblingsNamed:(NSString*)name forNodePath:(NSString*)nodepath fromParent:(TBXMLElement*)node;

@end

@interface LTTBXMLWrapper : NSObject

+(LTTBXMLWrapper*)tbxmlWrapperForRequest:(NSString*)request;
-(id)initForRequest:(NSString*)request;

@property(readonly,nonatomic) TBXMLElement* rootXMLElement;

@end


