//
//  SurveyWebBrowser.m
//  BloothEvents
//
//  Created by Kevin Costello on 1/13/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyWebBrowser.h"


@interface SurveyWebBrowser ()

@end

@implementation SurveyWebBrowser
@synthesize webView;
@synthesize surveyURL;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:surveyURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.navigationItem.title = _titleString;
}


@end