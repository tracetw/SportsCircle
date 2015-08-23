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
#import <ParseUI/ParseUI.h>
#import "PersonalPageViewController.h"
#import "readPostViewController.h"
#import "UIView+WZLBadge.h"
#import "LBHamburgerButton.h"

@interface TrendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *postWallDictionary;
    NSArray *postWallArray;
    NSMutableArray *datas;
    UIRefreshControl *refreshControl;
    PFImageView *userImage;
    int notidicationNumber; /**< 消息通知數量 */
}
@property (weak, nonatomic) IBOutlet UIView *theListView;
@property (strong, nonatomic) IBOutlet UIView *theTrendView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *notidicationButton;  /**< 消息通知按鈕 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LBHamburgerButton* buttonHamburgerCloseSmall;
@end

@implementation TrendViewController


- (NSInteger) plusWithNumber1:(NSInteger)numbe1 number2:(NSInteger)number2 {
    
    return numbe1 + number2;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self didConfirmBeFriend];
    
//    UIBarButtonItem *list=[[UIBarButtonItem alloc]initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector (barListBtnPressed:)];
    //創造一個UIBBtn.選擇plain的style(另一個也長一樣).selector為把某個方法包裝成一個變數.:為名稱的一部分必加
    [self initHamburgerButton];
    
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc]initWithCustomView:_buttonHamburgerCloseSmall];
    
    self.navigationItem.leftBarButtonItem=hamburgerButton;
    
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
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"動態首頁" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //返回到grayViewControllor的按鈕名稱改為中文～返回～
    
    _theListView.hidden=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    //if (!datas) {
    //    datas = [[NSMutableArray alloc] init];
    //}

    //[self fetchDataFromParse];
   // [[PFUser currentUser] refreshInBackgroundWithBlock:nil];
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:57.0f/255.0f green:88.0f/255.0f blue:100.0f/255.0f alpha:1]];
 
    userImage = [PFImageView new];
    
    //[list setTintColor:[UIColor whiteColor]];
    //[cell.contentView.layer setBorderColor:[UIColor redColor].CGColor];
    //[cell.contentView.layer setBorderWidth:10.0];
    
    self.tableView.separatorColor=[UIColor whiteColor];
}
-(void)reloadDatas
{
    //update here...
    NSLog(@"update");
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    [query addDescendingOrder:@"createdAt"];
    postWallArray = [NSArray new];
    postWallArray = [query findObjects];
    postWallDictionary = [NSDictionary new];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{

    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    [query addDescendingOrder:@"createdAt"];
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
    [_buttonHamburgerCloseSmall switchState];
    
    CATransition *transition=[CATransition animation];
    //catransition為Q的一個物件
    transition.duration=0.3;
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
    
    PFObject *postWallObject = postWallArray[indexPath.row];
    PFImageView *imageView = [PFImageView new];
    imageView.image = [UIImage imageNamed:@"camera"]; // placeholder image
    imageView.file = (PFFile *)postWallObject[@"image1"]; // remote image
    
    //[imageView loadInBackground];
    cell.postImage.image = imageView.image;
    [imageView loadInBackground:^(UIImage *image,  NSError * error){
        cell.postImage.image = image;
    }];
    
    
    //NSData *imageData = [imageView.file getData];
    cell.postImage.image = imageView.image;//[UIImage imageWithData:imageData];
    
    cell.contentLabel.text = postWallObject[@"content"];
    NSString *sportType = postWallObject[@"sportsType"];
    cell.sportTypeImage.image = [UIImage imageNamed:sportType];
    
    
    
    //PFObject *user = [postWallDictionary objectForKey:@"user"];
    
    PFObject *user = postWallObject[@"user"];
    
    cell.userName.text = @"Name";
    
    [user fetchInBackgroundWithBlock:^(PFObject *user,NSError *error){
        
        NSString *username = user[@"username"];
        cell.userName.text = username;
        
        userImage.file = (PFFile *)user[@"userImage"];
        
        [userImage loadInBackground:^(UIImage *image,NSError *error){
            cell.userImage.image = userImage.image;
        }];
        
        cell.userImage.image = userImage.image;
        
        [cell.contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [cell.contentView.layer setBorderWidth:8.0f];
        
    }];
    
    userImage.image = [UIImage imageNamed:@"camera"];
    
    //cell.userImage.image = userImage.image;
    
    
    //    PFFile *userImageData = user[@"userImage"];
    
    //    NSData *userImage = [userImageData getData];
    //    cell.userImage.image = [UIImage imageWithData:userImage];
    
    
    
    //PFObject *postWallObject = postWallArray[indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *postTime = postWallObject.createdAt;
    NSString *strDate = [dateFormatter stringFromDate:postTime];
    cell.timeLabel.text = strDate;

    //以下為usernameLabel新增連結
    UITapGestureRecognizer *singleTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameLabelPressed:)];
    
    [cell.userName setUserInteractionEnabled:TRUE];
    //[cell.userImage setUserInteractionEnabled:TRUE];
    [cell.userName addGestureRecognizer:singleTap1];
    //[cell.userImage addGestureRecognizer:singleTap2];
    cell.userName.tag = indexPath.row;
    
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
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //以下可以辨識點擊哪一行
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell title:%@ and row:%li",cell.textLabel.text,indexPath.row);
}
*/

