//
//  EventPickerTableViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/13/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventPickerTableViewController.h"
#import "BloothConstants.h"
#import "Events.h"
#import "EventDetailViewController.h"


@interface EventPickerTableViewController ()


@end

@implementation EventPickerTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aCoder{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = ParseEventClassName;
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = ParseEventNameKey;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        //self.imageKey = @"thumbnail";
        
        self.pullToRefreshEnabled = YES;
        
        self.objectsPerPage = 25;

    }
    return self;
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
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *image = [UIImage imageNamed: @"blooth_logo_full"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(0, 0, 200, 30);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.0;
    self.navigationItem.titleView = imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    // This method is called before a PFQuery is fired to get more objects

}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Configure the cell
    PFFile *thumbnail = [object objectForKey:@"picture"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
 UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
   nameLabel.text = [object objectForKey:@"EventName"];
    

    
    return cell;
}  */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventDetailViewController *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"showDetail" source:self destination:destination performHandler:^(void) {
        //view transition/animation
        [self.navigationController pushViewController:destination animated:YES];
    }];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self shouldPerformSegueWithIdentifier:segue.identifier sender:cell];//optional
    [self prepareForSegue:segue sender:cell];
    
    [segue perform];
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 if ([segue.identifier isEqualToString:@"showDetail"]) {
 NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 EventDetailViewController *destViewController = segue.destinationViewController;
 
 PFObject *object = [self.objects objectAtIndex:indexPath.row];
 Events *event = [[Events alloc] init];
 event.eventName = [object objectForKey:@"EventName"];
 event.thumbnail = [object objectForKey:@"thumbnail"];
 event.descriptionText = [object objectForKey:@"descriptionText"];
 event.eventID = [object objectId];
 destViewController.event = event;
  NSLog(@"%@", object);

 }
}


#pragma mark-
#pragma mark notes

- (void) eventIdDidChange:(NSNotification *)note {
    [self loadObjects];
}


@end


