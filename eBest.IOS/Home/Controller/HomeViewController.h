//
//  HomeViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RootViewController.h"
#import "HomeCell.h"
@interface HomeViewController : RootViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,HomeCellDelegate,MBProgressHUDDelegate>

{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITableView *tv;


@end
