//
//  UserModel.m
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize firstName, lastName, email, phoneNumber;

-(id)initWith:(NSString *)inpFirstName andLastName:(NSString *)inpLastName andEmail:(NSString *)inpEmail andPhone:(NSString *)inpPhone{
    firstName = inpFirstName;
    lastName = inpLastName;
    email = inpEmail;
    phoneNumber = inpPhone;
    
    return self;
}

@end
