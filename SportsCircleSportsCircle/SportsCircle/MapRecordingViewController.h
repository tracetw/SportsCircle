//
//  MapRecordingViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapRecordingViewController : UIViewController
- (void)viewDidLoad;
-(UIImage*)snapShotRoute;
-(float)getDistance;
@end
