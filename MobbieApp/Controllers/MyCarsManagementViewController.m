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

@synthesize carImage, loadingActivity;

- (void)viewWillAppear:(BOOL)animated{
    [self.loadingActivity stopAnimating];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    //TODO ADD to DB
    
    self.loadingActivity.hidden = NO;
    [self.loadingActivity startAnimating];
    
    //Disable button
    UIButton *saveBtn = (UIButton *)sender;
    saveBtn.enabled = NO;
    
    //Added Image to Firebase
    DatabaseProvider *db = [[DatabaseProvider alloc] init];
    [db InsertCarImage:carImage];
    
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
    
    //TODO Open List after input to firebase
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
