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

@interface scheduleDetailViewController ()<UITextViewDelegate>
{
    NSString *scTime;
    BOOL wasKeyboardDidShow;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //UITextView *myUITextView = [[UITextView alloc] init];
    _scheduleDetail.delegate = self;
    _scheduleDetail.text = @"請輸入行程內容...";
    _scheduleDetail.textColor = [UIColor darkGrayColor]; //optional
    
    
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    
    //scTime = [format stringFromDate:[NSDate date]];
    
    // Convert date to string
    scTime=[format stringFromDate:sender.date];
    
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




#pragma mark keyboard show hide

- (UIView *)findViewThatIsFirstResponder
{
    if (self.view.isFirstResponder) {
        return self.view;
    }
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    
    return nil;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (!wasKeyboardDidShow) {
        NSTimeInterval animationDuration =
        [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = self.view.frame;
        //        frame.origin.y -= 160;
        UIView *respView = [self findViewThatIsFirstResponder];
        if (respView.frame.origin.y + respView.frame.size.height > frame.size.height-255) {
            frame.origin.y -= respView.frame.origin.y + respView.frame.size.height - frame.size.height + 255;
        }
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
        wasKeyboardDidShow = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    wasKeyboardDidShow = NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"請輸入行程內容..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"請輸入行程內容...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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
