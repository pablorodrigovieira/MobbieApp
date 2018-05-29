//
//  DatabaseProvider.m
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "DatabaseProvider.h"

@implementation DatabaseProvider

@synthesize rootNode, usersNode, USER_ID;

//Constructor
-(id)init{
    
    self = [super init];
    
    if(self)
    {
        //Reference to Firebase
        self.rootNode = [[FIRDatabase database] reference];
        self.usersNode = [rootNode child:@"users"];
        
        //Get Current User ID
        if(USER_ID == nil){
            USER_ID = [FIRAuth auth].currentUser.uid;
        }
    }
    return self;
}

//Insert User Profile - FIREBASE
-(void)InsertUserProfileData: (UserModel *) user WithUserID:(NSString *) userID{
    @try{
        //Reference Child Firebase
        NSString *key = [[rootNode child:@"users/"] child:userID].key;
        
        //Obj to parse into Firebase
        NSDictionary *postFirebase =
        @{
          @"first_name": [user firstName],
          @"last_name": [user lastName],
          @"email": [user email],
          @"phone_number": [user phoneNumber]
          };
        
        //Append User info to Obj
        NSDictionary *childUpdate = @{[[@"/users/" stringByAppendingString:key] stringByAppendingString:@"/profile"]: postFirebase};
        
        //Insert into DB
        [rootNode updateChildValues:childUpdate
                withCompletionBlock:^(NSError * _Nullable error,
                                      FIRDatabaseReference * _Nonnull ref)
        {
            if(error != nil){
                //Error
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:error.localizedDescription];
            }
            else{
                return;
            }
        }];
        
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)UpdateUserProfile:(UserModel *)user WithUserID:(NSString*) userID{
    @try{
        //Get current UID
        if(userID == nil){
            userID = [FIRAuth auth].currentUser.uid;
        }
        
        //Create NSDictonary
        NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  user.firstName, @"first_name",
                                  user.lastName, @"last_name",
                                  user.phoneNumber, @"phone_number",nil];
        [[[[rootNode
            child:@"users"]
            child:userID]
            child:@"profile"]
         setValue:userDic
         withCompletionBlock:^(NSError * _Nullable error,
                               FIRDatabaseReference * _Nonnull ref)
        {
            if(error == nil){
                //Update successed
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:const_update_db_alert_message];
            }
            else{
                //Error
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:error.observationInfo];
            }
        }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)ChangeUserPassword:(NSString *)userPwd{
    @try{
        [[FIRAuth auth].currentUser
         updatePassword:userPwd
         completion:^(NSError * _Nullable error) {
             if(error == nil)
                 return;
         }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

@end
