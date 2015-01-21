//
//  Beacon.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/18/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"


@implementation Beacon

- (instancetype)initWithName:(NSString *)identifier
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _identifier = identifier;
    _uuid = uuid;
    _majorValue = major;
    _minorValue = minor;
    
    return self;
}
@end
