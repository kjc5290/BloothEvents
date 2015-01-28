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

@property(strong, nonatomic) NSString *addedPassId;
@property(strong, nonatomic) PKPassLibrary *passLibrary;
@property(strong, nonatomic) Offer *offer;

@end

@implementation ExclusiveOffersTableViewController
@synthesize addedPassId;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PKPassLibraryDidChangeNotification object:_passLibrary];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Offers";
    _passLibrary = [[PKPassLibrary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passLibraryDidChange:) name:PKPassLibraryDidChangeNotification object:_passLibrary];
    
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
    
    [[PFUser currentUser] fetch];
        NSArray *offerIds = [[PFUser currentUser] objectForKey:@"offersArray"];
        [query whereKey:@"objectId" containedIn:offerIds];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
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
    selectedOffer.offerId = object.objectId;
    selectedOffer.offerTitle = object[@"title"];
    _offer = selectedOffer;
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
            
            addedPassId = offer.offerId;
            
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
}

#pragma mark - Pass controller delegate

-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    //pass added
    [self dismissViewControllerAnimated:YES completion:nil];
    


    
}

- (void)passLibraryDidChange:(NSNotification *)notification
{
    [self updateThings:_offer];
}

- (void) updateThings:(Offer*)offer{
    PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:offer.offerId block:^(PFObject *offer, NSError *error) {
        
        //decrement offersRemaining count by 1
        [offer incrementKey:@"passesRemaining" byAmount:[NSNumber numberWithInt:-1]];
        [offer saveInBackground];
        
    }];
    
    [[PFUser currentUser] removeObject:offer.offerId forKey:@"offersArray"];
    [[PFUser currentUser] saveInBackground];
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