//
//  FriendsTableViewCell.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/11.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "FriendTableViewController.h"
#import <Parse/Parse.h>

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)confirmBtnPressed:(id)sender {
    if ([_addDelFriends.currentTitle isEqual:@"Add"]) {
        NSLog(@"11111");
        NSString *message = [NSString stringWithFormat:@"add %@ as friend?",_userName.text];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"123");
            
            
            PFQuery *fQuery = [PFQuery queryWithClassName:@"Friends"];
            [fQuery getObjectInBackgroundWithId:_currentUserFriendClassObjectId block:^(PFObject *frinendConfirm, NSError *error) {
                
                [frinendConfirm addUniqueObjectsFromArray:@[_friendObjectId] forKey:@"Friends"];
                [frinendConfirm saveInBackground];
                [frinendConfirm removeObjectsInArray:@[_friendObjectId] forKey:@"unFriends"];
                [frinendConfirm saveInBackground];
                
                
                
            }];
            
            
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        self.block(alertController);
        
        
    }else if([_addDelFriends.currentTitle isEqual:@"Delete"]){
        NSLog(@"22222");
        NSString *message2 = [NSString stringWithFormat:@"unfriend with %@?",_userName.text];
        UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"Confirm" message:message2 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"3333");
            
            PFQuery *fQuery = [PFQuery queryWithClassName:@"Friends"];
            [fQuery getObjectInBackgroundWithId:_currentUserFriendClassObjectId block:^(PFObject *delFrinendConfirm, NSError *error) {
                
                [delFrinendConfirm removeObjectsInArray:@[_friendObjectId] forKey:@"Friends"];
                [delFrinendConfirm saveInBackground];
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
