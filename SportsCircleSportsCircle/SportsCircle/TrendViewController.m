//
//  TrendViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/7/15.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "TrendViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "TrendTableViewCell.h"
@interface TrendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *postWallDictionary;
    NSArray *postWallArray;
    //NSMutableArray *datas;
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UIView *theListView;
@property (strong, nonatomic) IBOutlet UIView *theTrendView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *list=[[UIBarButtonItem alloc]initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector (barListBtnPressed:)];
    //創造一個UIBBtn.選擇plain的style(另一個也長一樣).selector為把某個方法包裝成一個變數.:為名稱的一部分必加
    
    self.navigationItem.leftBarButtonItem=list;
    
    //手勢操作
    UISwipeGestureRecognizer *toRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toRight)];
    toRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_theTrendView addGestureRecognizer:toRight];
    
    UISwipeGestureRecognizer *toLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toLeft)];
    toLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_theTrendView addGestureRecognizer:toLeft];
    
    UITapGestureRecognizer *toTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTap)];
    [_theTrendView addGestureRecognizer:toTap];
    
    
    //允許ImageView接受使用者互動
    _theTrendView.userInteractionEnabled = YES;
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //返回到grayViewControllor的按鈕名稱改為中文～返回～

    _theListView.hidden=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    //if (!datas) {
    //    datas = [[NSMutableArray alloc] init];
    //}

    //[self fetchDataFromParse];
   // [[PFUser currentUser] refreshInBackgroundWithBlock:nil];
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
    
}
-(void)reloadDatas
{
    //update here...
    NSLog(@"update");
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    postWallArray = [NSArray new];
    postWallArray = [query findObjects];
    postWallDictionary = [NSDictionary new];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{

    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    postWallArray = [NSArray new];
    postWallArray = [query findObjects];
    postWallDictionary = [NSDictionary new];
    
    //query為指向sc類別
    //[query whereKey:@"user" equalTo:currentUser];
    //類別為sc且key為user時value為currentUser
    //userSchedules = [query findObjects];//抓出資料有兩筆
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
    for (int i=0 ;i<postWallArray.count ; i++) {
        [datas insertObject:postWallArray atIndex:0];
        //使用者新增幾筆就會出現幾列
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //這裏要改為filename
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
*/
-(IBAction) barListBtnPressed:(id)sender{
    //按下listBtn時
    
    CATransition *transition=[CATransition animation];
    //catransition為Q的一個物件
    transition.duration=0.7;
    //動畫時間長度
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //動畫效果為進出緩慢中間快速
    transition.type=kCATransitionPush;
    //動畫效果為
    if (_theListView.isHidden) {
        _theListView.hidden=NO;
        transition.subtype=kCATransitionFromLeft;
    }else{
        _theListView.hidden=YES;
        transition.subtype=kCATransitionFromRight;
    }//subtype為動畫方向
    [_theListView.layer addAnimation:transition forKey:nil];
    //layer為比UIView更低階的uiview元件.可研究CAlayer
    
    //當theListView展開時 goButton無效
    if (_theListView.isHidden) {
        _goButton.userInteractionEnabled = YES;
    }else {
        _goButton.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backTotrendView:(UIStoryboardSegue *)segue//啟動逃生門所需.透過這個標記去回到login.白色的字可以改.後面的segue可以填香蕉
{
    NSLog(@"back to trendView");
}

-(void) toRight{
    if (_theListView.isHidden) {
        [self barListBtnPressed:nil];
    }
}

-(void) toLeft{
    if (!_theListView.isHidden) {
        [self barListBtnPressed:nil];
    }else{
        [self showMapBtnPressed:nil];//theListView未顯示時 右滑出現map
    }
}

-(void)toTap {
    if (!_theListView.isHidden) {
        [self barListBtnPressed:nil];
    }
}

- (IBAction)showMapBtnPressed:(id)sender {
    //在theListView展開時按下showMapBtnPressed需要把theListView一起隱藏
    //若使用segue到下一頁 無法達成此要求 所以這裡手動進入下一頁
    if (!_theListView.isHidden) {
        [self barListBtnPressed:nil];
    }
    UIViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self showViewController:mapViewController sender:self];
    //[self performSegueWithIdentifier:@"showMapSegue" sender:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postWallArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"TrendCell";
    TrendTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    /*
    NSDictionary *userSchedulesA=postWallArray[indexPath.row];
    //每一筆為NSDictionary
    
    //cell.textLabel.text=@"123";
    cell.headImg=userSchedulesA[@"image1"];
    cell.clockImg=userSchedulesA[@"image2"];
    cell.contentImg=userSchedulesA[@"image3"];
    cell.sportImg=userSchedulesA[@"image4"];
    */
    
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
    cell.userName.text = username;
    
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
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //以下可以辨識點擊哪一行
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell title:%@ and row:%li",cell.textLabel.text,indexPath.row);
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
