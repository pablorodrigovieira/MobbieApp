//
//  DatabaseProvider.h
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/UserModel.h"
#import "../Models/MapModel.h"
#import "CarModel.h"
#import "../Alerts/AlertsViewController.h"

@import Firebase;

@interface DatabaseProvider : NSObject

//Constants
extern NSString *const const_database_car_key_vin_chassis;
extern NSString *const const_database_car_key_rego_expiry;
extern NSString *const const_database_car_key_plate_number;
extern NSString *const const_database_car_key_year;
extern NSString *const const_database_car_key_make;
extern NSString *const const_database_car_key_body_type;
extern NSString *const const_database_car_key_transmission;
extern NSString *const const_database_car_key_colour;
extern NSString *const const_database_car_key_fuel_type;
extern NSString *const const_database_car_key_seats;
extern NSString *const const_database_car_key_doors;
extern NSString *const const_database_car_key_model;
extern NSString *const const_database_car_key_image_url;
extern NSString *const const_database_car_key_status;

@property (strong, nonatomic) FIRDatabaseReference *rootNode;
@property (strong, nonatomic) FIRDatabaseReference *usersNode;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property NSString *USER_ID;

-(void)insertUserProfileData: (UserModel *) user WithUserID:(NSString *) userID;
-(void)updateUserProfile:(UserModel *)user WithUserID:(NSString*) userID;
-(void)changeUserPassword:(NSString *)userPwd;
-(void)insertUserMapSettings:(MapModel *) distance WithUserID:(NSString *)userId;
-(void)updateMapSettings:(MapModel *) map WithUserID:(NSString *)userId;
-(void)insertCarDetails:(CarModel *) car;
-(NSString *)insertImage:(UIImageView *) image;
-(void)deleteCar:(CarModel *) car;

@end
