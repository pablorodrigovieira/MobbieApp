//
//  ViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "ViewController.h"
@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

@synthesize usernameTextField, passwordTextField, loadingActivity;

- (void)viewWillAppear:(BOOL)animated{
    //Hide Activity Indicator
    loadingActivity.hidden = YES;
    
    //Clean textfields
    [usernameTextField setText:@""];
    [passwordTextField setText:@""];
    
}

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
    
    AlertsViewController *about = [[AlertsViewController alloc] init];
    [about displayAboutAlert];
    
}


- (IBAction)loginButton:(id)sender {
    
    @try{
    
        if([usernameTextField.text isEqualToString:@""]){
            AlertsViewController *customAlert = [[AlertsViewController alloc] init];
            [customAlert displayInputAlert: [usernameTextField placeholder]];
        }
        else if([passwordTextField.text isEqualToString:@""]){
            AlertsViewController *customAlert = [[AlertsViewController alloc] init];
            [customAlert displayInputAlert: [passwordTextField placeholder]];
        }
        else{
            //Show Activity Indicator
            loadingActivity.hidden = NO;
            [loadingActivity startAnimating];
            
            //Perform login
            
            [[FIRAuth auth]
             signInWithEmail:usernameTextField.text
             password:passwordTextField.text
             completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                 
                 //Stop and hide Activity Indicator
                 self.loadingActivity.hidden = YES;
                 [self.loadingActivity stopAnimating];
                 
                 if(authResult){
                    [self performSegueWithIdentifier:@"login_identifier_segue" sender:self];
                 }
                 else{
                     AlertsViewController *alertError = [[AlertsViewController alloc] init];
                     [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
                 }
                 
             }];
        }
    }
    @catch(NSException *ex){
        //Stop and hide Activity Indicator
        loadingActivity.hidden = YES;
        [loadingActivity stopAnimating];
        
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}
@end
