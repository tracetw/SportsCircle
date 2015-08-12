//
//  SearchViewController.m
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/4.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
@interface SearchViewController ()
{
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
   
    
    //還要解決search沒輸入時應該下面列表為空
    
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //以下可以辨識點擊哪一行
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell title:%@ and row:%li",cell.textLabel.text,indexPath.row);
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
