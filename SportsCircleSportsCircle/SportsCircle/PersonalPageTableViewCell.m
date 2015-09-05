//
//  PersonalPageTableViewCell.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PersonalPageTableViewCell.h"


@implementation PersonalPageTableViewCell
- (IBAction)reprotBtnPressd:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"檢舉" message:@"是否檢舉此貼文為不當貼文" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            NSString *to = @"vito5314@hotmail.com";
        //            NSString *subject = cellObjectId;
        //            NSString *cc = @"vito5314@yahoo.com.tw";
        //            NSString *bcc = @"vito5314@hotmail.com";
        //            NSString *mailStr=[NSString stringWithFormat:@"mailto://%@?subject=%@&cc=%@&bcc=%@",to,subject,cc,bcc];
        //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mailStr]];
        
        NSString *URLEMail=[NSString stringWithFormat: @"mailto:vito5314@hotmail.com?subject=檢舉&body=檢舉編號:%@(請勿更改) \n檢舉原因:&cc=charlesstw@hotmail.com",_cellObjectId];
        
        NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    self.block(alertController);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
