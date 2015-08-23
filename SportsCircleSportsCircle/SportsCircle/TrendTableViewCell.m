//
//  TrendTableViewCell.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "TrendTableViewCell.h"
#import "PersonalPageViewController.h"
#import <Parse/Parse.h>
@implementation TrendTableViewCell
@synthesize cellObjectId;

- (IBAction)GoodBtnPressed:(id)sender {
    PFUser *currentUser=[PFUser currentUser];
    NSString *currentUserObjectId = currentUser.objectId;
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    [query getObjectInBackgroundWithId:cellObjectId block:^(PFObject *object, NSError *error) {
        if (!error) {
            NSMutableArray *tmpArray = [NSMutableArray new];
            tmpArray = object[@"like"];
            if (tmpArray.count == 0) {
                [self setLikesButtonNumber:0 likesButton:sender];
                NSMutableArray *tmpArray = [NSMutableArray new];
                [tmpArray addObject:currentUserObjectId];
                object[@"like"] = tmpArray;
                [object saveInBackground];
                
            }else{
                BOOL didRepeat = false;
                for (NSString *tmpString in tmpArray)
                {
                    if ([tmpString isEqualToString:currentUser.objectId]) {
                        didRepeat = true;
                        break;
                    }
                }
                if (!didRepeat) {
                    int number = (int)tmpArray.count;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setLikesButtonNumber:number likesButton:sender];
                    });
                    [tmpArray addObject:currentUserObjectId];
                    object[@"like"] = tmpArray;
                    [object saveInBackground];
                }
            }
        }else if (error){
            NSLog(@"error: %@",error);
        }
    }];
    NSLog(@"getCellObjectId: %@",cellObjectId);
}

- (void) setLikesButtonNumber:(int)number likesButton:(UIButton *)sender{
    NSString *str = [NSString stringWithFormat:@"%d👍🏻",number +1];
    [sender setTitle:str forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goPersonalPageFromTrend"])
    {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
       // TrendTableViewCell * cell =(TrendTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        PersonalPageViewController *controller = (PersonalPageViewController *)[segue destinationViewController];
       // NSLog(@"cell.userName.text:%@",cell.userName.text);
        [controller passData:self.userName.text];
        
    }
}
@end
