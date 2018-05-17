//
//  ViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize usernameTextField, passwordTextField;

NSString *const const_alert_message = @"Perform Sign Up or Login to access the features that Mobbie App allows the users..";
NSString *const const_alert_title = @"About Mobbie";
NSString *const const_alert_button = @"Ok";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Customize textFields
    CustomTextField *usernameInput = [[CustomTextField alloc] init];
    [usernameInput setIcon: const_username_icon forUITextField:self.usernameTextField];
    
    CustomTextField *passwordInput = [[CustomTextField alloc] init];
    [passwordInput setIcon: const_password_icon forUITextField:self.passwordTextField];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)aboutButton:(id)sender {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: const_alert_title
                                message:const_alert_message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    //Add ok button
    [alert addAction: okButton];
    
    //Display Aler
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
