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
    NSArray *invitingFriends;
    PFImageView *userImage;
    PFObject *currentUserFriendsClassObject;
    UIRefreshControl *refreshControl;
    PFUser *currentUser;
    PFQuery *query;
    NSString *username;
    NSString *searchUserName;
    NSArray *totalFriendClassArray;
    NSArray *eachUnFriendArray;
    NSMutableArray *invitingFriendArray;
    
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
    //找到當前使用者的好友及待加好友
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
        
        qfriends = arrayFriends;
        currentUserFriendsClassObject = qfriends[0];//只會找到一筆當前使用者
        friends = currentUserFriendsClassObject[@"Friends"];//當前使用者的好友array
        
        //unfriends = fObject[@"unFriends"];//當前使用者的待加好友arrayXXX   當前使用者有申請加的好友 這行沒有用...
        
        [_friendsView reloadData];
        
    }];
    
    invitingFriendArray = [NSMutableArray new];
    [self getInvitingFriends];
    
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
    userImage = [PFImageView new];
    
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
        return invitingFriendArray.count;
    }else {
        return friends.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.block = ^(UIAlertController *alert){
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    cell.reloadDataBlock = ^(void){
        [self reloadDatas];
        NSLog(@"already reload cell");
    };
    cell.currentUserObjectId = currentUser.objectId;
    NSLog(@"currentUser_objectID %@",currentUser.objectId);
    cell.currentUserFriendClassObjectId = currentUserFriendsClassObject.objectId;
    NSLog(@"currentUserFriendClassObjectID_objectID %@",currentUser.objectId);
    
    
    if (indexPath.section == 0) {//好友邀請
//        NSString *unfriendObject = unfriends[indexPath.row];//unfriend的user object id
//        
//        //PFQuery *queryFriend = [PFUser query];
//        PFObject *user = [PFQuery getUserObjectWithId:unfriendObject];
        
        PFObject *user = invitingFriendArray[indexPath.row];
        [user fetch];
        
        cell.friendObjectId = user.objectId;
        NSLog(@"friendObjectId %@",user.objectId);
        
        cell.changeFriendsStatusFObject = user;
        NSLog(@"userobject %@",cell.changeFriendsStatusFObject);
        username = user[@"username"];
        NSLog(@"name %@",username);
        cell.userName.text = username;
        
//        PFFile *userImageData = user[@"userImage"];
//        NSData *userImage = [userImageData getData];
//        cell.userImage.image = [UIImage imageWithData:userImage];
        
        
        userImage.image = [UIImage imageNamed:@"loading"];
        
        userImage.file = (PFFile *)user[@"userImage"];
        
        [userImage loadInBackground:^(UIImage *image,NSError *error){
            userImage.image = image;
           cell.userImage.image = userImage.image; 
        }];
        
        cell.userImage.image = userImage.image;
        
        
        [cell.addDelFriends setTitle:@"加好友" forState:UIControlStateNormal];
        

        
    }
    else if (indexPath.section == 1){//好友cell
        NSString *friendObject = friends[indexPath.row];
        PFUser *user = [PFQuery getUserObjectWithId:friendObject];
        
        username = user[@"username"];
        cell.friendObjectId = user.objectId;
        cell.changeFriendsStatusFObject = user;
        NSLog(@"userobject %@",cell.changeFriendsStatusFObject);
        cell.userName.text = username;
        
        userImage = [PFImageView new];
        userImage.image = [UIImage imageNamed:@"loading"];
        userImage.file = (PFFile *)user[@"userImage"];
        
        
        [userImage loadInBackground:^(UIImage *image, NSError *error){
            userImage.image = image;
            cell.userImage.image = userImage.image;
        }];
        cell.userImage.image = userImage.image;
        
//        PFFile *userImageData = user[@"userImage"];
//        NSData *userImage = [userImageData getData];
//        cell.userImage.image = [UIImage imageWithData:userImage];
        
        
        
        
        [cell.addDelFriends setTitle:@"刪除" forState:UIControlStateNormal];
        
        
    }
    
    // Configure the cell...
    
    return cell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *header;
    
    switch (section) {
        case 0:
            header = @"好友邀請";
            break;
        case 1:
            header = @"好友";
            break;
    }
    return header;
    
}

-(void) reloadDatas{
    
    [invitingFriendArray removeAllObjects];
    [self getInvitingFriends];
    
    [query whereKey:@"user" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
        
        qfriends = arrayFriends;
        currentUserFriendsClassObject = qfriends[0];
        friends = currentUserFriendsClassObject[@"Friends"];
        
       // unfriends = fObject[@"unFriends"];
        
        [_friendsView reloadData];
        [refreshControl endRefreshing];
    }];
    [_friendsView reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [_friendsView indexPathForSelectedRow];
    FriendsTableViewCell *cell = (FriendsTableViewCell *)[_friendsView cellForRowAtIndexPath:indexPath];
    //FriendsTableViewCell *cell = [_friendsView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    PersonalPageViewController *view = [segue destinationViewController];
    [view passData:cell.userName.text];
}
- (IBAction)addFriendBtnPressed:(id)sender {
    
    NSString *message = [NSString stringWithFormat:@"請輸入使用者姓名:"];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新增好友" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        searchUserName = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
        
        PFQuery *searchQuery = [PFQuery queryWithClassName:@"_User"];
        [searchQuery whereKey:@"username" equalTo:searchUserName];
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
            if(arrayFriends.count == 0){
                    UIAlertController *noUserAlertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"無此用戶" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:nil];
                    [noUserAlertController addAction:errorAction];
                    [self presentViewController:noUserAlertController animated:YES completion:nil];
            }else{
                NSString *addFriendMessage = [NSString stringWithFormat:@"將%@加入好友",searchUserName];
                UIAlertController *addFriendAlertController = [UIAlertController alertControllerWithTitle:@"加入好友" message:addFriendMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertActioin){
                    
                    PFObject* queryfriendObject = arrayFriends[0];
//                    PFQuery *queryFriendClass = [PFQuery queryWithClassName:@"Friends"];
//                    [queryFriendClass whereKey:@"user" equalTo:queryfriendObject];
//                    [queryFriendClass findObjectsInBackgroundWithBlock:^(NSArray *arrayFriends, NSError *error){
//                    
//                        PFObject *friendClassObject = arrayFriends[0];//只會找到一筆當前使用者
//                        
//                        [friendClassObject addUniqueObjectsFromArray:@[currentUser.objectId] forKey:@"unFriends"];
//                        [friendClassObject saveInBackground];
//                    }];
                    
                    //加好友只把對方user objectID放入自己的unFriends內
                    PFQuery *queryFriendClass2 = [PFQuery queryWithClassName:@"Friends"];
                    NSLog(@"currObjec %@",queryfriendObject.objectId);
                    [queryFriendClass2 getObjectInBackgroundWithId:currentUserFriendsClassObject.objectId block:^(PFObject *frinendConfirm, NSError *error) {
                        [frinendConfirm addUniqueObjectsFromArray:@[queryfriendObject.objectId] forKey:@"unFriends"];
                        [frinendConfirm saveInBackground];
                        
                        //==========push
                        
                       
                        
                        PFQuery *pushQuery = [PFInstallation query];
                        [pushQuery whereKey:@"user" equalTo:queryfriendObject];
                        // Send push notification to query
                        PFPush *push = [[PFPush alloc] init];
                        [push setQuery:pushQuery];
                        // Set our Installation query
                        NSString *message = [NSString stringWithFormat:@"%@將你加為好友",currentUser.username];
//                        [push setMessage:message];
                        NSDictionary *pushData = [NSDictionary new];
                        pushData = @{@"alert":message,@"sound":UILocalNotificationDefaultSoundName,@"badge":@"Increment"};
                        [push setData:pushData];
                        [push sendPushInBackground];
                        //------------
                    }];
                    
                }];
                [addFriendAlertController addAction:confirmAction];
                [addFriendAlertController addAction:cancelAction];
                [self presentViewController:addFriendAlertController animated:YES completion:nil];
                
                }
        
            }];
        
        }];
        
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"User Name";
    }];
    
    [alertController addAction:searchAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)getInvitingFriends{
    
    PFQuery *queryFriendClass = [PFQuery queryWithClassName:@"Friends"];
    
//    NSArray *totalFriendClassArray;
//    為何totalFriendClassArray不能在裡面宣告
    totalFriendClassArray = [queryFriendClass findObjects];
    
    
        
        for (int i=0; i < totalFriendClassArray.count; i++) {
            
            PFObject *eachFriendObject = totalFriendClassArray[i];
            
            eachUnFriendArray = eachFriendObject[@"unFriends"];
            
            
            for (int j=0; j < eachUnFriendArray.count; j++) {
                NSLog(@"check %@ ,%@",currentUser.objectId,eachUnFriendArray[j]);
                if ([currentUser.objectId isEqualToString:eachUnFriendArray[j]]) {
                    [invitingFriendArray addObject: eachFriendObject[@"user"]];
                    NSLog(@"allArray%@",invitingFriendArray);
                }
            }
            
        }
    

    

   
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
