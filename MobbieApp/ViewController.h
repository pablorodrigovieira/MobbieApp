//
//  ViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customs/CustomTextField.h"

@interface ViewController : UIViewController

//Constants
extern NSString *const const_alert_message;
extern NSString *const const_alert_title;
extern NSString *const const_alert_button;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)aboutButton:(id)sender;

@end

