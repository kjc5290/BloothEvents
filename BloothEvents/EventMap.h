//
//  EventMap.h
//  BloothEvents
//
//  Created by Kevin Costello on 1/20/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Events.h"
#import "BloothConstants.h"
#import <Parse/Parse.h>

@interface EventMap : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *mapView;
@property (nonatomic, strong) IBOutlet UIButton *eventStats;
@property (nonatomic, strong) IBOutlet UIButton *aroundMe;

@end
