//
//  FriendsTableViewCell.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/11.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
typedef void(^presentAlertView)(UIAlertController *);
typedef void(^reloadData)(void);

@interface FriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *addDelFriends;
@property (nonatomic,strong) presentAlertView block;
@property (nonatomic,strong) reloadData reloadDataBlock;
@property (strong, nonatomic) NSString *friendObjectId;
@property (strong, nonatomic) NSString *currentUserFriendClassObjectId;
@property (strong, nonatomic) PFObject *changeFriendsStatusFObject;
@property (strong, nonatomic) NSString *currentUserObjectId;

@end
