//
//  SignUpViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/14.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//
#define EngNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" //可以輸入英文數字
#import "SignUpViewController.h"
#import <Parse/Parse.h>
@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;    /**< 帳號 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;    /**< 密碼 */
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self settingTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButtonPressed:(id)sender {  //註冊
    PFUser *user = [PFUser user];
    user.username = _userTextField.text;    //加一些字串限制的判斷
    user.password = _passwordTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [self performSegueWithIdentifier:@"SignupSuccesful" sender:sender];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            if ([errorString isEqualToString:@"missing username"]) {
                errorString = @"請輸入使用者名稱";
            }else if ([errorString isEqualToString:[NSString stringWithFormat:@"username %@ already taken",_userTextField.text]]){
                errorString = [NSString stringWithFormat:@"%@ 已被註冊，請選擇其他的使用者名稱",_userTextField.text];
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊失敗" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
}

-(void)settingTextField{
    _userTextField.placeholder = @"username";   //欄位內容提示
    _passwordTextField.placeholder = @"password";
    
    _userTextField.clearButtonMode = UITextFieldViewModeAlways; //顯示叉號
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    _passwordTextField.secureTextEntry = YES;   //密碼顯示星號
    
    _userTextField.returnKeyType = UIReturnKeyNext; //設成Next按鈕
    _passwordTextField.returnKeyType = UIReturnKeySend; //設成Return按鈕
    
    //    _userTextField.keyboardAppearance = UIKeyboardAppearanceAlert;  //設定鍵盤樣式
    //    _passwordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    _userTextField.keyboardType = UIKeyboardTypeASCIICapable;   //設置鍵盤的類型
    
    _userTextField.delegate = self; //Delegate
    _passwordTextField.delegate = self;
    
}

// 按下Return後會反應的事件  //收鍵盤
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_userTextField resignFirstResponder];   //收鍵盤
    [_passwordTextField resignFirstResponder];
    return YES;
}



//限制只能輸入特定的字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *setCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:EngNum]invertedSet];
    
    NSString *filteredWords = [[string componentsSeparatedByCharactersInSet:setCharacterSet]componentsJoinedByString:@""]; //分離出數組,數組依@""分離出字符串
    
    BOOL canChange = [string isEqualToString:filteredWords];
    
    return canChange;
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
