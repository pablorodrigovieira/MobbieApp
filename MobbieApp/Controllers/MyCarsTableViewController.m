//
//  MyCarsTableViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 17/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "MyCarsTableViewController.h"

@interface MyCarsTableViewController (){
    NSString *userID;
}

@end

@implementation MyCarsTableViewController

//Class ENUMS
typedef NS_ENUM(NSInteger, mycars_table_view_){
    mycars_table_view_enum_number_column = 1,
    mycars_table_view_enum_dispatch_time = 2
};

//Class Constants
NSString *const const_car_management_segue = @"car_management_edit_segue";
NSString *const const_custom_table_view_cell = @"CustomTableViewCell";
NSString *const const_cell_identifier = @"carCell";

@synthesize carData,loadingActivity;

/**
 *
 * Handle Car data from Firebase to TableViewController
 *
 * @author Pablo Vieira
 *
 */
-(void)viewDidAppear:(BOOL)animated{
    @try{
        [super viewDidAppear:animated];
        carData = [[NSMutableArray alloc]init];
        
        [self handleCarData];
        
        //Wait 2 seconds to stop loading activity
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mycars_table_view_enum_dispatch_time *NSEC_PER_SEC)),dispatch_get_main_queue(),
           ^{
               //Stop and hide Activity Indicator
               [self.loadingActivity stopAnimating];
           });
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Firebase references and Table view custom
 *
 * @author Pablo Vieira
 *
 */
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //DB Ref
        self.ref = [[FIRDatabase database] reference];
        
        //UserID
        userID = [FIRAuth auth].currentUser.uid;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

#pragma mark - Car Data

/**
 *
 * Get cars from Firebase and add to table view
 *
 * @author Pablo Vieira
 *
 */
-(void)handleCarData{
    @try{
        [self.loadingActivity startAnimating];
        
        //Firebase Query
        NSString *CarPath = [NSString stringWithFormat:@"%@/%@/%@", const_database_node_users,userID,const_database_node_cars];
        
        FIRDatabaseQuery *query = [[self.ref child:CarPath] queryOrderedByKey];
        
        [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            CarModel *myNewCar = [[CarModel alloc] init];
            
            [myNewCar setMake:[snapshot.value objectForKey:const_database_car_key_make]];
            [myNewCar setCarModel:[snapshot.value objectForKey:const_database_car_key_model]];
            [myNewCar setPlateNumber:[snapshot.value objectForKey:const_database_car_key_plate_number]];
            [myNewCar setImageURL:[snapshot.value objectForKey:const_database_car_key_image_url]];
            [myNewCar setRegoExpiry:[snapshot.value objectForKey:const_database_car_key_rego_expiry]];
            [myNewCar setVinChassis:[snapshot.value objectForKey:const_database_car_key_vin_chassis]];
            [myNewCar setYear:[snapshot.value objectForKey:const_database_car_key_year]];
            [myNewCar setBodyType:[snapshot.value objectForKey:const_database_car_key_body_type]];
            [myNewCar setTransmission:[snapshot.value objectForKey:const_database_car_key_transmission]];
            [myNewCar setColour:[snapshot.value objectForKey:const_database_car_key_colour]];
            [myNewCar setFuelType:[snapshot.value objectForKey:const_database_car_key_fuel_type]];
            [myNewCar setSeats:[snapshot.value objectForKey:const_database_car_key_seats]];
            [myNewCar setDoors:[snapshot.value objectForKey:const_database_car_key_doors]];
            
            [self->carData addObject:myNewCar];
            [self.tableView reloadData];
            
            self.loadingActivity.hidden = YES;
            [self.loadingActivity stopAnimating];
            
        }withCancelBlock:^(NSError * _Nonnull error) {
            
            self.loadingActivity.hidden = YES;
            [self.loadingActivity stopAnimating];
            
            AlertsViewController *alertError = [[AlertsViewController alloc] init];
            [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
        }];
        
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView
/**
 *
 * Return number of Columns in the table view
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 *
 * @return NSInteger
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @try{
        return mycars_table_view_enum_number_column;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Return number of rows in the table view based on the Array info
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 * @param section - NSInteger
 *
 * @return NSInteger
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try{
        return [carData count];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Parse Car data into Custom Table View Cell
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 * @param indexPath - NSIndexPath
 *
 * @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        static NSString *cellIdentifier = const_cell_identifier;
        NSString *image_url, *carName;
        
        [self.tableView registerNib:[UINib nibWithNibName:const_custom_table_view_cell bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        //Details
        carName = [NSString stringWithFormat:@"%@ %@", [[carData objectAtIndex:indexPath.row] make], [[carData objectAtIndex:indexPath.row] carModel]];
        
        [[cell labelCarName] setText: carName];
        [[cell labelRegoPlate] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] plateNumber]]];
        [[cell labelRegoExpiry] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] regoExpiry]]];
        
        //Image
        image_url = [[carData objectAtIndex:indexPath.row]imageURL];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: image_url]];
        [[cell carImage] setImage:[UIImage imageWithData:imageData]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //Change background color of selected cell
        UIView *backgroundColorView = [[UIView alloc] init];
        [backgroundColorView setBackgroundColor:[UIColor colorWithRed:248/255.0f
                                                 green:248/255.0f
                                                 blue:248/255.0f
                                                 alpha:1.0f]];
        [cell setSelectedBackgroundView:backgroundColorView];
        
        return cell;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Set table view property:canEditRowAtIndexPath to YES
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 * @param indexPath - NSIndexPath
 *
 * @return BOOL
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 *
 * Delete row selected in the Firebase and remove from table view
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 * @param editingStyle - editingStyle
 * @param indexPath - NSIndexPath
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //Delete on Firebase
            CarModel *currentCar = [carData objectAtIndex:indexPath.row];
            DatabaseProvider *db = [[DatabaseProvider alloc] init];
            [db deleteCar: currentCar];
            
            //Remove table view
            [carData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Perform segue with the row selected
 *
 * @author Pablo Vieira
 *
 * @param tableView - UITableView
 * @param indexPath - NSIndexPath
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        [self performSegueWithIdentifier:const_car_management_segue sender:self];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

/**
 *
 * Prepare segue with Car Object
 *
 * @author Pablo Vieira
 *
 * @param segue - UIStoryboardSegue
 *
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        CarModel *myCar = [[CarModel alloc] init];
        
        if ([segue.identifier isEqualToString:const_car_management_segue])
        {
            myCar = [carData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            MyCarsManagementViewController *viewController = segue.destinationViewController;
            viewController.carSegue = myCar;
        }
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }    
}

@end
