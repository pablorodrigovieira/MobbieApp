//
//  ProfileViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "../ViewController.h"
#import "../Customs/CustomTextField.h"
#import "../Models/UserModel.h"
#import "../Providers/DatabaseProvider.h"

@interface ProfileViewController : ViewController

extern NSString *const const_profile_alert_message;
extern NSString *const const_profile_alert_title;
extern NSString *const const_profile_alert_button;
extern NSString *const const_profile_alert_cancel_button;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
- (IBAction)changePasswordButton:(id)sender;
- (IBAction)updateProfileButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

@end
