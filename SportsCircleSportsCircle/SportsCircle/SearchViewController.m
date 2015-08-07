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


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      /* PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:@"vito"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
 */
    PFQuery *query = [PFQuery queryWithClassName:@"schedule"];
    [query whereKey:@"scheduleDetail" hasPrefix:@"行程內容run"];
    NSArray* scoreArray = [query findObjects];
    
    NSLog(@"===: %@ ",scoreArray);
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _searchBar.delegate=self;
    
    totalString=[[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven", nil];
    //目前是放這個七個object,之後再換成資料庫～不過還要解決search沒輸入時應該下面列表為空
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_tableView resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length==0) {
        isFiltered=NO;
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
