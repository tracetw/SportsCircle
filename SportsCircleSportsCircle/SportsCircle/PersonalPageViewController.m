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


@interface PersonalPageViewController ()
{
    NSDictionary *postWallDictionary;
    NSArray *postWallArray;
}
@end

@implementation PersonalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    [query whereKey:@"user" equalTo:currentUser];
    
    postWallArray = [NSArray new];
    postWallArray = [query findObjects];
    postWallDictionary = [NSDictionary new];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return postWallArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    
    
    postWallDictionary = postWallArray[indexPath.row];
    //NSLog(@"%@",[postWallDictionary objectForKey:@"content"]);
    cell.contentLabel.text = [postWallDictionary objectForKey:@"content"];
    NSLog(@"%@",postWallDictionary);
    NSString *sportType = [postWallDictionary objectForKey:@"sportsType"];
    cell.sportTypeImage.image = [UIImage imageNamed:sportType];
    
    PFFile *image = [postWallDictionary objectForKey:@"image1"];
    NSData *imageData = [image getData];
    cell.postImage.image = [UIImage imageWithData:imageData];
    
    //PFFile *userImage= [postWall objectForKey:@"image"];
    //cell.profileImage.image = [UIImage imageWithData:[profifeImg getData]];
    
    
    PFObject *user = [postWallDictionary objectForKey:@"user"];
    
    [user fetch];
    
    NSString *username = user[@"username"];
    
    [cell.userNameBtn setTitle:username forState:UIControlStateNormal];
    
    PFFile *userImageData = user[@"userImage"];
    NSData *userImage = [userImageData getData];
    cell.userImage.image = [UIImage imageWithData:userImage];
    
    
    
    PFObject *postWallObject = postWallArray[indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *postTime = postWallObject.createdAt;
    NSString *strDate = [dateFormatter stringFromDate:postTime];
    cell.timeLabel.text = strDate;
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *detailPostView = [UIViewController new];
    [self.navigationController showViewController:detailPostView sender:nil];
    
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
