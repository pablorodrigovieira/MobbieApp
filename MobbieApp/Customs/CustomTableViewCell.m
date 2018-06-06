//
//  CustomTableViewCell.m
//  MobbieApp
//
//  Created by Pablo Vieira on 15/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "CustomTableViewCell.h"
//#import "QuartzCore/QuartzCore.h"

@implementation CustomTableViewCell

@synthesize carImage,labelCarName, labelRegoPlate, switchCarStatus;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
