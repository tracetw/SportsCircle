//
//  PersonalPageViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "PersonalPageTableViewCell.h"
#import <Parse/Parse.h>
#import "EditProfileTableViewController.h"
#import <ParseUI/ParseUI.h>


@interface PersonalPageViewController ()
{
    NSArray *postWallArray;
    PFImageView *userImage;
    PFImageView *imageView;
    PFObject *postWallObject;
    UIRefreshControl *refreshControl;
    PFUser *currentUser;
    PFQuery *query;
}
@property (strong, nonatomic) IBOutlet UITableView *personalPageTableView;
@end

@implementation PersonalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentUser = [PFUser currentUser];
    query = [PFQuery queryWithClassName:@"WallPost"];
    [query whereKey:@"user" equalTo:currentUser];
    
    postWallArray = [NSArray new];

    [query findObjectsInBackgroundWithBlock:^(NSArray *postWall, NSError *error){
        postWallArray = postWall;
        [_personalPageTableView reloadData];
    }];
    
    userImage =[PFImageView new];
    imageView = [PFImageView new];
    
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_personalPageTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return postWallArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    
    
    postWallObject = postWallArray[indexPath.row];
    // placeholder image
    
    
    imageView.image = [UIImage imageNamed:@"camera"];
    
    imageView.file = (PFFile *)postWallObject[@"image1"]; // remote image
    
    [imageView loadInBackground];
    
    //NSData *imageData = [imageView.file getData];
    cell.postImage.image = imageView.image;//[UIImage imageWithData:imageData];
    
    cell.contentLabel.text = postWallObject[@"content"];
    NSString *sportType = postWallObject[@"sportsType"];
    cell.sportTypeImage.image = [UIImage imageNamed:sportType];
    
    
    //PFFile *userImage= [postWall objectForKey:@"image"];
    //cell.profileImage.image = [UIImage imageWithData:[profifeImg getData]];
    
    
    
    
    //    PFFile *userImageData = user[@"userImage"];
    //    NSData *userImage = [userImageData getData];
    //    cell.userImage.image = [UIImage imageWithData:userImage];
    
    //=--------------------
    PFObject *user = postWallObject[@"user"];
    
    [user fetchInBackground];
    
    NSString *username = user[@"username"];
    
    [cell.userNameBtn setTitle:username forState:UIControlStateNormal];
    
    
    
    userImage.image = [UIImage imageNamed:@"camera"];
    //NSLog(@"user111 %@",user);
    userImage.file = (PFFile *)user[@"userImage"];
    
    [userImage loadInBackground];
    
    cell.userImage.image = userImage.image;
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *postTime = postWallObject.createdAt;
    NSString *strDate = [dateFormatter stringFromDate:postTime];
    cell.timeLabel.text = strDate;
    
    //=-----------------------
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *detailPostView = [UIViewController new];
    [self.navigationController showViewController:detailPostView sender:nil];
    
}

-(void) reloadDatas{
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *postWall, NSError *error){
        postWallArray = postWall;
        [_personalPageTableView reloadData];
        [refreshControl endRefreshing];

    }];
    
   
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
