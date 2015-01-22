//
//  EventMap.m
//  BloothEvents
//
//  Created by Kevin Costello on 1/20/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventMap.h"
#import <Parse/Parse.h>
#import "Events.h"


@interface EventMap ()
{
    NSString *eventId;
    Events *event;
}
@end

@implementation EventMap

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    eventId = [defaults objectForKey:@"currentEventId"];
    
    PFQuery *imageQuery = [PFQuery queryWithClassName:ParseEventClassName];
    [imageQuery getObjectInBackgroundWithId:eventId block:^(PFObject *object, NSError *error) {
       
        if (!error){
            self.mapView.file = object[@"eventMap"];
                [mapView loadInBackground];
        }else{
            NSLog(@"%@", error);
        }
    }];
}
    

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)aroundMePressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
                                                    message:@"Feature Under Construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];

}

- (IBAction)eventStatsPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
                                                    message:@"Feature Under Construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}
@end