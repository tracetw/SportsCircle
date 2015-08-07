//
//  TrendTableViewCell.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@end
