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
#import "Reachability.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate, FBSDKLoginButtonDelegate>{
    PFUser *currentUser;    /**< Parse當前帳戶 */
    Reachability *rech;

}
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButtonView;           /**< FB登入按鈕 */
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbProfilePictureView; /**< FB個人頭像 */
@property (weak, nonatomic) IBOutlet UITextField *userTextField;                    /**< 帳號 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;                /**< 密碼 */
@end

@implementation LoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    
    //開啟自動追蹤currentAccessToken
    //[FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    //FBSDKLoginButton *fbLoginButtonView = [FBSDKLoginButton new];
    //FBSDKProfilePictureView *fbProfilePictureView = [FBSDKProfilePictureView new];
    //NSLog(@"NOThing,%@,%@",fbLoginButtonView,fbProfilePictureView);
    
    
    //獲取FB授權
    //self.fbLoginButtonView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    self.fbLoginButtonView.delegate = self;

    //顯示使用者名稱
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateProfile:)
     name:FBSDKProfileDidChangeNotification
     object:nil];
    
    //圓角頭像
    _fbProfilePictureView.layer.cornerRadius = _fbProfilePictureView.frame.size.width/2.0;
    _fbProfilePictureView.layer.masksToBounds = YES;
    
    
    [self settingTextField];
    
}

//------------------------FBCEBOOK-LOGIN------------------------------------------------

- (void)updateProfile:(NSNotification *)notification {
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (!rech) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        rech = [Reachability reachabilityWithHostName:@"www.apple.com"];
        [rech startNotifier];
    }

    
    //如果FB是登入的狀態所要執行的方法
    if ([FBSDKAccessToken currentAccessToken] && [FBSDKProfile currentProfile].userID != nil) {
        //[self performSegueWithIdentifier:@"LoginSuccesful" sender:nil];
        
        NSLog(@"FB userID = %@",[FBSDKProfile currentProfile].userID);
        NSLog(@"FB name = %@",[FBSDKProfile currentProfile].name);
        NSLog(@"FB linkURL = %@",[FBSDKProfile currentProfile].linkURL);
        
        //userID轉長整數資料型態
        NSLog(@"%li ", (long)[[FBSDKProfile currentProfile].userID integerValue]);

        [self ifFindFBuserID];
    }else{
        //[self performSegueWithIdentifier:@"goSignUpSuccesful" sender:@"gogo"];
        NSLog(@"GG");
    }
    
    //添加背景點擊事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardResign)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
}

//點擊空白處收起鍵盤
- (void)keyboardResign {
    [self.view endEditing:YES];
}


#pragma mark FBloginViewDelegate
//登入FB後執行的方法
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{

    if ([FBSDKAccessToken currentAccessToken] && [FBSDKProfile currentProfile].userID != nil){
        [self ifFindFBuserID];
    }else{
    //判斷是否有parse帳號
    [self performSegueWithIdentifier:@"goSignUpSuccesful" sender:nil];

    NSLog(@"FBID:%@",[FBSDKProfile currentProfile].userID);
    }
    
    
}


//FB登入按鈕點擊時登出所要執行的方法
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"已登出");
}


-(void)ifFindFBuserID{
    /*
     if(parse 是登入狀態){
        直接登入
     }else{ //未登入parse
        if (parse user 有找到 fbUserID) {
            直接登入parse的帳號
        }else{  //如果沒找到
            新增一筆使用者
            增加fbUserID
            加入fb name
            一組固定密碼
     
            登入parse的帳號
        }
     }
     */
    
    //如果parse 是登入狀態
    currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"未登出%@",currentUser);
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:nil];
    } else {
        NSLog(@"已登出%@",currentUser);
    
    
    //查詢使用者的特殊方法，如果parse user 有找到 fbUserID
    PFQuery *query = [PFUser query];
    [query whereKey:@"fbUserID" equalTo:[FBSDKProfile currentProfile].userID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {  //沒有找到 fbUserID
            NSLog(@"The getFirstObject request failed.");
            
            //用FB資料建立Parse帳號
            PFUser *user = [PFUser user];
            user.username = [FBSDKProfile currentProfile].name; //fbName註冊ParseName
            user.password = @"sportscircle";    //預設密碼不可不填
            user[@"fbUserID"] = [FBSDKProfile currentProfile].userID;   //fbUserID存到Parse fbUserID欄位
            //註冊
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {   //註冊成功，進入下一頁
                    NSLog(@"Success user = %@",user.username);
                    [self performSegueWithIdentifier:@"LoginSuccesful" sender:nil];
                    
                } else {
//                    NSString *errorString = [error userInfo][@"error"];
//                    NSLog(@"%@",errorString);
                }
            }];
            
            
            
        } else {    //有找到 fbUserID
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            NSLog(@"%@qqqqq", object.objectId);
            if ([FBSDKAccessToken currentAccessToken]) {
                //fbUserID登入Parse
                [self loginParseWithFBUserID];
            }else{
                [self performSegueWithIdentifier:@"goSignUpSuccesful" sender:@"gogo"];
            }
            
        }
    }];
        
        }

}

-(void)loginParseWithFBUserID{
    //登入Parse
    [PFUser logInWithUsernameInBackground:[FBSDKProfile currentProfile].name password:@"sportscircle"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"登入成功%@",user.username);
                                            [self performSegueWithIdentifier:@"LoginSuccesful" sender:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"登入失敗");
                                        }
                                    }];
}
//-------------------------PARSE-LOGIN-------------------------------------------------------

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
    _userTextField.autocorrectionType = UITextAutocorrectionTypeNo; //不自動更正
    
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

-(IBAction)backToLogin:(UIStoryboardSegue *)segue
{
}


- (void) reachabilityChanged:(NSNotification*)note{
    
    NetworkStatus netStatus = [note.object currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"目前沒有網路，請檢查您的網路狀態");
        [self showAlertWithTitle:nil message:@"目前沒有網路，請檢查您的網路狀態"];
        
        
    }else{
        
        currentUser = [PFUser currentUser];
        if (currentUser) {
            NSLog(@"未登出%@",currentUser);
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:nil];
        } else {
            NSLog(@"已登出%@",currentUser);
        }
        
    }
}

-(void) showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentViewController:alert animated:YES completion:nil];
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
