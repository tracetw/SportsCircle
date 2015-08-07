//
//  mapViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/31.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//


#import "mapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface mapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
}
@property (weak, nonatomic) IBOutlet UIButton *whereAmIBtn;
@property (weak, nonatomic) IBOutlet MKMapView *theMapView;
@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager=[CLLocationManager new];
    //ask user's permission
    if ([locationManager respondsToSelector:@selector(respondsToSelector:)])
    {
        [locationManager requestAlwaysAuthorization];
        //定位方式 使用此app以及背景都會執行
        //1.info要加list讓使用者確認授權 2.MKMAP要勾userlocation
    }
    
    //prepare locationManager
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //kCLLocationAccuracyBest為最佳 點進去看可以換精確度
    locationManager.activityType=CLActivityTypeAutomotiveNavigation;
    //運動類型專題可以用CLActivityTypeFitness
    locationManager.delegate=self;
    //物件溝通
    [locationManager startUpdatingLocation];
    //回報位置
    
    _theMapView.mapType=MKMapTypeStandard;//一般地圖圖示
    _theMapView.userTrackingMode=MKUserTrackingModeNone;//尚無追蹤的模式
    
    [_whereAmIBtn setBackgroundImage:[UIImage imageNamed:@"map-pin-746123_640.png"] forState: UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)whereAmIBtnPressed:(id)sender {
    _theMapView.userTrackingMode=MKUserTrackingModeFollow;//這個會瞬間回自己的位置～看不出來剛剛查的地圖方向
    //_theMapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;//用這個才會滑回自己的位置
}


#pragma mark - CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = locations.lastObject;
    //最新的位子會放在array的最後一個,所以用lastObject
    NSLog(@"Current Location: %.06f,%.06f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);//(緯度,經度).06f表示一定取六位～沒有會補零
    
    if (isFirstLocationReceived==false)
    {
        
        MKCoordinateRegion region=_theMapView.region;
        //MKCoordinateRegion 中心 縮放
        //region不用*因為為c的struct結構.表示為一個資料儲存.非物件
        region.center=currentLocation.coordinate;
        region.span.latitudeDelta=0.01;
        //0.01表示螢幕上一個點是緯度的0.01
        region.span.longitudeDelta=0.01;
        [_theMapView setRegion:region animated:true];
        //設定region並跳過去指定的region
        isFirstLocationReceived=true;
        
        
        //add annotation
        CLLocationCoordinate2D coordicate=currentLocation.coordinate;//MKCoordinateRegion含有CLLocationCoordinate2D(只取x,y)
        coordicate.latitude+=0.0005;//設定頭針的緯度
        coordicate.longitude+=0.0005;//設定頭針的經度
        
        MKPointAnnotation *annotation=[MKPointAnnotation new];
        annotation.coordinate=coordicate;
        //coordinate座標
        annotation.title=@"肯德基";
        annotation.subtitle=@"真好吃!🍗";
        
        [_theMapView addAnnotation:annotation];
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //MKAnnotationView 顯示圖標的樣貌 每一個大頭針插上去都會跑這裡確認
    
    if (annotation==mapView.userLocation){
        return nil;}
    
    MKPinAnnotationView *resultView=(MKPinAnnotationView*)
    //MKPinAnnotationView是大頭針
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"Store"];
    //地圖有無要回收的大頭針,其名稱為Store
    if (resultView==nil) {
        resultView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Store"];
        //大頭針跑出螢幕後～放入回收
    }else{
        resultView.annotation=annotation;
    }
    
    resultView.canShowCallout=true;
    resultView.animatesDrop=true;
    resultView.pinColor=MKPinAnnotationColorGreen;
    
    
    //針對CallOut去做圖片放入.mapview&controllerview要記得用delegate
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,100,180)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border.png"]];
    [view addSubview:imgView];
    resultView.leftCalloutAccessoryView = view;
    //圖有被切到之後再調整
    
    return resultView;
}
@end
