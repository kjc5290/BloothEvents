//
//  LoginViewController.h
//  Blooth Exhibitor
//
//  Created by Kevin Costello on 11/13/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end


