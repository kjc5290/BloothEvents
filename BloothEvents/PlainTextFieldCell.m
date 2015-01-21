//
//  PlainTextFieldCell.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/22/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "PlainTextFieldCell.h"

@implementation PlainTextFieldCell
@synthesize txt;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{       self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        for (UIView *v in self.contentView.subviews) {
            [v removeFromSuperview];
        }
        
        txt=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 290, 28)];
        [txt setBorderStyle:UITextBorderStyleNone];
        //        [txt setFont:];
        [txt setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [txt setReturnKeyType:UIReturnKeyNext];
        [self.contentView addSubview:txt];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
