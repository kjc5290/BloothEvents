//
//  TalksTableViewCell.h
//  BloothEvents
//
//  Created by Kevin Costello on 12/17/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface TalksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet PFImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end