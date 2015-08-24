//
//  searchLocationViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/17.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "searchLocationViewController.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

static NSTimeInterval const kTimeDelay = 2.5;


@interface searchLocationViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    NSString *str1,*str2,*userLat,*userLon;
}
@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (weak, nonatomic) IBOutlet UILabel     *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
//@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
//@property (weak, nonatomic) IBOutlet UITextField *longitudeField;

@property (strong, nonatomic) MBProgressHUD      *hud;
@property (strong, nonatomic) CLLocationManager  *locMgr;
@property (strong, nonatomic) CLGeocoder         *geocoder;

- (IBAction)startLocating;
- (IBAction)geocode;
//- (IBAction)reverseGeocode;//這個是輸入座標轉地址～站不需要

@end

@implementation searchLocationViewController
- (CLLocationManager *)locMgr {
    if (!_locMgr) {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
        
        // 定位精度
        _locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // 距离过滤器，当移动距离小于这个值时不会收到回调
        //        _locMgr.distanceFilter = 50;
    }
    return _locMgr;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        MKMapView *mapView = [[MKMapView alloc] init];
        _mapView = mapView;
        
        _mapView.delegate = self;
    }
    
    return _mapView;
}

#pragma mark - Lifecycle

-(void)viewWillDisappear:(BOOL)animated
{
    self.block(_addressField.text,str1,str2,userLat,userLon);
    //[self.view endEditing:YES];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];//當使用者點到需要輸入的框框時,則會跑出鍵盤,firstresponder表示第一個被觸碰到的地方
//    [self geocode];//表示自己按下goButton
//    return false;//取消resignFirstResponder=>鍵盤就會縮小
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
    [self startLocating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startLocating {
    [self keyboardResign];
    [self locationAuthorizationJudge];
}

/**
 *  地理编码
 */
- (IBAction)geocode {
    //[self keyboardResign];
    
    if (self.addressField.text.length == 0) {
        [self showCommonTip:@"請填寫地址"];
        return;
    }
    
    [self showProcessHud:@"正在獲取位置信息"];
    
    WS(weakSelf);
    [self.geocoder geocodeAddressString:self.addressField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [weakSelf.hud hide:YES];
        
        if (error) {
            [weakSelf showCommonTip:@"地理編碼出錯，或許你選的地方在冥王星"];
            NSLog(@"%@", error);
            return;
        }
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *formatString = [NSString stringWithFormat:@"經度：%lf，緯度：%lf\n%@ %@ %@\n%@\n%@ %@", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude, placemark.addressDictionary[@"City"], placemark.addressDictionary[@"Country"], placemark.addressDictionary[@"CountryCode"], [placemark.addressDictionary[@"FormattedAddressLines"] firstObject], placemark.addressDictionary[@"Name"], placemark.addressDictionary[@"State"]];
        str1=[NSString stringWithFormat:@"%lf",placemark.location.coordinate.latitude];
        str2=[NSString stringWithFormat:@"%lf",placemark.location.coordinate.longitude];
        weakSelf.resultLabel.text = formatString;
        [weakSelf showInMapWithCoordinate:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)];
        
        for (CLPlacemark *pm in placemarks) {
            NSLog(@"經度：%lf，緯度：%lf\n%@ %@ %@\n%@\n%@ %@", pm.location.coordinate.latitude, pm.location.coordinate.longitude, pm.addressDictionary[@"City"], pm.addressDictionary[@"Country"], pm.addressDictionary[@"CountryCode"], [pm.addressDictionary[@"FormattedAddressLines"] firstObject], pm.addressDictionary[@"Name"], pm.addressDictionary[@"State"]);
        }
    }];

}

/**
 *  反地理编码
 */
