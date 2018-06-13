//
//  CustomTextField.m
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

//Constants declaration
NSString *const const_username_icon = @"username";
NSString *const const_password_icon = @"password";
NSString *const const_email_icon = @"email";
NSString *const const_phone_icon = @"phone";

/**
 *
 * Customize UITextField with Icon(image)
 * @author Pablo Vieira
 *
 * @param textField - UITextField
 * @param iconName - NSString
 *
 */
-(void)setIcon:(NSString *)iconName forUITextField:(UITextField *)textField{
    
    //Set frame around icon
    UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    //Set image to icon name
    [imgforLeft setImage:[UIImage imageNamed:iconName]];
    
    //Set content mode centre
    [imgforLeft setContentMode:UIViewContentModeCenter];
    
    //Set Icon to Left
    textField.leftView=imgforLeft;
    
    //Set border style
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //Display always
    textField.leftViewMode=UITextFieldViewModeAlways;
}

@end
