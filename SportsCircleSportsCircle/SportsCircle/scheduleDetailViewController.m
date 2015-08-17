//
//  scheduleDetailViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/31.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "scheduleDetailViewController.h"
#import <Parse/Parse.h>
#import "scheduleTableViewController.h"

@interface scheduleDetailViewController ()
{
    NSString *scTime;
}
@property (weak, nonatomic) IBOutlet UITextField *scheduleName;
@property (weak, nonatomic) IBOutlet UITextView *scheduleDetail;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation scheduleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"M/d HH:mm"];
    //NSLog(@"設定時間為: %@",[format stringFromDate:sender.date]);
    
    scTime = [format stringFromDate:[NSDate date]];
    // Convert date to string
    [_datePicker setDate:[NSDate date]];
    
    //添加背景點擊事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardResign)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
}

//點擊空白處收起鍵盤
- (void)keyboardResign {
    [self.view endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[self.view viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeValueChanged:(UIDatePicker *)sender {
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    
    [format setDateFormat:@"M/d HH:mm"];
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
        userName[@"scheduleLocation"]=_locationLabel.text;
        userName[@"scheduleDetail"]=_scheduleDetail.text;
        userName[@"cheatMode"] = @NO;
        //        PFRelation * relation = [[PFRelation alloc] init];
        //        [relation addObject:[PFUser currentUser]];
        userName[@"user"] = [PFUser currentUser];//連結現在登入的使用者id
        [userName saveInBackground];
        NSLog(@"WTF dealloc.");
    }
    
    //[scheduleTableViewController viewDidLoad];
    
}

-(void) dealloc{
    //解構式～確認回上一頁.原本的黃色那頁已被消滅(線不能直接拉回去.因為RAM會一直疊加上去)
    NSLog(@"scheduleDetailViewController dealloc.");
}
- (IBAction)locationBtnPressed:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"行程地點" message:@"請輸入地點" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //[self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *locationStr=((UITextField*)[alert.textFields objectAtIndex:0]).text;
        _locationLabel.text=locationStr;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
       textField.placeholder=@"ex:大安森林公園";
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
