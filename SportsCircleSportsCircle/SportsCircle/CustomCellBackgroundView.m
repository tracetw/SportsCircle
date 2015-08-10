//
//  CustomCellBackgroundView.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/10.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "CustomCellBackgroundView.h"

@implementation CustomCellBackgroundView

//點擊collectionView產生的效果
- (void)drawRect:(CGRect)rect{
    //邊緣圓角，藍色底圖
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    bezierPath.lineWidth = 5.0f;
    [[UIColor blackColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1]; // color equivalent is #87ceeb
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
