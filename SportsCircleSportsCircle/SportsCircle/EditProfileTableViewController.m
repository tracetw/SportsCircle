//
//  EditProfileTableViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//  http://flatuicolors.com/

#import "EditProfileTableViewController.h"
#import <Parse/Parse.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FavoriteSportViewController.h"
#import "DetailImageViewController.h"
#import "ImageCollectionViewCell.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface EditProfileTableViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    NSMutableDictionary *profileDictionary; /**< 存個人資料包在Array裡面 */
    NSMutableArray *profileAndPictureArray; /**< 存個人資料及照片 */
    NSMutableDictionary *tempDictionary;    /**< 暫存的Dictionary */
    NSArray *sportsItemArray;   /**< 運動項目Array */
    NSArray *selectUserSportsItemArray;  /**< 點擊進來的使用者運動項目Array */
    BOOL tempDidUpdateSportItem;    /**< 儲存是否有更新喜愛運動項目 */
    NSInteger totalSportPictureNumber; /**< 運動照片數量 */
    NSInteger totalClothingPictureNumber;   /**< 裝備照片數量 */
    NSString *selectUserName;   /**< 點擊進來的使用者名稱 */
    NSString *selectUserObjectId;    /**< 點擊進來的使用者ObjectId */
    BOOL didCurrentUser; /**< 是否為當前用戶 */
    UIImagePickerController *imagePicker;   /**< 選擇上傳照片 */
    NSMutableArray *friendsArray;  /**< 好友列表 */
    NSMutableArray *unfriendsArray;    /**< 要求加好友列表 */
    BOOL didBeFriend;   /**< 已經是好友 */
    BOOL ConfirmBeFriend;   /**< 確認好友邀請 */
    BOOL prepareForBeFriend; /**< 準備成為好友 */
    NSString *otherPersonobjectId;  /**< 準備加入的好友 */
    NSMutableArray *otherPersonfriendsArray;  /**< 對方好友列表 */
    NSMutableArray *otherPersonunfriendsArray;    /**< 對方要求加好友列表 */
}
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *heightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *weightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *habitCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;  /**< 運動相片 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2; /**< 裝備相片 */
@property (weak, nonatomic) IBOutlet FUIButton *beFriendButton; /**< 好友按鈕 */
@property (weak, nonatomic) IBOutlet UIButton *updataImageBtnPressed;   /**< 更新照片按鈕 */

@end

@implementation EditProfileTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    _beFriendButton.hidden = YES;
    
    [self countPictureNumber];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFUser *currentUser = [PFUser currentUser];
    if (!selectUserName) {    //如果選擇的名字是空的
        selectUserName = currentUser[@"username"];  //當前用戶名字作為選擇的名字
    }
    [query whereKey:@"username" equalTo:selectUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        // comments now contains the comments for myPost
        PFObject *selectUser = comments[0];
        selectUserObjectId = selectUser.objectId;
        NSLog(@"%@oooooooooo%@",selectUser.objectId,currentUser.objectId);
        
        if (selectUser.objectId == currentUser.objectId) {  //如果選擇的名字是當前用戶
            didCurrentUser = true;
            
            [self queryDatabase];
            
        }else{  //如果選擇的名字不是當前用戶
            didCurrentUser = false;
            _updataImageBtnPressed.hidden = YES;
            _beFriendButton.hidden = NO;
            [self queryselectUserDatabase];
        }
        
    }];
    
    
//    self.collectionView.delegate = self;
//    self.collectionView2.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView2.dataSource = self;



}


- (void)passValue:(NSString *)userNameTextField passSelectUserObjectId:(NSString *)userObjectId{
    NSLog(@"%@aaaaaaaa%@",userNameTextField,userObjectId);
    selectUserName = userNameTextField;
    selectUserObjectId = userObjectId;
    
}

