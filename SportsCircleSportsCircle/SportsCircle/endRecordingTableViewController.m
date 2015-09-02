//
//  endRecordingTableViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/8/13.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "endRecordingTableViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface endRecordingTableViewController ()
{
    int customSecondTableCellHeight,customThirdTableCellHeight;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (weak, nonatomic) IBOutlet UIImageView *snapshotForImage;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *speedImage;
@property (weak, nonatomic) IBOutlet UIImageView *equitmentImage;
@property (weak, nonatomic) IBOutlet UIImageView *clothesImage;
@property (weak, nonatomic) IBOutlet UIImageView *pantsImage;
@property (weak, nonatomic) IBOutlet UIImageView *shoesImage;
@property (weak, nonatomic) IBOutlet UILabel *locatoinLabel;


@end

@implementation endRecordingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    //PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
    PFObject *sendInObject = [query getObjectWithId:_sendInObjectID];
    
//    PFFile *mainImagePFFile = sendInObject[@"image1"];
//    NSData *mainImageData = [mainImagePFFile getData];
//    UIImage *mainImage = [UIImage imageWithData:mainImageData];
    PFImageView *mainImage = [PFImageView new];
    mainImage.image = [UIImage imageNamed:@"loading"];
    mainImage.file = (PFFile *)sendInObject[@"image1"];
    [mainImage loadInBackground:^(UIImage *image,NSError *error){
        mainImage.image = image;
         _mainImageView.image = mainImage.image;
    }];
    _mainImageView.image = mainImage.image;
    
    PFImageView *equiptmentImage = [PFImageView new];
    equiptmentImage.image = [UIImage imageNamed:@"ball"];
    equiptmentImage.file = (PFFile *)sendInObject[@"image2"];
    [equiptmentImage loadInBackground:^(UIImage *image,NSError *error){
        if (image != nil) {
        equiptmentImage.image = image;
        _equitmentImage.image = equiptmentImage.image;
        }
    }];
    _equitmentImage.image = equiptmentImage.image;
    
    PFImageView *clothesImage = [PFImageView new];
    clothesImage.image = [UIImage imageNamed:@"clothes"];
    clothesImage.file = (PFFile *)sendInObject[@"image3"];
    [clothesImage loadInBackground:^(UIImage *image,NSError *error){
        if (image != nil) {
        clothesImage.image = image;
        _clothesImage.image = clothesImage.image;
        }
    }];
    _clothesImage.image = clothesImage.image;
    
    PFImageView *pantsImage = [PFImageView new];
    pantsImage.image = [UIImage imageNamed:@"pants"];
    pantsImage.file = (PFFile *)sendInObject[@"image4"];
    [pantsImage loadInBackground:^(UIImage *image,NSError *error){
        if (image != nil) {
        pantsImage.image = image;
        _pantsImage.image = pantsImage.image;
        }
    }];
    _pantsImage.image = pantsImage.image;
    
    PFImageView *shoesImage = [PFImageView new];
    shoesImage.image = [UIImage imageNamed:@"shoes"];
    shoesImage.file = (PFFile *)sendInObject[@"image5"];
    [shoesImage loadInBackground:^(UIImage *image,NSError *error){
        if (image != nil) {
        shoesImage.image = image;
        _shoesImage.image = shoesImage.image;
        }
    }];
    _shoesImage.image = shoesImage.image;
    
    NSString *sportType = sendInObject[@"sportsType"];
    _sportTypeImage.image = [UIImage imageNamed:sportType];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *postTime = sendInObject.createdAt;
    NSString *strDate = [dateFormatter stringFromDate:postTime];
    _timeTextLabel.text = strDate;
    
    PFObject *user = sendInObject[@"user"];
    [user fetchInBackground];
    NSString *username = user[@"username"];
    _userName.text = username;
    
//    PFFile *userImagePFFIle = user[@"userImage"];
//    NSData *userImageData = [userImagePFFIle getData];
//    _userImageView.image = [UIImage imageWithData:userImageData];
    PFImageView *userImage = [PFImageView new];
    _userImageView.image = [UIImage imageNamed:@"camera"];
    userImage.file = user[@"userImage"];
    [userImage loadInBackground:^(UIImage *image,NSError *error){
        userImage.image = image;
        _userImageView.image = userImage.image;
    }];
    _contentTextLabel.text = sendInObject[@"content"];
    _locatoinLabel.text = sendInObject[@"location"];
    _calorieLabel.text = sendInObject[@"calories"];
    

    if ([_comingView isEqualToString:@"recordingView"]) {
        self.navigationItem.hidesBackButton = YES;
    }

    if (![_comingView isEqualToString:@"recordingView"]) {
        _countTime = sendInObject[@"recordingTime"];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }

   // _totalTimeLabel.text = sendInObject[@"recordingTime"];

    _totalTimeLabel.text = _countTime;
    [_distanceLabel setHidden:true];
    [_distanceImage setHidden:true];
    [_snapshotForImage setHidden:true];
    [_speedLabel setHidden:true];
    [_speedImage setHidden:true];
    customSecondTableCellHeight = 150;
    customThirdTableCellHeight = 0;
    
    if ([sportType isEqualToString:@"Athletics"] || [sportType isEqualToString:@"Cycling"]) {
        customSecondTableCellHeight = 274;
        customThirdTableCellHeight = 184;
        [_distanceLabel setHidden:false];
        [_distanceImage setHidden:false];
        [_snapshotForImage setHidden:false];
        [_speedLabel setHidden:false];
        [_speedImage setHidden:false];
       
        
        if (![_comingView isEqualToString:@"recordingView"]) {
            
            _distance = sendInObject[@"distance"];
            _speed = sendInObject[@"speed"];
            
            _snapshotForImage.image = [UIImage imageNamed:@"loading"];
            PFImageView *snapshotImage = [PFImageView new];
            snapshotImage.file = sendInObject[@"mapSnapshot"];
            [snapshotImage loadInBackground:^(UIImage *image,NSError *error){
                snapshotImage.image = image;
                _snapshotForImage.image = snapshotImage.image;
            }];
//            PFFile *imageFile = [PFFile new];
//            imageFile = sendInObject[@"mapSnapshot"];
//            NSData *imageData = [imageFile getData];
//            _snapshotForImage.image = [UIImage imageWithData:imageData];
        }else{
            _snapshotForImage.image = _snapshotImage;
        }
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f km",[_distance doubleValue]];
        _speedLabel.text = [NSString stringWithFormat:@" %.1f km/hr",[_speed doubleValue]];
        
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor=[UIColor clearColor];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 466;
    }else if (indexPath.row == 1)
    {
    return customSecondTableCellHeight;
    }else if (indexPath.row == 2)
        return customThirdTableCellHeight;
    else{
        return 125;
    }
}

-(void)getObjectID:(NSString*)objectID{
    
    _sendInObjectID = objectID;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
