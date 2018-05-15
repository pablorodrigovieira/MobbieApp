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


@end
