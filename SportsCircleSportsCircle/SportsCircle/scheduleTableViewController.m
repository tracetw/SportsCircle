//
//  scheduleTableViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/31.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "scheduleTableViewController.h"
#import "scheduleDetailViewController.h"
#import "scheduleTableViewCell.h"
#import "scheduleEditViewController.h"
#import <Parse/Parse.h>

//#import "FMDatabase.h"
@interface scheduleTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *datas;
    //NSArray *userSchedules;
    PFQuery *query;
}
@property (weak, nonatomic) IBOutlet UIButton *goDetailBtn;

//@property NSMutableArray *objects;
@end

@implementation scheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _goDetailBtn.hidden=YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *image = [[UIImage imageNamed:@"edit.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPressed)];
    
    self.navigationItem.rightBarButtonItem=addButton;
    
    
    // if (!userSchedules) {
    //    userSchedules = [[NSArray alloc] init];
    // }
    if (!datas) {
        datas=[[NSMutableArray alloc]init];
    }
    
    UIColor *backgroundColor = [UIColor colorWithRed:165/255.0 green:163/255.0 blue:165/255.0 alpha:0.23];
    self.tableView.backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = backgroundColor;
    
    
    //    [self fetchDataFromParse];
    
    //    PFUser *currentUser=[PFUser currentUser];//抓到目前user的objId
    //    PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    //    //query為指向sc類別
    //    [query whereKey:@"user" equalTo:currentUser];
    //    //類別為sc且key為user時value為currentUser
    //    userSchedules = [query findObjects];//抓出資料有兩筆
    //    //NSDictionary *userSchedulesA=userSchedules[0];//cheatMode
    //    //NSDictionary *userSchedulesB=userSchedules[1];//cheatMode
    //    //每一筆為NSDictionary
    //    //NSLog(@"this id is: %@",userSchedulesA[@"scheduleDetail"]);
    //    //NSLog(@"this id is: %@",userSchedulesB[@"scheduleDetail"]);
    //    for (int i=0 ;i<userSchedules.count ; i++) {
    //        [datas insertObject:userSchedules atIndex:0];
    //        //使用者新增幾筆就會出現幾列
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //        //這裏要改為filename
    //        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //
    //    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    datas=[[NSMutableArray alloc]init];
    PFUser *currentUser=[PFUser currentUser];//抓到目前user的objId
    query = [PFQuery queryWithClassName:@"schedule"];
    //query為指向sc類別
    [query whereKey:@"user" equalTo:currentUser];
    //類別為sc且key為user時value為currentUser
    for (NSObject *object in [query findObjects]) {
        [datas addObject:object];
        
    }
    //datas = [query findObjects];//抓出資料有兩筆
    //NSDictionary *userSchedulesA=userSchedules[0];//cheatMode
    //NSDictionary *userSchedulesB=userSchedules[1];//cheatMode
    //每一筆為NSDictionary
    //NSLog(@"this id is: %@",userSchedulesA[@"scheduleDetail"]);
    //NSLog(@"this id is: %@",userSchedulesB[@"scheduleDetail"]);
    //[self fetchDataFromParse];
    
    [self.tableView reloadData];
    
}
/*
 -(void)fetchDataFromParse
 {
 for (int i=0 ;i<userSchedules.count ; i++) {
 [datas insertObject:userSchedules atIndex:0];
 //使用者新增幾筆就會出現幾列
 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
 //這裏要改為filename
 [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 }
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addBtnPressed{
    //Add into db first
    
    [self performSegueWithIdentifier:@"goDetail" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    scheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSLog(@"indexPath:%@",indexPath.description);
    
    NSDictionary *userSchedulesA=datas[indexPath.row];
    //取得userSchedules[indexPath.row]裡面的NSDictionary
    
    cell.scheduleName.text=userSchedulesA[@"scheduleName"];
    cell.scheduleTime.text=userSchedulesA[@"scheduleTime"];
    
    return cell;
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        // Delete the row from the data source
        //for (NSObject *object in userSchedules) {
        //   NSLog(@"%@",object);
        //   [datas addObject:object];
        //}
        PFObject * deleteObject = [datas objectAtIndex:indexPath.row];
        NSString *objectId = deleteObject.objectId;
        NSLog(@"id: %@",objectId); // not null
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"schedule"
                                                           objectId:objectId];
        [object deleteEventually];
        
        
        [datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //[self.tableView reloadData];
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 //如果滑出畫面的row也會更新.要調整不會更新
 //id tmpItem=datas[fromIndexPath.row];
 id tmpItem=[datas objectAtIndex:fromIndexPath.row];
 
 [datas removeObjectAtIndex:fromIndexPath.row];//虛擬的資料庫刪除
 
 [datas insertObject:tmpItem atIndex:toIndexPath.row];
 //然後再將原資料插入
 }
 
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
-(IBAction)backToSchedule:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to schedule");
}
/*
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 //  scheduleEditViewController * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleEditViewController"];
 
 //以下可以辨識點擊哪一行
 PFObject * object = [datas objectAtIndex:indexPath.row];
 objectCellId = object.objectId;
 //NSString *id1=[NSString stringWithFormat:@"%@",objectCellId];
 UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
 
 NSLog(@"cell title:%@ , row:%li and objectId:%@",cell.textLabel.text,indexPath.row,objectCellId);
 
 //self.textField.text=objectCellId;
 // [self.navigationController pushViewController:viewcontroller animated:YES];
 }
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goEdit"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PFObject * object = [datas objectAtIndex:indexPath.row];
        NSString *objectCellId = object.objectId;
        //NSString *id1=[NSString stringWithFormat:@"%@",objectCellId];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"cell title:%@ , row:%li and objectId:%@",cell.textLabel.text,(long)indexPath.row,objectCellId);
        
        //NSDate *object = datas[indexPath.row];
        scheduleEditViewController *controller = (scheduleEditViewController *)[segue destinationViewController];
        [controller passData:objectCellId];
        
    }
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