//
//  AlertsViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 21/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "AlertsViewController.h"

@interface AlertsViewController ()

@end

@implementation AlertsViewController

//Constants for Alerts
NSString *const const_alert_message = @"DEFAULT..";
NSString *const const_alert_title = @"Mobbie";
NSString *const const_alert_button = @"Ok";
NSString *const const_about_alert_message = @"Perform Sign Up or Login to access the features that Mobbie App allows the users..";
NSString *const const_about_alert_title = @"About Mobbie";
NSString *const const_input_alert_message = @"Please fill up the Information at: ";
NSString *const const_input_alert_title = @"Empty Field";
NSString *const const_no_input_alert_message = @"Please fill information in all fields";
NSString *const const_passwords_not_matching_alert_message = @"Passwords did not match, try again";
NSString *const const_update_db_alert_message = @"Update Successfully!";
NSString *const const_upload_db_alert_message = @"Uploaded Successfully!";
NSString *const const_invalid_email_alert_message = @"E-mail format not valid!";
NSString *const const_car_input_required = @"Plate number / Make / Model are fields required!";
NSString *const const_error_terms_and_conditions = @"Please accept the Ts and Cs";
NSString *const const_error_sign_out = @"Error signing out: ";
NSString *const const_error_device_no_camera = @"Your device has no camera.";
NSString *const const_profile_alert_message = @"Enter a new password";
NSString *const const_profile_alert_title = @"Change Password";
NSString *const const_profile_alert_button = @"Confirm";
NSString *const const_profile_alert_cancel_button = @"Cancel";


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *
 * Get top view controller of the App
 * @author Pablo Vieira
 *
 * @return topViewController
 */
- (UIViewController *)topViewController {
    @try{
        return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Get top view controller with rootViewController
 * @author Pablo Vieira
 *
 * @return topViewController
 */
- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    @try{
        if (rootViewController.presentedViewController == nil) {
            return rootViewController;
        }
        
        if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
            UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
            return [self topViewController:lastViewController];
        }
        
        UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
        return [self topViewController:presentedViewController];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Display an Alert message based in a fieldName
 * @author Pablo Vieira
 *
 * @param fieldName - NSString
 *
 */
-(void)displayInputAlert: (NSString *) fieldName{
    @try{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: const_input_alert_title
                                    message: [const_input_alert_message stringByAppendingString: fieldName]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        //Add ok button
        [alert addAction: okButton];
        
        //Display Alert
        UIViewController *rootViewController = self.topViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Display Alert About
 * @author Pablo Vieira
 *
 */
-(void)displayAboutAlert{
    @try{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: const_about_alert_title
                                    message: const_about_alert_message
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        //Add ok button
        [alert addAction: okButton];
        
        //Display Alert
        UIViewController *rootViewController = self.topViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Display Alert with message as parameter
 * @author Pablo Vieira
 *
 * @param message - NSString
 */
-(void)displayAlertMessage: (NSString *) message{
    @try{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle: const_alert_title
                                    message: message
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        //Add ok button
        [alert addAction: okButton];
        
        //Display Alert
        UIViewController *rootViewController = self.topViewController;
        [rootViewController presentViewController:alert animated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

@end
