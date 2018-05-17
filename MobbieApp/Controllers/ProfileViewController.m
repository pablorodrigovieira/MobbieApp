//
//  ProfileViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

NSString *const const_profile_alert_message = @"Enter a new password";
NSString *const const_profile_alert_title = @"Change Password";
NSString *const const_profile_alert_button = @"Confirm";
NSString *const const_profile_alert_cancel_button = @"Cancel";

@synthesize firstNameTextField, lastNameTextField, emailTextField, phoneNumberTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Custom TextFields
    CustomTextField *firstNameInput = [[CustomTextField alloc] init];
    [firstNameInput setIcon:const_username_icon forUITextField: self.firstNameTextField];
    
    CustomTextField *lastNameInput = [[CustomTextField alloc] init];
    [lastNameInput setIcon:const_username_icon forUITextField:self.lastNameTextField];
    
    CustomTextField *emailInput = [[CustomTextField alloc] init];
    [emailInput setIcon:const_email_icon forUITextField:self.emailTextField];
    
    CustomTextField *phoneNumberInput = [[CustomTextField alloc] init];
    [phoneNumberInput setIcon:const_phone_icon forUITextField:self.phoneNumberTextField];   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changePasswordButton:(id)sender {
    //TODO
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: const_profile_alert_title
                                message:const_profile_alert_message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //Add textfield
    [alert addTextFieldWithConfigurationHandler:^(UITextField *newPassword) {
        [newPassword setPlaceholder:@"New Password"];
        [newPassword setSecureTextEntry:YES];
        
    }];
    
    //Buttons
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle: const_profile_alert_cancel_button
                                   style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    UIAlertAction *confirmButton = [UIAlertAction
                                    actionWithTitle: const_profile_alert_button
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        //TODO change password
                                        //[alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
    //Add Confirm button
    [alert addAction: confirmButton];
    [alert addAction: cancelButton];
    
    //Display Aler
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)updateProfileButton:(id)sender {
    //TODO
    
}
@end
