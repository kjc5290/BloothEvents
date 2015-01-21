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

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:_surveyURL];
    [_webView loadRequest:requestObj];
}


@end