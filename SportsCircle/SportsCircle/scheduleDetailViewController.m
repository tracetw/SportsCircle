//
//  scheduleDetailViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/31.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "scheduleDetailViewController.h"
#import <Parse/Parse.h>

@interface scheduleDetailViewController ()
{
    NSString *scTime;
}
@property (weak, nonatomic) IBOutlet UITextField *scheduleName;
@property (weak, nonatomic) IBOutlet UITextView *scheduleDetail;


@end

@implementation scheduleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeValueChanged:(UIDatePicker *)sender {
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/M/d HH:mm:ss"];
    //NSLog(@"設定時間為: %@",[format stringFromDate:sender.date]);

    scTime = [format stringFromDate:[NSDate date]];
    // Convert date to string
    
    
    //scTime=[format stringFromDate:sender.date];
    
}

- (IBAction)comfirmBtnPreesed:(id)sender {
    
    if ([PFUser currentUser]) {
        PFObject *userName = [PFObject objectWithClassName:@"schedule"];
        userName[@"scheduleTime"] =scTime;
        userName[@"scheduleName"] =_scheduleName.text;
        userName[@"scheduleLocation"]=@"";
        userName[@"scheduleDetail"]=_scheduleDetail.text;
        userName[@"cheatMode"] = @NO;
//        PFRelation * relation = [[PFRelation alloc] init];
//        [relation addObject:[PFUser currentUser]];
        userName[@"user"] = [PFUser currentUser];
        [userName saveInBackground];
        NSLog(@"WTF dealloc.");
    }
    
    

}

-(void) dealloc{
    //解構式～確認回上一頁.原本的黃色那頁已被消滅(線不能直接拉回去.因為RAM會一直疊加上去)
    NSLog(@"scheduleDetailViewController dealloc.");
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
