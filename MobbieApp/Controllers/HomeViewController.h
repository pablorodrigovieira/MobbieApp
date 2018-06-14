//  Controller for Home Screen (View)
//
//  HomeViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "../Models/UserModel.h"
#import "../Providers/DatabaseProvider.h"

@interface HomeViewController : UIViewController

- (IBAction)logoutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
