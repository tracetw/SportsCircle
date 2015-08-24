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

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface SignUpViewController ()<UITextFieldDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;    /**< 帳號 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;    /**< 密碼 */
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //顯示使用者名稱
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateProfile:)
     name:FBSDKProfileDidChangeNotification
     object:nil];
    
    [self settingTextField];
    
    //添加背景點擊事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardResign)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
}

//點擊空白處收起鍵盤
- (void)keyboardResign {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //如果parse 是登入狀態
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"未登出%@",currentUser);
        [self performSegueWithIdentifier:@"SignUpSuccesful" sender:nil];
    } else {
        NSLog(@"已登出%@",currentUser);
    //如果FB是登入的狀態所要執行的方法
    if ([FBSDKAccessToken currentAccessToken] && [FBSDKProfile currentProfile].userID != nil) {
        //登入Parse
        [PFUser logInWithUsernameInBackground:[FBSDKProfile currentProfile].name password:@"sportscircle"
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                NSLog(@"登入成功%@",user.username);
                                                [self performSegueWithIdentifier:@"SignUpSuccesful" sender:nil];
                                            } else {
                                                // The login failed. Check error to see why.
                                                NSLog(@"登入失敗");
                                            }
                                        }];
        
        NSLog(@"FB userID = %@",[FBSDKProfile currentProfile].userID);
        NSLog(@"FB name = %@",[FBSDKProfile currentProfile].name);
        NSLog(@"FB linkURL = %@",[FBSDKProfile currentProfile].linkURL);
        
    }else{
        //回到上一頁
        NSLog(@"回到上一頁");
    }
    }
}

- (void)updateProfile:(NSNotification *)notification {
    //不能刪掉
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
            [self performSegueWithIdentifier:@"SignUpSuccesful" sender:sender];
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

#pragma mark FBloginViewDelegate
//登入FB後執行的方法
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
    //FB登入後更新頭像狀態
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
}
//FB登入按鈕點擊時登出所要執行的方法
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"已登出");
    [self performSegueWithIdentifier:@"LogoutSuccesful" sender:nil];
}

@end
