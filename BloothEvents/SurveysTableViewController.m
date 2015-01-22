//
//  ViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 11/5/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "SurveysTableViewController.h"
#import "BloothConstants.h"
#import "Events.h"
#import "SurveyTableViewCell.h"
#import "KCLocationManager.h"
#import "SurveyWebBrowser.h"


@interface SurveysTableViewController ()

@property(strong, nonatomic) NSString *EventID;
@property (nonatomic, strong) NSString *surveyURL;

@end

@implementation SurveysTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aCoder{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = ParseSurveyClassName;
        
        // The key of the PFObject to display in the label of the default cell style
        
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        
        
        self.pullToRefreshEnabled = YES;
        
        self.objectsPerPage = 25;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventIdDidChange:) name:eventIdDidUpdateNote object:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _EventID = [defaults objectForKey:@"currentEventId"];
        
        
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:eventIdDidUpdateNote object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //this hides the entire nav bar which is not ideal incase the eventId needs to be changed
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Available Surveys";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    //gets the relvant surveys by using the beaconId from the last seen beacon from the location manager
    //want to show query by closest beacon but if lastSeenBeacon is nil the app crases because query won't run on nil
    [query whereKey:@"eventID" equalTo:_EventID];
    // [query whereKey:@"BeaconId" equalTo:[KCLocationManager sharedManager].lastSeenBeacon];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"SurveyTableViewCell";
    
    SurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SurveyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    
    cell.surveyName.text = [object objectForKey:@"surveyTitle"];
    cell.talkName.text = [object objectForKey:@"talkName"];
    
    return cell;
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"showSurveyWebBrowser"]) {
 NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 SurveyWebBrowser *destViewController = segue.destinationViewController;
 
 PFObject *object = [self.objects objectAtIndex:indexPath.row];
 NSString *fullURL = [object objectForKey:@"surveyURL"];
 self.surveyURL = fullURL;
 destViewController.surveyURL = _surveyURL;
 
 }
 }

#pragma mark-
#pragma mark notes

- (void)eventIdDidChange:(NSNotification *)note {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _EventID = [defaults objectForKey:@"currentEventId"];
    [self loadObjects];
}


@end
