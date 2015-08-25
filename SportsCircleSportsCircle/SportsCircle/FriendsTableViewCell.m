//
//  FriendsTableViewCell.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/11.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "FriendTableViewController.h"


@implementation FriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _addDelFriends.layer.cornerRadius = 5;

}
- (IBAction)confirmBtnPressed:(id)sender {
    if ([_addDelFriends.currentTitle isEqual:@"加好友"]) {
        //NSLog(@"11111");
        NSString *message = [NSString stringWithFormat:@"加%@為好友?",_userName.text];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友確認" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            PFQuery *fQuery = [PFQuery queryWithClassName:@"Friends"];
            [fQuery getObjectInBackgroundWithId:_currentUserFriendClassObjectId block:^(PFObject *frinendConfirm, NSError *error) {
                
                [frinendConfirm addUniqueObjectsFromArray:@[_friendObjectId] forKey:@"Friends"];
                [frinendConfirm saveInBackground];
                [frinendConfirm removeObjectsInArray:@[_friendObjectId] forKey:@"unFriends"];
                [frinendConfirm saveInBackground];
            }];
            PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friends"];
            NSLog(@"changeID %@",_changeFriendsStatusFObject);
            [friendQuery whereKey:@"user" equalTo:_changeFriendsStatusFObject];
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
        
            PFObject *fObject = arrayFriends[0];//只會找到一筆當前使用者
            
                [fObject addUniqueObjectsFromArray:@[_currentUserObjectId] forKey:@"Friends"];//把自己加到對方好友內
                [fObject saveInBackground];
                [fObject removeObjectsInArray:@[_currentUserObjectId] forKey:@"unFriends"];//把自己從對方unfriend刪除
                [fObject saveInBackground];
                self.reloadDataBlock();
            }];
            
            
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        self.block(alertController);
        
        
    }else if([_addDelFriends.currentTitle isEqual:@"刪除"]){
       // NSLog(@"22222");
        NSString *message2 = [NSString stringWithFormat:@"將%@從好友中刪除?",_userName.text];
        UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"刪除好友" message:message2 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           // NSLog(@"3333");
            
            PFQuery *fQuery = [PFQuery queryWithClassName:@"Friends"];
            [fQuery getObjectInBackgroundWithId:_currentUserFriendClassObjectId block:^(PFObject *delFrinendConfirm, NSError *error) {
                NSLog(@"friendObjectId%@",_friendObjectId);
                [delFrinendConfirm removeObjectsInArray:@[_friendObjectId] forKey:@"Friends"];
                [delFrinendConfirm saveInBackground];
            }];
            
            PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friends"];
             NSLog(@"changeID %@",_changeFriendsStatusFObject);
            [friendQuery whereKey:@"user" equalTo:_changeFriendsStatusFObject];
           
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
                
                PFObject *fObject = arrayFriends[0];//只會找到一筆當前使用者
                NSLog(@"currentObjectId%@",_currentUserObjectId);
                [fObject removeObjectsInArray:@[_currentUserObjectId] forKey:@"Friends"];
                [fObject saveInBackground];
                self.reloadDataBlock();
            }];
           
        }];
        [alertController2 addAction:cancelAction2];
        [alertController2 addAction:okAction2];
        
        self.block(alertController2);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
