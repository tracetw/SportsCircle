//
//  searchDetailViewController.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchDetailViewController : UIViewController
@property(strong,nonatomic)NSString *detailContents;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
