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

// NSCoding Methods
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:firstName forKey:@"first_name"];
    [aCoder encodeObject:lastName forKey:@"last_name"];
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:phoneNumber forKey:@"phone_number"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    NSString *thisFirstName = [aDecoder decodeObjectForKey:@"first_name"];
    NSString *thisLastName = [aDecoder decodeObjectForKey:@"last_name"];
    NSString *thisEmail = [aDecoder decodeObjectForKey:@"email"];
    NSString *thisPhoneNumber = [aDecoder decodeObjectForKey:@"phone_number"];
    
    return [self initWith:thisFirstName andLastName:thisLastName andEmail:thisEmail andPhone:thisPhoneNumber];
}

@end
