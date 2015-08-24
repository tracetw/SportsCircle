//
//  MapRecordingViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "MapRecordingViewController.h"

#define ToRadian(x) ((x) * M_PI/180)
#define ToDegrees(x) ((x) * 180/M_PI)

@interface MapRecordingViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    CLLocation *currentLocation, *newCurrentLocation;
    NSArray *locationArray;
    NSMutableArray *locationMutableArray;
    NSMutableArray *beginingPositionArray;
    //double oldLatitude,oldLongitude,newLatitude,newLongitude;
    float totalDistance;
    int i;
    
}
@property (weak, nonatomic) IBOutlet UIButton *traceLocationBtn;
@property (weak, nonatomic) IBOutlet MKMapView *recordingMapView;
@end

@implementation MapRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        beginingPositionArray = [NSMutableArray new];
    }
    
//    MKCoordinateRegion region = _recordingMapView.region;
//    region.center = currentLocation.coordinate;
//    region.span.latitudeDelta = 0.003;//螢幕上一個點緯度經度
//    region.span.longitudeDelta = 0.003;
    
    [_traceLocationBtn setImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
    
   // [_recordingMapView setRegion:region animated:true];
    //_recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    MKCoordinateRegion region = _recordingMapView.region;
    region.center = currentLocation.coordinate;
    region.span.latitudeDelta = 0.003;
    region.span.longitudeDelta = 0.003;
    
    [_recordingMapView setRegion:region animated:true];
    
    CLLocationCoordinate2D coordinates[i];
    for (int x=0; x<i; x++) {
        
        CLLocation *drawLocation;
        
        drawLocation = locationMutableArray[x];
        
        coordinates[x]=CLLocationCoordinate2DMake(drawLocation.coordinate.latitude, drawLocation.coordinate.longitude);
    }
   // NSLog(@"asdfsf %d",i);
   MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:i];
    [_recordingMapView addOverlay:polyLine];

}


- (IBAction)locatiionBtnPressed:(id)sender {
    _recordingMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
//    MKCoordinateRegion region = _recordingMapView.region;
//    region.center = currentLocation.coordinate;
//    region.span.latitudeDelta = 0.003;
//    region.span.longitudeDelta = 0.003;
//    
//    [_recordingMapView setRegion:region animated:true];
//    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = locations.lastObject;
    
    [beginingPositionArray addObject:locations.lastObject];
    int j = (int)beginingPositionArray.count;
    if (j>2)
    {
        CLLocationDistance distance = ([beginingPositionArray[j-1] distanceFromLocation:beginingPositionArray[j-2]]) * 0.000621371192;
        //NSLog(@"%f",distance);
        if (location.coordinate.longitude != 0  && location.coordinate.latitude != 0 && distance < 0.1) {
            
            [locationMutableArray addObject:beginingPositionArray[j-1]];
            
            i = (int)locationMutableArray.count;
            if (i>1)
            {
                currentLocation = locationMutableArray[i-1];
                newCurrentLocation = locationMutableArray[i-2];
                
                //NSLog(@"Current Location: %.6f,%.6f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);//.08不到8位補0
               // NSLog(@"i = %d",i);
                
                [self drawRoute:currentLocation to:newCurrentLocation];
                [self coutDistance:currentLocation to:newCurrentLocation];
            }
        }
    }
}


