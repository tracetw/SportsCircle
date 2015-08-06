//
//  ViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/7/8.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "ViewController.h"
#import "SignUpViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
//asdasdfs
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToLogin:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to login");
}

@end
