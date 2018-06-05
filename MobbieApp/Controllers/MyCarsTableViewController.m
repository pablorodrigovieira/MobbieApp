//
//  MyCarsTableViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 17/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "MyCarsTableViewController.h"


@interface MyCarsTableViewController (){
    NSString *userID;
}

@end

@implementation MyCarsTableViewController

@synthesize carData;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self handleCarData];
     //NSLog(@"carData: %@", carData);
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //DB Ref
    self.ref = [[FIRDatabase database] reference];
    
    //UserID
    userID = [FIRAuth auth].currentUser.uid;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    /*
    carData = [NSMutableArray array];
    
    NSInteger numberOfCars = 3;
    
    for(NSUInteger index = 1; index <= numberOfCars; index++){
        CarModel *myCar = [[CarModel alloc]init];
        myCar.model = @"Ford";
        myCar.plateNumber = @"XXX-1111";
        //myCar.status = YES;
        //myCar.imageURL = @"logo";
        
        [carData addObject:myCar];
    }
     */
    
}
-(void)handleCarData{
    
    //Firebase Query
    NSString *CarPath = [NSString stringWithFormat:@"users/%@/cars", userID];
    
    FIRDatabaseQuery *query = [[self.ref child:CarPath] queryOrderedByKey];
    
    carData = [[NSMutableArray alloc]init];
    
    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        CarModel *myNewCar = [[CarModel alloc] init];
        [myNewCar setCarModel:[snapshot.value objectForKey:const_database_car_key_model]];
        [myNewCar setPlateNumber:[snapshot.value objectForKey:const_database_car_key_plate_number]];
        [myNewCar setImageURL:[snapshot.value objectForKey:const_database_car_key_image_url]];
        
        [self->carData addObject:myNewCar];
        [self.tableView reloadData];
    }];
    
    NSLog(@"car: %@", carData);
    
    /*
    CarModel *newCar = [[CarModel alloc] init];
    
    DatabaseProvider *db = [[DatabaseProvider alloc] init];
    
    [[[[[db rootNode] child:@"users"] child:userID] child:@"cars"]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot){

         [newCar setPlateNumber:[snapshot.value objectForKey:@"plate-number"]];
         [newCar setCarModel:[snapshot.value objectForKey:@"model"]];
         [newCar setImageURL:[snapshot.value objectForKey:@"image-url"]];
         [newCar setCarStatus:[snapshot.value objectForKey:@"status"]];

         //Get result and hold in a NSDictinary
         NSDictionary *carDis = snapshot.value;
         
         //Set UserModel with values
         [newCar setPlateNumber:[carDis valueForKey:@"plate-number"]];
         [newCar setCarModel:[carDis valueForKey:@"plate-number"]];
         [newCar setImageURL:[carDis valueForKey:@"plate-number"]];
         [newCar setCarStatus:[carDis valueForKey:@"plate-number"]];
         
         [self->carData addObject:newCar];
         NSLog(@"snap: %@", snapshot.value);
         NSLog(@"car: %@", newCar);
         NSLog(@"Model: %@", newCar.carModel);
         NSLog(@"Plate: %@", newCar.plateNumber);
         NSLog(@"Img: %@", newCar.imageURL);
         NSLog(@"Status: %@", newCar.carStatus);
         
         [self.tableView reloadData];
         
     }withCancelBlock:^(NSError * _Nonnull error) {
         AlertsViewController *alertError = [[AlertsViewController alloc] init];
         [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
     }];
*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [carData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"carCell";
    NSString *image_url;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    image_url = [[carData objectAtIndex:indexPath.row]imageURL];
    
    [[cell labelCarName] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] carModel]]];
    [[cell labelRegoPlate] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] plateNumber]]];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: image_url]];
    //[cell imageView].frame = CGRectMake(0, 0, 100, 100);
    //[cell imageView].center = cell.imageView.superview.center;
    [[cell carImage] setImage:[UIImage imageWithData:imageData]];
     //:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] plateNumber]]];
    /*
    CarModel *_car = [carData objectAtIndex:indexPath.row];
    cell.labelCarName.text = [_car model];
    cell.labelRegoPlate.text = [_car plateNumber];
    */
    //Custom color and border
    
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 2.0;
    cell.contentView.layer.cornerRadius = 10.0;
    [cell.contentView setClipsToBounds:YES];
    
    /*
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setShadowOffset:CGSizeMake(-4.0, 4.0)];
    [cell.layer setShadowRadius:4.75];
    [cell.layer setShadowOpacity:0.4];
    */
    return cell;
}

@end
