//
//  MyCarsManagementViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "MyCarsManagementViewController.h"

@interface MyCarsManagementViewController (){
    BOOL isUpdate;
}

@end

@implementation MyCarsManagementViewController

//Class ENUMS
typedef NS_ENUM(NSInteger, mycars_management_view_){
    mycars_management_view_enum_first_item = 0
};

@synthesize carImage, loadingActivity, vinTextField,regoTextField,plateNumberTextField,yearTextField,makeTextField,modelTextField,bodyTypeTextField,transmissionTextField,colourTextField,fuelTypeTextField,seatsTextField,doorsTextField, carSegue;

/**
 *
 * Load Car data if user selected it from table list
 * @author Pablo Vieira
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    @try{
        [self.loadingActivity stopAnimating];
        
        //Variable to control if its update or insert new car
        //in order to delete current image
        isUpdate = NO;
        
        //Read Car segue
        if(carSegue){
            
            isUpdate = YES;
            
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

/**
 *
 * Add Tap gesture to dismiss keyboard and build the Array with Body type Info
 * @author Pablo Vieira
 *
 */
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
        
        bodyTypeArray = [[NSMutableArray alloc] init];
        [bodyTypeArray addObject:@"Convertible"];
        [bodyTypeArray addObject:@"Coupe"];
        [bodyTypeArray addObject:@"Hatch"];
        [bodyTypeArray addObject:@"Sedan"];
        [bodyTypeArray addObject:@"SUV"];
        [bodyTypeArray addObject:@"Ute"];
        [bodyTypeArray addObject:@"Van"];
        [bodyTypeArray addObject:@"Wagon"];
        [bodyTypeArray addObject:@"Other"];
        
        bodyTypeTextField.delegate = self;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Method to dismiss keyboard
 * @author Pablo Vieira
 *
 */
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

#pragma mark - UITextField
/**
 *
 * Set textfield with picker/array Info and Picker style
 * @author Pablo Vieira
 *
 * @param textField - UITextField
 *
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    @try{
        
        CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
        pickerBodyType = [[UIPickerView alloc] initWithFrame:pickerFrame];
        [pickerBodyType setBackgroundColor:[UIColor lightTextColor]];
        
        bodyTypeTextField.text = [bodyTypeArray objectAtIndex: mycars_management_view_enum_first_item];
        bodyTypeTextField.inputView = pickerBodyType;
        
        pickerBodyType.delegate = self;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Resign first responder for bodytype text field
 * @author Pablo Vieira
 *
 * @param touches - NSSet<UITouch *>
 * @param event - UIEvent
 *
 */
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try{
        [bodyTypeTextField resignFirstResponder];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

#pragma mark - UIPickerView Delegate

/**
 *
 * Define number of columns in the PickerView
 * @author Pablo Vieira
 *
 * @param pickerView - UIPickerView
 *
 * @return Integer
 */
-(NSUInteger)numberOfComponentsInpickerView:(UIPickerView *)pickerView{
    @try{
        return 1;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Return number of rows based on the Array
 *
 * @author Pablo Vieira
 *
 * @param pickerView - UIPickerView
 * @param component - NSInteger
 *
 * @return Integer
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    @try{
        return [bodyTypeArray count];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Return the Value of the UIPickerView (row)
 *
 * @author Pablo Vieira
 *
 * @param pickerView - UIPickerView
 * @param row - NSInteger
 * @param component - NSInteger
 *
 * @return NSString
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    @try{
        return [bodyTypeArray objectAtIndex:row];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Set text field with the Value of the UIPickerView (row)
 *
 * @author Pablo Vieira
 *
 * @param pickerView - UIPickerView
 * @param row - NSInteger
 * @param component - NSInteger
 *
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    @try{
        bodyTypeTextField.text = [bodyTypeArray objectAtIndex:row];
        //Hide pickerview
        [[self view] endEditing:YES];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

#pragma mark - Buttons

/**
 *
 * Take a Photo
 *
 * @author Pablo Vieira
 *
 */
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
            [alertError displayAlertMessage: const_error_device_no_camera];
        }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Insert/Update Car Model into Firebase
 *
 * @author Pablo Vieira
 *
 */
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
            
            //If its update, delete current image to Update new before Insert New Img
            if(isUpdate){
                
                //Image reference from storage
                FIRStorage *storage = [FIRStorage storage];
                FIRStorageReference *imageRef = [storage referenceForURL:carSegue.imageURL];
                
                // Delete Image file
                [imageRef deleteWithCompletion:^(NSError *error){
                    // File deleted successfully
                    if (error != nil) {
                        AlertsViewController *alertError = [[AlertsViewController alloc]init];
                        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.description]];
                    }
                }];
            }
            
            newCar.imageURL = [db insertImage:carImage];
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

/**
 *
 * Image Picked handling
 *
 * @author Pablo Vieira
 *
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    @try{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        [carImage setImage:image];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Cancel button handling
 *
 * @author Pablo Vieira
 *
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    @try{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

@end
