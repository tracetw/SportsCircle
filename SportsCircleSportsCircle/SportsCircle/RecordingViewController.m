//
//  RecordingViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "RecordingViewController.h"
#import "EndRecordingViewController.h"
#import "MapRecordingViewController.h"

@interface RecordingViewController ()<UINavigationBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int count;
    MapRecordingViewController *mapRecordingView;
}
@property (weak, nonatomic) IBOutlet UILabel *miniSecond;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    mapRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRecordingView"];
    [mapRecordingView viewDidLoad];
}
- (IBAction)pauseBtnPressed:(id)sender {
    if ([counter isValid]) {
        [counter invalidate];
    }else {
        counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];//每0.01秒更新一次
    }
}
- (IBAction)stopBtnLongPressed:(id)sender {
    [counter invalidate];
    EndRecordingViewController *endRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"endRecordingView"];
    [self.navigationController showDetailViewController:endRecordingView sender:nil];
}

- (IBAction)cameraBtnPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }

}
- (IBAction)mapBtnPressed:(id)sender {
    [self.navigationController showViewController: mapRecordingView sender:nil];
}


-(void)addNumber:(NSTimer *)sender{
    
    count++;
    int ms = count%100;
    int second = (count/100)%60;
    int minites = (count/6000)%60;
    int hour = count/360000;
    _second.text = [NSString stringWithFormat:@"%02d",second];
    _minutes.text = [NSString stringWithFormat:@"%02d",minites];
    _hour.text = [NSString stringWithFormat:@"%02d",hour];
    _miniSecond.text = [NSString stringWithFormat:@"%02d",ms];
    
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