- (void) drawRoute:(CLLocation *)oldLocation to:(CLLocation *)newLocation
{
    
    CLLocationCoordinate2D coor[2];
    
    
    coor[0]=CLLocationCoordinate2DMake(oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    coor[1]=CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    
    MKPolyline *polyLine2 = [MKPolyline polylineWithCoordinates:coor count:2];
    [_recordingMapView addOverlay:polyLine2];
    
}


-(void)coutDistance:(CLLocation*)old to:(CLLocation*)new
{
    CLLocationDistance distance = ([new distanceFromLocation:old]) * 0.000621371192;
    
    totalDistance += distance;
    //NSLog(@"%f",totalDistance);
}

-(float)getDistance
{
    return totalDistance;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 15.0;
    
    return polylineView;
}

-(UIImage*)snapShotRoute{
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    
    CLLocationCoordinate2D coordinate[2];
    
    CLLocation *snapshotLocation;
    CLLocation *snapshotLocation2;
    //
    snapshotLocation = locationMutableArray[0];
    snapshotLocation2 = locationMutableArray.lastObject;
    //
    coordinate[0]=CLLocationCoordinate2DMake(snapshotLocation.coordinate.latitude, snapshotLocation.coordinate.longitude);
    coordinate[1]=CLLocationCoordinate2DMake(snapshotLocation2.coordinate.latitude, snapshotLocation2.coordinate.longitude);
    
    CLLocationCoordinate2D centerPoint = [self findCenterCoordinate];
    
    CLLocationDistance distance = [self findLongestDistance];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerPoint, 2*distance, 2*distance) ;
   //    MKCoordinateRegion region;
    //
    //
    options.region =  region;
    //    region.center = centerPoint;
    //    //region.span.latitudeDelta = 0.1;//螢幕上一個點緯度經度
    //    //region.span.longitudeDelta = 0.1;
    //    double dNumber = _recordingMapView.frame.size.height;
    //    double dLatitude =fabs(snapshotLocation.coordinate.latitude-snapshotLocation2.coordinate.latitude);
    //    NSLog(@"span %f",dLatitude);
    ////    region.span.latitudeDelta=(double)dLatitude/dNumber*1.2;
    ////    region.span.longitudeDelta=(double)dLatitude/dNumber*1.2;
    //    region.span.latitudeDelta=0.01;
    //    region.span.longitudeDelta=0.01;
    //    NSLog(@"span %f",dLatitude/dNumber*1.2);
    
    options.scale = [UIScreen mainScreen].scale;
    
    
    
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    __block UIImage *finalSnapShotterImage = nil;
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   // dispatch_sync(queue,completionHandler);
    //dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [snapshotter startWithCompletionHandler: ^(MKMapSnapshot *snapshot, NSError *error) {
        
        UIImage *resImage = nil;
        
        UIImage*image = snapshot.image;
        
        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
        [image drawAtPoint:CGPointMake(0, 0)];
        
        CGContextRef context  = UIGraphicsGetCurrentContext();
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[] = {1.0,0.0,0.0,1.0};//颜色元素
        CGColorRef color = CGColorCreate(colorspace, components);
        
        CGContextSetStrokeColorWithColor(context, color);
        CGContextSetLineWidth(context,3.0f);
        CGContextBeginPath(context);
        CGColorSpaceRelease(colorspace);
        CGColorRelease(color);
        
        //draw line in snapshot
        CLLocationCoordinate2D coor[i];
        for (int x=0; x<i; x++) {
            
            CLLocation *drawLocation;
            
            drawLocation = locationMutableArray[x];
            
            coor[x]=CLLocationCoordinate2DMake(drawLocation.coordinate.latitude, drawLocation.coordinate.longitude);
        }
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coor count:i];
        CLLocationCoordinate2D coordinates[[polyLine pointCount]];
        [polyLine getCoordinates:coordinates range:NSMakeRange(0, [polyLine pointCount])];
        
        for(int j=0;j<[polyLine pointCount];j++)
        {
            CGPoint point = [snapshot pointForCoordinate:coordinates[j]];
            
            if(j==0)
            {
                CGContextMoveToPoint(context,point.x, point.y);
            }
            else{
                CGContextAddLineToPoint(context,point.x, point.y);
                
            }
        }
        
        CGContextStrokePath(context);
        
        resImage = UIGraphicsGetImageFromCurrentImageContext();
        finalSnapShotterImage = resImage;
        UIImageWriteToSavedPhotosAlbum(resImage, nil, nil, nil);
        UIGraphicsEndImageContext();
        
        //dispatch_semaphore_signal(sem);
        
    }];
    //dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    while(!finalSnapShotterImage) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    return finalSnapShotterImage;
}


-(CLLocationCoordinate2D)findCenterCoordinate{
    
    CLLocation *longDistanceLocationX;
    CLLocation *longDistanceLocationY;
    CLLocationCoordinate2D centerPoint;
    CLLocationDistance distance2 = 0.0;
    for (int x=0; x < locationMutableArray.count; x++) {
        for (int y =0; y < locationMutableArray.count; y++) {
            CLLocationDistance distance = ([locationMutableArray[y] distanceFromLocation:locationMutableArray[x]]);
            longDistanceLocationX = locationMutableArray[x];
            longDistanceLocationY = locationMutableArray[y];
            CLLocationCoordinate2D coordinate[2];
            coordinate[0] = CLLocationCoordinate2DMake(longDistanceLocationX.coordinate.latitude, longDistanceLocationX.coordinate.longitude);
            coordinate[1] = CLLocationCoordinate2DMake(longDistanceLocationY.coordinate.latitude,longDistanceLocationY.coordinate.longitude);
            if (locationMutableArray.count<2) {
                centerPoint = coordinate[0];
            }
            
            if (distance > distance2) {
                distance2 = distance;
                centerPoint = [self midpointBetweenCoordinate:coordinate[0] andCoordinate:coordinate[1]];
            }
        }
    }
    return centerPoint;
}

-(CLLocationDistance)findLongestDistance{
    
    CLLocationDistance distance;
    CLLocationDistance distance2 = 0.01;
    
    for (int x=0; x < locationMutableArray.count; x++) {
        for (int y =0; y < locationMutableArray.count; y++) {
            distance = ([locationMutableArray[y] distanceFromLocation:locationMutableArray[x]]);
            if (distance > distance2) {
                distance2 = distance;
            }
        }
    }
    return distance2;
}

- (CLLocationCoordinate2D)midpointBetweenCoordinate:(CLLocationCoordinate2D)c1 andCoordinate:(CLLocationCoordinate2D)c2
{
//    c1.latitude = ToRadian(c1.latitude);
//    c2.latitude = ToRadian(c2.latitude);
//    CLLocationDegrees dLon = ToRadian(c2.longitude - c1.longitude);
//    CLLocationDegrees bx = cos(c2.latitude) * cos(dLon);
//    CLLocationDegrees by = cos(c2.latitude) * sin(dLon);
//    CLLocationDegrees latitude = atan2(sin(c1.latitude) + sin(c2.latitude), sqrt((cos(c1.latitude) + bx) * (cos(c1.latitude) + bx) + by*by));
//    CLLocationDegrees longitude = ToRadian(c1.longitude) + atan2(by, cos(c1.latitude) + bx);
//    
//    CLLocationCoordinate2D midpointCoordinate;
//    midpointCoordinate.longitude = ToDegrees(longitude);
//    midpointCoordinate.latitude = ToDegrees(latitude);
    
    CLLocationCoordinate2D midpointCoordinate;
    midpointCoordinate.longitude = (c1.longitude + c2.longitude)/2;
    midpointCoordinate.latitude = (c1.latitude + c2.latitude)/2;
    
    return midpointCoordinate;
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
