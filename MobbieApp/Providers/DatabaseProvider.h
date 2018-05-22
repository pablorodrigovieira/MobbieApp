//
//  DatabaseProvider.h
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/UserModel.h"

@import Firebase;

@interface DatabaseProvider : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;

- (void) InsertUserProfileData: (UserModel *) user WithUserID: (NSString *) userID;

@end
