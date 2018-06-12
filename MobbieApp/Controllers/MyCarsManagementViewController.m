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

@synthesize carImage, loadingActivity, vinTextField,regoTextField,plateNumberTextField,yearTextField,makeTextField,modelTextField,bodyTypeTextField,transmissionTextField,colourTextField,fuelTypeTextField,seatsTextField,doorsTextField, carSegue;

- (void)viewWillAppear:(BOOL)animated{
    @try{
        [self.loadingActivity stopAnimating];
        
        //Read Car segue
        if(carSegue){
            [vinTextField setText:carSegue.vinChassis];
            [regoTextField setText:carSegue.regoExpiry];
            [plateNumberTextField setText:carSegue.plateNumber];
            [yearTextField setText:carSegue.year];
            [makeTextField setText:carSegue.make];
            [modelTextField setText:carSegue.carModel];
            [bodyTypeTextField setText:carSegue.bodyType];
            [transmissionTextField setText:carSegue.transmission];
            [colourTextField setText:carSegue.colour];
            [fuelTypeTextField setText:carSegue.fuelType];
            [seatsTextField setText:carSegue.seats];
            [doorsTextField setText:carSegue.doors];
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: carSegue.imageURL]];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [carImage setImage: image];
        }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        //Tap gesture to dismiss keyboard
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

//Method to dismiss keyboard
-(void)dismissKeyboard {
    @try{
        [vinTextField resignFirstResponder];
        [regoTextField resignFirstResponder];
        [plateNumberTextField resignFirstResponder];
        [yearTextField resignFirstResponder];
        [makeTextField resignFirstResponder];
        [modelTextField resignFirstResponder];
        [bodyTypeTextField resignFirstResponder];
        [transmissionTextField resignFirstResponder];
        [colourTextField resignFirstResponder];
        [fuelTypeTextField resignFirstResponder];
        [seatsTextField resignFirstResponder];
        [doorsTextField resignFirstResponder];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}

- (IBAction)saveCar:(id)sender {
    @try{
        
        //Regex Validation  for Plate Number / Model / Make
        NSString *regexRequiredPattern = @"^[^-\\s][a-zA-Z0-9_\\s-]+$";

        NSString *plateNumberInput = [plateNumberTextField text];
        NSString *modelInput = [modelTextField text];
        NSString *makeInput = [makeTextField text];
        
        NSRange plateRange = NSMakeRange(0, [plateNumberInput length]);
        NSRange modelRange = NSMakeRange(0, [modelInput length]);
        NSRange makeRange = NSMakeRange(0, [makeInput length]);
        
        NSError *error = nil;
        
        NSRegularExpression *regexPlateNumber = [NSRegularExpression regularExpressionWithPattern:regexRequiredPattern options:0 error:&error];
        NSRegularExpression *regexMake = [NSRegularExpression regularExpressionWithPattern:regexRequiredPattern options:0 error:&error];
        NSRegularExpression *regexModel = [NSRegularExpression regularExpressionWithPattern:regexRequiredPattern options:0 error:&error];
        
        NSTextCheckingResult *plateNumberMatch = [regexPlateNumber firstMatchInString:plateNumberInput options:0 range:plateRange];
        NSTextCheckingResult *makeMatch = [regexMake firstMatchInString:makeInput options:0 range:makeRange];
         NSTextCheckingResult *modelMatch = [regexModel firstMatchInString:modelInput options:0 range:modelRange];
        
        if(plateNumberMatch && makeMatch && modelMatch){
            
            self.loadingActivity.hidden = NO;
            [self.loadingActivity startAnimating];
            
            //Disable button
            UIButton *saveBtn = (UIButton *)sender;
            saveBtn.enabled = NO;
            
            //Added Image to Firebase
            DatabaseProvider *db = [[DatabaseProvider alloc] init];
            
            //Car Model
            CarModel *newCar = [[CarModel alloc] init];
            
            newCar.vinChassis = self.vinTextField.text;
            newCar.regoExpiry = self.regoTextField.text;
            newCar.plateNumber = self.plateNumberTextField.text;
            newCar.year = self.yearTextField.text;
            newCar.make = self.makeTextField.text;
            newCar.bodyType = self.bodyTypeTextField.text;
            newCar.transmission = self.transmissionTextField.text;
            newCar.colour = self.colourTextField.text;
            newCar.fuelType = self.fuelTypeTextField.text;
            newCar.seats = self.seatsTextField.text;
            newCar.doors = self.doorsTextField.text;
            newCar.carModel = self.modelTextField.text;
            newCar.imageURL = [db insertImage:carImage];
            newCar.carStatus = @"YES";
            
            [db insertCarDetails:newCar];
            
            //Open List after input to firebase
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            AlertsViewController *alertError = [[AlertsViewController alloc]init];
            [alertError displayAlertMessage: const_car_input_required];
        }

    }
    @catch(NSException *ex){
        //Enable button
        UIButton *saveBtn = (UIButton *)sender;
        saveBtn.enabled = YES;
        
        self.loadingActivity.hidden = YES;
        [self.loadingActivity stopAnimating];
        
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

#pragma mark UIImagePickerController Delegate

//Image Picked handling
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    @try{
        //Successfully picked / handover
        UIImage *image = info[UIImagePickerControllerEditedImage];
        [carImage setImage:image];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}

//Cancel button handling
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    @try{
        //Handle Cancel
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

@end