/*
- (IBAction)reverseGeocode {
    [self keyboardResign];
    
    if (self.latitudeField.text.length == 0 || self.longitudeField.text.length == 0) {
        [self showCommonTip:@"请填写经纬度"];
        return;
    }
    
    [self showProcessHud:@"正在获取位置信息"];
    
    CLLocationDegrees latitude = [self.latitudeField.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeField.text doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    WS(weakSelf);
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [weakSelf.hud hide:YES];
        
        if (error) {
            [weakSelf showCommonTip:@"地理编码出错，或许你选的地方在冥王星"];
            NSLog(@"%@", error);
            return;
        }
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *formatString = [NSString stringWithFormat:@"经度：%lf，纬度：%lf\n%@ %@ %@\n%@\n%@ %@", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude, placemark.addressDictionary[@"City"], placemark.addressDictionary[@"Country"], placemark.addressDictionary[@"CountryCode"], [placemark.addressDictionary[@"FormattedAddressLines"] firstObject], placemark.addressDictionary[@"Name"], placemark.addressDictionary[@"State"]];
        weakSelf.resultLabel.text = formatString;
        [weakSelf showInMapWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        
        for (CLPlacemark *pm in placemarks) {
            NSLog(@"经度：%lf，纬度：%lf\n%@ %@ %@\n%@\n%@ %@", pm.location.coordinate.latitude, pm.location.coordinate.longitude, pm.addressDictionary[@"City"], pm.addressDictionary[@"Country"], pm.addressDictionary[@"CountryCode"], [pm.addressDictionary[@"FormattedAddressLines"] firstObject], pm.addressDictionary[@"Name"], pm.addressDictionary[@"State"]);
        }
    }];
}
*/
#pragma mark - Private

- (void)showCommonTip:(NSString *)tip {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = tip;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:kTimeDelay];
}

- (void)showProcessHud:(NSString *)msg {
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view  addSubview:self.hud];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = msg;
    [self.hud show:NO];
}

/**
 *  点击空白处收起键盘
 */
- (void)backgroundTapped {
    [self keyboardResign];
}

- (void)keyboardResign {
    [self geocode];
    [self.view endEditing:YES];
}

/**
 *  判断定位授权
 */
- (void)locationAuthorizationJudge {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    NSString *locationServicesEnabled = [CLLocationManager locationServicesEnabled] ? @"YES" : @"NO";
    NSLog(@"location services enabled = %@", locationServicesEnabled);
    
    if (status == kCLAuthorizationStatusNotDetermined) { // 如果授权状态还没有被决定就弹出提示框
        if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locMgr requestWhenInUseAuthorization];
            //            [self.locMgr requestAlwaysAuthorization];
        }
        
        // 也可以判断当前系统版本是否大于8.0
        //        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        //            [self.locMgr requestWhenInUseAuthorization];
        //        }
    } else if (status == kCLAuthorizationStatusDenied) { // 如果授权状态是拒绝就给用户提示
        [self showCommonTip:@"請前往設置-隱私-定位中打開定位服務"];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) { // 如果授权状态可以使用就开始获取用户位置
        [self.locMgr startUpdatingLocation];
    }
}

/**
 *  计算两个坐标之间的直线距离;
 */
- (void)calculateStraightDistance {
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:30 longitude:123];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:31 longitude:124];
    CLLocationDistance distances = [loc1 distanceFromLocation:loc2];
    NSLog(@"兩點之間的直線距離是%lf", distances);
}

/**
 *  将位置信息显示到mapView上
 */
- (void)showInMapWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.025, 0.025));
    [self.mapView setRegion:region animated:YES];
    
    [self addAnnotation:coordinate];
}

/**
 *  添加大头针
 */
- (void)addAnnotation:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"here";
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - CLLocationManagerDelegate

/**
 *  只要定位到位置，就会调用，调用频率频繁
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    //CLLocationCoordinate2D coordicate=location.coordinate;
    userLat=[NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    userLon=[NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    NSLog(@"我的位置是 - %@", location);
    [self showInMapWithCoordinate:location.coordinate];
    // 根据不同需要停止更新位置
    [self.locMgr stopUpdatingLocation];
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//        self.block(textField.text);
//    //self.block(textField.text);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
