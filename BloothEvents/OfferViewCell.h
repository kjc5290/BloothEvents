//
//  OffcerViewCell.h
//  BloothEvents
//
//  Created by Kevin Costello on 1/19/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface OfferViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *offerName;
@property (weak, nonatomic) IBOutlet UILabel *details;

@end
