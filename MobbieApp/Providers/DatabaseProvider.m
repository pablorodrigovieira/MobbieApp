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
    
    [[[self.ref child:@"users"] child:userID] setValue:user];
}

@end