//設定好友Button樣式
-(void)settingStyle:(int)value{
    //UIColor *hex22C3AA = [UIColor colorWithRed:34.0/255.0 green:195.0/255.0 blue:170.0/255.0 alpha:1];
    
    if (value == 1) {
        [_beFriendButton setTitle:@"加好友" forState:UIControlStateNormal];
        self.beFriendButton.buttonColor = [UIColor peterRiverColor];    //主體
        self.beFriendButton.shadowColor = [UIColor belizeHoleColor];  //陰影
        self.beFriendButton.shadowHeight = 2.0f;
        self.beFriendButton.cornerRadius = 3.0f;
        self.beFriendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.beFriendButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];  //文字
        [self.beFriendButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateHighlighted]; //點選後文字
    }
    
    if (value == 2) {
        [_beFriendButton setTitle:@"取消好友" forState:UIControlStateNormal];
        self.beFriendButton.buttonColor = [UIColor concreteColor];    //主體
        self.beFriendButton.shadowColor = [UIColor asbestosColor];  //陰影
        self.beFriendButton.shadowHeight = 2.0f;
        self.beFriendButton.cornerRadius = 3.0f;
        self.beFriendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.beFriendButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];  //文字
        [self.beFriendButton setTitleColor:[UIColor wetAsphaltColor] forState:UIControlStateHighlighted]; //點選後文字
    }
    
    if(value == 3){
        [_beFriendButton setTitle:@"取消邀請" forState:UIControlStateNormal];
        self.beFriendButton.buttonColor = [UIColor emerlandColor];    //主體
        self.beFriendButton.shadowColor = [UIColor nephritisColor];  //陰影
        self.beFriendButton.shadowHeight = 2.0f;
        self.beFriendButton.cornerRadius = 3.0f;
        self.beFriendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.beFriendButton setTitleColor:[UIColor pomegranateColor] forState:UIControlStateNormal];  //文字
        [self.beFriendButton setTitleColor:[UIColor alizarinColor] forState:UIControlStateHighlighted]; //點選後文字
    }
    
    if (value == 4) {
        [_beFriendButton setTitle:@"確認邀請" forState:UIControlStateNormal];
        self.beFriendButton.buttonColor = [UIColor peterRiverColor];    //主體
        self.beFriendButton.shadowColor = [UIColor belizeHoleColor];  //陰影
        self.beFriendButton.shadowHeight = 2.0f;
        self.beFriendButton.cornerRadius = 3.0f;
        self.beFriendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.beFriendButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];  //文字
        [self.beFriendButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateHighlighted]; //點選後文字
    }
}

//如果資料有變動更新
-(void)viewDidAppear:(BOOL)animated{
    if (tempDidUpdateSportItem) {
        [self queryDatabase];
    }
    
    [self didBeFriend];
    [self didConfirmBeFriend];
}


#pragma mark BeFriend
- (void) initFriendsList:(PFObject *)User{   //初始化好友列表
    PFObject *initFriends = [PFObject objectWithClassName:@"Friends"];
    NSArray *tempArray = [NSArray new];
    initFriends[@"Friends"] = tempArray;
    initFriends[@"unFriends"] = tempArray;
    initFriends[@"user"] = User;
    [initFriends saveInBackground];
}

- (void) didBeFriend{   //確認是否為好友
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"user" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if (array.count == 0) {
            [self initFriendsList:currentUser];
            [self settingStyle:1];
            return;
        }
        
        PFObject *fObject = array[0];
        friendsArray = fObject[@"Friends"];
        unfriendsArray = fObject[@"unFriends"];
    
        for (NSString *string in friendsArray) {
            if ([string caseInsensitiveCompare:selectUserObjectId]==NSOrderedSame) {
                NSLog(@"已經是好朋友了");
                didBeFriend = true;
                [self settingStyle:2];
            }
        }
        for (NSString *string in unfriendsArray) {
            if ([string caseInsensitiveCompare:selectUserObjectId]==NSOrderedSame) {
                NSLog(@"取消加好友邀請");
                ConfirmBeFriend = true;
                [self settingStyle:3];
            }
        }
    }];
    
    
    [self settingStyle:1];
}

