//
//  main.m
//  MobbieApp
//
//  Created by Pablo Vieira on 10/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AlertsViewController.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *ex)
        {
            AlertsViewController *alertError = [[AlertsViewController alloc] init];
            [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
            NSLog(@"NAME: %@ , REASON: %@", [ex name], [ex reason]);
        }
    }
    return 0;
}
    
