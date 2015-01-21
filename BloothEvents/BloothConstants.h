//
//  BloothConstants.h
//  BloothEvents
//
//  Created by Kevin Costello on 11/5/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef BloothEvents_BloothConstants_h
#define BloothEvents_BloothConstants_h

//search radius
static double const EventSearchRadius = 50.0;

//ParseConstants api
static NSString * const ParseEventClassName = @"Events";
static NSString * const ParseEventLocationKey = @"EventLocation";
static NSString * const ParseEventNameKey = @"EventName";
static NSString * const ParseObjectID = @"objectId";

static NSString * const ParseUserClass = @"User";

static NSString * const ParseTalksClassName = @"Talks";
static NSString * const ParseTalksEventID = @"eventId";
static NSString * const ParseTalksTitle = @"title";

static NSString * const ParseFBUserName = @"name";
static NSString * const ParseFBEmail = @"email";
static NSString * const ParseFBUserCurrentCompany = @"currentCompany";
static NSString * const ParseFBUserTitle = @"title";

static NSString * const ParseSurveyClassName = @"Surveys";
static NSString * const ParseSurveyEventID = @"eventId";
static NSString * const ParseSurveyTitle = @"title";

static NSString * const ParseOffersClass = @"Offers";

//current location keys
static NSString * const bloothLocationKey = @"location";
static NSString * const bloothCurrentLocationDidChangeNotification = @"bloothCurrentLocationDidChangeNotification";
//current eventId keys
static NSString * const eventIdDidUpdateNote = @"eventId";
static NSString * const currentEventID = @"objectID";
 
#endif
