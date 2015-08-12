//
//  FriendsTableViewCell.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/11.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^presentAlertView)(UIAlertController *);

@interface FriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *addDelFriends;
@property (nonatomic,strong) presentAlertView block;
@property (weak, nonatomic) NSString *friendObjectId;
@property (weak, nonatomic) NSString *currentUserFriendClassObjectId;
@end
