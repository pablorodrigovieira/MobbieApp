//
//  DatabaseProvider.m
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "DatabaseProvider.h"

@implementation DatabaseProvider

@synthesize ref;

-(id)init{
    
    self = [super init];
    
    if(self)
    {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

- (void) InsertUserProfileData: (UserModel *) user WithUserID: (NSString *) userID{
    @try{
        //Reference Child Firebase
        NSString *key = [[ref child:@"users/"] child:userID].key;
        
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
        [ref updateChildValues:childUpdate];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }

}

@end
