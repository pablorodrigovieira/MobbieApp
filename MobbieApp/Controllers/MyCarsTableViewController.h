//  Controller for My Cars Screen (View)
//
//  MyCarsTableViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 17/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import <UIKit/UIKit.h>
#import "../Models/CarModel.h"
#import "../Customs/CustomTableViewCell.h"
#import "DatabaseProvider.h"
#import "MyCarsManagementViewController.h"

@import Firebase;

@interface MyCarsTableViewController : UITableViewController
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray *carData;

@property (nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

@end
