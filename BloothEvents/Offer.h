//
//  Offer.h
//  BloothEvents
//
//  Created by Kevin Costello on 1/15/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <ParseUI/ParseUI.h>


@interface Offer : NSObject


@property (nonatomic, strong) NSString *offerTitle; // name of offer
@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) PFFile *passFile;

@end
