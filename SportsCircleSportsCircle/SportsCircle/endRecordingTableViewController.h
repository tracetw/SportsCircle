//
//  endRecordingTableViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/13.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface endRecordingTableViewController : UITableViewController

@property (weak, nonatomic) UIImage *snapshotImage;
@property (weak, nonatomic) NSNumber *speed;
@property (weak, nonatomic) NSNumber *distance;
@property (weak, nonatomic) NSString *countTime;



-(void)getObjectID:(NSString*)objectID;

@end
