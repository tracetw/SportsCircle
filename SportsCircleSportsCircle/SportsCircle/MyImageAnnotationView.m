//
//  MyImageAnnotationView.m
//  HelloMap
//
//  Created by Kent Liu on 2015/1/8.
//  Copyright (c) 2015年 Kent Liu. All rights reserved.
//

#import "MyImageAnnotationView.h"

@implementation MyImageAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    UIImage *image = [UIImage imageNamed:@"pointRed.png"];
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    
    [self addSubview:imageView];
    
    return self;
}

@end
