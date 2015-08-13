//
//  FriendTableViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/11.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "FriendTableViewController.h"
#import "FriendsTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PersonalPageViewController.h"


@interface FriendTableViewController ()
{
    NSArray *qfriends;
    NSArray *friends;
    NSArray *unfriends;
    PFImageView *usersImage;
    PFObject *fObject;
    UIRefreshControl *refreshControl;
    PFUser *currentUser;
    PFQuery *query;
    NSString *username;
    
}
@property (strong, nonatomic) IBOutlet UITableView *friendsView;

@end

@implementation FriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    currentUser = [PFUser currentUser];
    //NSLog(@"%@",currentUser);
    query = [PFQuery queryWithClassName:@"Friends"];
    //NSLog(@"%@",query);
    [query whereKey:@"user" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
        
        qfriends = arrayFriends;
        fObject = qfriends[0];
        friends = fObject[@"Friends"];
        
        unfriends = fObject[@"unFriends"];
        
        [_friendsView reloadData];
        
    }];
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
    //usersImage = [PFImageView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0 ) {
        return unfriends.count;
    }else {
        return friends.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.block = ^(UIAlertController *alert){
        [self presentViewController:alert animated:YES completion:nil];
    };
    cell.currentUserFriendClassObjectId = fObject.objectId;
    if (indexPath.section == 0) {
        NSString *unfriendObject = unfriends[indexPath.row];//unfriend的object id
        
        //PFQuery *queryFriend = [PFUser query];
        PFObject *user = [PFQuery getUserObjectWithId:unfriendObject];
        
        cell.friendObjectId = user.objectId;
        
        username = user[@"username"];
        NSLog(@"name %@",username);
        cell.userName.text = username;
        
        PFFile *userImageData = user[@"userImage"];
        NSData *userImage = [userImageData getData];
        cell.userImage.image = [UIImage imageWithData:userImage];
        
        
//        userImage.image = [UIImage imageNamed:@"camera"];
//        
//        userImage.file = (PFFile *)user[@"userImage"];
//        
//        [userImage loadInBackground];
//        
//        cell.userImage.image = userImage.image;
        
        
        [cell.addDelFriends setTitle:@"Add" forState:UIControlStateNormal];
        
        
    }
    else if (indexPath.section == 1){
        NSString *friendObject = friends[indexPath.row];
        PFUser *user = [PFQuery getUserObjectWithId:friendObject];
        username = user[@"username"];
        cell.friendObjectId = user.objectId;
        cell.userName.text = username;
        
//        userImage.image = [UIImage imageNamed:@"camera"];
//        userImage.file = (PFFile *)user[@"userImage"];
//        
//        [userImage loadInBackground];
//        
//        cell.userImage.image = userImage.image;
        PFFile *userImageData = user[@"userImage"];
        NSData *userImage = [userImageData getData];
        cell.userImage.image = [UIImage imageWithData:userImage];
        
        [cell.addDelFriends setTitle:@"Delete" forState:UIControlStateNormal];
        
        
    }
    
    // Configure the cell...
    
    return cell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *header;
    
    switch (section) {
        case 0:
            header = @"Invitation";
            break;
        case 1:
            header = @"Friends";
            break;
    }
    return header;
    
}

-(void) reloadDatas{
    [query whereKey:@"user" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
        
        qfriends = arrayFriends;
        fObject = qfriends[0];
        friends = fObject[@"Friends"];
        
        unfriends = fObject[@"unFriends"];
        
        [_friendsView reloadData];
        [refreshControl endRefreshing];
    }];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [_friendsView indexPathForSelectedRow];
    FriendsTableViewCell *cell = (FriendsTableViewCell *)[_friendsView cellForRowAtIndexPath:indexPath];
    //FriendsTableViewCell *cell = [_friendsView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    PersonalPageViewController *view = [segue destinationViewController];
    [view passData:cell.userName.text];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
