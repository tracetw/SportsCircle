//
//  MasterTableViewController.h
//  SportsCircle
//
//  Created by 劉瑋軒 on 2015/8/5.
//  Copyright (c) 2015年 SportsCircle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableViewController : UITableViewController<UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray *objects;
@property (nonatomic,strong)NSMutableArray *results;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end
