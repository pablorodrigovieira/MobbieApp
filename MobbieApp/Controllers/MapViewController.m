//
//  MapViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 14/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationCoordinate2D selectedCoord;
    CGFloat userLatitude, userLongitude;
    NSString *userID;
    float rangeSlider;
}
@end

@implementation MapViewController

@synthesize kmLabel, sliderRange, locationManager, mapView, loadingIndicator;


-(void)loadMapSettings{
    @try{
        //As DEFAULT
        rangeSlider = 1;
        
        //Objs
        DatabaseProvider *db = [[DatabaseProvider alloc] init];
        MapModel *map = [[MapModel alloc]init];
        
        if([FIRAuth auth].currentUser != nil){
            
            //Get userID info from Authentication
            userID = [FIRAuth auth].currentUser.uid;
            
            [[[[[db rootNode] child:@"users"] child:userID] child:@"map"]
             observeSingleEventOfType:FIRDataEventTypeValue
             withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                 
                 if(snapshot != nil){
                     //Get result and hold in a NSDictinary
                     NSDictionary *mapDisc = snapshot.value;
                     
                     //Set UserModel with values
                     [map setRangeDistance: [mapDisc valueForKey:@"range_distance"]];
                     
                     //Convert to float to add value to Slider
                     if([map rangeDistance] != nil){
                         self->rangeSlider = [[map rangeDistance] floatValue];
                         //Convert to meters
                         self->rangeSlider = self->rangeSlider*1000;
                     }
                     //Set Range Label with details
                     NSString *rangeLabel = [map rangeDistance];
                     
                     self.kmLabel.text = rangeLabel;
                     
                     //Set Slider Value
                     [self.sliderRange setValue:self->rangeSlider animated:YES];
                     [self createBoundaryWithRadius:self->rangeSlider];
                     
                     //Wait 1 seconds to stop loading activity
                     //Give time to map and slider update
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)),dispatch_get_main_queue(),
                        ^{
                             //Stop and hide Activity Indicator
                             self.loadingIndicator.hidden = YES;
                            [self.loadingIndicator stopAnimating];
                            
                        });
                 }
                 
             } withCancelBlock:^(NSError * _Nonnull error) {
                 AlertsViewController *alertError = [[AlertsViewController alloc] init];
                 [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", error.localizedDescription]];
             }];
        }
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    @try{
        [super viewWillAppear:YES];
        
        //Get User Map Settings
        [self loadMapSettings];
        
        [self sliderRangeChanged: self.sliderRange];
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}
- (void)viewDidLoad {
    @try{
        
        [super viewDidLoad];
        
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        selectedCoord.latitude = locationManager.location.coordinate.latitude;
        selectedCoord.longitude = locationManager.location.coordinate.longitude;
        
        //Request User Authorization
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)didReceiveMemoryWarning {
    @try{
        
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (void)createBoundaryWithRadius:(float)radius{
    @try{
        //Create circle
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:selectedCoord radius:radius];
        //Remove overlays of mapview
        [self.mapView removeOverlays: self.mapView.overlays];
        //Add circle to mapview
        [self.mapView addOverlay:circle];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(selectedCoord,radius*4, radius*4);
        [self.mapView setRegion:viewRegion animated:YES];
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    @try{
        MKCircleRenderer *circle = [[MKCircleRenderer alloc]initWithOverlay:overlay];
        
        circle.strokeColor = [UIColor blueColor];
        circle.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        
        return circle;
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (IBAction)sliderRangeChanged:(UISlider *)sender {
    @try{
        NSString *distance;
        
        if(sender == sliderRange){
            distance = [NSString stringWithFormat:@"%0.fKM", sender.value/1000];
            [kmLabel setText:distance];
            
            if(selectedCoord.latitude != 0 && selectedCoord.longitude != 0)
                [self createBoundaryWithRadius:sender.value];
        }
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

- (IBAction)updateDatabase:(id)sender {
    @try{
        //show activity
        self.loadingIndicator.hidden = NO;
        [self.loadingIndicator startAnimating];
        
        //Get userID info from Authentication
        userID = [FIRAuth auth].currentUser.uid;
        
        //Remove KM from range distance
        NSString *distance = kmLabel.text;
        [distance stringByReplacingOccurrencesOfString:@"KM" withString:@""];
        
        //Map Model
        MapModel *map = [[MapModel alloc] init];
        [map setRangeDistance:distance];
        
        DatabaseProvider *db = [[DatabaseProvider alloc] init];
        [db updateMapSettings:map WithUserID:userID];
        
        //hide activity
        self.loadingIndicator.hidden = YES;
        [self.loadingIndicator stopAnimating];
        
        
    }@catch(NSException *ex){
        AlertsViewController *alertError = [[AlertsViewController alloc]init];
        [alertError displayAlertMessage: [NSString stringWithFormat:@"%@", [ex reason]]];
    }
}

@end
