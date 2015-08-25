//
//  NotificationTableViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/17.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "NotificationTableViewController.h"
#import <Parse/Parse.h>
#import "EditProfileTableViewController.h"

@interface NotificationTableViewController (){
    NSMutableArray *notidicationArray;  /**< 加好友通知 */
    NSString *otherPersonObjectId;      /**< 對方objectId */
    NSString *otherPersonName;          /**< 對方Name */
}

@end

@implementation NotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotidication];
    [self.tableView setDelegate:self];
    
    [self.tableView setDataSource:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;   //不會刷新這一行cell，就沒事兒了 ，默認YES返回會刷新這行
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self.tableView reloadData];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //取值
    NSDictionary *notidicationDictionary = [userDefaults dictionaryForKey:@"notidicationDictionary"];
    notidicationArray = [notidicationDictionary objectForKey:@"addFriend"];

}

- (void) initNotidication{
    notidicationArray = [NSMutableArray new];


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
    if (notidicationArray.count == 0) {
        return 1;
    }
    return notidicationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *tempLogString;
    if (notidicationArray.count == 0) {
        cell.textLabel.text = @"您沒有新的消息通知";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        //擷取前10位元
        otherPersonObjectId = [NSString stringWithFormat:@"%@", [notidicationArray[indexPath.row] substringToIndex:10]];
        
        //擷取時略過前11位元
        tempLogString = [NSString stringWithFormat:@"%@", [notidicationArray[indexPath.row] substringFromIndex:11]];
        otherPersonName = tempLogString;
        tempLogString = [NSString stringWithFormat:@"%@ 邀請與您成為好友",tempLogString];
        NSLog(@"%@ 邀請與您成為好友",notidicationArray[indexPath.row]);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",tempLogString];
    }
    
    
    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goEditProfile"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //擷取前10位元
        otherPersonObjectId = [NSString stringWithFormat:@"%@", [notidicationArray[indexPath.row] substringToIndex:10]];
        
        //擷取時略過前11位元
        otherPersonName = [NSString stringWithFormat:@"%@", [notidicationArray[indexPath.row] substringFromIndex:11]];

        EditProfileTableViewController *controller = (EditProfileTableViewController *)[segue destinationViewController];
        [controller passValue:otherPersonName passSelectUserObjectId:otherPersonObjectId];
    }
}


@end
