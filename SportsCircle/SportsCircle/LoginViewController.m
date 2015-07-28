//
//  LoginViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/7/26.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//
#define NUMBERS @"0123456789n"  //可以輸入數字和換行
#define EngNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" //可以輸入英文數字
#import "LoginViewController.h"
#import <Parse/Parse.h>
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;    /**< 帳號 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;    /**< 密碼 */
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingTextField];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonPressed:(id)sender { //登入
    [PFUser logInWithUsernameInBackground:_userTextField.text password:_passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:@"LoginSuccesful" sender:sender];
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            if ([errorString isEqualToString:@"invalid login parameters"]) {
                                                errorString = @"無效的帳號密碼";
                                            }
                                            // The login failed. Check error to see why.
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登入失敗" message:errorString preferredStyle:UIAlertControllerStyleAlert];
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
    
//    //TextField值改變時發出通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textDidChange)
//                                                 name: UITextFieldTextDidChangeNotification
//                                               object:self.userTextField];
}

// 按下Return後會反應的事件  //收鍵盤
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_userTextField resignFirstResponder];   //收鍵盤
    [_passwordTextField resignFirstResponder];
    return YES;
}


-(void)textDidChange{
    NSLog(@"GG");
}

//限制只能輸入特定的字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *setCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:EngNum]invertedSet];
    
    NSString *filteredWords = [[string componentsSeparatedByCharactersInSet:setCharacterSet]componentsJoinedByString:@""]; //分離出數組,數組依@""分離出字符串
    
    BOOL canChange = [string isEqualToString:filteredWords];
    
    return canChange;
}



//UITextFieldTextDidEndEditingNotification
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
