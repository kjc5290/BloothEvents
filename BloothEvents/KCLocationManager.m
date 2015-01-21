//
//  LocationManager.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BloothConstants.h"
#import "KCLocationManager.h"
#import "Events.h"
#import <Parse/Parse.h>
#import "Beacon.h"

@interface KCLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) NSString *EventID;
@property (nonatomic, strong) NSArray *beaconsToMonitor;
@property (nonatomic, strong) NSMutableArray *returnedBeaconObjects;
@property (strong, nonatomic) CLBeacon *nearestBeacon;



@end

@implementation KCLocationManager

+(instancetype)sharedManager{
    static dispatch_once_t oncetoken;
    static KCLocationManager *sharedManager;
    dispatch_once(&oncetoken, ^{ sharedManager = [[self alloc]init];
    });
    return sharedManager;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(eventIdDidChange:)
                                                     name:eventIdDidUpdateNote
                                                   object:nil];
        [self setupLocationManager];
 
    }
    return self;
}

- (void)setupLocationManager
{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]== NO){
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }else{
    
        if(![CLLocationManager locationServicesEnabled])
        {
            //You need to enable Location Services
            NSLog(@"Location Services disabled");
            NSString *message = @"Location Services Disabled! Blooth Events uses location services to provide exclusive offers while to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
            [self locationServicesNotAuthed:message];
        }
        if(![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
        {
            //Region monitoring is not available for this Class;
            NSLog(@"Region Monitoring not available");
            NSString *message = @"iBeacon features not available on this device!";
            [self locationServicesNotAuthed:message];
        }
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
        {
            //You need to authorize Location Services for the app
            NSLog(@"App not authorized");
            NSString *message = @"Location Services not authorized! Blooth Events uses location services to provide exclusive offers while to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
            [self locationServicesNotAuthed:message];
        }
    }
}



- (void) getBeaconsAtEvent{
    //add manager status check
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]){
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Locaiton Manager"
                                                        message:@"Location Manager not authorized. Location services are required for this application"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    self.beaconsToMonitor = [NSArray new];
    self.returnedBeaconObjects = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Beacons"];
    [query whereKey:@"eventId" equalTo:_EventID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            NSArray* realObjects = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",@"eventId",_EventID]];
            for (PFObject *object in realObjects){
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[object objectForKey:@"UUID"]];
                //NSString *uuid = [object objectForKey:@"UUID"];
                NSNumber * major = [NSNumber numberWithUnsignedShort:(unsigned short)[object objectForKey:@"Major"]]; //TODO the major and minor are not same as backend uint_16 type conversion from parse.com number. Conversion from NSNumber to Beacon class property CLBeaconMajor/minor value is the problem
                NSNumber  *minor = [NSNumber numberWithUnsignedShort:
                                    (unsigned short)[object objectForKey:@"Minor"]];
                NSString *eventId = [object objectForKey:@"eventId"];
                NSString *identifier = [object objectForKey:@"identifier"];
                
                Beacon *b = [[Beacon new]
                             initWithName:identifier
                             uuid:(NSUUID *)uuid
                             major:(CLBeaconMajorValue)major
                             minor:(CLBeaconMinorValue)minor];
                
                [_returnedBeaconObjects addObject:b];}
            NSArray *objectsToSend = self.returnedBeaconObjects;
            NSLog(@"%@", objectsToSend); //log beacon objects
            [self createRegionsToMonitor:objectsToSend];
            }else {
            NSLog(@"%@", error);
        }
    }];
}

- (void) createRegionsToMonitor:(NSArray*)beacons{    //every object in objectstosend
    NSMutableArray *workArray = [NSMutableArray new];
    for(Beacon *beacon in beacons){
        [workArray addObject:[self beaconRegionWithObject:beacon]];
    }
    _beaconsToMonitor = workArray;
    [self startMonitoringForRegions:_beaconsToMonitor];
}
- (CLBeaconRegion *)beaconRegionWithObject:(Beacon *)beacon {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.uuid
                                                                           major:beacon.majorValue
                                                                           minor:beacon.minorValue
                                                                      identifier:beacon.identifier];
    return beaconRegion;
}

