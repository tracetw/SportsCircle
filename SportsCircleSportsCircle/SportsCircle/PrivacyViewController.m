//
//  PrivacyViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/21.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *privacyWebView;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_privacyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
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
