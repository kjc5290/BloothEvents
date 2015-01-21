//
//  RegistrationViewController.h
//  Blooth Events
//
//  Created by Kevin Costello on 11/13/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.


#import "RegistrationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "EventPickerTableViewController.h"

@interface RegistrationViewController () 

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation RegistrationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _username.returnKeyType = UIReturnKeyDone;
    [_username setDelegate:self];
    _password.returnKeyType = UIReturnKeyDone;
    [_password setDelegate:self];
    _confirmPassword.returnKeyType = UIReturnKeyDone;
    [_confirmPassword setDelegate:self];
    _email.returnKeyType = UIReturnKeyDone;
    [_email setDelegate:self];
    _jobTitle.returnKeyType = UIReturnKeyDone;
    [_jobTitle setDelegate:self];
    _company.returnKeyType = UIReturnKeyDone;
    [_company setDelegate:self];
    _name.returnKeyType = UIReturnKeyDone;
    [_name setDelegate:self];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createUser:(id)sender {
    if([self validateFields] == TRUE){
        return;
    }
    PFUser *user = [PFUser user];
    user.username = _username.text;
    user.password = _password.text;
    user.email = _email.text;
    user[@"title"] = _jobTitle.text;
    user[@"company"] = _company.text;
    user[@"name"] = _name.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
          /*  UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:alertTitle
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert]; */
            UIAlertView *alertViewSignupSuccess = [[UIAlertView alloc] initWithTitle:@"Success! Thanks for signing up!" message:@"Press OK to get started"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
            
            [alertViewSignupSuccess show];
        } else {
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your signup information was invalid" message:@"Please try entering your information again"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
            
            [alertViewLoginFailure show];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_email resignFirstResponder];
    [_jobTitle resignFirstResponder];
    [_company resignFirstResponder];
    [_name resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    if (textField == self.password) {
        [self.confirmPassword becomeFirstResponder];
    }
    
    if (textField == self.confirmPassword) {
        [self.email becomeFirstResponder];
    }
    if (textField == self.email) {
        [self.name becomeFirstResponder];
    }
    if (textField == self.name) {
        [self.jobTitle becomeFirstResponder];
    }
    if (textField == self.jobTitle) {
        [self.company becomeFirstResponder];
    }
    
    if (textField == self.company) {
        [self.company resignFirstResponder];
        if([self validateFields] != TRUE){
            
        PFUser *user = [PFUser user];
        user.username = _username.text;
        user.password = _password.text;
        user.email = _email.text;
        user[@"title"] = _jobTitle.text;
        user[@"company"] = _company.text;
        user[@"name"] = _name.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                
                UIAlertView *alertViewSignupSuccess = [[UIAlertView alloc] initWithTitle:@"Success! Thanks for signing up!" message:@"Press OK to get started" delegate: self cancelButtonTitle: @"OK" otherButtonTitles:nil];
                
                [alertViewSignupSuccess show];
                
            } else {
                // Show the errorString somewhere and let the user try again.
                UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your signup information was invalid" message:@"Please try entering your information again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alertViewLoginFailure show];
            }
        }];
        }
    }
    
    return YES;
}
/*-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    [_jobTitle resignFirstResponder];
    [_company resignFirstResponder];
    [_name resignFirstResponder];
    
    PFUser *user = [PFUser user];
    user.username = _username.text;
    user.password = _password.text;
    user[@"title"] = _jobTitle.text;
    user[@"company"] = _company.text;
    user[@"name"] = _name.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
            UIAlertView *alertViewSignupSuccess = [[UIAlertView alloc] initWithTitle:@"Success! Thanks for signing up!" message:@"Press OK to get started" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertViewSignupSuccess show];
            
        } else {
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your signup information was invalid" message:@"Please try entering your information again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertViewLoginFailure show];
        }
    }];
    
    
    return YES;
} */

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex== alertView.cancelButtonIndex){
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            NSLog(@"Logged IN");
            NSLog(@"%@", currentUser);
            [self.delegate signupviewControllerDidLogin:self];
        }
        else {
            NSLog(@"failure");
        }
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]){
        // Do cancel
        NSLog(@"cancel");
    }else if(buttonIndex == 1){
        NSLog(@"index 1");
        AppDelegate* blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [blah presentEventPicker];
    }
}*/

#pragma mark -Keyboard

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
                                  CGRectGetMaxY(self.signUp.frame) - 10.0f));
    
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

#pragma mark- Validation

- (BOOL) validateFields {
    NSString *username = _username.text;
    NSString *password = _password.text;
    NSString *pass2 = _confirmPassword.text;
    NSString *job = _jobTitle.text;
    NSString *company = _company.text;
    NSString *name = _name.text;
    BOOL textError = NO;
    NSString *errorText= @"No";
    
    
    if (username.length == 0 || password.length == 0 || job.length == 0 || company.length == 0 || name.length == 0) {
        textError = YES;
        errorText = @"All fields are required";
        // Set up the keyboard for the first field missing input:
        if (password.length == 0) {
            [_password becomeFirstResponder];
        }
        if (username.length == 0) {
            [_username becomeFirstResponder];
        }
        
        if (job.length == 0) {
            [_jobTitle becomeFirstResponder];
        }
        
        if (company.length == 0) {
            [_company becomeFirstResponder];
        }
        
        if (name.length == 0) {
            [_name becomeFirstResponder];
        }
    }
    
    if (pass2 == password){
        textError = NO;
        
    }else{
        textError = YES;
        errorText = @"Passwords do not match.";
    }

    
    if (textError == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return TRUE;
    }
    return FALSE;

}


@end
