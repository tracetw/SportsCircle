//
//  TrendTableViewCell.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "TrendTableViewCell.h"
#import "PersonalPageViewController.h"
@implementation TrendTableViewCell

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
