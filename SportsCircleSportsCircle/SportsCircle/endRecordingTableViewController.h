//
//  endRecordingTableViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/13.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface endRecordingTableViewController : UITableViewController

@property (strong, nonatomic) UIImage *snapshotImage;
@property (strong, nonatomic) NSNumber *speed;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *countTime;

@property (strong,nonatomic)  NSString *sendInObjectID;
@property (strong,nonatomic)  NSString *comingView;
@property (strong,nonatomic) NSString *calory;

-(void)getObjectID:(NSString*)objectID;

@end
