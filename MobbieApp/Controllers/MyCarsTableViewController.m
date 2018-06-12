//
//  MyCarsTableViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 17/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "MyCarsTableViewController.h"

//Create color with RGB Value
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface MyCarsTableViewController (){
    NSString *userID;
}

@end // TODO ENUM

@implementation MyCarsTableViewController

@synthesize carData,loadingActivity;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self handleCarData];
}
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        self.loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingActivity.color = UIColorFromRGB(0x06028D);
        
        loadingActivity.center = self.view.center;
        [self.tableView addSubview:loadingActivity];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [loadingActivity setHidesWhenStopped:YES];
        
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
-(void)handleCarData{
    @try{
        [self.loadingActivity startAnimating];
        
        //Firebase Query
        NSString *CarPath = [NSString stringWithFormat:@"users/%@/cars", userID];
        
        FIRDatabaseQuery *query = [[self.ref child:CarPath] queryOrderedByKey];
        
        carData = [[NSMutableArray alloc]init];
        CarModel *myNewCar = [[CarModel alloc] init];
        
        [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            [myNewCar setCarModel:[snapshot.value objectForKey:const_database_car_key_model]];
            [myNewCar setPlateNumber:[snapshot.value objectForKey:const_database_car_key_plate_number]];
            [myNewCar setImageURL:[snapshot.value objectForKey:const_database_car_key_image_url]];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @try{
        return 1;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try{
        return [carData count];
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        static NSString *cellIdentifier = @"carCell";
        NSString *image_url;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        image_url = [[carData objectAtIndex:indexPath.row]imageURL];
        
        [[cell labelCarName] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] carModel]]];
        [[cell labelRegoPlate] setText:[NSString stringWithFormat:@"%@", [[carData objectAtIndex:indexPath.row] plateNumber]]];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: image_url]];
        [[cell carImage] setImage:[UIImage imageWithData:imageData]];
        
        return cell;
    }
    @catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

@end
