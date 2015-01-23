//
//  LoginViewController.m
//  Blooth Exhibitor
//
//  Created by Kevin Costello on 11/13/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ActivityView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "BloothConstants.h"
#import <ParseUI/ParseUI.h>
#import "RegistrationViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *facebookLogin;
@property (nonatomic, strong) IBOutlet UIButton *signUp;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, assign) BOOL activityViewVisible;

@end

@implementation LoginViewController

#pragma mark -
#pragma mark init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Disable automatic adjustment, as we want to occupy all screen real estate
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.activityView.frame = self.view.bounds;
    self.scrollView.contentSize = self.backgroundView.bounds.size;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)loginPressed:(id)sender {
    [self dismissKeyboard];
    [self processFieldEntries];
}

- (IBAction)facebookLoginPressed:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"user_work_history"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        self.activityViewVisible = NO; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                // save first name last name work history
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] setObject:result[@"name"] forKey:ParseFBUserName];
                       // [[PFUser currentUser] setObject:result[@"email"] forKey:ParseFBEmail];
                       // [[PFUser currentUser] setObject:result[@"title"] forKey:ParseFBUserTitle];
                        //[[PFUser currentUser] setObject:result[@"company"] forKey:ParseFBCurrentCompany];
                        // title and company
                        [[PFUser currentUser] saveInBackground];
                    }
                }];
            } else {
                NSLog(@"User with facebook logged in!");
            }
           [self.delegate loginViewControllerDidLogin:self];
        }
    }];
    
    self.activityViewVisible = YES; // Show loading indicator until login is finished
}

- (IBAction)signupPressed:(id)sender {
    RegistrationViewController *signup = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    [signup setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:signup animated:YES completion:nil];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
        [self processFieldEntries];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Private

#pragma mark Field validation

- (void)processFieldEntries {
    // Get the username text, store it in the app delegate for now
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *noUsernameText = @"username";
    NSString *noPasswordText = @"password";
    NSString *errorText = @"No ";
    NSString *errorTextJoin = @" or ";
    NSString *errorTextEnding = @" entered";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (password.length == 0) {
            [self.passwordField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.usernameField becomeFirstResponder];
        }
    }
    
    if ([username length] == 0) {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    if ([password length] == 0) {
        textError = YES;
        if ([username length] == 0) {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    if (textError) {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Everything looks good; try to log in.
    
    // Set up activity view
    self.activityViewVisible = YES;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        // Tear down the activity view in all cases.
        self.activityViewVisible = NO;
        
        if (user) {
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            // Didn't get a user.
            NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
            
            NSString *alertTitle = nil;
            
            if (error) {
                // Something else went wrong
                alertTitle = [error userInfo][@"error"];
            } else {
                // the username or password is probably wrong.
                alertTitle = @"Couldn’t log in:\nThe username or password were wrong.";
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.usernameField becomeFirstResponder];
        }
    }];
}

#pragma mark keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    
    CGFloat scrollViewOffsetY = (CGRectGetHeight(keyboardFrame) -
                                 (CGRectGetMaxY(self.view.bounds) -
                                  CGRectGetMaxY(self.loginButton.frame) - 10.0f));
    
    if (scrollViewOffsetY < 0) {
        return;
    }
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0.0f, scrollViewOffsetY) animated:NO];
                     }
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                     }
                     completion:nil];
}

#pragma mark ActivityView

- (void)setActivityViewVisible:(BOOL)visible {
    if (self.activityViewVisible == visible) {
        return;
    }
    
    _activityViewVisible = visible;
    
    if (_activityViewVisible) {
        ActivityView *activityView = [[ActivityView alloc] initWithFrame:self.view.bounds];
        activityView.label.text = @"Logging in";
        activityView.label.font = [UIFont boldSystemFontOfSize:20.f];
        [activityView.activityIndicator startAnimating];
        
        _activityView = activityView;
        [self.view addSubview:_activityView];
    } else {
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
}

@end


