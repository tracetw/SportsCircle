//
//  DetailImageViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/10.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "DetailImageViewController.h"
#import <Parse/Parse.h>

@interface DetailImageViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate>{
    int targetIndex;    /**< 第幾張照片 */
    NSInteger totalclothingNumber;    /**< 裝備照片總數 */
    NSArray *usersPostsArray;   /**< 使用者PO的文章 */
    UIPageControl *pageControl; /**< 頁面控制小工具 */
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@end

@implementation DetailImageViewController
@synthesize param;
@synthesize param2;
@synthesize selectUserObjectId;

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

- (void)showPageControl{

    //頁面控制小工具
    //它會在底部繪製小圓點標誌當前顯示頁面
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 550,self.view.frame.size.width, 20)];
    //設置顏色
    UIColor *hex5e6285 = [UIColor colorWithRed:94.0/255.0 green:98.0/255.0 blue:113.0/255.0 alpha:1];
    UIColor *hexe85d6b = [UIColor colorWithRed:232.0/255.0 green:93.0/255.0 blue:107.0/255.0 alpha:1];
    pageControl.pageIndicatorTintColor = hex5e6285;
    pageControl.currentPageIndicatorTintColor = hexe85d6b;
    //設置頁面的數量
    [pageControl setNumberOfPages:5];
    //監聽頁面是否發生改變
    //[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [self.view addSubview:_theScrollView];
    //pageControl.currentPage = 2;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[pageControl setCurrentPage:fabs(scrollView.contentOffset.x/self.view.frame.size.width)];
    //pageControl.currentPage = 1; //pagecontroll響應值的變化
    NSLog(@"x軸座標%f",scrollView.contentOffset.x);
    NSLog(@"y軸座標%f",scrollView.contentOffset.y);
    NSLog(@"顯示下一頁");
}

-(void) toLeft{
    NSLog(@"toLfet is action");
    //動畫
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_imageView.layer addAnimation:transition forKey:nil];

    NSInteger index = (param) ? usersPostsArray.count-1 : totalclothingNumber-1;
    if (targetIndex == index) {
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
    NSInteger index = (param) ? usersPostsArray.count : totalclothingNumber;
    if (targetIndex == 0) {
        targetIndex = (unsigned)index;
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
    
    
    if (param) {

    
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    //PFUser *currentUser = [PFUser currentUser];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
    [query whereKey:@"user" equalTo:pfObject];
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
    
    
    }else if(param2){
        
        PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
        //PFUser *currentUser = [PFUser currentUser];
        PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
        [query whereKey:@"user" equalTo:pfObject];
        usersPostsArray = [query findObjects];
        //totalPictureNumber = usersPostsArray.count;
        
        
        //抓到所有的裝備照片物件
        NSMutableArray *tempImageArray = [NSMutableArray new];
        for (int j = 0; j < usersPostsArray.count; j++) {
            for (int i = 2; i < 6; i++) {
                
                NSLog(@"%lu",(unsigned long)usersPostsArray.count);
                NSString *tempString = [NSString stringWithFormat:@"image%d",i];
                PFObject *tempObject = usersPostsArray[j][tempString];
                if (tempObject == nil) {
                    continue;
                }
                [tempImageArray addObject: tempObject];
            }
        }
        totalclothingNumber = tempImageArray.count;
        PFFile *userImageFile = tempImageArray[targetIndex];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.imageView.image = image;
            }else{
                NSLog(@"GG%@",error);
            }
        }];

        
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (param) {
        targetIndex = [param intValue];
    }else if (param2){
        targetIndex = [param2 intValue];
        totalclothingNumber = [param2 intValue];
    }
    
    NSLog(@"GG%d",targetIndex);
    [self configureView];
    [self showPageControl];
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
