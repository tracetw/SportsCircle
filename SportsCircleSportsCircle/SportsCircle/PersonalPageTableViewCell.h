//
//  PersonalPageTableViewCell.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^presentAlertView)(UIAlertController *);

@interface PersonalPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) NSString *cellObjectId;
@property (nonatomic,strong) presentAlertView block;
@end
