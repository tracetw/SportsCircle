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
@interface EditProfileTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *profileDictionary; /**< 存個人資料包在Array裡面 */
    NSMutableArray *profileAndPictureArray; /**< 存個人資料及照片 */
    NSMutableDictionary *tempDictionary;    /**< 暫存的Dictionary */
}
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *heightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *weightCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *habitCell;

@end

@implementation EditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
//
//    
//    
//    //查詢資料庫
//    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
//    [query whereKey:@"user" equalTo:user];
//    NSArray* scoreArray = [query findObjects];
//    NSDictionary *myDictionary = scoreArray[0];
//    [myDictionary objectForKey:@"gender"];
//    [myDictionary objectForKey:@"age"];
//    [myDictionary objectForKey:@"height"];
//    [myDictionary objectForKey:@"weight"];
//    NSArray *sportsItemArray = [myDictionary objectForKey:@"habit"];
//    //NSLog(@"%@",[myDictionary objectForKey:@"age"]);
//    
//    //顯示資料至cell.textlabel
//    if ([FBSDKAccessToken currentAccessToken]) {
//        NSString *title = [NSString stringWithFormat:@" %@", [FBSDKProfile currentProfile].name];
//        _nameCell.textLabel.text = [NSString stringWithFormat:@"姓名：%@",title];
//    }
//    
//    if ([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"1"]) {
//        _genderCell.textLabel.text = @"性別：男性";
//    }else if([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"2"]){
//        _genderCell.textLabel.text = @"性別：女性";
//    }else{
//        //....
//    }
//    _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡：%@",[myDictionary objectForKey:@"age"]];
//    _heightCell.textLabel.text = [NSString stringWithFormat:@"身高：%@",[myDictionary objectForKey:@"height"]];
//    _weightCell.textLabel.text = [NSString stringWithFormat:@"體重：%@",[myDictionary objectForKey:@"weight"]];
//    
//    
//    NSString *sportsItemString;
//    for (NSString *object in sportsItemArray) {
//        NSLog(@"%@\n",object);
//        if (sportsItemString == nil) {
//            sportsItemString = [NSString stringWithFormat:@"%@",object];
//            continue;
//        }
//        sportsItemString = [NSString stringWithFormat:@"%@, %@",sportsItemString, object];
//    }
//    NSLog(@"%@\n",sportsItemString);
//    
//    _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動：%@",sportsItemString];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    //查詢資料庫
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
    NSDictionary *myDictionary = scoreArray[0];
    [myDictionary objectForKey:@"gender"];
    [myDictionary objectForKey:@"age"];
    [myDictionary objectForKey:@"height"];
    [myDictionary objectForKey:@"weight"];
    NSArray *sportsItemArray = [myDictionary objectForKey:@"habit"];
    //NSLog(@"%@",[myDictionary objectForKey:@"age"]);
    
    //顯示資料至cell.textlabel
    if ([FBSDKAccessToken currentAccessToken]) {
        NSString *title = [NSString stringWithFormat:@" %@", [FBSDKProfile currentProfile].name];
        _nameCell.textLabel.text = [NSString stringWithFormat:@"姓名：%@",title];
    }
    
    if ([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"1"]) {
        _genderCell.textLabel.text = @"性別：男性";
    }else if([[NSString stringWithFormat:@"%@",[myDictionary objectForKey:@"gender"]] isEqualToString:@"2"]){
        _genderCell.textLabel.text = @"性別：女性";
    }else{
        //....
    }
    _ageCell.textLabel.text = [NSString stringWithFormat:@"年齡：%@",[myDictionary objectForKey:@"age"]];
    _heightCell.textLabel.text = [NSString stringWithFormat:@"身高：%@",[myDictionary objectForKey:@"height"]];
    _weightCell.textLabel.text = [NSString stringWithFormat:@"體重：%@",[myDictionary objectForKey:@"weight"]];
    
    
    NSString *sportsItemString;
    for (NSString *object in sportsItemArray) {
        NSLog(@"%@\n",object);
        if (sportsItemString == nil) {
            sportsItemString = [NSString stringWithFormat:@"%@",object];
            continue;
        }
        sportsItemString = [NSString stringWithFormat:@"%@, %@",sportsItemString, object];
    }
    NSLog(@"%@\n",sportsItemString);
    
    _habitCell.textLabel.text = [NSString stringWithFormat:@"喜好運動：%@",sportsItemString];
}

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
            NSLog(@"0");
            break;
        case 1:{
            NSLog(@"1");
            

 
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
            NSLog(@"2");
            break;
        case 3:{
            
            [self askValueWithTitle:@"年齡：" withMessage:@"請輸入年齡更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"年齡：%@",[NSString stringWithFormat:@"%d",value]];
                    [self updateParseData:@"age" withValue:value];
                }
            }];
            
            NSLog(@"3");
        }
            
            break;
        case 4:{
            
            [self askValueWithTitle:@"身高：" withMessage:@"請輸入身高更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"身高：%@",[NSString stringWithFormat:@"%d",value]];
                        [self updateParseData:@"height" withValue:value];
                    
                }
            }];
            
            
        }
            NSLog(@"4");
            break;
        case 5:{
            
            [self askValueWithTitle:@"體重：" withMessage:@"請輸入體重更新個人資訊" withDefaultValue:@"" completion:^(int value, bool success) {
                if(success == NO || value == 0){
                    return;
                }else{
                    NSLog(@"%d",value);
                    cell.textLabel.text =[NSString stringWithFormat:@"體重：%@",[NSString stringWithFormat:@"%d",value]];
                    [self updateParseData:@"weight" withValue:value];
                }
            }];
            
        }
            NSLog(@"5");
            break;
        case 6:{
            
        }
            NSLog(@"6");
            break;
        case 7:{
            
        }
            NSLog(@"7");
            break;
        case 8:{
            
        }
            NSLog(@"8");
            break;
        default:
            break;
    }
}

//更新Parse個人資料
-(void)updateParseData:(NSString*)profileClass withValue:(int)value{
    NSLog(@"%@     %d",profileClass,value);
    //查詢資料庫
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
    NSDictionary *myDictionary = scoreArray[0];
    PFObject *persionalInfoObject = scoreArray[0];
    
    //查詢物件
    NSLog(@"%@%@%@",scoreArray[0], persionalInfoObject.objectId, [myDictionary objectForKey:profileClass]);
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

@end
