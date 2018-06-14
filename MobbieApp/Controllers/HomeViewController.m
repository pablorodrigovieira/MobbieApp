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

@synthesize backgroundImage;

/**
 *
 * Change image mode according to device orientation
 *
 * @author Pablo Vieira
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    @try{
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
         if (orientation == UIInterfaceOrientationLandscapeLeft){
             self->backgroundImage.contentMode = UIViewContentModeScaleToFill;
         }
         else if (orientation == UIInterfaceOrientationLandscapeRight){
             self->backgroundImage.contentMode = UIViewContentModeScaleToFill;
         }
         else{
             self->backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
         }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *
 * Change image mode according to device orientation
 *
 * @author Pablo Vieira
 *
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    @try{
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
         {
             UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
             
             if (orientation == UIInterfaceOrientationLandscapeLeft){
                 self->backgroundImage.contentMode = UIViewContentModeScaleToFill;
             }
             else if (orientation == UIInterfaceOrientationLandscapeRight){
                 self->backgroundImage.contentMode = UIViewContentModeScaleToFill;
             }
             else{
                 self->backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
             }
         } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
         {
             
         }];
        
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
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
