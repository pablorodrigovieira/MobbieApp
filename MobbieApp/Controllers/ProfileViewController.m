//
//  ProfileViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController (){
    NSString *userID;
}

@end

@implementation ProfileViewController

NSString *const const_profile_alert_message = @"Enter a new password";
NSString *const const_profile_alert_title = @"Change Password";
NSString *const const_profile_alert_button = @"Confirm";
NSString *const const_profile_alert_cancel_button = @"Cancel";

@synthesize firstNameTextField, lastNameTextField, emailTextField, phoneNumberTextField, loadingActivity;

-(void)viewWillAppear:(BOOL)animated{
    [self loadProfileData];
}


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
    
    //Tap gesture to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

//Method to dismiss keyboard
-(void)dismissKeyboard {
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [phoneNumberTextField resignFirstResponder];
}

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
            
            [[[[[db rootNode] child:@"users"] child:userID] child:@"profile"]
             observeSingleEventOfType:FIRDataEventTypeValue
             withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                 
                 if(snapshot != nil){
                     //Get result and hold in a NSDictinary
                     NSDictionary *usersDict = snapshot.value;
                     
                     //Set UserModel with values
                     [user setFirstName: [usersDict valueForKey:@"first_name"]];
                     [user setLastName: [usersDict valueForKey:@"last_name"]];
                     [user setEmail: [usersDict valueForKey:@"email"]];
                     [user setPhoneNumber: [usersDict valueForKey:@"phone_number"]];
                     
                     //Set textfields with details
                     self.firstNameTextField.text = user.firstName;
                     self.lastNameTextField.text = user.lastName;
                     self.emailTextField.text = user.email;
                     self.phoneNumberTextField.text = user.phoneNumber;
                     
                     //Stop and hide Activity Indicator
                     self.loadingActivity.hidden = YES;
                     [self.loadingActivity stopAnimating];
                 }
                 
             } withCancelBlock:^(NSError * _Nonnull error) {
                 //code
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
    @try{
        //Check if fields are not empty
        //parei aqui
        if((![firstNameTextField.text isEqualToString:@""]) &&
           (![lastNameTextField.text isEqualToString:@""]) &&
           (![phoneNumberTextField.text isEqualToString:@""]))
        {
            //Get info from fields
            NSString *firstName = firstNameTextField.text;
            NSString *lastName = lastNameTextField.text;
            NSString *phoneNumber = phoneNumberTextField.text;
            
            //Build obj with user input
            UserModel *user = [[UserModel alloc] init];
            [user setFirstName:firstName];
            [user setLastName:lastName];
            [user setPhoneNumber:phoneNumber];
            
            //Get reference to DB
            if(userID == nil){
                userID = [FIRAuth auth].currentUser.uid;
            }
            
            //Update DB
            DatabaseProvider *db = [[DatabaseProvider alloc ] init];
            [db UpdateUserProfile:user WithUserID:userID];
            
            [self dismissKeyboard];
        }
        //Display msg to fill up
        else{
            AlertsViewController *inputAlert = [[AlertsViewController alloc] init];
            [inputAlert displayInputAlert:const_no_input_alert_message];
        }
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}
@end
