//
//  DetailImageViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/10.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "DetailImageViewController.h"
#import <Parse/Parse.h>

@interface DetailImageViewController ()<UIScrollViewDelegate>{
    int targetIndex;
    NSArray *usersPostsArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@end

@implementation DetailImageViewController
@synthesize param;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //關閉ScrollView自動調整，讓照片不要放太下面
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //手勢左右滑動
    UISwipeGestureRecognizer *toLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toLeft)];
    toLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_imageView addGestureRecognizer:toLeft];
    
    
    UISwipeGestureRecognizer *toRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toRight)];
    toRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_imageView addGestureRecognizer:toRight];
    //允許ImageView接受使用者互動
    _imageView.userInteractionEnabled = YES;
    
    
    

}


-(void) toLeft{
    NSLog(@"toLfet is action");
    //動畫
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [_imageView.layer addAnimation:transition forKey:nil];
    
    if (targetIndex == usersPostsArray.count-1) {
        targetIndex = 0;
    }else{
        targetIndex++;
    }
    [self configureView];
}

-(void) toRight{
    
    
    //動畫
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_imageView.layer addAnimation:transition forKey:nil];
    
    if (targetIndex == 0) {
        targetIndex = (unsigned)usersPostsArray.count;
    }
    targetIndex--;
    
    [self configureView];
    
}
//縮放
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)configureView {
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _theScrollView.delegate = self;
    _theScrollView.contentSize = _imageView.image.size;
    _theScrollView.maximumZoomScale = 3.0;
    _theScrollView.minimumZoomScale = 1.0;
    _theScrollView.zoomScale = 1.0;
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" equalTo:currentUser];
    usersPostsArray = [query findObjects];
    //totalPictureNumber = usersPostsArray.count;
    
    PFFile *userImageFile = usersPostsArray[targetIndex][@"image1"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
            
        }else{
            NSLog(@"GG%@",error);
        }
    }];
    
    //self.imageView.image = self.image;
    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    targetIndex = [param intValue];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
