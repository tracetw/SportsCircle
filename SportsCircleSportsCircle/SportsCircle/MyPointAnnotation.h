//
//  MyPointAnnotation.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/21.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyPointAnnotation : MKPointAnnotation//繼承頭真～主要增加title subtitle以外的資訊

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) NSString *content;
@property (nonatomic,assign) NSString *locaiton;
@end
