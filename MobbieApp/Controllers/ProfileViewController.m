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
    
}

- (IBAction)updateProfileButton:(id)sender {
    //TODO
    
}
@end