- (void) didConfirmBeFriend{   //確認是否有好友邀請名單
    
    //init
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];   /**< NSUserDefaults */
    NSMutableDictionary *notidicationDictionary = [NSMutableDictionary new];    /**< 消息通知 */
    NSMutableArray *addFriendArray = [NSMutableArray new];  /**< 所有的待確認好友objectId */
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *unConfirmfriendsArray = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        for (PFObject *pfobject in array) {
            for (NSObject *object in pfobject[@"unFriends"]) {
                if ([[NSString stringWithFormat:@"%@",object] caseInsensitiveCompare:currentUser.objectId]==NSOrderedSame) {
                    NSLog(@"%@邀請您成為好友",pfobject[@"user"]); //發出通知
                    PFUser *otherPerson = pfobject[@"user"];
                    NSString *tempNameString = otherPerson.username;
                    NSString *tempString = otherPerson.objectId;
                    tempString = [NSString stringWithFormat:@"%@&%@",tempString,tempNameString];
                    NSLog(@"%@",tempString);
                    
                    [addFriendArray addObject:tempString];

                    if ([tempString caseInsensitiveCompare:selectUserObjectId]==NSOrderedSame){
                        otherPersonobjectId = tempString;
                        NSLog(@"當前頁面的user%@邀請您成為好友",tempString); //加好友
                        prepareForBeFriend = YES;
                            //雙方互加好友
                        [self settingStyle:4];
                    }
                }
                [unConfirmfriendsArray addObject:object];
            }
        }
        
        //存檔
        [notidicationDictionary setObject:addFriendArray forKey:@"addFriend"];
        [userDefaults setObject:notidicationDictionary forKey:@"notidicationDictionary"];
        //設定好後只是單純的cache住，要存進硬碟要用，才真正儲存
        [userDefaults synchronize];
    }];
    
}

- (void) processOtherPerson{   //處理對方好友列表查詢
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:otherPersonobjectId];
    [query whereKey:@"user" equalTo:pfObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if (array.count == 0) {
            [self initFriendsList:pfObject];
            [self processOtherPerson];
        }
        PFObject *fObject = array[0];
        otherPersonfriendsArray = fObject[@"Friends"];
        otherPersonunfriendsArray = fObject[@"unFriends"];
        
        [otherPersonfriendsArray addObject:currentUser.objectId];   //加入好友名單
        [otherPersonunfriendsArray removeObject:currentUser.objectId];  //移除確認列表
        
        [self processOtherPersonToBefriend];
        
    }];


}

- (void) processOtherPersonToBefriend{ //處理對方好友列表加回去
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:otherPersonobjectId];
    [query whereKey:@"user" equalTo:pfObject];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        NSLog(@"%@",object);
        object[@"Friends"] = otherPersonfriendsArray;
        object[@"unFriends"] = otherPersonunfriendsArray;
        [object saveInBackground];
    }];
}
//加好友
- (IBAction)addFriendBtnPressed:(id)sender {
    
    if (didBeFriend && !ConfirmBeFriend  && !prepareForBeFriend) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"確定取消好友" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [friendsArray removeObject:selectUserObjectId]; //如果已經是好友，移除好友
            NSLog(@"移除好友");
            [self settingStyle:1];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(ConfirmBeFriend && !didBeFriend  && !prepareForBeFriend){
        [unfriendsArray removeObject:selectUserObjectId];   //如果是確認好友狀態，取消加入好友邀請
        [self settingStyle:1];
    }else if(!ConfirmBeFriend && !didBeFriend && !prepareForBeFriend){
        [unfriendsArray addObject:selectUserObjectId];  //按下去加入確認名單
        [self settingStyle:3];
            //發出通知
    }else if(prepareForBeFriend && !ConfirmBeFriend && !didBeFriend ){   //準備成為好友
        [unfriendsArray removeObject:otherPersonobjectId];   //移除確認列表
        [friendsArray addObject:otherPersonobjectId];    //加入好友名單
        [self settingStyle:2];
        [self processOtherPerson];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" equalTo:currentUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        NSLog(@"%@",object);
        object[@"Friends"] = friendsArray;
        object[@"unFriends"] = unfriendsArray;
        [object saveInBackground];
    }];
    [self didBeFriend];
}



