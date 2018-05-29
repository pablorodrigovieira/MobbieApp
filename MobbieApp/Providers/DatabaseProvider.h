//
//  DatabaseProvider.h
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/UserModel.h"
#import "../Alerts/AlertsViewController.h"

@import Firebase;

@interface DatabaseProvider : NSObject

@property (strong, nonatomic) FIRDatabaseReference *rootNode;
@property (strong, nonatomic) FIRDatabaseReference *usersNode;
@property NSString *USER_ID;


-(void)InsertUserProfileData: (UserModel *) user WithUserID:(NSString *) userID;
-(void)UpdateUserProfile:(UserModel *)user WithUserID:(NSString*) userID;
-(void)ChangeUserPassword:(NSString *)userPwd;


@end
