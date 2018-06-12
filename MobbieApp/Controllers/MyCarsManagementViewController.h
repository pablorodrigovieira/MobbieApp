//
//  MyCarsManagementViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseProvider.h"
#import "CarModel.h"
@import Firebase;

@interface MyCarsManagementViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (weak, nonatomic) IBOutlet UITextField *vinTextField;
@property (weak, nonatomic) IBOutlet UITextField *regoTextField;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *makeTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *transmissionTextField;
@property (weak, nonatomic) IBOutlet UITextField *colourTextField;
@property (weak, nonatomic) IBOutlet UITextField *fuelTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *seatsTextField;
@property (weak, nonatomic) IBOutlet UITextField *doorsTextField;
@property IBOutlet UIImageView *carImage;
@property CarModel *carSegue;

- (IBAction)takePhoto:(id)sender;
- (IBAction)saveCar:(id)sender;

@end
