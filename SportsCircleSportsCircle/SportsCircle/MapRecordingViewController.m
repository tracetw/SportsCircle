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
    CLLocation *currentLocation, *newCurrentLocation;
    NSArray *locationArray;
    NSMutableArray *locationMutableArray;
    //double oldLatitude,oldLongitude,newLatitude,newLongitude;
    float totalDistance;
    int i;
}
@property (weak, nonatomic) IBOutlet MKMapView *recordingMapView;
@end

@implementation MapRecordingViewController

- (void)viewDidLoad {
    locationManager = [CLLocationManager new];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];//授權
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    _recordingMapView.delegate = self;
    
    if (locationMutableArray == nil) {
        locationMutableArray = [NSMutableArray new];
    }
    
    MKCoordinateRegion region = _recordingMapView.region;
    region.center = currentLocation.coordinate;
    region.span.latitudeDelta = 0.01;//螢幕上一個點緯度經度
    region.span.longitudeDelta = 0.01;
    
    [_recordingMapView setRegion:region animated:true];
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}


-(void)viewDidAppear:(BOOL)animated
{
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    MKCoordinateRegion region = _recordingMapView.region;
    region.center = currentLocation.coordinate;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    [_recordingMapView setRegion:region animated:true];
    
    CLLocationCoordinate2D coordinates[i];
    for (int x=0; x<i; x++) {
        
        CLLocation *drawLocation;
        
        drawLocation = locationMutableArray[x];
        
        coordinates[x]=CLLocationCoordinate2DMake(drawLocation.coordinate.latitude, drawLocation.coordinate.longitude);
    }
    NSLog(@"asdfsf %d",i);
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:i];
    [_recordingMapView addOverlay:polyLine];

}


- (IBAction)locatiionBtnPressed:(id)sender {
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = locations.lastObject;
    
    if (location.coordinate.longitude != 0  && location.coordinate.latitude != 0) {
        
        [locationMutableArray addObject:locations.lastObject];
        
        i = (int)locationMutableArray.count;
        if (i>1)
        {
            currentLocation = locationMutableArray[i-1];
            newCurrentLocation = locationMutableArray[i-2];
            
            NSLog(@"Current Location: %.6f,%.6f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);//.08不到8位補0
            NSLog(@"i = %d",i);
            [self drawRoute:currentLocation to:newCurrentLocation];
        }
    }
}


- (void) drawRoute:(CLLocation *)oldLocation to:(CLLocation *)newLocation
{
    
    CLLocationCoordinate2D coor[2];
    
    
    coor[0]=CLLocationCoordinate2DMake(oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    coor[1]=CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coor count:2];
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
