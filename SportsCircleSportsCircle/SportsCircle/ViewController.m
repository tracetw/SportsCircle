//
//  ViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/7/8.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//dd

#import "ViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>
@interface ViewController (){
    	NSThread *backgroundThread;
    UIImage *image;
    NSArray *usersPostsArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    backgroundThread=[[NSThread alloc] initWithTarget:self selector:@selector(doThreadJob)
                                               object:nil];
    
    [backgroundThread start];
}

- (void) doThreadJob {
    //NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    usersPostsArray = [NSArray new];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    [query whereKey:@"user" equalTo:currentUser];
    usersPostsArray = [query findObjects];
    
    PFFile *userImageFile = usersPostsArray[0][@"image1"];
    
    
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            image = [UIImage imageWithData:imageData];
            

    
    
    //多執行緒
    @autoreleasepool {
        
        while(YES)
        {
            [self performSelectorOnMainThread:@selector(changeLabelColor) withObject:nil waitUntilDone:NO];//是否等待主執行緒完成再執行背景執行緒
            //睡0.1秒
            //[NSThread sleepForTimeInterval:0.1];
        }
    }
    
        }else{
            NSLog(@"ggggggg%@",error);
        }
    }];
}

- (void) changeLabelColor {
    
_ImageView.image = image;
    NSLog(@"HIHIHI");

}

//asdasdfs
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToLogin:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to login");
}

@end
