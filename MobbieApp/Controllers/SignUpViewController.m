//
//  SignUpViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize firstNameTextField,lastNameTextField,emailTextField,phoneTextField,passwordTextField,confirmPasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Customize textFields
    CustomTextField *firstNameInput = [[CustomTextField alloc] init];
    [firstNameInput setIcon: const_username_icon forUITextField: self.firstNameTextField];
    
    CustomTextField *lastNameInput = [[CustomTextField alloc] init];
    [lastNameInput setIcon:const_username_icon forUITextField:self.lastNameTextField];
    
    CustomTextField *emailInput = [[CustomTextField alloc] init];
    [emailInput setIcon:const_email_icon forUITextField:self.emailTextField];
    
    CustomTextField *phoneInput = [[CustomTextField alloc] init];
    [phoneInput setIcon:const_phone_icon forUITextField:self.phoneTextField];
    
    CustomTextField *passwordInput = [[CustomTextField alloc] init];
    [passwordInput setIcon:const_password_icon forUITextField:self.passwordTextField];
    
    CustomTextField *confirmPasswordInput = [[CustomTextField alloc] init];
    [confirmPasswordInput setIcon:const_password_icon forUITextField:self.confirmPasswordTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {
    //Dismiss current view
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
