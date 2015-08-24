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
#import "RecordingViewController.h"
#import "searchLocationViewController.h"

typedef enum {
    cameraCategory1,
    cameraCategory2,
    cameraCategory3,
    cameraCategory4,
    cameraCategory5
}cameraCategory;

@interface PostMainViewController ()<AKPickerViewDataSource, AKPickerViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSString *locationStr;
    UIImage *image1,*image2,*image3,*image4,*image5,*imageX;
    NSData *imageData;
}
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UILabel *sportsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *ballBtn;
@property (weak, nonatomic) IBOutlet UIButton *TshirtBtn;
@property (weak, nonatomic) IBOutlet UIButton *PantsBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoesBtn;
@property (strong, nonatomic) IBOutlet UIView *postMainView;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

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
    self.titles = @[@"Other",
                    @"Archery",
                    @"Athletics",
                    @"Badminton",
                    @"Basketball",
                    @"Beach Volleyball",
                    @"Cycling",
                    @"Diving",
                    @"Equestrian",
                    @"Fencing",
                    @"Football",
                    @"Gymnastics",
                    @"Handball",
                    @"Hockey",
                    @"Judo",
                    @"Rowing",
                    @"Sailing",
                    @"Shooting",
                    @"Swimming",
                    @"Synchronised Swimming",
                    @"Table Tennis",
                    @"Taekwondo",
                    @"Tennis",
                    @"Trampoline",
                    @"Volleyball",
                    @"Water Polo",
                    @"Weightlifting",
                    @"Wrestling",@""];
    
    [self.pickerView reloadData];
    [self.view sendSubviewToBack:_pickerView];
    
    //顯示時間
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"EEE d MMM h m a"];
    NSDate *today=[NSDate date];
    _infoLabel.text=[format stringFromDate:today];
    
    //相機
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState: UIControlStateNormal];//用圖片在按鈕上

    // initialize popover view
    popView = [[[NSBundle mainBundle] loadNibNamed:@"PopView" owner:nil options:nil] lastObject];
    [popView.popPicBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];

