//
//  searchLocationViewController.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/17.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendStringBack)(NSString*string,NSString*string2,NSString*string3,NSString *userLat,NSString *userLon);
@interface searchLocationViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) SendStringBack block;
@end