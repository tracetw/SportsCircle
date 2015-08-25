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
#import "SearchViewController.h"
#import "EditProfileTableViewController.h"
#import "endRecordingTableViewController.h"


@interface PersonalPageViewController ()
{
    NSArray *postWallArray;
    PFImageView *userImage;
    PFImageView *imageView;
    PFObject *postWallObject;
    UIRefreshControl *refreshControl;
    PFUser *currentUser;
    PFQuery *query;
    NSString *selectUserObjectId;
    PersonalPageTableViewCell *cell;
    NSString *selectObjectId;
}
@property (strong, nonatomic) IBOutlet UITableView *personalPageTableView;
@end

@implementation PersonalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentUser = [PFUser currentUser];
    
    if ([usernameStr isEqualToString: currentUser.username] || usernameStr == nil) {
        
        query = [PFQuery queryWithClassName:@"WallPost"];
        [query whereKey:@"user" equalTo:currentUser];
        [query addDescendingOrder:@"createdAt"];
        
        postWallArray = [NSArray new];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *postWall, NSError *error){
            postWallArray = postWall;
            [_personalPageTableView reloadData];
        }];
    }else {
        
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:usernameStr];
        NSArray *userNameEqlUsernameStr = [userQuery findObjects];
        PFObject *usernameStrObject = userNameEqlUsernameStr[0];
        query = [PFQuery queryWithClassName:@"WallPost"];
        [query whereKey:@"user" equalTo:usernameStrObject];
        
        postWallArray = [NSArray new];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *postWall, NSError *error){
            postWallArray = postWall;
            [_personalPageTableView reloadData];
        }];
        
        
    }
    
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

     NSLog(@"edit id= %@",usernameStr);
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return postWallArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    
    
    postWallObject = postWallArray[indexPath.row];
    // placeholder image
    
    
    imageView.image = [UIImage imageNamed:@"camera"];
    
    imageView.file = (PFFile *)postWallObject[@"image1"]; // remote image
    
    [imageView loadInBackground:^(UIImage *image,NSError *error){
        cell.postImage.image = imageView.image;
    }];
    
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
    cell.userImage.image = userImage.image;
    [userImage loadInBackground:^(UIImage *image,  NSError * error){
        cell.userImage.image = userImage.image;
    }];

    
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *postTime = postWallObject.createdAt;
    NSString *strDate = [dateFormatter stringFromDate:postTime];
    cell.timeLabel.text = strDate;
    
    //=-----------------------
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    postWallObject = postWallArray[indexPath.row];
    selectObjectId = postWallObject.objectId;
    //    endRecordingTableViewController *detailPostView = [self.storyboard instantiateViewControllerWithIdentifier:@"endRecordingView"];
    //    [self.navigationController showViewController:detailPostView sender:nil];
    [self performSegueWithIdentifier:@"goDetailView" sender:nil];
    
}

-(void) reloadDatas{
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *postWall, NSError *error){
        postWallArray = postWall;
        [_personalPageTableView reloadData];
        [refreshControl endRefreshing];

    }];
    
   
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goEditProfileTableViewController"])
    {
        EditProfileTableViewController *controller = (EditProfileTableViewController *)[segue destinationViewController];
        [controller passValue:usernameStr passSelectUserObjectId:selectUserObjectId];
    }else if ([[segue identifier] isEqualToString:@"goDetailView"]){
        endRecordingTableViewController *detailView = (endRecordingTableViewController *)[segue destinationViewController];
        [detailView getObjectID:selectObjectId];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passData:(NSString*)argu;
{
    usernameStr=argu;

    [self getSelectUserObjectId];
}

//-(void)getSelectUserObjectId{
//    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
//    if (!usernameStr) {
//        usernameStr = currentUser[@"username"];
//    }
//    [userQuery whereKey:@"username" equalTo:usernameStr];
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
//        PFObject *selectUser = comments[0];
//        selectUserObjectId = selectUser.objectId;
//    }];
//
//    [self initFriendsList];
//}

- (void)getSelectUserObjectId{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    if (!usernameStr) {
        usernameStr = currentUser[@"username"];
    }
    [userQuery whereKey:@"username" equalTo:usernameStr];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"The getFirstObject request failed.");
            selectUserObjectId = object.objectId;
            [self initFriendsList];
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
        }
    }];
}

//初始化好友列表
- (void) initFriendsList{
    PFQuery *newQuery = [PFQuery queryWithClassName:@"Friends"];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
    [newQuery whereKey:@"user" equalTo:pfObject];
    [newQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0) {
                PFObject *initFriends = [PFObject objectWithClassName:@"Friends"];
                
                NSArray *tempArray = [NSArray new];
                initFriends[@"Friends"] = tempArray;
                initFriends[@"unFriends"] = tempArray;
                initFriends[@"user"] = pfObject;
                [initFriends saveInBackground];
            }else{
                return;
            }
            
        } else {
            return;
        }
    }];
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
