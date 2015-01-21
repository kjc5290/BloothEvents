//
//  LocationManager.h
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "BloothConstants.h"
#import <CoreLocation/CoreLocation.h>

@class KCLocationManager;
@interface KCLocationManager : NSObject

@property (strong, nonatomic) NSString *lastSeenBeacon;
- (void)setupLocationManager;
- (void)eventIdDidChange:(NSNotification *)note;
+(instancetype)sharedManager;




@end
