//
//  EventDetailViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/17/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "EventDetailViewController.h"
#import "ActivityView.h"
#import "KCLocationManager.h"

@interface EventDetailViewController ()

@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, assign) BOOL activityViewVisible;

@end

@implementation EventDetailViewController

@synthesize eventThumbnail;
@synthesize eventName;
@synthesize descriptionTextView;
@synthesize event;
@synthesize startDate;
@synthesize eventId;


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
    self.navigationItem.title = @"Event Details";
    self.activityViewVisible = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
     self.activityView.frame = self.view.bounds;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventName.text = event.eventName;
    self.eventName.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    self.eventThumbnail.file = event.thumbnail;
    [eventThumbnail loadInBackground];
    self.startDate.text = event.startDate;
    self.descriptionTextView.text = event.descriptionText;
    self.eventId = event.eventID;
    
}

- (void)viewDidUnload
{
    [self setEventName:nil];
    [self setEventThumbnail:nil];
    [self setDescriptionTextView:nil];
    [self setStartDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)loadEventPressed:(id)sender {
    NSLog(@"%@", self.eventId);
    self.activityViewVisible = YES;
    UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tb = [mainboard instantiateInitialViewController];
    NSString *currentEventIdUpdate = self.eventId;
    
    // save to NSuserdefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentEventIdUpdate forKey:@"currentEventId"];
    [defaults synchronize];
    
    NSLog(@"Data saved");
    NSLog(@"%@", currentEventIdUpdate);

    //[KCLocationManager sharedManager];// call singleton locationManager
    
    [[NSNotificationCenter defaultCenter] postNotificationName:eventIdDidUpdateNote
                                                        object:nil
                                                      userInfo:nil];
    
    NSLog(@"%@", currentEventID);
    [self presentViewController:tb animated:YES completion:nil];
}

#pragma mark ActivityView

- (void)setActivityViewVisible:(BOOL)visible {
    if (self.activityViewVisible == visible) {
        return;
    }
    
    _activityViewVisible = visible;
    
    if (_activityViewVisible) {
        ActivityView *activityView = [[ActivityView alloc] initWithFrame:self.view.bounds];
        activityView.label.text = @"Please Wait";
        activityView.label.font = [UIFont boldSystemFontOfSize:20.f];
        [activityView.activityIndicator startAnimating];
        
        _activityView = activityView;
        [self.view addSubview:_activityView];
    } else {
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
}
@end

