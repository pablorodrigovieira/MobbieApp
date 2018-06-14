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

//Class Constants
NSString *const const_signup_segue = @"signup_identifier_segue";
NSString *const const_minimum_range_distance = @"1KM";

@synthesize firstNameTextField,lastNameTextField,emailTextField,phoneTextField,passwordTextField,confirmPasswordTextField, loadingActivityIndicator, termsAndConditionsSwitch, ref;

/**
 *
 * Customize UITextField with Icon(image), Add firebase reference
 * @author Pablo Vieira
 *
 */
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        self.ref = [[FIRDatabase database] reference];
        
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
        
        //Tap gesture to dismiss keyboard
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Method to dismiss keyboard
 * @author Pablo Vieira
 *
 */
-(void)dismissKeyboard {
    @try{
        [firstNameTextField resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [emailTextField resignFirstResponder];
        [phoneTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        [confirmPasswordTextField resignFirstResponder];
        [termsAndConditionsSwitch resignFirstResponder];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons

/**
 *
 * Dismiss current view
 * @author Pablo Vieira
 *
 */
- (IBAction)cancelButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *
 * Method that create user Account, Profile and Add Default Map Object
 * @author Pablo Vieira
 *
 */
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
             
                //Regex Validation form Email
                NSString *regexEmailPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSString *emailInput = [emailTextField text];
                NSRange emailRange = NSMakeRange(0, [emailInput length]);
                NSError *error = nil;
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexEmailPattern options:0 error:&error];
                
                NSTextCheckingResult *emailMatch = [regex firstMatchInString:emailInput options:0 range:emailRange];
                
                if(emailMatch){
                    
                    if(passwordTextField.text == confirmPasswordTextField.text)
                    {
                        NSString *userEmail = emailTextField.text;
                        NSString *userPassword = confirmPasswordTextField.text;
                        NSString *userFirstName = firstNameTextField.text;
                        NSString *userLastName = lastNameTextField.text;
                        NSString *userPhone = phoneTextField.text;
                        
                        //Build up user obj
                        UserModel *userModel = [[UserModel alloc] init];
                        userModel.firstName = userFirstName;
                        userModel.lastName = userLastName;
                        userModel.phoneNumber = userPhone;
                        
                        [[FIRAuth auth]
                         createUserWithEmail: userEmail
                         password: userPassword
                         completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                             
                             self.loadingActivityIndicator.hidden = YES;
                             [self.loadingActivityIndicator stopAnimating];
                             
                             //Error or Result
                             if(authResult != nil){
                                 
                                 //Get USER ID returned
                                 NSString *userID;
                                 userID = [FIRAuth auth].currentUser.uid;
                                 
                                 //Add User email after create login
                                 userModel.email = userEmail;
                                 
                                 //Insert new User Profile
                                 DatabaseProvider *dbProvider = [[DatabaseProvider alloc] init];
                                 [dbProvider insertUserProfileData:userModel WithUserID:userID];
                                 
                                 //Insert Map Obj as Default 1km range
                                 MapModel *map = [[MapModel alloc] init];
                                 map.rangeDistance = const_minimum_range_distance;
                                 [dbProvider insertUserMapSettings:map WithUserID:userID];
                                 
                                 //Go to Home screen
                                 [self performSegueWithIdentifier:const_signup_segue sender:self];
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
                    
                    //Invalid Email
                    AlertsViewController *errAlert = [[AlertsViewController alloc] init];
                    [errAlert displayAlertMessage:const_invalid_email_alert_message];
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
            [errAlert displayAlertMessage:const_error_terms_and_conditions];
        }
    }
    @catch(NSException *ex){
        //Stop and hide Activity Indicator
        loadingActivityIndicator.hidden = YES;
        [loadingActivityIndicator stopAnimating];

        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
@end
