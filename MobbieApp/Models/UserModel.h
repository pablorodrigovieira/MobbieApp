//
//  UserModel.h
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (weak,nonatomic) NSString *firstName;
@property (weak,nonatomic) NSString *lastName;
@property (weak,nonatomic) NSString *email;
@property (weak,nonatomic) NSString *phoneNumber;

@end
