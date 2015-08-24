//
//  PrivacyFromRegisterViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/23.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PrivacyFromRegisterViewController.h"

@interface PrivacyFromRegisterViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *privacyWebView;

@end

@implementation PrivacyFromRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [_privacyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://goo.gl/kAAjcN"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
