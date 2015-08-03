//
//  MapRecordingViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "MapRecordingViewController.h"

@interface MapRecordingViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    CLLocation *currentLocation;
    NSMutableArray *locationArray;
    double oldLatitude,oldLongitude,newLatitude,newLongitude;
    float totalDistance;
}
@property (weak, nonatomic) IBOutlet MKMapView *recordingMapView;
@end

@implementation MapRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [CLLocationManager new];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    _recordingMapView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    MKCoordinateRegion region = _recordingMapView.region;
    region.center = currentLocation.coordinate;
    region.span.latitudeDelta = 0.01;//螢幕上一個點緯度經度
    region.span.longitudeDelta = 0.01;
    
    [_recordingMapView setRegion:region animated:true];
}
- (IBAction)locatiionBtnPressed:(id)sender {
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    oldLatitude = oldLocation.coordinate.latitude;
    oldLongitude = oldLocation.coordinate.longitude;
    newLatitude = newLocation.coordinate.latitude;
    newLongitude = newLocation.coordinate.longitude;
    currentLocation = newLocation;
    if (oldLocation.coordinate.latitude != 0.000000 && newLocation.coordinate.longitude != 0) {
        
        
        [self drawRoute:oldLatitude and: oldLongitude toNewLocation:newLatitude and:newLongitude];
        [self coutDistance:oldLocation to:newLocation];
        NSLog(@"%f,%f",oldLocation.coordinate.latitude,oldLocation.coordinate.longitude);
    }
}

- (void) drawRoute:(double)latitude and: (double)longtitude toNewLocation: (double)secondLatitude and: (double)secondLongtitude
{
    CLLocationCoordinate2D coordinates[2];
    
    coordinates[0]=CLLocationCoordinate2DMake(latitude, longtitude);
    coordinates[1]=CLLocationCoordinate2DMake(secondLatitude, secondLongtitude);
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
    [_recordingMapView addOverlay:polyLine];
    
}

-(void)coutDistance:(CLLocation*)old to:(CLLocation*)new
{
    CLLocationDistance distance = ([new distanceFromLocation:old]) * 0.000621371192;
    
    totalDistance += distance;
    NSLog(@"%f",totalDistance);
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
