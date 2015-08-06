//
//  PostMainViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/7/28.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PostMainViewController.h"
#import "AKPickerView.h"
#import <Parse/Parse.h>

@interface PostMainViewController ()<AKPickerViewDataSource, AKPickerViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UILabel *sportsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (strong, nonatomic) IBOutlet UIView *postMainView;

@end

@implementation PostMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    //顯示時間
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"EEE d MMM h m a"];
    NSDate *today=[NSDate date];
    _infoLabel.text=[format stringFromDate:today];
    
    //相機
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState: UIControlStateNormal];//用圖片在按鈕上
    
    //手勢操作
    UITapGestureRecognizer *toTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTap)];
    [_postMainView addGestureRecognizer:toTap];
    
    //允許ImageView接受使用者互動
    _postMainView.userInteractionEnabled = YES;
    
    // initialize popover view
    popView = [[[NSBundle mainBundle] loadNibNamed:@"PopView" owner:nil options:nil] lastObject];
    [popView.popPicBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView2 = [[[NSBundle mainBundle] loadNibNamed:@"PopView2" owner:nil options:nil] lastObject];
    [popView2.popPicBtn2 setBackgroundImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView3 = [[[NSBundle mainBundle] loadNibNamed:@"PopView3" owner:nil options:nil] lastObject];
    [popView3.popPicBtn3 setBackgroundImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView4 = [[[NSBundle mainBundle] loadNibNamed:@"PopView4" owner:nil options:nil] lastObject];
    [popView4.popPicBtn4 setBackgroundImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    
}

-(void)toTap {
    if (!popView.isHidden) {
        [popView removeFromSuperview];
        [popView2 removeFromSuperview];
        [popView3 removeFromSuperview];
        [popView4 removeFromSuperview];
    }
}

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
    NSLog(@"%@", self.titles[item]);
    _sportsNameLabel.text = self.titles[item];
    
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}

- (IBAction)theCameraBtnPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        
        //設定相片來源為裝置上的相機
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //設定imagePicker的delegate為viewcontroller
        imagePicker.delegate=self;
        //開啟相機拍照介面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
//相機開啟後～使用者可以選擇拍照或取消 選拍照時
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取得使用者的相片
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    //存檔
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    //關閉拍照
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //按鈕的背景換成剛拍下來的照片
    [_cameraBtn setBackgroundImage:image forState:UIControlStateNormal];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //當使用者按下取消後關閉拍照
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)ballBtnPressed:(id)sender
{
    //    UIPopoverController *pop=[[UIPopoverController alloc]initWithContentViewController:popView];
    //    [pop setDelegate:self];
    //    [pop presentPopoverFromRect:popBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    //設定popover的位置跟
    
    //UIButton * button = (UIButton*)sender;
    //CGPoint btn_point = button.frame.origin;
    //CGRect rect = CGRectZero;
    //rect.origin = btn_point;
    //rect.size = CGSizeMake(50, 50);
    //上面是蛤蜊教的
    
    CGRect rect=CGRectMake(100, 331, 50, 50);
    [popView setFrame:rect];
    [self.view addSubview:popView];
    [self.view sendSubviewToBack:popView];
    
    [popView2 removeFromSuperview];
    [popView3 removeFromSuperview];
    [popView4 removeFromSuperview];
    
}

- (IBAction)TshirtBtnPressed:(id)sender {
    CGRect rect=CGRectMake(165, 331, 50, 50);
    [popView2 setFrame:rect];
    [self.view addSubview:popView2];
    [self.view sendSubviewToBack:popView2];
    
    [popView removeFromSuperview];
    [popView3 removeFromSuperview];
    [popView4 removeFromSuperview];
}
- (IBAction)PantsBtnPressed:(id)sender {
    CGRect rect=CGRectMake(230, 331, 50, 50);
    [popView3 setFrame:rect];
    [self.view addSubview:popView3];
    [self.view sendSubviewToBack:popView3];
    
    [popView removeFromSuperview];
    [popView2 removeFromSuperview];
    [popView4 removeFromSuperview];
}
- (IBAction)shoesBtnPressed:(id)sender {
    CGRect rect=CGRectMake(295, 331, 50, 50);
    [popView4 setFrame:rect];
    [self.view addSubview:popView4];
    [self.view sendSubviewToBack:popView4];
    
    [popView removeFromSuperview];
    [popView2 removeFromSuperview];
    [popView3 removeFromSuperview];
}


- (IBAction)goBtnPressed:(id)sender {
    //當按下按鈕～將資料上傳到wallpost
    /*
    if ([PFUser currentUser]) {
        PFObject *userName = [PFObject objectWithClassName:@"WallPost"];
        userName[@"image1"] =@"";
        userName[@"image2"] =@"";
        userName[@"image3"]=@"";
        userName[@"image4"]=@"";
        userName[@"image5"]=@"";
        userName[@"like"]=@"";
        userName[@"content"]=@"";
        userName[@"latitude"]=@"";
        userName[@"longitude"]=@"";
        userName[@"sportsType"]=@"";
        //userName[@"cheatMode"] = @NO;
        //        PFRelation * relation = [[PFRelation alloc] init];
        //        [relation addObject:[PFUser currentUser]];
        userName[@"user"] = [PFUser currentUser];//連結現在登入的使用者id
        [userName saveInBackground];
    }
    *///等連結街設定完再開啟
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
