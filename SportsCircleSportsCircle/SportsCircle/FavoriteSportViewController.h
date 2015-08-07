//
//  FavoriteSportViewController.h
//  SportsCircle
//
//  Created by  tracetw on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendBOOLBack)(BOOL tempDidUpdateSportItem);
@interface FavoriteSportViewController : UIViewController
@property (nonatomic,strong) SendBOOLBack block;
@end
