//
//  UserProfileViewController.m
//  BloothEvents
//
//  Created by Kevin Costello on 1/28/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <ParseUI/ParseUI.h>
#import "HexColorConverter.h"
#import "ProfileTableViewCell.h"

@interface UserProfileViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *splashBg;
@property (strong, nonatomic) IBOutlet PFImageView *userThumb;
@property (strong, nonatomic) IBOutlet UIButton *userPoints;
@property (strong, nonatomic) IBOutlet UIButton *userPosts;
@property (strong, nonatomic) IBOutlet UITableView *profileInfo;
@property (strong, nonatomic) IBOutlet UILabel *numPoints;
@property (strong, nonatomic) IBOutlet UILabel *numPosts;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *userData;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[PFUser currentUser] fetch];
        self.currentUser = [PFUser currentUser];
       
    }
    return self;
}

- (void)viewDidLoad{
    
    self.userThumb.layer.cornerRadius = 85;
    self.userThumb.clipsToBounds = YES;
    self.userThumb.layer.borderWidth = 6.0f;
    self.userThumb.layer.borderColor = [[HexColorConverter alloc] colorWithHexString:@"000000"].CGColor;
   
    
    _userThumb.file = [_currentUser objectForKey:@"thumbnail"];
    [_userThumb loadInBackground];
    _numPoints.text = [[_currentUser objectForKey:@"points"] stringValue];
    _nameLabel.text = [_currentUser objectForKey:@"name"];

    //_numPosts.text = query number of posts in
    
    self.profileInfo.layer.cornerRadius = 20;
    self.profileInfo.clipsToBounds = YES;
    _profileInfo.dataSource = self;
    _profileInfo.delegate = self;
    self.profileInfo.rowHeight = 44;
    
    _userData = [NSMutableArray new];
    NSString *email = _currentUser.email;
    NSString *title = [_currentUser objectForKey:@"title"];
    NSString *company = [_currentUser objectForKey:@"company"];
    
    [_userData addObject:email];
    [_userData addObject:title];
    [_userData addObject:company];
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:@selector(profileDone)];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStyleDone target:nil action:@selector(editTouched)];
    
    UINavigationItem *item = [UINavigationItem alloc];
    item.leftBarButtonItem = back;
    item.hidesBackButton = YES;
    [_navBar pushNavigationItem:item animated:NO];
    
    UINavigationItem *item2 = [UINavigationItem alloc];
    item.rightBarButtonItem = edit;
    [_navBar pushNavigationItem:item2 animated:NO];
    
    self.profileInfo.tableFooterView.hidden = YES;
    
    _profileInfo.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor *backgroundColor = [[HexColorConverter alloc] colorWithHexString:@"000000"];
    self.profileInfo.backgroundView = [[UIView alloc]initWithFrame:self.profileInfo.bounds];
    self.profileInfo.backgroundView.backgroundColor = backgroundColor;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    _userData = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.splashBg.bounds.size;
}

#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath {
    
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"profileCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(ProfileTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.profileText.text = [self.userData objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleInsert;
}

- (void) profileDone{
    UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tb = [mainboard instantiateInitialViewController];
    [self presentViewController:tb animated:YES completion:nil];
}

- (void) editTouched{
    
}

@end