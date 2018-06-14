//  Custom UITextField to add Icon
//  CustomTextField.h
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import <UIKit/UIKit.h>

@interface CustomTextField : UIViewController

//Constants to use in this Class
extern NSString *const const_username_icon;
extern NSString *const const_password_icon;
extern NSString *const const_email_icon;
extern NSString *const const_phone_icon;

-(void)setIcon:(NSString *)iconName forUITextField:(UITextField *)textField;

@end
