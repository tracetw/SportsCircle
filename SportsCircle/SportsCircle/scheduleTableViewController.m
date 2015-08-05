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
#import <Parse/Parse.h>

//#import "FMDatabase.h"
@interface scheduleTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *datas;
    NSString *dbFilePathName;//路徑名
}

@property NSMutableArray *objects;
@end

@implementation scheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    datas=[NSMutableArray new];
    
    UIImage *image = [[UIImage imageNamed:@"edit1x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPressed)];
    
    self.navigationItem.rightBarButtonItem=addButton;

    PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    [query getObjectInBackgroundWithId:@"0GJ4aUltRa" block:^(PFObject *schedule, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"%@", schedule);
        NSString *scName = schedule[@"scheduleName"];
        NSString *scDetial = schedule[@"scheduleDetail"];
        BOOL cheatMode = [schedule[@"cheatMode"] boolValue];

            NSLog(@"Name: %@ , detail:%@ , bool:%d",scName,scDetial,cheatMode);
    
        NSString *objectId = schedule.objectId;
        
        NSLog(@"this id is: %@",objectId);
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addBtnPressed{
    //Add into db first
    
     [self performSegueWithIdentifier:@"goDetail" sender:nil];
    
    
    [datas insertObject:[NSDate date] atIndex:0];
    //日期存到datas.atindex放在0表示插在最前面
    //先跟新資料庫(此為新增data)在更新UI
    
    //Insert into TabView 此為新增的動作
    NSIndexPath *insertIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];//標示位子
    [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //@[]表array,可多個
    
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
    
    //    NSDate *targetItem=datas[indexPath.row];
    //    cell.textLabel.text=targetItem.description;
    //顯示datas出來
    
    cell.scheduleName.text=@"123";
    
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
        // Delete the row from the data source
        [datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

-(IBAction)backToSchedule:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to schedule");
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
