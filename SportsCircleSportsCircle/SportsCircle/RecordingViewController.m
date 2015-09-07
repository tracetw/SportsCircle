//
//  RecordingViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "RecordingViewController.h"
#import "endRecordingTableViewController.h"
#import "MapRecordingViewController.h"
#import <Parse/Parse.h>
#import "DKCircleButton.h"
#import "ABFillButton.h"

#define CARORY_PARAMETER 7.0

@interface RecordingViewController ()<UINavigationBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ABFillButtonDelegate>
{
    int count;
    MapRecordingViewController *mapRecordingView;
    NSString *sportName;
    UISwitch *switchview;
    CATransition *transition;
    //NSTimer *refleshDistance;
    PFQuery *query;
    PFObject *lastPostObject;
    NSNumber *distance;
    NSNumber *speedNo;
    NSString *recordingTime;
    NSString *objectID;
    BOOL buttonState;
    UIImage *mainPostImage;
    NSString *userWeight;
    NSString *calory;
}
@property (weak, nonatomic) IBOutlet ABFillButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *miniSecond;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UIView *lockScreenView;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *caloryTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet DKCircleButton *pauseButton;
@property (weak, nonatomic) UIImage *mapRecordingImage;
@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Setup stopBtn
    
    [_stopButton configureButtonWithHightlightedShadowAndZoom:YES];
    [_stopButton setEmptyButtonPressing:YES];
    [_stopButton setFillPercent:1.0];
    
    self.navigationItem.hidesBackButton = YES;
    
   // [_cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    mapRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRecordingView"];
    
//    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapBtnPressed:)];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"locationIcon"]style:UIBarButtonItemStylePlain target:self action:@selector(mapBtnPressed:)];
    
    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.on = NO;
    //[switchview setOnImage: [UIImage imageWithCGImage:<#(CGImageRef)#>]];
    //[switchview setOnImage: [UIImage imageNamed:@"Unock"]];
    [switchview addTarget:self action:@selector(lockSwitched:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *lockSwith = [[UIBarButtonItem alloc]initWithCustomView:switchview];
    
    [_distanceTextLabel setHidden:true];
    [_distanceImage setHidden:true];
    
    if ([sportName isEqualToString:@"Athletics"] || [sportName isEqualToString:@"Cycling"]) {
        speedNo = [NSNumber new];
        mapRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRecordingView"];
        [mapRecordingView viewDidLoad];
        
        [_distanceTextLabel setHidden:false];
        [_distanceImage setHidden:false];
        
//        refleshDistance = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDistance:) userInfo:NULL repeats:YES];
        
        self.navigationItem.rightBarButtonItem = mapButton;
        self.navigationItem.leftBarButtonItem = lockSwith;
    }else
    {
        self.navigationItem.leftBarButtonItem = lockSwith;
    }
    
    transition=[CATransition animation];
    transition.duration=0.6;
    //動畫時間長度
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //動畫效果 進出緩慢中間快速
    transition.type=kCATransitionPush;
    
    _lockScreenView.hidden=YES;
    
    _sportTypeImage.image = [UIImage imageNamed:sportName];
    
    [self initPauseButton];
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *queryPersonalClass = [PFQuery queryWithClassName:@"PersionalInfo"];
    [queryPersonalClass whereKey:@"user" equalTo:currentUser];
    [queryPersonalClass findObjectsInBackgroundWithBlock:^(NSArray *array,NSError *error){
        if (array[0]) {
            PFObject *currentUserPersonalInfoClassObject = array[0];
            userWeight = currentUserPersonalInfoClassObject[@"weight"];
        }
    }];
    
    
}


//- (IBAction)pauseBtnPressed:(id)sender {
//    if ([counter isValid]) {
//        [counter invalidate];
//    }else{
//        counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];//每0.01秒更新一次
//    }
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIApplication  *app = [UIApplication sharedApplication];
    
    if (!app.isIdleTimerDisabled)
        app.idleTimerDisabled = YES;
}
- (IBAction)stopButtonPressed:(id)sender {
    [_stopButton setFillPercent:1.0];
}
- (void)buttonIsEmpty:(ABFillButton *)button
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-40,self.view.center.y-40,80,80)];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.layer.cornerRadius = 8;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [spinner setCenter:self.view.center];
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
    
    
    NSLog(@"buttonIsEmpty");
    [counter invalidate];
    PFUser *currentUser = [PFUser currentUser];
    // NSLog(@"%@",currentUser);
    query = [PFQuery queryWithClassName:@"WallPost"];
    [query whereKey:@"user" equalTo:currentUser];
    [query addAscendingOrder:@"createdAt"];
    
    //    NSLog(@"array %@",[query findObjects]);
    lastPostObject = [[query findObjects] lastObject];
    objectID = lastPostObject.objectId;
    NSLog(@"%@",lastPostObject);
    
    
    
    if ([sportName isEqualToString:@"Athletics"] || [sportName isEqualToString:@"Cycling"]) {
        _mapRecordingImage = [mapRecordingView snapShotRoute];
        NSData *imageData = UIImagePNGRepresentation(_mapRecordingImage);
        PFFile *mapImageFile = [PFFile fileWithName:@"mapSnapshot.png" data:imageData];
        lastPostObject[@"distance"] = distance;
        [lastPostObject saveInBackground];
        lastPostObject[@"speed"] = speedNo;
        [lastPostObject saveInBackground];
        lastPostObject[@"mapSnapshot"] = mapImageFile;
        [lastPostObject saveInBackground];
        
    }
    
    lastPostObject[@"recordingTime"] = recordingTime;
    [lastPostObject saveInBackground];
    lastPostObject[@"calories"] = calory;
    [lastPostObject saveInBackground];
    [self performSegueWithIdentifier:@"goEndRecording" sender:nil];
    [_stopButton setFillPercent:1.0];
}
//- (IBAction)stopButtonLongPressed:(UILongPressGestureRecognizer*)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [counter invalidate];
//        PFUser *currentUser = [PFUser currentUser];
//        // NSLog(@"%@",currentUser);
//        query = [PFQuery queryWithClassName:@"WallPost"];
//        [query whereKey:@"user" equalTo:currentUser];
//        [query addAscendingOrder:@"createdAt"];
//        
//        //    NSLog(@"array %@",[query findObjects]);
//        lastPostObject = [[query findObjects] lastObject];
//        objectID = lastPostObject.objectId;
//        NSLog(@"%@",lastPostObject);
//        
//        if ([sportName isEqualToString:@"Athletics"] || [sportName isEqualToString:@"Cycling"]) {
//            _mapRecordingImage = [mapRecordingView snapShotRoute];
//            NSData *imageData = UIImagePNGRepresentation(_mapRecordingImage);
//            PFFile *mapImageFile = [PFFile fileWithName:@"mapSnapshot.png" data:imageData];
//            lastPostObject[@"distance"] = distance;
//            [lastPostObject saveInBackground];
//            lastPostObject[@"speed"] = speedNo;
//            [lastPostObject saveInBackground];
//            lastPostObject[@"mapSnapshot"] = mapImageFile;
//            [lastPostObject saveInBackground];
//            
//        }
//        
//        lastPostObject[@"recordingTime"] = recordingTime;
//        [lastPostObject saveInBackground];
//        [self performSegueWithIdentifier:@"goEndRecording" sender:nil];
////        endRecordingTableViewController *endRecordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"endRecordingView"];
////        [self showDetailViewController:endRecordingView sender:self];
//
//    }
//}