//    [popView.popPicBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView2 = [[[NSBundle mainBundle] loadNibNamed:@"PopView2" owner:nil options:nil] lastObject];
    [popView2.popPicBtn2 setImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView3 = [[[NSBundle mainBundle] loadNibNamed:@"PopView3" owner:nil options:nil] lastObject];
    [popView3.popPicBtn3 setImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    popView4 = [[[NSBundle mainBundle] loadNibNamed:@"PopView4" owner:nil options:nil] lastObject];
    [popView4.popPicBtn4 setImage:[UIImage imageNamed:@"camera"] forState: UIControlStateNormal];
    //手勢操作
//    UITapGestureRecognizer *toTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTap)];
//    [_ballBtn addGestureRecognizer:toTap];
    
    //允許ImageView接受使用者互動
//    _ballBtn.userInteractionEnabled = YES;

    //以下為popPicBtn新增連結
//    UITapGestureRecognizer *singleTap1 =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPicBtnPressed:)];
//    
//
//    [popView.popPicBtn addGestureRecognizer:singleTap1];
//    [cell.userImage addGestureRecognizer:singleTap2];
//    popView.popPicBtn.tag = 1;

    //添加背景點擊事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardResign)];
    //recognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:recognizer];
    self.view.userInteractionEnabled = YES;
    
//    [popView.popPicBtn addTarget:self action:@selector(logsomething) forControlEvents:UIControlEventTouchUpInside];
//    [popView setUserInteractionEnabled:TRUE];
//    [popView.popPicBtn setUserInteractionEnabled:YES];
    //[cell.userImage setUserInteractionEnabled:TRUE];
    
}

//點擊空白處收起鍵盤
- (void)keyboardResign {
    [self.view endEditing:YES];
    [popView removeFromSuperview];
    [popView2 removeFromSuperview];
    [popView3 removeFromSuperview];
    [popView4 removeFromSuperview];

}

//-(void)toTap {
//    [popView removeFromSuperview];
//    [popView2 removeFromSuperview];
//    [popView3 removeFromSuperview];
//    [popView4 removeFromSuperview];
//    
//}

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
    [[NSUserDefaults standardUserDefaults] setInteger:cameraCategory1 forKey:@"cameraCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"cameraCategory"] == cameraCategory1)
    {
        //取得使用者的相片
        image1=[info valueForKey:UIImagePickerControllerOriginalImage];
        //存檔
        UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
        //按鈕的背景換成剛拍下來的照片
        [_cameraBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [_cameraBtn setFrame:CGRectMake(0, 0, 90, 90)];
        //關閉拍照
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"cameraCategory"] == cameraCategory2)
    {
        //取得使用者的相片
        image2=[info valueForKey:UIImagePickerControllerOriginalImage];
        //存檔
        UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
        //按鈕的背景換成剛拍下來的照片
        [_ballBtn setTitle:@"" forState:UIControlStateNormal];
        [_ballBtn setBackgroundImage:image2 forState:UIControlStateNormal];
        [_ballBtn setFrame:CGRectMake(0, 0, 60, 60)];

        //關閉拍照
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"cameraCategory"] == cameraCategory3)
    {
        //取得使用者的相片
        image3=[info valueForKey:UIImagePickerControllerOriginalImage];
        //存檔
        UIImageWriteToSavedPhotosAlbum(image3, nil, nil, nil);
        //按鈕的背景換成剛拍下來的照片
        [_TshirtBtn setTitle:@"" forState:UIControlStateNormal];
        [_TshirtBtn setBackgroundImage:image3 forState:UIControlStateNormal];
        [_TshirtBtn setFrame:CGRectMake(0, 0, 60, 60)];
        //關閉拍照
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"cameraCategory"] == cameraCategory4)
    {
        //取得使用者的相片
        image4=[info valueForKey:UIImagePickerControllerOriginalImage];
        //存檔
        UIImageWriteToSavedPhotosAlbum(image4, nil, nil, nil);
        //按鈕的背景換成剛拍下來的照片
        [_PantsBtn setTitle:@"" forState:UIControlStateNormal];
        [_PantsBtn setBackgroundImage:image4 forState:UIControlStateNormal];
        [_PantsBtn setFrame:CGRectMake(0, 0, 60, 60)];
        //關閉拍照
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"cameraCategory"] == cameraCategory5)
    {
        //取得使用者的相片
        image5=[info valueForKey:UIImagePickerControllerOriginalImage];
        //存檔
        UIImageWriteToSavedPhotosAlbum(image5, nil, nil, nil);
        //按鈕的背景換成剛拍下來的照片
        [_shoesBtn setTitle:@"" forState:UIControlStateNormal];
        [_shoesBtn setBackgroundImage:image5 forState:UIControlStateNormal];
        [_shoesBtn setFrame:CGRectMake(0, 0, 60, 60)];
        //關閉拍照
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    
    CGRect rect=CGRectMake(135, 385, 50, 50);
    [popView setFrame:rect];
    [popView setUserInteractionEnabled:YES];
    [popView.popPicBtn setUserInteractionEnabled:YES];
//    [popView.popPicBtn addTarget:self action:@selector(logsomething) forControlEvents:UIControlEventTouchUpInside];
    [popView.popPicBtn addTarget:self action:@selector(popPicBtn2Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView.bgOfPopView setUserInteractionEnabled:YES];
    [popView bringSubviewToFront:popView.popPicBtn];
    [self.view addSubview:popView];
//    [self.view bringSubviewToFront:popView];
//    [self.view bringSubviewToFront:popView];

//    UIButton * button = (UIButton*)sender;
//    CGPoint btn_point = button.frame.origin;
//    CGRect rect = CGRectZero;
//    rect.origin = btn_point;
//    rect.size = CGSizeMake(50, 50);
    //上面是蛤蜊教的
    
    [popView2 removeFromSuperview];
    [popView3 removeFromSuperview];
    [popView4 removeFromSuperview];

}
-(void)popPicBtn2Pressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:cameraCategory2 forKey:@"cameraCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (IBAction)TshirtBtnPressed:(id)sender {
    CGRect rect=CGRectMake(203, 385, 50, 50);
    [popView2 setFrame:rect];
    [popView2 setUserInteractionEnabled:YES];
    [popView2.popPicBtn2 setUserInteractionEnabled:YES];
    //    [popView.popPicBtn addTarget:self action:@selector(logsomething) forControlEvents:UIControlEventTouchUpInside];
    [popView2.popPicBtn2 addTarget:self action:@selector(popPicBtn3Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView2.bgOfPopView2 setUserInteractionEnabled:YES];
    [popView2 bringSubviewToFront:popView2.popPicBtn2];
    [self.view addSubview:popView2];
    
    
    [popView removeFromSuperview];
    [popView3 removeFromSuperview];
    [popView4 removeFromSuperview];

}

-(void)popPicBtn3Pressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:cameraCategory3 forKey:@"cameraCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (IBAction)PantsBtnPressed:(id)sender {
    CGRect rect=CGRectMake(271, 385, 50, 50);
    [popView3 setFrame:rect];
    [popView3 setUserInteractionEnabled:YES];
    [popView3.popPicBtn3 setUserInteractionEnabled:YES];
    //    [popView.popPicBtn addTarget:self action:@selector(logsomething) forControlEvents:UIControlEventTouchUpInside];
    [popView3.popPicBtn3 addTarget:self action:@selector(popPicBtn4Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView3.bgOfPopView3 setUserInteractionEnabled:YES];
    [popView3 bringSubviewToFront:popView3.popPicBtn3];
    [self.view addSubview:popView3];
    
    [popView removeFromSuperview];
    [popView2 removeFromSuperview];
    [popView4 removeFromSuperview];

}

-(void)popPicBtn4Pressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:cameraCategory4 forKey:@"cameraCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
- (IBAction)shoesBtnPressed:(id)sender {
    CGRect rect=CGRectMake(311, 385, 50, 50);
    [popView4 setFrame:rect];
    [popView4 setUserInteractionEnabled:YES];
    [popView4.popPicBtn4 setUserInteractionEnabled:YES];
    //    [popView.popPicBtn addTarget:self action:@selector(logsomething) forControlEvents:UIControlEventTouchUpInside];
    [popView4.popPicBtn4 addTarget:self action:@selector(popPicBtn5Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [popView4.bgOfPopView4 setUserInteractionEnabled:YES];
    [popView4 bringSubviewToFront:popView4.popPicBtn4];
    [self.view addSubview:popView4];

    
    [popView removeFromSuperview];
    [popView2 removeFromSuperview];
    [popView3 removeFromSuperview];

}

-(void)popPicBtn5Pressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:cameraCategory5 forKey:@"cameraCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (IBAction)goBtnPressed:(id)sender {
    //當按下按鈕～將資料上傳到wallpost
    
    if ([PFUser currentUser]) {
        PFObject *wallpost = [PFObject objectWithClassName:@"WallPost"];
        
        imageData = UIImageJPEGRepresentation(image1,0.1);
        PFFile *imageFile = [PFFile fileWithName:@"image.jpeg" data:imageData];
        if (image1==nil) {
            imageX= [UIImage imageNamed:@"sport mix 5"];
            NSData *imageData2 = UIImageJPEGRepresentation(imageX,0.1);
            PFFile *imageFile2 = [PFFile fileWithName:@"image.jpeg" data:imageData2];
            wallpost[@"image1"] = imageFile2;
        }else{
            wallpost[@"image1"] = imageFile;
        }
//        NSData *imageData1 = UIImagePNGRepresentation(_cameraBtn.imageView.image);
//        PFFile *pic = [PFFile fileWithName:@"image1.png" data:imageData1];
//        PFQuery *query = [PFQuery queryWithClassName:@"WallPost"];
//        [query whereKey:@"username" equalTo:[[PFUser currentUser] valueForKey:@"username"]];
//        PFObject *object =  [[NSArray arrayWithArray:[query findObjects]]lastObject];
//        [object setValue:pic forKey:@"image1"];
//        [object saveInBackground];

        
        NSData *imageData2 = UIImageJPEGRepresentation(image2,0.1);
        PFFile *imageFile2 = [PFFile fileWithName:@"image.jpeg" data:imageData2];
        if (image2==nil) {

        }else{
            wallpost[@"image2"] = imageFile2;
        }

        
        NSData *imageData3 = UIImageJPEGRepresentation(image3,0.1);
        PFFile *imageFile3 = [PFFile fileWithName:@"image.jpeg" data:imageData3];
        if (image3==nil) {

        }else{
            wallpost[@"image3"] = imageFile3;
        }
        
        NSData *imageData4 = UIImageJPEGRepresentation(image4,0.1);
        PFFile *imageFile4 = [PFFile fileWithName:@"image.jpeg" data:imageData4];
        if (image4==nil) {

        }else{
            wallpost[@"image4"] = imageFile4;
        }
        
        NSData *imageData5 = UIImageJPEGRepresentation(image5,0.1);
        PFFile *imageFile5 = [PFFile fileWithName:@"image.jpeg" data:imageData5];
        if (image5==nil) {
        
        }else{
            wallpost[@"image5"] = imageFile5;
        }

        
        if (_contentTextField.text==nil) {
            wallpost[@"content"] = @"";
        }else{
            wallpost[@"content"] = _contentTextField.text;
        }
        //wallpost[@"content"]=_contentTextField.text;


        NSNumberFormatter *lat = [[NSNumberFormatter alloc] init];
        lat.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *latNumber = [lat numberFromString:latitudeStr];
        if (latNumber==nil) {
            //wallpost[@"latitude"]=@"";
        }else{
            wallpost[@"latitude"]=latNumber;
        }
        
        NSNumberFormatter *lon = [[NSNumberFormatter alloc] init];
        lon.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *lonNumber = [lon numberFromString:longitudeStr];
        if (lonNumber==nil) {
            //wallpost[@"longitude"]=@"";
        }else{
            wallpost[@"longitude"]=lonNumber;
        }
        
        if (locationStr==nil) {
            wallpost[@"location"]=@"";
        }else{
            wallpost[@"location"]=locationStr;
        }
        if ([_sportsNameLabel.text isEqualToString:@"請選擇用動項目"]) {
            wallpost[@"sportsType"]=@"Other";
        }else{
        wallpost[@"sportsType"]=_sportsNameLabel.text;
        }
        //userName[@"cheatMode"] = @NO;
        //        PFRelation * relation = [[PFRelation alloc] init];
        //        [relation addObject:[PFUser currentUser]];
        wallpost[@"user"] = [PFUser currentUser];//連結現在登入的使用者id
        [wallpost saveInBackground];
    }
    //等連結街設定完再開啟
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RecordingViewController *view = [segue destinationViewController];
    NSString *sportName = _sportsNameLabel.text;
    if ([sportName isEqualToString:@"請選擇用動項目"]) {
        sportName = @"Other";
    }
    
    [view getSportType:sportName];
    UIImage *mainImage = [UIImage new];
    if (imageData == nil) {
        mainImage = [UIImage imageNamed:@"xib.png"];
    }else{
        mainImage = [UIImage imageWithData:imageData];
    }
    
    [view getMainImage:mainImage];
}

- (IBAction)locationBtnPressed:(id)sender
{
    searchLocationViewController * viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"searchLocationViewController"];
    viewcontroller.block = ^void(NSString*response,NSString*string2,NSString*string3,NSString*userLat,NSString*userLon){
        //設一個字串～把空白去掉
        NSString *responseStr = [response stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (responseStr.length==0) {
            locationStr=[NSString stringWithFormat:@"使用者當前位置"];
        }else{
            locationStr=response;
        }
        [_locationBtn setTitle:locationStr forState:UIControlStateNormal];
        NSLog(@"%@~~~ %@ and %@ | %@ and %@ ",response,string2,string3,userLat,userLon);//latitude=str2 longitude=str3
        
        if (string2==nil) {
            latitudeStr=userLat;
        }else{
            latitudeStr=string2;
        }
        if (string3==nil) {
            longitudeStr=userLon;
        }else{
            longitudeStr=string3;
        }

    };
    [self.navigationController pushViewController:viewcontroller animated:YES];

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
