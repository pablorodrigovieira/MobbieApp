//
//  ViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "ViewController.h"
@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

//Class ENUMS
typedef NS_ENUM(NSInteger, login_view_){
    login_view_enum_dispatch_time = 1
};

//Class Constants
NSString *const const_login_segue = @"login_identifier_segue";

@synthesize usernameTextField, passwordTextField, loadingActivity;

- (void)viewWillAppear:(BOOL)animated{
    @try{
        //Hide Activity Indicator
        loadingActivity.hidden = YES;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Customise textfields with icon and add Tap recognizer
 * @author Pablo Vieira
 *
 */
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        //Customize textFields
        CustomTextField *usernameInput = [[CustomTextField alloc] init];
        [usernameInput setIcon: const_username_icon forUITextField:self.usernameTextField];
        
        CustomTextField *passwordInput = [[CustomTextField alloc] init];
        [passwordInput setIcon: const_password_icon forUITextField:self.passwordTextField];
        
        //Tap gesture to dismiss keyboard
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
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
        [usernameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons

/**
 *
 * Display About Alert
 * @author Pablo Vieira
 *
 */
- (IBAction)aboutButton:(id)sender {
    @try{
        AlertsViewController *about = [[AlertsViewController alloc] init];
        [about displayAboutAlert];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Perform Login
 * @author Pablo Vieira
 *
 */
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
            //Regex Validation form Email
            NSString *regexEmailPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSString *emailInput = [usernameTextField text];
            NSRange emailRange = NSMakeRange(0, [emailInput length]);
            NSError *error = nil;
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexEmailPattern options:0 error:&error];
            
            NSTextCheckingResult *emailMatch = [regex firstMatchInString:emailInput options:0 range:emailRange];
            
            if(emailMatch){
                
                //Disable button
                UIButton *btn = (UIButton *)sender;
                btn.enabled = NO;
                
                //Show Activity Indicator
                loadingActivity.hidden = NO;
                [loadingActivity startAnimating];
                
                //Perform login
                
                [[FIRAuth auth]
                 signInWithEmail:usernameTextField.text
                 password:passwordTextField.text
                 completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                     
                     //Wait 1 second to stop loading activity,
                     //as the result from firebase may take time..
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(login_view_enum_dispatch_time * NSEC_PER_SEC)),
                                    dispatch_get_main_queue(),
                     ^{
                         //Stop and hide Activity Indicator
                         self.loadingActivity.hidden = YES;
                         [self.loadingActivity stopAnimating];
                         
                         if(authResult){
                             [self performSegueWithIdentifier:const_login_segue sender:self];
                         }
                         else{
                             //Enable button
                             UIButton *btn = (UIButton *)sender;
                             btn.enabled = YES;
                             
                             AlertsViewController *alertError = [[AlertsViewController alloc] init];
                             [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
                         }
                     });
                 }];
            }
            else{
                self.loadingActivity.hidden = YES;
                [self.loadingActivity stopAnimating];
                
                //Invalid Email
                AlertsViewController *errAlert = [[AlertsViewController alloc] init];
                [errAlert displayAlertMessage:const_invalid_email_alert_message];
            }
        }
    }
    @catch(NSException *ex){
        //Enable button
        UIButton *btn = (UIButton *)sender;
        btn.enabled = YES;
        
        //Stop and hide Activity Indicator
        loadingActivity.hidden = YES;
        [loadingActivity stopAnimating];
        
        AlertsViewController *alertError = [[AlertsViewController alloc] init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
@end
