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
}
@end

@implementation MapViewController

@synthesize kmLabel, sliderRange, locationManager, mapView;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    //TODO Get value of slider from DB Profile
    [self createBoundaryWithRadius: self.sliderRange.value];
    
    [self sliderRangeChanged: self.sliderRange];
    
}
- (void)viewDidLoad {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBoundaryWithRadius:(float)radius{
    //Create circle
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:selectedCoord radius:radius];
    //Remove overlays of mapview
    [self.mapView removeOverlays: self.mapView.overlays];
    //Add circle to mapview
    [self.mapView addOverlay:circle];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(selectedCoord,radius*4, radius*4);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKCircleRenderer *circle = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    
    circle.strokeColor = [UIColor blueColor];
    circle.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    
    return circle;
}

- (IBAction)sliderRangeChanged:(UISlider *)sender {
    
    NSString *distance;
    
    if(sender == sliderRange){
        distance = [NSString stringWithFormat:@"%0.fKM", sender.value/1000];
        [kmLabel setText:distance];
        
        if(selectedCoord.latitude != 0 && selectedCoord.longitude != 0)
            [self createBoundaryWithRadius:sender.value];
    }
}

@end
