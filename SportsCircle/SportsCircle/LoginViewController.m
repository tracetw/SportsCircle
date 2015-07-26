//
//  LoginViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/7/26.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;    /**< 帳號 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;    /**< 密碼 */
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
