//
//  SignUpViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize firstNameTextField,lastNameTextField,emailTextField,phoneTextField,passwordTextField,confirmPasswordTextField, loadingActivityIndicator, termsAndConditionsSwitch;


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
- (IBAction)confirmButton:(id)sender {
    
    @try{
        self.loadingActivityIndicator.hidden = NO;
        [loadingActivityIndicator startAnimating];
        
        if([termsAndConditionsSwitch isOn]){
            
            if(![firstNameTextField.text isEqualToString:@""] ||
               ![lastNameTextField.text isEqualToString:@""] ||
               ![emailTextField.text isEqualToString:@""] ||
               ![phoneTextField.text isEqualToString:@""] ||
               ![passwordTextField.text isEqualToString:@""] ||
               ![confirmPasswordTextField.text isEqualToString:@""])
            {
                
                if(passwordTextField.text == confirmPasswordTextField.text)
                {
                    NSString *email = emailTextField.text;
                    NSString *password = confirmPasswordTextField.text;
                    
                    //Build up user obj
                    UserModel *user = [[UserModel alloc] init];
                    
                    //TODO parei aqui
                    //ver pq email ta nil
                    user.firstName = firstNameTextField.text;
                    user.lastName = lastNameTextField.text;
                    user.email = emailTextField.text;
                    user.phoneNumber = phoneTextField.text;
                    
                    [[FIRAuth auth]
                     createUserWithEmail: email
                     password: password
                     completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                         
                         self.loadingActivityIndicator.hidden = YES;
                         [self.loadingActivityIndicator stopAnimating];
                         
                         //Error or Result
                         if(authResult != nil){
                             
                             //TODO - Get USER ID returned
                             NSString *userID;
                             //userID = authResult.additionalUserInfo.username;
                             
                             //TODO
                             //Add User data to storage
                             DatabaseProvider *dbProvider = [[DatabaseProvider alloc] init];
                             [dbProvider InsertUserProfileData:user WithUserID:userID];
                             
                             //Go to Home screen
                             [self performSegueWithIdentifier:@"signup_identifier_segue" sender:self];
                         }
                         else{
                             //error
                             AlertsViewController *errorFirebase = [[AlertsViewController alloc] init];
                             [errorFirebase displayAlertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
                         }
                         
                     }];
                }
                else{
                    self.loadingActivityIndicator.hidden = YES;
                    [self.loadingActivityIndicator stopAnimating];
                    
                    //Password didnt match
                    AlertsViewController *errAlert = [[AlertsViewController alloc] init];
                    [errAlert displayAlertMessage:const_passwords_not_matching_alert_message];
                }
            }
            else{
                self.loadingActivityIndicator.hidden = YES;
                [self.loadingActivityIndicator stopAnimating];
                //Display error input MSGs
                AlertsViewController *errAlert = [[AlertsViewController alloc] init];
                [errAlert displayAlertMessage:const_no_input_alert_message];
            }
        }else{
            self.loadingActivityIndicator.hidden = YES;
            [self.loadingActivityIndicator stopAnimating];
            //Display error input MSGs
            AlertsViewController *errAlert = [[AlertsViewController alloc] init];
            [errAlert displayAlertMessage:@"Please accept the Ts and Cs"];
        }
        
    }@catch(NSException *ex){
        //Stop and hide Activity Indicator
        loadingActivityIndicator.hidden = YES;
        [loadingActivityIndicator stopAnimating];

        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
    
    
}
@end
