//
//  SurveyWebBrowser.h
//  BloothEvents
//
//  Created by Kevin Costello on 1/13/15.
//  Copyright (c) 2015 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyWebBrowser : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *surveyURL;

@end