//
//  EventDetailViewController.h
//  BloothEvents
//
//  Created by Kevin Costello on 12/17/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
#import "BloothConstants.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface EventDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *eventThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (nonatomic, strong) IBOutlet UIButton *loadEvent;
@property (nonatomic, strong)NSString *eventId;

@property (nonatomic, strong) Events *event;

@end
