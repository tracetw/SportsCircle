//
//  DetailImageViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/10.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "DetailImageViewController.h"
#import <Parse/Parse.h>
@interface DetailImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailImageViewController
@synthesize param;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int value = [param intValue];
    
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" equalTo:currentUser];
    NSArray *usersPostsArray = [query findObjects];
    //totalPictureNumber = usersPostsArray.count;
    
    PFFile *userImageFile = usersPostsArray[value][@"image1"];
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
