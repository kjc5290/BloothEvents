//
//  ViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 11/5/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "TalksTableViewController.h"
#import "BloothConstants.h"
#import "Events.h"
#import "TalksTableViewCell.h"
#import "KCLocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface TalksTableViewController ()

@property(strong, nonatomic) NSString *EventID;

@end

@implementation TalksTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aCoder{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = ParseTalksClassName;
        
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
    self.navigationItem.title = @"Event Schedule";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //this hides the entire nav bar which is not ideal incase the eventId needs to be changed
    
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
  [query orderByAscending:@"orderOfAppearence"];
  NSLog(@"%@", _EventID);
  [query whereKey:@"eventId" equalTo:_EventID];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"TalksTableViewCell";
    
    TalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TalksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell

    cell.picture.file = [object objectForKey:@"picture"];
    [cell.picture loadInBackground];
    cell.title.text = [object objectForKey:@"title"];
    cell.startTime.text = [object objectForKey:@"startTime"];
    cell.presenters.text = [object objectForKey:@"presenterName"];
    
    return cell;
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RecipeDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Recipe *recipe = [[Recipe alloc] init];
        recipe.name = [object objectForKey:@"name"];
        recipe.imageFile = [object objectForKey:@"imageFile"];
        recipe.prepTime = [object objectForKey:@"prepTime"];
        recipe.ingredients = [object objectForKey:@"ingredients"];
        destViewController.recipe = recipe;
        
    }
}*/

#pragma mark-
#pragma mark notes

- (void)eventIdDidChange:(NSNotification *)note {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _EventID = [defaults objectForKey:@"currentEventId"];
    [self loadObjects];
}


@end
