//
//  MyCarsManagementViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "MyCarsManagementViewController.h"

@interface MyCarsManagementViewController ()

@end

@implementation MyCarsManagementViewController

@synthesize carImage, loadingActivity, plateNumberTextField;

- (void)viewWillAppear:(BOOL)animated{
    [self.loadingActivity stopAnimating];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    @try{
        //If the device has camera
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            //Image Picker Obj
            UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
            
            //Set picker delegate
            pickerCtrl.delegate=self;
            
            //Set Camera type for the source
            [pickerCtrl setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            //Enable editing photo taken
            [pickerCtrl setAllowsEditing:YES];
            
            //Present Camera
            [self presentViewController:pickerCtrl animated:YES completion:nil];
            
        }
        else{
            AlertsViewController *alertError = [[AlertsViewController alloc]init];
            [alertError displayAlertMessage: @"Your device has no camera."];
        }
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}

- (IBAction)saveCar:(id)sender {
    //TODO fields Validation
    //TODO ADD to DB
    
    self.loadingActivity.hidden = NO;
    [self.loadingActivity startAnimating];
    
    //Disable button
    UIButton *saveBtn = (UIButton *)sender;
    saveBtn.enabled = NO;
    
    //Added Image to Firebase
    DatabaseProvider *db = [[DatabaseProvider alloc] init];
    [db InsertCarImage:carImage];
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    
    NSString *CarPath = [NSString stringWithFormat:@"users/%@/cars", userID];
    
    NSString *key = [[_ref child:CarPath] childByAutoId].key;
    
    //Values as Model
    NSString *vinChassis, *regoExpiry, *plateNumber, *year, *make, *bodyType, *transmission, *colour, *fuelType, *seats, *doors, *carModel, *imageURL, *carStatus;
    
    vinChassis = self.vinTextField.text;
    regoExpiry = self.regoTextField.text;
    plateNumber = self.plateNumberTextField.text;
    year = self.yearTextField.text;
    make = self.makeTextField.text;
    bodyType = self.bodyTypeTextField.text;
    transmission = self.transmissionTextField.text;
    colour = self.colourTextField.text;
    fuelType = self.fuelTypeTextField.text;
    seats = self.seatsTextField.text;
    doors = self.doorsTextField.text;
    carModel = self.modelTextField.text;
    imageURL = @"https://firebasestorage.googleapis.com/v0/b/mobbieapp.appspot.com/o/ujiF9eHrrPUCvo91qNZjXD46bH92%20%2F85DE6D86-3223-4F59-84BA-0D372400AA00.jpg?alt=media&token=e11d3228-912e-499a-b7e8-7bb7422cb8e3";
    carStatus = @"YES";
    
    
    //Obj to be inserted into DB
    NSDictionary *carPost = @{
                              const_database_car_key_vin_chassis: vinChassis,
                              const_database_car_key_rego_expiry: regoExpiry,
                              const_database_car_key_plate_number: plateNumber,
                              const_database_car_key_year: year,
                              const_database_car_key_make: make,
                              const_database_car_key_body_type: bodyType,
                              const_database_car_key_transmission: transmission,
                              const_database_car_key_colour: colour,
                              const_database_car_key_fuel_type: fuelType,
                              const_database_car_key_seats: seats,
                              const_database_car_key_doors: doors,
                              const_database_car_key_model: carModel,
                              const_database_car_key_image_url: imageURL,
                              const_database_car_key_status: carStatus
                              };
    
    NSDictionary *childUpdate = @{[NSString stringWithFormat:@"%@/%@", CarPath, key]: carPost};
    
    [_ref updateChildValues:childUpdate];

    /*
    //Wait 2 seconds to stop loading activity
    //Give time to upload Image
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 *NSEC_PER_SEC)),dispatch_get_main_queue(),
                   ^{
                       //Enable button
                       saveBtn.enabled = YES;
                       [self->loadingActivity stopAnimating];
                   });
     */
    
    //Open List after input to firebase
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIImagePickerController Delegate

//Image Picked handling
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //Successfully picked / handover
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [carImage setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Cancel button handling
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //Handle Cancel
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
