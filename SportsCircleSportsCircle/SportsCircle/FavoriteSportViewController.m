//
//  FavoriteSportViewController.m
//  SportsCircle
//
//  Created by  tracetw on 2015/8/6.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "FavoriteSportViewController.h"
#import "AKPickerView.h"
#import <Parse/Parse.h>
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06

@interface FavoriteSportViewController ()<AKPickerViewDelegate, AKPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * sportsItemArray;   /**< 運動項目陣列 */
    NSString *getSportsName;    /**< 選中的運動項目 */
    BOOL didUpdateItem;
<<<<<<< HEAD
=======
=======
@interface FavoriteSportViewController ()<AKPickerViewDelegate, AKPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * sportsItemArray;   /**< 運動項目陣列 */
    NSString *getSportsName;    /**< 選中的運動項目 */
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UILabel *sportsNameLabel;
@end

@implementation FavoriteSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_tableView.delegate= self;
    //_tableView.dataSource = self;
    [self.view addSubview:_tableView];

    //查詢資料庫，丟到Array裡
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
    NSDictionary *myDictionary = scoreArray[0];
    sportsItemArray = [myDictionary objectForKey:@"habit"];
    
    
    
    //------------------------------------------------------------------------------------------
    // Do any additional setup after loading the view.
    //ImagePicker顯示位置在“AKPickerView.m”裡面修改
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pickerView];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.maskDisabled = false;
    
    //運動項目名稱必須配合相同的圖片標題
    self.titles = @[@"Archery",
                    @"Athletics",
                    @"Badminton",
                    @"Basketball",
                    @"Beach Volleyball",
                    @"Canoe Slalom",
                    @"Canoe Sprint",
                    @"Cycling BMX",
                    @"Cycling Mountain Bike",
                    @"Cycling Road",
                    @"Cycling Track",
                    @"Diving",
                    @"Equestrian",
                    @"Fencing",
                    @"Football",
                    @"Gymnastics Artistic",
                    @"Gymnastics Rhythmic",
                    @"Handball",
                    @"Hockey",
                    @"Judo",
                    @"Modern Pentathlon",
                    @"Rowing",
                    @"Sailing",
                    @"Shooting",
                    @"Swimming",
                    @"Synchronised Swimming",
                    @"Table Tennisv",
                    @"Taekwondo",
                    @"Tennis",
                    @"Trampoline",
                    @"Triathlon",
                    @"Voleyball",
                    @"Waterpolp",
                    @"Weightliftling",
                    @"Wrestling"];
    
    [self.pickerView reloadData];
    [self.view sendSubviewToBack:_pickerView];
}

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
//返回的傳回值，如果有新增刪除過資料，返回YES
-(void)viewWillDisappear:(BOOL)animated
{
    self.block(didUpdateItem);
}
<<<<<<< HEAD
=======
=======
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06

//-------------------------------------Parse-----------------------------------------------------



//查詢資料
//存到可變動ＡＲＲＡＹ
//
//點擊新增一筆資料
//可變動ＡＲＲＡＹ增加一筆
//更新資料庫
//
//刪除一筆資料
//可變動ＡＲＲＡＹ減少一筆
//更新資料庫

//更新Parse個人資料
-(void)updateParseData:(NSString*)profileClass withValue:(NSMutableArray *)value{
<<<<<<< HEAD
    
=======
<<<<<<< HEAD
    
=======
    NSLog(@"%@     %@",profileClass,value);
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    //查詢資料庫
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PersionalInfo"];
    [query whereKey:@"user" equalTo:user];
    NSArray* scoreArray = [query findObjects];
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    //NSDictionary *myDictionary = scoreArray[0];
    PFObject *persionalInfoObject = scoreArray[0];
    
    //查詢物件
    //NSLog(@"%@%@%@",scoreArray[0], persionalInfoObject.objectId, [myDictionary objectForKey:profileClass]);
<<<<<<< HEAD
=======
=======
    NSDictionary *myDictionary = scoreArray[0];
    PFObject *persionalInfoObject = scoreArray[0];
    
    //查詢物件
    NSLog(@"%@%@%@",scoreArray[0], persionalInfoObject.objectId, [myDictionary objectForKey:profileClass]);
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    //更新物件
    [query getObjectInBackgroundWithId:persionalInfoObject.objectId block:^(PFObject *tempObject, NSError *error) {
        tempObject[profileClass] = value;
        [tempObject saveInBackground];
    }];
}
//--------------------------------------UITableView----------------------------------------------------
- (IBAction)addNewSportItemBtnPressed:(id)sender {
    [self insertNewObject:sender];
    
}

- (void)insertNewObject:(id)sender {
    if (getSportsName == nil) {
        return;
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    }else if(sportsItemArray == nil || sportsItemArray.count == 0){
        sportsItemArray = [NSMutableArray new];
    }
    didUpdateItem = YES;    //資料有變動
<<<<<<< HEAD
=======
=======
    }
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    NSString *numbers = getSportsName;
    [sportsItemArray insertObject:numbers atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self updateParseData:@"habit" withValue:sportsItemArray];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
<<<<<<< HEAD
    if (sportsItemArray == nil || sportsItemArray.count == 0) {
        return 0;
    }
=======
<<<<<<< HEAD
    if (sportsItemArray == nil || sportsItemArray.count == 0) {
        return 0;
    }
=======
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    return sportsItemArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@qqqqqq%@",cell,indexPath);
=======
<<<<<<< HEAD
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@qqqqqq%@",cell,indexPath);
=======
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@qqqqqq%@",cell,indexPath);
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    UITableViewCell * cell = [UITableViewCell new];
//    NSDate *object = ChildArr[indexPath.row];
//    cell.textLabel.text = [object description];
    
    UITableViewCell * cell = [UITableViewCell new];
    cell.textLabel.text = [sportsItemArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
<<<<<<< HEAD
        didUpdateItem = YES;    //資料有變動
=======
<<<<<<< HEAD
        didUpdateItem = YES;    //資料有變動
=======
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
        [sportsItemArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self updateParseData:@"habit" withValue:sportsItemArray];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
//---------------------------------ImagePicker---------------------------------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */
/*
 - (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
 {
	return self.titles[item];
 }
 */

- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
{
    return [UIImage imageNamed:self.titles[item]];
}


#pragma mark - AKPickerViewDelegate
//選中的運動名稱
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
<<<<<<< HEAD
    //NSLog(@"%@", self.titles[item]);
=======
<<<<<<< HEAD
    //NSLog(@"%@", self.titles[item]);
=======
    NSLog(@"%@", self.titles[item]);
>>>>>>> bc471434b421d0c2ce035a7603485e478503eda2
>>>>>>> 052f00c3e243e5d8a160474722547109e982df06
    _sportsNameLabel.text = self.titles[item];
    getSportsName = self.titles[item];
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
