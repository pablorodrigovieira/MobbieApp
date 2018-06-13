//  Controller for Login Screen (View)
//
//  ViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import <UIKit/UIKit.h>
#import "Customs/CustomTextField.h"
#import "Alerts/AlertsViewController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

- (IBAction)aboutButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@end

