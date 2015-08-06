//
//  SearchViewController.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/4.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *totalString;
    NSMutableArray *filteredStr;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