#pragma mark 上傳頭像
//上傳頭像
- (IBAction)takePhotoBtnPressed:(id)sender {
    UIImagePickerControllerSourceType sourceType; //= UIImagePickerControllerSourceTypePhotoLibrary;
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = sourceType;
    
    imagePicker.mediaTypes = @[@"public.image"];
    //imagePicker.allowsEditing = true;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:true completion:nil];
}

//選擇照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];    //選擇後的圖片
    _userImageView.image = originalImage;
    [self takePhoto];
    //Save modifiedImage    //存3張圖片，原始，裁切，加框圖
    //toBeSavedImages = [NSMutableArray arrayWithObjects:originalImage,editedImage,modifiedImage, nil];
    //[self processSaveImage];
    
    [picker dismissViewControllerAnimated:true completion:nil]; //把 Image picker 收起來
}

//壓縮照片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 創建一個bitmap的context
    // 並把它設置成為當前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 繪製改變大小的圖片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 從當前context中創建一個改變大小後的圖片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使當前的context出堆棧
    UIGraphicsEndImageContext();
    // 返回新的改變大小後的圖片
    return scaledImage;
}

//上傳頭像至Parse
- (void) takePhoto{
    //壓縮照片
    _userImageView.image = [self scaleToSize:_userImageView.image size:CGSizeMake(200, 200)];
    
    NSData *imageData = UIImagePNGRepresentation(_userImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"Profile.png" data:imageData];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:selectUserObjectId block:^(PFObject *object, NSError *error) {
        if (!error) {
            object[@"userImage"] = imageFile;
            [object saveInBackground];
            //[self.navigationController popViewControllerAnimated:YES]; //返回到前面一層viewController
        }else{  //上傳失敗
            NSString *errorString = [error userInfo][@"error"];
            
            if ([errorString isEqualToString:@"The Internet connection appears to be offline."]) {
                errorString = @"網路連線已斷線";
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上傳失敗" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
}

#pragma mark 載入資料
- (void)countPictureNumber{
    //抓到所有的運動照片物件
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    //PFUser *currentUser = [PFUser currentUser];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
    //NSLog(@"qqqqqqq%@",currentUser.objectId);
    [query whereKey:@"user" equalTo:pfObject];
    NSArray *usersPostsArray = [query findObjects];
    totalSportPictureNumber = usersPostsArray.count;
    
    //抓到所有的裝備照片物件
    NSMutableArray *tempImageArray = [NSMutableArray new];
    for (int j = 0; j < totalSportPictureNumber; j++) {
        for (int i = 2; i < 6; i++) {
            NSString *tempString = [NSString stringWithFormat:@"image%d",i];
            PFObject *tempObject = usersPostsArray[j][tempString];
            if (tempObject == nil) {
                continue;
            }
            [tempImageArray addObject: tempObject];
        }
    }
    NSLog(@"%@",tempImageArray);
    totalClothingPictureNumber = tempImageArray.count;
}

-(void)queryselectUserDatabase{ //非當前用戶資料

    //無法被選擇
    _genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _ageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _heightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _habitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //查詢資料庫
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
    
    PFFile *userImageData = pfObject[@"userImage"];
    NSData *userImage = [userImageData getData];
    _userImageView.image = [UIImage imageWithData:userImage];
    
    [query whereKey:@"user" equalTo:pfObject];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSDictionary *myDictionary = objects[0];
            [myDictionary objectForKey:@"gender"];
            [myDictionary objectForKey:@"age"];
            [myDictionary objectForKey:@"height"];
            [myDictionary objectForKey:@"weight"];
            selectUserSportsItemArray = [myDictionary objectForKey:@"habit"];
            //NSLog(@"%@",[myDictionary objectForKey:@"age"]);
            
            
            //顯示資料至cell.textlabel
            _nameCell.textLabel.text = [NSString stringWithFormat:@"姓名：%@",selectUserName];
            
            if ([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"1"]) {
                _genderCell.textLabel.text = @"性別：男性";
            }else if([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"2"]){
                _genderCell.textLabel.text = @"性別：女性";
            }else{
                //....
            }
            
            if ([myDictionary objectForKey:@"age"] == nil){
                _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡："];
            }else{
                _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡：%@",[myDictionary objectForKey:@"age"]];
            }
            
            if ([myDictionary objectForKey:@"age"] == nil){
                _heightCell.textLabel.text = [NSString stringWithFormat:@"身高："];
            }else{
                _heightCell.textLabel.text = [NSString stringWithFormat:@"身高：%@",[myDictionary objectForKey:@"height"]];
            }
            
            if ([myDictionary objectForKey:@"age"] == nil){
                _weightCell.textLabel.text = [NSString stringWithFormat:@"體重："];
            }else{
                _weightCell.textLabel.text = [NSString stringWithFormat:@"體重：%@",[myDictionary objectForKey:@"weight"]];
            }
    
            NSString *sportsItemString;
            for (NSString *object in selectUserSportsItemArray) {
                //NSLog(@"%@\n",object);
                if (sportsItemString == nil) {
                    sportsItemString = [NSString stringWithFormat:@"%@",object];
                    continue;
                }
                sportsItemString = [NSString stringWithFormat:@"%@, %@",sportsItemString, object];
            }
            //NSLog(@"%@\n",sportsItemString);
            if (sportsItemString == nil) {
                _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動："];
            }else{
                _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動：%@",sportsItemString];
            }
            //Label自動換行
            _habitCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _habitCell.textLabel.numberOfLines = 0;
            
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}

-(void)queryDatabase{   //當前用戶資料
    
    //顯示下一頁標籤
    _genderCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _ageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _heightCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _weightCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _habitCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //查詢資料庫
    PFUser *user = [PFUser currentUser];
    //NSLog(@"%@",user.objectId);
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
    //NSLog(@"scoreArray = %@",scoreArray);
    
    
    PFFile *userImageData = user[@"userImage"];
    NSData *userImage = [userImageData getData];
    _userImageView.image = [UIImage imageWithData:userImage];
    
    
    if (scoreArray.count == 0) {
        PFObject *gameScore = [PFObject objectWithClassName:@"PersionalInfo"];
        gameScore[@"user"] = user;
        [gameScore saveInBackground];
        
        return;
    }
    NSDictionary *myDictionary = scoreArray[0];
    [myDictionary objectForKey:@"gender"];
    [myDictionary objectForKey:@"age"];
    [myDictionary objectForKey:@"height"];
    [myDictionary objectForKey:@"weight"];
    sportsItemArray = [myDictionary objectForKey:@"habit"];
    //NSLog(@"%@",[myDictionary objectForKey:@"age"]);
    
    
    //顯示資料至cell.textlabel
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSString *title = [NSString stringWithFormat:@" %@", currentUser.username];
        _nameCell.textLabel.text = [NSString stringWithFormat:@"姓名：%@",title];
    } else {
        // show the signup or login screen
    }
    
    if ([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"1"]) {
        _genderCell.textLabel.text = @"性別：男性";
    }else if([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"2"]){
        _genderCell.textLabel.text = @"性別：女性";
    }else{
        //....
    }
    
    if ([myDictionary objectForKey:@"age"] == nil){
        _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡："];
    }else{
        _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡：%@",[myDictionary objectForKey:@"age"]];
    }
    
    if ([myDictionary objectForKey:@"age"] == nil){
        _heightCell.textLabel.text = [NSString stringWithFormat:@"身高："];
    }else{
        _heightCell.textLabel.text = [NSString stringWithFormat:@"身高：%@",[myDictionary objectForKey:@"height"]];
    }
    
    if ([myDictionary objectForKey:@"age"] == nil){
        _weightCell.textLabel.text = [NSString stringWithFormat:@"體重："];
    }else{
        _weightCell.textLabel.text = [NSString stringWithFormat:@"體重：%@",[myDictionary objectForKey:@"weight"]];
    }
    
    
    
    
    NSString *sportsItemString;
    for (NSString *object in sportsItemArray) {
        //NSLog(@"%@\n",object);
        if (sportsItemString == nil) {
            sportsItemString = [NSString stringWithFormat:@"%@",object];
            continue;
        }
        sportsItemString = [NSString stringWithFormat:@"%@, %@",sportsItemString, object];
    }
    //NSLog(@"%@\n",sportsItemString);
    if (sportsItemString == nil) {
        _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動："];
    }else{
    _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動：%@",sportsItemString];
    }
    //Label自動換行
    _habitCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _habitCell.textLabel.numberOfLines = 0;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath]; //cell預設高度
//    if (indexPath.row == 0) {
//        return height;
//    }else if (indexPath.row == 6){
//            if (sportsItemArray.count < 2) {
//                return height;
//            }else if (sportsItemArray.count < 4) {
//                return height*2;
//            }else if (sportsItemArray.count < 6) {
//                return height*3;
//            }else if (sportsItemArray.count < 8) {
//                return height*4;
//            }else if (sportsItemArray.count < 10) {
//                return height*5;
//            }else{
//                return height*6;
//            }
//        
//    }else {
//        return height;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return (unsigned long)profileDictionary.count;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
//
//    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (didCurrentUser) {   //如果是當前用戶才允許編輯

    switch (indexPath.row) {
        case 0:{
            
        }
            break;
        case 1:{
 
        }
            break;
        case 2:{
            
            [self askValueWithTitle:@"性別：" withMessage:@"請輸入性別更新個人資訊\n輸入1為男性，2為女性" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    
                    if ([[NSString stringWithFormat:@"%d",value] isEqualToString:@"1"]) {
                        cell.textLabel.text = @"性別：男性";
                    }else if ([[NSString stringWithFormat:@"%d",value] isEqualToString:@"2"]){
                        cell.textLabel.text = @"性別：女性";
                    }
                    
                    //cell.textLabel.text =[NSString stringWithFormat:@"性別：%@",[NSString stringWithFormat:@"%d",value]];
                    if (value == 1 || value == 2) {
                        [self updateParseData:@"gender" withValue:value];
                    }
                }
            }];
            
            
        }
            break;
        case 3:{
            
            [self askValueWithTitle:@"年齡：" withMessage:@"請輸入年齡更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    //NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"年齡：%@",[NSString stringWithFormat:@"%d",value]];
                    [self updateParseData:@"age" withValue:value];
                }
            }];
        }
            
            break;
        case 4:{
            
            [self askValueWithTitle:@"身高：" withMessage:@"請輸入身高更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    //NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"身高：%@",[NSString stringWithFormat:@"%d",value]];
                        [self updateParseData:@"height" withValue:value];
                    
                }
            }];
            
            
        }
            break;
        case 5:{
            
            [self askValueWithTitle:@"體重：" withMessage:@"請輸入體重更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    //NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"體重：%@",[NSString stringWithFormat:@"%d",value]];
                    [self updateParseData:@"weight" withValue:value];
                }
            }];
            
        }
            break;
        case 6:{
            
            FavoriteSportViewController * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"BViewController"];
            viewcontroller.block = ^void(BOOL response){
                    tempDidUpdateSportItem = response;
            };
            [self.navigationController pushViewController:viewcontroller animated:YES];

            
        }
            break;
        case 7:{
            
        }
            break;
        case 8:{
            
        }
            break;
        default:
            break;
    }
    }
}

