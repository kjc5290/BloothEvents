//
//  ExclusiveOffersTableViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 1/14/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import "BloothConstants.h"
#import "ExclusiveOffersTableViewController.h"
#import "OfferViewCell.h"
#import <PassKit/PassKit.h>
#import "Offer.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ExclusiveOffersTableViewController () <
PKAddPassesViewControllerDelegate>
{
    NSString *addedPassId;
}

@end

@implementation ExclusiveOffersTableViewController

- (instancetype)initWithCoder:(NSCoder *)aCoder{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = ParseOffersClass; //change to Offers
    
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        self.pullToRefreshEnabled = YES;
        
        self.objectsPerPage = 25;
        
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc
- (void)dealloc {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Offers";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //this hides the entire nav bar which is not ideal incase the eventId needs to be changed
    self.navigationItem.title = @"Offers";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    NSArray *offerIds = [[PFUser currentUser] objectForKey:@"offersArray"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query whereKey:@"objectId" containedIn:offerIds];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"OfferViewCell";
    
    OfferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[OfferViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    
    cell.offerName.text = [object objectForKey:@"title"];
    cell.details.text = [object objectForKey:@"description"];
    
    return cell;
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    Offer *selectedOffer = [Offer new];
    selectedOffer.passFile = object[@"iphonePassFile"];
    selectedOffer.offerId = object[@"objectId"];
    selectedOffer.offerTitle = object[@"title"];
    [self openPassWithOffer:selectedOffer];
    
}


-(void)openPassWithOffer:(Offer*)offer
{
    PFFile *pkfile = offer.passFile;
    //get the PFfile data
    [pkfile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSError* passError = nil;
            PKPass *newPass = [[PKPass alloc] initWithData:data
                                                     error:&passError];
            
            PKAddPassesViewController *addController =
            [[PKAddPassesViewController alloc] initWithPass:newPass];
            addController.delegate = self;
            [self presentViewController:addController
                               animated:YES
                             completion:nil];
            
            if (passError!=nil) {
                [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                            message:[error
                                                     localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"Ooops"
                                  otherButtonTitles: nil] show];
                return; }
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    addedPassId = [NSString new];
    addedPassId = offer.offerId;
}

#pragma mark - Pass controller delegate

-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    //pass added
    [self dismissViewControllerAnimated:YES completion:nil];
    //subtract one from passesRemaining column on Offer object
    PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:addedPassId block:^(PFObject *offer, NSError *error) {
        
        //decrement offersRemaining count by 1
        [offer incrementKey:@"passesRemaining" byAmount:[NSNumber numberWithInt:-1]];
        [offer saveInBackground];
        
    }];
    
    [[PFUser currentUser] removeObject:addedPassId forKey:@"offersArray"];
    [[PFUser currentUser] saveInBackground];

    
}
@end