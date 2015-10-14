//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LTSerializableObject.h"

@interface LTAudioStreamerStation : LTSerializableObject

@property(nonatomic,retain) NSString* id;
@property(nonatomic,retain) NSString* url;
@property(nonatomic,retain) NSString* imageUrl;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* claim;
@property(nonatomic,retain) NSString* rating;
@property(nonatomic,retain) NSString* ratings;
@property(nonatomic,retain) NSString* myrating;

@property(nonatomic,retain) NSString* status; /* stringified status */

@property(nonatomic,retain) NSString* bitrate; /* icy_br */
@property(nonatomic,retain) NSString* channel; /* icy_name */
@property(nonatomic,retain) NSString* website; /* icy_url */
@property(nonatomic,retain) NSString* genre; /* icy_genre */
@property(nonatomic,retain) NSString* title; /* SongTitle */

// subclassing API
@property(nonatomic,retain) UIImage* coverImage;
@property(nonatomic,retain) NSString* applicationName;

+(instancetype)station;
+(instancetype)stationWithURL:(NSString*)url;

-(void)resetStreamInformation;
-(void)didUpdateTitle;

@end
