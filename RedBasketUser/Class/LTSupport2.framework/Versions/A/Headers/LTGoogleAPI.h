//
//  LTGoogleAPI.h
//  LTSupport2
//
//  Created by Dr. Michael Lauer on 21.08.13.
//  Copyright (c) 2013 Lauer, Teuber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LTGoogleAPI : NSObject

+(NSURL*)urlForStaticMapImageWithLocation:(CLLocation*)location pixelSize:(CGSize)size zoom:(NSUInteger)zoom withMarker:(BOOL)yesOrNo;

+(NSURL*)urlForPlacesImageWithReference:(NSString*)photoReference maximumPixelSize:(CGSize)size;


@end
