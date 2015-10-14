//
//  Copyright 2009 Trevor Harmon.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

-(BOOL)hasAlpha;
-(UIImage*)imageWithAlpha;
-(UIImage*)imageByAddingTransparentBorderWithWidth:(NSUInteger)borderWidth;

@end
