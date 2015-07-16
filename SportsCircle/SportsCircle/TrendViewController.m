//
//  TrendViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/15.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "TrendViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TrendViewController ()
@property (weak, nonatomic) IBOutlet UIView *theListView;
@property (strong, nonatomic) IBOutlet UIView *theTrendView;

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *list=[[UIBarButtonItem alloc]initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector (barListBtnPressed:)];
    //創造一個UIBBtn.選擇plain的style(另一個也長一樣).selector為把某個方法包裝成一個變數.:為名稱的一部分必加
    
    self.navigationItem.leftBarButtonItem=list;
    
    //手勢操作
    UISwipeGestureRecognizer *toRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toRight)];
    toRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_theTrendView addGestureRecognizer:toRight];
    
    UISwipeGestureRecognizer *toLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toLeft)];
    toLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_theTrendView addGestureRecognizer:toLeft];
    
    //允許ImageView接受使用者互動
    _theTrendView.userInteractionEnabled = YES;
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //返回到grayViewControllor的按鈕名稱改為中文～返回～

    _theListView.hidden=YES;
    
    
    
}

-(IBAction) barListBtnPressed:(id)sender{
    //按下listBtn時
    
    CATransition *transition=[CATransition animation];
    //catransition為Q的一個物件
    transition.duration=1.0;
    //動畫時間長度
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //動畫效果為進出緩慢中間快速
    transition.type=kCATransitionPush;
    //動畫效果為
    if (_theListView.isHidden) {
        _theListView.hidden=NO;
        transition.subtype=kCATransitionFromLeft;
    }else{
        _theListView.hidden=YES;
        transition.subtype=kCATransitionFromRight;
    }//subtype為動畫方向
    [_theListView.layer addAnimation:transition forKey:nil];
    //layer為比UIView更低階的uiview元件.可研究CAlayer
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backTotrendView:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to trendView");
}

-(void) toRight{
    if (_theListView.isHidden) {
        [self barListBtnPressed:nil];
    }
}
-(void) toLeft{
    if (!_theListView.isHidden) {
        [self barListBtnPressed:nil];
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
