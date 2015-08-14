//
//  EditProfileTableViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

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

@interface EditProfileTableViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate>{
    NSMutableDictionary *profileDictionary; /**< 存個人資料包在Array裡面 */
    NSMutableArray *profileAndPictureArray; /**< 存個人資料及照片 */
    NSMutableDictionary *tempDictionary;    /**< 暫存的Dictionary */
    NSArray *sportsItemArray;   /**< 運動項目Array */
    BOOL tempDidUpdateSportItem;    /**< 儲存是否有更新喜愛運動項目 */
    NSInteger totalPictureNumber; /**< 運動照片數量 */
    NSString *selectUserName;   /**< 點擊進來的使用者名稱 */
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
@property (weak, nonatomic) IBOutlet FUIButton *beFriendButton;

@end

@implementation EditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    
    [self settingStyle];

    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" equalTo:currentUser];
    NSArray *usersPostsArray = [query findObjects];
    totalPictureNumber = usersPostsArray.count;
    
    //抓到所有的裝備照片物件
    NSMutableArray *tempImageArray = [NSMutableArray new];
    for (int j = 0; j < totalPictureNumber; j++) {
        for (int i = 2; i < 5; i++) {
            NSString *tempString = [NSString stringWithFormat:@"image%d",i];
            NSObject *tempObject = usersPostsArray[j][tempString];
            if (tempObject == nil) {
                continue;
            }
            [tempImageArray addObject: tempObject];
        }
    }
    NSLog(@"%@",tempImageArray);
    
    
//    self.collectionView.delegate = self;
//    self.collectionView2.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView2.dataSource = self;
    
    [self queryDatabase];
    [self queryselectUserDatabase];
}

- (void)passValue:(NSString *)userNameTextField {
    NSLog(@"aaaaaaaa%@",userNameTextField);
    selectUserName = userNameTextField;
    
}
-(void)settingStyle{
    self.beFriendButton.buttonColor = [UIColor turquoiseColor];
    self.beFriendButton.shadowColor = [UIColor greenSeaColor];
    self.beFriendButton.shadowHeight = 1.0f;
    self.beFriendButton.cornerRadius = 3.0f;
    self.beFriendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.beFriendButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.beFriendButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}
//如果資料有變動更新
-(void)viewDidAppear:(BOOL)animated{
    if (tempDidUpdateSportItem) {
        [self queryDatabase];
    }
}

-(void)queryselectUserDatabase{
//    PFUser *currentUser = [PFUser currentUser];
//    if (currentUser) {
//        // do stuff with the user
//    } else {
//        // show the signup or login screen
//    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:selectUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        // comments now contains the comments for myPost
        for (PFObject *object in comments) {
            NSLog(@"oooooooooo%@,,,%@",object,error);
        }
        
        
    }];
}

-(void)queryDatabase{
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
//    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier2"];
//
//    
//    return cell;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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
//----------------------------------CollectionView-------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    if(view == _collectionView){
        return totalPictureNumber;
    }   //_collectionView2
        return 30;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _collectionView){
        
        //create出CollectionViewCell實體
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sportsCollectionIdentifiers" forIndexPath:indexPath];
        
        //cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
        
        //載入小圖片
        PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
        PFUser *currentUser = [PFUser currentUser];
        [query whereKey:@"user" equalTo:currentUser];
        NSArray *usersPostsArray = [query findObjects];
        //totalPictureNumber = usersPostsArray.count;
        
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
    
    //設cell的背景色為gray
    [cell setBackgroundColor:[UIColor grayColor]];
    
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
    }
}

@end