//更新Parse個人資料
-(void)updateParseData:(NSString*)profileClass withValue:(int)value{
    //NSLog(@"%@     %d",profileClass,value);
    //查詢資料庫
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
    //NSDictionary *myDictionary = scoreArray[0];
    PFObject *persionalInfoObject = scoreArray[0];
    
    //查詢物件
    //NSLog(@"%@%@%@",scoreArray[0], persionalInfoObject.objectId, [myDictionary objectForKey:profileClass]);
    //更新物件
    [query getObjectInBackgroundWithId:persionalInfoObject.objectId block:^(PFObject *tempObject, NSError *error) {
        tempObject[profileClass] = [NSNumber numberWithInt:value];
        [tempObject saveInBackground];
    }];
}

//UIAlertController
- (void) askValueWithTitle:(NSString *)title withMessage:(NSString*)message withDefaultValue:(NSString*) defaultValue completion:(void (^)(int value, bool success))completion {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.text = [NSString stringWithFormat:@"%@",defaultValue];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *inputTextField = alert.textFields[0];
        
        if(inputTextField.text == nil){
            completion(0,NO);
        }
        else{
            completion(inputTextField.text.doubleValue,YES);
        }
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        completion(0,NO);
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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

#pragma mark CollectionView
//----------------------------------CollectionView-------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    if(view == _collectionView){
        //return 5;
        return totalSportPictureNumber;
    }   //_collectionView2
    return totalClothingPictureNumber;

}
     
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _collectionView){
        
        //create出CollectionViewCell實體
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sportsCollectionIdentifiers" forIndexPath:indexPath];
        
        //cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
        
        
        
        //載入小圖片
        PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
        //PFUser *currentUser = [PFUser currentUser];
        PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
        [query whereKey:@"user" equalTo:pfObject];
        NSArray *usersPostsArray = [query findObjects];
        PFFile *userImageFile = usersPostsArray[indexPath.row][@"image1"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                cell.image.image = image;

            }else{
                NSLog(@"GG%@",error);
            }
        }];

        //    NSString *imageToLoad = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        //    cell.image.image = [UIImage imageNamed:imageToLoad];
        
        //設cell的背景色為gray
        //[cell setBackgroundColor:[UIColor grayColor]];
        
        return cell;
        
    }   //_collectionView2
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"equipCollectionIdentifiers" forIndexPath:indexPath];
    
    
    //載入小圖片
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    //PFUser *currentUser = [PFUser currentUser];
    PFObject *pfObject = [PFObject objectWithoutDataWithClassName:@"_User" objectId:selectUserObjectId];
    [query whereKey:@"user" equalTo:pfObject];
    NSArray *usersPostsArray = [query findObjects];
    //totalPictureNumber = usersPostsArray.count;

    //抓到所有的裝備照片物件
    NSMutableArray *tempImageArray = [NSMutableArray new];
    for (int j = 0; j < totalSportPictureNumber; j++) {
        for (int i = 2; i < 6; i++) {
            NSString *tempString = [NSString stringWithFormat:@"image%d",i];
            PFObject *tempObject = usersPostsArray[j][tempString];
            if (tempObject == nil) {
                continue;
            }
            [tempImageArray addObject: tempObject];
        }
    }
    
    PFFile *userImageFile = tempImageArray[indexPath.row];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.clothingImage.image = image;
        }else{
            NSLog(@"GG%@",error);
        }
    }];
    
    
    //設cell的背景色為gray
    //[cell setBackgroundColor:[UIColor grayColor]];
    
    return cell;

}
//準備離開這個view時執行
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];

