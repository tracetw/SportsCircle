//
//  ImageCollectionViewCell.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/10.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "CustomCellBackgroundView.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        CustomCellBackgroundView *backgroundView = [[CustomCellBackgroundView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}


@end
