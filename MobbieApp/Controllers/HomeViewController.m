//
//  HomeViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

//Class Constants
NSString *const const_logout_segue = @"logout_identifier_segue";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *
 * Perform Logout/Signout local and Firebase
 *
 * @author Pablo Vieira
 *
 */
- (IBAction)logoutButton:(id)sender {
    @try{
        NSError *signOutError;
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        
        if (!status) {
            AlertsViewController *alertError = [[AlertsViewController alloc]init];
            [alertError displayAlertMessage: [NSString stringWithFormat:@"%@ %@", const_error_sign_out, signOutError]];
            
            return;
        }else{
            [self performSegueWithIdentifier:const_logout_segue sender:nil];
        }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
@end
