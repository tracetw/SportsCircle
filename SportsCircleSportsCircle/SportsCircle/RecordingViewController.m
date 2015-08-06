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
    UISwitch *switchview;
    CATransition *transition;

}
@property (weak, nonatomic) IBOutlet UILabel *miniSecond;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIView *lockScreenView;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    mapRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRecordingView"];
    [mapRecordingView viewDidLoad];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapBtnPressed:)];
    
    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.on = NO;
    //[switchview setOnImage: [UIImage imageWithCGImage:<#(CGImageRef)#>]];
    //[switchview setOnImage: [UIImage imageNamed:@"Unock"]];
    [switchview addTarget:self action:@selector(lockSwitched:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *lockSwith = [[UIBarButtonItem alloc]initWithCustomView:switchview];
    
    self.navigationItem.rightBarButtonItems = @[mapButton,lockSwith];
    
    transition=[CATransition animation];
    transition.duration=0.6;
    //動畫時間長度
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //動畫效果 進出緩慢中間快速
    transition.type=kCATransitionPush;
    
    _lockScreenView.hidden=YES;

}


- (IBAction)pauseBtnPressed:(id)sender {
    if ([counter isValid]) {
        [counter invalidate];
    }else{
        counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];//每0.01秒更新一次
}

- (IBAction)stopButtonLongPressed:(UILongPressGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [counter invalidate];
        EndRecordingViewController *endRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"endRecordingView"];
        [self.navigationController pushViewController:endRecordingView animated:YES];
    }
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

-(void) lockSwitched:(id)sender{
    if ([switchview isOn])  {
        
        _lockScreenView.hidden=NO;
        transition.subtype=kCATransitionFade;
        
    } else {
        _lockScreenView.hidden=YES;
        transition.subtype=kCATransitionFade;
        [_lockScreenView.layer addAnimation:transition forKey:nil];
    }
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