- (void) startMonitoringForRegions:(NSArray*)regions{
    NSLog(@"Starting to monitor");
    NSLog(@"%@",regions);
    for (CLBeaconRegion *region in regions){
        region.notifyEntryStateOnDisplay = YES;
        region.notifyOnEntry=YES;
        region.notifyOnExit =YES;
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager startRangingBeaconsInRegion:region];
        NSLog(@"%@",self.locationManager.monitoredRegions);
    }
    
    NSLog(@"%@",self.locationManager.monitoredRegions);
}

- (void) stopMonitoringForRegions{
    for (CLBeaconRegion *region in self.locationManager.monitoredRegions){
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}


#pragma mark CLDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

    NSLog(@"locationManagerDidChangeAuthorizationStatus: %d", status);
    /*if (status != 3){
    NSString *message = @"Location Services Disabled! Blooth Events uses location services to provide exclusive offers while to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
        [self locationServicesNotAuthed:message];
    } */
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLBeaconRegion *)region{
    NSLog(@"%@", region);
    //add the region and PFUser to Checkin Collection. we dont care much about region toggling because the use case would be a person leaving one region to go to another
    
    PFObject *checkin = [PFObject objectWithClassName:@"Checkin"];
    checkin[@"regionIdentifier"] = region.identifier;
    checkin[@"User"] = [PFUser currentUser];
    [checkin saveInBackground];
    NSLog(@"%@", checkin);
    [self.locationManager startRangingBeaconsInRegion:region];
}
/*- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLBeaconRegion *)region
{
    for (CLBeaconRegion *region in _beaconsToMonitor){
        [self.locationManager requestStateForRegion:region];
        NSLog(@"%@",self.locationManager.monitoredRegions);
        
    }
    
} */

- (void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLBeaconRegion *)region{
    [self.locationManager stopRangingBeaconsInRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region{
    if (CLRegionStateInside){
        [self.locationManager startRangingBeaconsInRegion:region];
        NSLog(@"We are in a region");
    }
    if (CLRegionStateOutside){
        NSLog(@"We are not in a region");
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    //filter the array out for any beacons that are far or unknown and compare to the last seen beacon in order to determine if an update is needed
     NSPredicate *predicateIrrelevantBeacons = [NSPredicate predicateWithFormat:@"(self.accuracy != -1) AND ((self.proximity != %d) OR (self.proximity != %d))", CLProximityFar,CLProximityUnknown];
    NSArray *relevantBeacons = [beacons filteredArrayUsingPredicate: predicateIrrelevantBeacons];
    CLBeacon *closestBeacon = nil;
    if ([relevantBeacons count] > 0){   //may cause problem because this method is called for every beacon every second
        closestBeacon = [relevantBeacons objectAtIndex:0];
        NSLog(@"Closest Beacon is: %@", closestBeacon);
    }
    BOOL sameUUID = [closestBeacon.proximityUUID isEqual:_nearestBeacon.proximityUUID];
    if (sameUUID == FALSE){
        self.nearestBeacon = closestBeacon;
        NSLog(@"Nearest Beacon is : %@", self.nearestBeacon);
        [self lastBeaconSeenUpdate];
    }
}

- (void) lastBeaconSeenUpdate{
    //write function to save the beacon outside of ranging because it gets called every second
   NSArray *regions = [self.locationManager.monitoredRegions allObjects];
   for (CLBeaconRegion *region in regions){
       BOOL sameUUID = [region.proximityUUID isEqual:_nearestBeacon.proximityUUID];
     if (sameUUID == TRUE){
     PFUser *user = [PFUser currentUser];
     user[@"lastBeacon"] = region.identifier;
     self.lastSeenBeacon = region.identifier;
     [user saveInBackground];
     NSLog(@"Just saved: %@", user[@"lastBeacon"]);
     }else{
         PFUser *user = [PFUser currentUser];
         user[@"lastBeacon"] = nil;
         self.lastSeenBeacon = nil;
         [user saveInBackground];
     }
   }
}
       


#pragma mark notes
//start point
- (void)eventIdDidChange:(NSNotification *)note {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _EventID = [defaults objectForKey:@"currentEventId"];
    //stop monitoring for old regions
    [self stopMonitoringForRegions];
    //call getBeacons
    [self getBeaconsAtEvent];
}

#pragma mark notAuthorized

- (void)locationServicesNotAuthed:(NSString*)message{
    //TODO add settings path to open settings
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Locaiton Manager Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}



@end

