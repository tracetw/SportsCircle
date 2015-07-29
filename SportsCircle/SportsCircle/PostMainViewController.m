//
//  PostMainViewController.m
//  SportsCircle
//
//  Created by Charles Wang on 2015/7/28.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "PostMainViewController.h"
#import "AKPickerView.h"
@interface PostMainViewController ()<AKPickerViewDataSource, AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UILabel *sportsNameLabel;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