//- (IBAction)cameraBtnPressed:(id)sender {
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIImagePickerController *imagePicker = [UIImagePickerController new];
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.delegate = self;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }
//
//}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    recordingTime = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minites,second];
    
    int weight;
        if (userWeight == NULL) {
            weight = 50;
        }else{
            weight = [userWeight intValue];
        }
    
    //NSLog(@"userweight %d",weight);
    double changeToHour =hour+(minites/60.0)+(second/3600.0);
    calory = [NSString stringWithFormat:@"%.0f", weight*CARORY_PARAMETER*changeToHour];
    _caloryTextLabel.text = calory;
    if ([sportName isEqualToString:@"Athletics"] || [sportName isEqualToString:@"Cycling"]) {
        float distanceFloat = [mapRecordingView getDistance];
        distance = @(distanceFloat);
        _distanceTextLabel.text = [NSString stringWithFormat:@" %.2f km",distanceFloat];
        float speed = distanceFloat/(hour+(minites/60.0)+(second/3600.0));
        NSLog(@"%f",speed);
        speedNo = @(speed);
    }
    
}

//-(void)countDistance:(NSTimer *)sender
//{
//    
//}

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

-(void) getSportType:(NSString *)sportType{
        sportName = sportType;
        
        if ([counter isValid]) {
            [counter invalidate];
        }else{
            counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];
        }
}

-(void) getMainImage:(UIImage*)mainImage{
    mainPostImage = mainImage;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    endRecordingTableViewController *view = [segue destinationViewController];
    [view getObjectID:objectID];
    view.snapshotImage = _mapRecordingImage;
    view.countTime = recordingTime;
    view.speed = speedNo;
    view.distance = distance;
    view.calory = calory;
    view.comingView = @"recordingView";

    

//    recordingTime
//    mainPostImage
//    _distanceTextLabel.text
//    snapShot
}

-(void) initPauseButton{
    
    _pauseButton.titleLabel.font = [UIFont systemFontOfSize:22];
    _pauseButton.layer.cornerRadius = _pauseButton.bounds.size.width/2;
    [_pauseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [_pauseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [_pauseButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
    [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateSelected];
    [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateHighlighted];
    
    [_pauseButton addTarget:self action:@selector(tapOnButton) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.backgroundColor = [UIColor colorWithRed:57.0f/255.0f green:88.0f/255.0f blue:100.0f/255.0f alpha:1];
//    [_backgroundView addSubview:pauseBtn];
    //[_backgroundView insertSubview:pauseBtn belowSubview:_lockScreenView];
}

- (void)tapOnButton {
    if (buttonState) {
        [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
        [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateSelected];
        [_pauseButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateHighlighted];
        
    } else {
        [_pauseButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [_pauseButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
        [_pauseButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
        
    }
    if ([counter isValid]) {
        [counter invalidate];
    }else{
        counter = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addNumber:) userInfo:NULL repeats:YES];//每0.01秒更新一次
    }
    buttonState = !buttonState;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    UIApplication  *app = [UIApplication sharedApplication];
    
    if (!app.isIdleTimerDisabled)
        app.idleTimerDisabled = NO;
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
