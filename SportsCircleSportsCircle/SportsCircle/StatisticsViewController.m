//
//  StatisticsViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/9/8.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *StatisticsWebView;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [_StatisticsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.196.115:8888/example/graph.php"]]];
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
