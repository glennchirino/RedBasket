#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	
}

@property(copy,nonatomic) NSString * title;

@property(assign, nonatomic) NSInteger  index;
@property(strong, nonatomic) NSString * category;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
