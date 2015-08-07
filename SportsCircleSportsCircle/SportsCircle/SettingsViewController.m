//
//  SettingsViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface SettingsViewController ()<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *fbUserNameLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLogoutButtonView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fbLogoutButtonView.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [FBSDKAccessToken currentAccessToken];
    

    


    
    //圓角頭像
    _fbProfilePictureView.layer.cornerRadius = _fbProfilePictureView.frame.size.width/2.0;
    _fbProfilePictureView.layer.masksToBounds = YES;
    
    


    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSString *title = [NSString stringWithFormat:@" %@", [FBSDKProfile currentProfile].name];
        NSLog(@"%@",[FBSDKProfile currentProfile].userID);
        self.fbUserNameLabel.text = title;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark FBloginViewDelegate
//登入FB後執行的方法
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    //登出
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"未登出%@",currentUser);
    if (currentUser) {
        [PFUser logOut];    //登出
        NSLog(@"已登出%@",currentUser);
        [self performSegueWithIdentifier:@"LogoutSuccesful" sender:nil];
    } else {
        // show the signup or login screen
    }
    
}



//FB按鈕點擊時登出所要執行的方法
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    //登出
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"未登出%@",currentUser);
    if (currentUser) {
        [PFUser logOut];    //登出
        NSLog(@"已登出%@",currentUser);
        [self performSegueWithIdentifier:@"LogoutSuccesful" sender:nil];
    } else {
        // show the signup or login screen
    }
    
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
