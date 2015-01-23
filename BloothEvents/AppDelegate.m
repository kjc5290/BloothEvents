//
//  AppDelegate.m
//  BloothEvents
//
//  Created by Kevin Costello on 11/5/14.
//  Copyright (c) 2014 Kevin Costello. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "TalksTableViewController.h"
#import "KCLocationManager.h"
#import "EventPickerTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "RegistrationViewController.h"


@interface AppDelegate () <LoginViewControllerDelegate, RegistrationViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //parse info
    [Parse setApplicationId:@"vSG1sUHBHr6u4yV98nhLpRhBd99TymLG7R9Pj7zK" clientKey:@"myMfTfqnMoboNwpU5vGWA2lD2pM6c5nShfZIGFzF"];
    
    //push stuff ios 8
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    //nav
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.navController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];

    [PFFacebookUtils initializeFacebook];
    
    if ([PFUser currentUser]) {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"currentEventId"] == nil){
        // Present event picker straight-away
            UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"EventPicker" bundle:nil];
            EventPickerTableViewController *eventController = [mainboard instantiateInitialViewController];
            self.window.rootViewController=nil;
            self.window.rootViewController = self.navController;
            [self.navController pushViewController:eventController animated:YES];
        }else{
            UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tb = [mainboard instantiateInitialViewController];
            self.window.rootViewController = tb;
            [self.window makeKeyAndVisible];
        }
    } else {
        // Go to the welcome screen and have them log in or create an account.
        LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController=nil;
        self.window.rootViewController = self.navController;
        viewController.delegate = self;
        [self.navController setViewControllers:@[ viewController ] animated:NO];
    }
    
    [KCLocationManager sharedManager];
    
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

#pragma - Push

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)presentLoginViewController {
   //added this code in applicationDidFinish instead of its own method so the nav heiarchy would be correct
    // Go to the welcome screen and have them log in or create an account.
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController=nil;
    self.window.rootViewController = self.navController;
    viewController.delegate = self;
    [self.navController setViewControllers:@[ viewController ] animated:NO];
}
//todo change the xib
- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    [self presentEventPicker];
}
- (void) presentEventPicker{
    //added this code in applicationDidFinish instead of its own method so the nav heiarchy would be correct
    UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"EventPicker" bundle:nil];
    EventPickerTableViewController *eventController = [mainboard instantiateInitialViewController];
    self.window.rootViewController=nil;
    self.window.rootViewController = self.navController;
    [self.navController pushViewController:eventController animated:YES];
    
}

- (void) signupviewControllerDidLogin:(RegistrationViewController*)controller{
    [self presentEventPicker];
}
- (void) presentMain{
    //added this code in applicationDidFinish instead of its own method so the nav heiarchy would be correct
    UIStoryboard* mainboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tb = [mainboard instantiateInitialViewController];
    self.window.rootViewController=nil;
    self.window.rootViewController = tb;
    [self.window makeKeyAndVisible];
    [self.navController pushViewController:tb animated:YES];
}


@end
