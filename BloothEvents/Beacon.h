//
//  Beacon.h
//  BloothEvents
//
//  Created by Kevin Costello on 12/18/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface Beacon : NSObject

@property (strong, nonatomic, readonly) NSString *identifier;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
//@property (strong, nonatomic) CLBeacon *lastSeenBeacon;


- (instancetype)initWithName:(NSString *)identifier
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;
@end