//
//  MyCarsTableViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 17/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "MyCarsTableViewController.h"


@interface MyCarsTableViewController ()

@end

@implementation MyCarsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CarModel *_car = [carData objectAtIndex:indexPath.row];
    cell.labelCarName.text = [_car model];
    cell.labelRegoPlate.text = [_car plateNumber];
    
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
