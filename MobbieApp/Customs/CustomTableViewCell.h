//  
//  CustomTableViewCell.h
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *labelCarName;
@property (weak, nonatomic) IBOutlet UILabel *labelRegoPlate;
@property (weak, nonatomic) IBOutlet UILabel *labelRegoExpiry;

@end
