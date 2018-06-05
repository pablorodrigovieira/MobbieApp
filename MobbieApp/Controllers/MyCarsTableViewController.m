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
        
    }withCancelBlock:^(NSError * _Nonnull error) {
         AlertsViewController *alertError = [[AlertsViewController alloc] init];
         [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
     }];
    
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
    [[cell carImage] setImage:[UIImage imageWithData:imageData]];
    
    
    //Custom color and border
    
    /*
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 2.0;
    cell.contentView.layer.cornerRadius = 10.0;
    [cell.contentView setClipsToBounds:YES];
    */
    /*
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setShadowOffset:CGSizeMake(-4.0, 4.0)];
    [cell.layer setShadowRadius:4.75];
    [cell.layer setShadowOpacity:0.4];
    */
    return cell;
}

@end
