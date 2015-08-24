//
//  RecordingViewController.h
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/3.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordingViewController : UIViewController
{
    NSTimer *counter;
}

-(void) getSportType:(NSString *)sportType;
-(void) getMainImage:(UIImage*)mainImage;
@end
