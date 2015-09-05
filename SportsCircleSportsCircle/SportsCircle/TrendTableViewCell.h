//
//  TrendTableViewCell.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalPageViewController.h"
#import "myPostImageView.h"
typedef void(^presentAlertView)(UIAlertController *);

@interface TrendTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *cellObjectId;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet myPostImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (nonatomic,strong) presentAlertView block;




@end
