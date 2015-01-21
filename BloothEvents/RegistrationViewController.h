//
//  RegistrationViewController.h
//  Blooth Events
//
//  Created by Kevin Costello on 11/13/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@class RegistrationViewController;

@protocol RegistrationViewControllerDelegate <NSObject>

- (void)signupviewControllerDidLogin:(RegistrationViewController *)controller;

@end

@interface RegistrationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<RegistrationViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *signUp;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *confirmPassword;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *jobTitle;
@property (nonatomic, strong) IBOutlet UITextField *company;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UIImageView *logo;

@end