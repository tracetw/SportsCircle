//
//  scheduleEditViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "scheduleEditViewController.h"
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

@end

@implementation scheduleEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!datas) {
        datas = [[NSMutableArray alloc] init];
    }
    
    //PFUser *currentUser=[PFUser currentUser];//抓到目前user的objId
    //PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    //query為指向sc類別
    //[query whereKey:@"user" equalTo:currentUser];
    //類別為sc且key為user時value為currentUser
    //userSchedules = [query findObjects];//抓出資料有兩筆
    //NSDictionary *userSchedulesA=userSchedules[0];//cheatMode
    //NSDictionary *userSchedulesB=userSchedules[1];
    //每一筆為NSDictionary
    //id: sA0fZxmosj
    PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    
    postWallArray = [NSArray new];
    postWallArray = [query findObjects];
    
    postWallDictionary = [NSDictionary new];

    
    

    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/M/d HH:mm:ss"];
    //NSLog(@"設定時間為: %@",[format stringFromDate:sender.date]);
    
    scTime = [format stringFromDate:[NSDate date]];
    // Convert date to string
    
    
    //scTime=[format stringFromDate:sender.date];
<<<<<<< HEAD
    //[self.tableView reloadData];
=======
    [self.tableView reloadData];
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)timeValueChanged:(UIDatePicker *)sender {
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/M/d HH:mm:ss"];
    //NSLog(@"設定時間為: %@",[format stringFromDate:sender.date]);
    
    scTime = [format stringFromDate:[NSDate date]];
    // Convert date to string
    
    
    //scTime=[format stringFromDate:sender.date];
    
}
*/
/*
- (IBAction)comfirmBtnPreesed:(id)sender {
    
    //此為新增上去
    if ([PFUser currentUser]) {
        PFObject *userName = [PFObject objectWithClassName:@"schedule"];
        userName[@"scheduleTime"] =scTime;
        userName[@"scheduleName"] =_scheduleName.text;
        userName[@"scheduleLocation"]=@"";
        userName[@"scheduleDetail"]=_scheduleDetail.text;
        userName[@"cheatMode"] = @NO;
        //        PFRelation * relation = [[PFRelation alloc] init];
        //        [relation addObject:[PFUser currentUser]];
        userName[@"user"] = [PFUser currentUser];//連結現在登入的使用者id
        [userName saveInBackground];
        NSLog(@"WTF dealloc.");
    }
    
    
    
}
*/
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