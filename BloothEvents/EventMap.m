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
    self.navigationItem.title = @"Event Map";
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
    //custom nav stuff
    UIBarButtonItem * changeEvent = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"blooth_eventPicker"] style:UIBarButtonItemStylePlain target:self action:@selector(showEventPicker)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = changeEvent;
    
    UIImage *image = [UIImage imageNamed: @"blooth_logo_full"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(0, 0, 200, 30);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.0;
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem * settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"blooth_settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showUser)];
    self.navigationItem.rightBarButtonItem = settings;
    
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

-(void) showEventPicker{
    UIStoryboard *storyBoard;
    
    storyBoard = [UIStoryboard storyboardWithName:@"EventPicker" bundle:nil];
    UINavigationController *eventPicker = [storyBoard instantiateViewControllerWithIdentifier:@"eventPickNav"];
    [self presentViewController:eventPicker animated:YES completion:nil];
}

- (void) showUser{
    
}
@end