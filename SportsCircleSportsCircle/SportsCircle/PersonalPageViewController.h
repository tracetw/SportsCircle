//
//  PersonalPageViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalPageViewController : UIViewController
{
    NSString *usernameStr;
}
-(void)passData:(NSString*)argu;
@property (strong, nonatomic) NSString *cellUserName;
@end
