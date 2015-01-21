//
//  SurveyTableViewCell
//  BloothEvents
//
//  Created by Kevin Costello on 12/17/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface SurveyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *surveyName;
@property (weak, nonatomic) IBOutlet UILabel *talkName;

@end