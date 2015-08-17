//
//  SearchViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/4.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import <Parse/Parse.h>
#import "PersonalPageViewController.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *datas;
    PFQuery *query;
    NSString *searchText2;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _searchBar.delegate=self;
    
    //PFUser *currentUser=[PFUser currentUser];//抓到目前user的objId
    query = [PFQuery queryWithClassName:@"_User"];
    //query為指向sc類別
    //[query whereKey:@"user" equalTo:currentUser];
    //類別為sc且key為user時value為currentUser
  
    NSArray *userData = [query findObjects];//抓出資料有五筆
    
    totalString=[[NSMutableArray alloc]initWithObjects:nil];
    for (PFObject *object in userData) {
        NSString *Uname = [object objectForKey:@"username"];
        [totalString addObject:Uname];
    }
    
   // for (NSInteger i=0; i<=userData.count; i++)
   // {
        //NSDictionary *UserNameDictionary=userData[i];
   //     NSString *Uname = [userData[i] objectForKey:@"usernameX"];
   //     [totalString addObject:Uname];
   //因為Uname不能自動為Uname1~5 }
   
    datas=[[NSMutableArray alloc]init];
    for (PFObject *object in userData) {
        [datas addObject:object];
    }
    
    UIColor *backgroundColor = [UIColor colorWithRed:165/255.0 green:163/255.0 blue:165/255.0 alpha:0.23];
    self.tableView.backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = backgroundColor;
    
<<<<<<< HEAD
    self.tableView.separatorColor=[UIColor clearColor];
=======
    //添加背景點擊事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardResign)];
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
}

//點擊空白處收起鍵盤
- (void)keyboardResign {
    [self.view endEditing:YES];
>>>>>>> e574c97d86047c7dff8a013194ce111a25ef1745
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_tableView resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchText2 = searchText;
    if (searchText.length==0) {
        isFiltered=NO;
        //這裏根本沒跑進來啊？
    }else{
        isFiltered=YES;
        filteredStr=[[NSMutableArray alloc]init];
        for (NSString *str in totalString) {
            NSRange range=[str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location !=NSNotFound) {
                [filteredStr addObject:str];
            }
        }
    }
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered) {
        return filteredStr.count;
    }
    return totalString.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (!isFiltered) {
        cell.textLabel.text=[totalString objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text=[filteredStr objectAtIndex:indexPath.row];
    }
    if (searchText2.length==0) {
        [cell setHidden:YES];
    }else{
        [cell setHidden:NO];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //以下可以辨識點擊哪一行
    //UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"cell title:%@ and row:%li",cell.textLabel.text,indexPath.row);
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
if ([[segue identifier] isEqualToString:@"goPersonalPage"])
{

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSArray *object=[totalString objectAtIndex:indexPath.row];
        PFObject * object = [datas objectAtIndex:indexPath.row];
        //NSLog(@"object:%@",object);
        NSString *objectCellId =object[@"username"];
        //NSString *id1=[NSString stringWithFormat:@"%@",objectCellId];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"cell title:%ld , row:%li and objectId:%@",(long)cell.textLabel.text,indexPath.row,objectCellId);
        
        //NSDate *object = datas[indexPath.row];
        PersonalPageViewController *controller = (PersonalPageViewController *)[segue destinationViewController];
        [controller passData:cell.textLabel.text];
    }
}


@end