//
//        NSLog(@"Source controller = %@",[segue sourceViewController]);
//        NSLog(@"Destination controller = %@",[segue destinationViewController]);
//        NSLog(@"Segue Identifier = %@",[segue identifier]);
//        
//        //載入完整大圖
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%ld_full", (long)selectedIndexPath.row];
//        UIImage *image = [UIImage imageNamed:imageNameToLoad];
//        DetailImageViewController *detailViewController = segue.destinationViewController;
//        detailViewController.image = image;
        
        NSString *roleNumber = [NSString stringWithFormat:@"%ld",(long)selectedIndexPath.row];

        //使用segue將物件傳給Detail View Controller class
        [segue.destinationViewController setValue:roleNumber forKey:@"param"];
        [segue.destinationViewController setValue:selectUserObjectId forKey:@"selectUserObjectId"];

    }else if([segue.identifier isEqualToString:@"showDetail2"]){
        NSIndexPath *selectedIndexPath2 = [self.collectionView2 indexPathsForSelectedItems][0];
        NSString *roleNumber2 = [NSString stringWithFormat:@"%ld",(long)selectedIndexPath2.row];
        [segue.destinationViewController setValue:roleNumber2 forKey:@"param2"];
        [segue.destinationViewController setValue:selectUserObjectId forKey:@"selectUserObjectId"];
    }
}

@end