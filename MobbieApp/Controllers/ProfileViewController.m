//
//  ProfileViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "ProfileViewController.h"

@interface ProfileViewController (){
    NSString *userID;
}

@end

@implementation ProfileViewController

@synthesize firstNameTextField, lastNameTextField, emailTextField, phoneNumberTextField, loadingActivity;

/**
 *
 * Loads Profile Data
 * @author Pablo Vieira
 *
 */
-(void)viewWillAppear:(BOOL)animated{
    @try{
        [self loadProfileData];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Customize TextFields and add tap recognizer
 * @author Pablo Vieira
 *
 */
- (void)viewDidLoad {
    @try{
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
        [phoneNumberTextField resignFirstResponder];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

/**
 *
 * Method to Load profile data from Firebase
 * @author Pablo Vieira
 *
 */
-(void)loadProfileData{
    @try{
        //Add loading activity
        [loadingActivity startAnimating];
        [loadingActivity setHidden:NO];
        
        UserModel *user = [[UserModel alloc] init];
        DatabaseProvider *db = [[DatabaseProvider alloc] init];
        
        if([FIRAuth auth].currentUser != nil){
            
            //Get userID info from Authentication
            userID = [FIRAuth auth].currentUser.uid;
            
            [[[[[db rootNode] child:const_database_node_users] child:userID] child:const_database_node_profile]
             observeSingleEventOfType:FIRDataEventTypeValue
             withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                 
                 if(snapshot != nil){
                     NSDictionary *usersDict = snapshot.value;
                     
                     //Set UserModel with values
                     [user setFirstName: [usersDict valueForKey:const_database_profile_key_first_name]];
                     [user setLastName: [usersDict valueForKey:const_database_profile_key_last_name]];
                     [user setEmail: [usersDict valueForKey:const_database_profile_key_email]];
                     [user setPhoneNumber: [usersDict valueForKey:const_database_profile_key_phone_number]];
                     
                     self.firstNameTextField.text = user.firstName;
                     self.lastNameTextField.text = user.lastName;
                     self.emailTextField.text = user.email;
                     self.phoneNumberTextField.text = user.phoneNumber;
                     
                     //Stop and hide Activity Indicator
                     self.loadingActivity.hidden = YES;
                     [self.loadingActivity stopAnimating];
                 }
                 
             } withCancelBlock:^(NSError * _Nonnull error) {
                 AlertsViewController *alertError = [[AlertsViewController alloc] init];
                 [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
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

#pragma mark - Buttons
/**
 *
 * Perform change password
 * @author Pablo Vieira
 *
 */
- (IBAction)changePasswordButton:(id)sender {
    @try{
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
                                        handler:^(UIAlertAction * _Nonnull action){
                                            
            UITextField *newPwd = alert.textFields.firstObject;
                                            
            if([newPwd.text isEqualToString:@""]){
                //Display alert
                AlertsViewController *alertError = [[AlertsViewController alloc]init];
                [alertError displayAlertMessage: const_no_input_alert_message];
            }
            else{
                //change password
                DatabaseProvider *db = [[DatabaseProvider alloc ]init];
                [db changeUserPassword: newPwd.text];
                AlertsViewController *alertError = [[AlertsViewController alloc]init];
                [alertError displayAlertMessage: const_update_db_alert_message];
            }
        }];
        //Add Confirm button
        [alert addAction: confirmButton];
        [alert addAction: cancelButton];
        
        //Display Alert
        [self presentViewController:alert animated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Update Profile
 * @author Pablo Vieira
 *
 */
- (IBAction)updateProfileButton:(id)sender {
    @try{
        //Check if fields are not empty
        if((![firstNameTextField.text isEqualToString:@""]) &&
           (![lastNameTextField.text isEqualToString:@""]) &&
           (![phoneNumberTextField.text isEqualToString:@""]))
        {
            //Get info from fields
            NSString *firstName = firstNameTextField.text;
            NSString *lastName = lastNameTextField.text;
            NSString *phoneNumber = phoneNumberTextField.text;
            NSString *email = emailTextField.text;
            
            //Build obj with user input
            UserModel *user = [[UserModel alloc] init];
            [user setFirstName:firstName];
            [user setLastName:lastName];
            [user setPhoneNumber:phoneNumber];
            [user setEmail:email];
            
            //Get reference to DB
            if(userID == nil){
                userID = [FIRAuth auth].currentUser.uid;
            }
            
            //Update DB
            DatabaseProvider *db = [[DatabaseProvider alloc ] init];
            [db updateUserProfile:user WithUserID:userID];
            
            [self dismissKeyboard];
        }
        //Display msg to fill up
        else{
            AlertsViewController *inputAlert = [[AlertsViewController alloc] init];
            [inputAlert displayAlertMessage:const_no_input_alert_message];
        }
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
@end
