//
//  PostMainViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/7/28.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopView.h"
#import "PopView2.h"
#import "PopView3.h"
#import "PopView4.h"

@interface PostMainViewController : UIViewController<UIPopoverControllerDelegate>
{
    PopView *popView;
    PopView2 *popView2;
    PopView3 *popView3;
    PopView4 *popView4;
}
@property (nonatomic,strong) NSString* infoString;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@end
