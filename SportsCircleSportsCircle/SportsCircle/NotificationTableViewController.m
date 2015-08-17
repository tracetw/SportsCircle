//
//  NotificationTableViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/17.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "NotificationTableViewController.h"
#import <Parse/Parse.h>

@interface NotificationTableViewController (){
    NSMutableArray *notidicationArray;
    NSString *otherPersonObjectId;
}

@end

@implementation NotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotidication];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self didConfirmBeFriend];
    
    
}

- (void) initNotidication{
    notidicationArray = [NSMutableArray new];
}

- (void) didConfirmBeFriend{   //確認是否有好友邀請名單
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *unConfirmfriendsArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        for (PFObject *pfobject in array) {
            for (NSObject *object in pfobject[@"unFriends"]) {
                if ([[NSString stringWithFormat:@"%@",object] caseInsensitiveCompare:currentUser.objectId]==NSOrderedSame) {
                    NSLog(@"%@邀請您成為好友",pfobject[@"user"]); //發出通知
                    PFUser *otherPerson = pfobject[@"user"];
                    NSString *tempString = otherPerson.objectId;
                    NSLog(@"%@",tempString);
                    otherPersonObjectId = tempString;
                    [self getOtherPerson];
                }
                [unConfirmfriendsArray addObject:object];
            }
        }
        
        NSLog(@"%@",unConfirmfriendsArray);
    }];
}

- (void) getOtherPerson{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:otherPersonObjectId block:^(PFObject *PFObject, NSError *error) {
        NSString *tempString = PFObject[@"username"];
        NSLog(@"%@ 邀請與您成為好友", tempString);
        NSString *notidicationString = [NSString stringWithFormat:@"%@ 邀請與您成為好友", tempString];
        [notidicationArray addObject:notidicationString];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
    //return notidicationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    

        cell.textLabel.text = [NSString stringWithFormat:@"%@",notidicationArray[0]];

    
    return cell;
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
