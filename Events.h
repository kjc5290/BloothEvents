//
//  Events.h
//  BloothEvents
//
//  Created by Kevin Costello on 11/10/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <ParseUI/ParseUI.h>


@interface Events : NSObject


@property (nonatomic, strong) NSString *eventName; // name of event
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSMutableString *descriptionText;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) UIImage *eventMap;

@end
