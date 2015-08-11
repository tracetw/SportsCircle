//
//  scheduleEditViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "scheduleEditViewController.h"
#import "scheduleTableViewController.h"
#import <Parse/Parse.h>

@interface scheduleEditViewController ()
{
    NSString *scTime;
    NSMutableArray *datas;
    NSArray *userSchedules;
    NSDictionary *postWallDictionary;
    NSArray *postWallArray;
}
@property (weak, nonatomic) IBOutlet UITextField *scheduleName;
@property (weak, nonatomic) IBOutlet UITextView *scheduleDetail;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation scheduleEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _confirmBtn.hidden=YES;
    
    
    NSLog(@"edit id= %@",idStr);
    
    PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    //[query getObjectWithId:idStr];
    PFObject *object=[query getObjectWithId:idStr];
    _scheduleName.text =object[@"scheduleName"];
    //NSLog(@"%@",postWallDictionary);
    
    _scheduleDetail.text=object[@"scheduleDetail"];
    
    _locationLabel.text =object[@"scheduleLocation"];
    
    _timeLabel.text=object[@"scheduleTime"];
    
    /*
     [query getObjectInBackgroundWithId:idStr block:^(PFObject *object, NSError *error) {
     // Do something with the returned PFObject in the gameScore variable.
     // NSLog(@"%@", object);
     _scheduleName.text =object[@"scheduleName"];
     //NSLog(@"%@",postWallDictionary);
     
     _scheduleDetail.text=object[@"scheduleDetail"];
     
     _locationLabel.text =object[@"scheduleLocation"];
     
     _timeLabel.text=object[@"scheduleTime"];
     // NSLog(@"%@",object[@"scheduleTime"]);
     
     }];
     */
    _scheduleName.userInteractionEnabled = NO;
    _scheduleDetail.userInteractionEnabled = NO;
    _locationBtn.userInteractionEnabled=NO;
    _locationLabel.userInteractionEnabled = NO;
    _timeLabel.userInteractionEnabled = NO;
    
    
}
//-(IBAction)buttonPressed:(id)sender
//{
//  self.label.text=idStr;
//}

-(void)passData:(NSString*)argu;
{
    idStr=argu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    //解構式～確認回上一頁.原本的黃色那頁已被消滅(線不能直接拉回去.因為RAM會一直疊加上去)
    NSLog(@"scheduleDetailViewController dealloc.");
}
@end