- (void) didConfirmBeFriend{   //確認是否有好友邀請名單
    
    //init
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];   /**< NSUserDefaults */
    NSMutableDictionary *notidicationDictionary = [NSMutableDictionary new];    /**< 消息通知 */
    NSMutableArray *addFriendArray = [NSMutableArray new];  /**< 所有的待確認好友objectId */
    
    
    NSMutableArray *unConfirmfriendsArray = [NSMutableArray new];
    PFUser *currentUser=[PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        NSLog(@"%@",array[0]);
        for (PFObject *pfobject in array) {
            for (NSObject *object in pfobject[@"unFriends"]) {
                if ([[NSString stringWithFormat:@"%@",object] caseInsensitiveCompare:currentUser.objectId]==NSOrderedSame) {
                    PFUser *otherPerson = pfobject[@"user"];
                    [otherPerson fetch];    //取值
                    NSString *tempNameString = otherPerson.username;
                    NSString *tempString = otherPerson.objectId;

                    NSString *tempAddString = [NSString stringWithFormat:@"%@&%@",tempString,tempNameString];
                    [addFriendArray addObject:tempAddString];
                    
                }
                [unConfirmfriendsArray addObject:object];
            }
        }
        
        notidicationNumber = (int)addFriendArray.count;
        //存檔
        [notidicationDictionary setObject:addFriendArray forKey:@"addFriend"];
        [userDefaults setObject:notidicationDictionary forKey:@"notidicationDictionary"];
        //設定好後只是單純的cache住，要存進硬碟要用，才真正儲存
        [userDefaults synchronize];
        
        [self showNotidicationBadge:notidicationNumber];
    }];
    
    
}

- (void) showNotidicationBadge:(int)number{
    if (number > 0) {
        [_notidicationButton showBadgeWithStyle:WBadgeStyleRedDot value:number animationType:WBadgeAnimTypeScale];
        [_notidicationButton showBadge];
    }
}

- (IBAction)notidicationBtnPressed:(id)sender {
    [_notidicationButton clearBadge];
}



-(void)userNameLabelPressed:(id)sender
{
    [self performSegueWithIdentifier: @"goPersonalPageFromTrend" sender:[sender view]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goPersonalPageFromTrend"])
    {
        //以下是按cell的使用者名字傳輸的資料
        PersonalPageViewController *controller = (PersonalPageViewController *)[segue destinationViewController];
        
        //NSLog(@"cell.userName.text:%@",[sender text]);
        [controller passData:[sender text]];
        
    }
    //以下是按個人動態按鈕傳輸的資料
    if ([[segue identifier] isEqualToString:@"goPersonalPageFromTrend2"])
    {
        PFUser *currentUser=[PFUser currentUser];//抓到目前user的objId
        NSString *Uname = [currentUser objectForKey:@"username"];
        NSLog(@"user: %@",Uname);

        PersonalPageViewController *controller = (PersonalPageViewController *)[segue destinationViewController];
        //NSLog(@"cell.userName.text:%@",[sender text]);
        
        [controller passData:Uname];
    }

}

-(void)initHamburgerButton{
    _buttonHamburgerCloseSmall = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)
                                                        withHamburgerType:LBHamburgerButtonTypeCloseButton
                                                                lineWidth:20
                                                               lineHeight:20/6
                                                              lineSpacing:2
                                                               lineCenter:CGPointMake(25, 25)
                                                                    color:[UIColor whiteColor]];
    [_buttonHamburgerCloseSmall setCenter:CGPointMake(_buttonHamburgerCloseSmall.center.x + 100, 120)];
    //[_buttonHamburgerCloseSmall setBackgroundColor:[UIColor blackColor]];
    [_buttonHamburgerCloseSmall addTarget:self action:@selector(barListBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}
@end
