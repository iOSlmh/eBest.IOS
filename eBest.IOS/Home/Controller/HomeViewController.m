//
//  HomeViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "SecondHomeCell.h"
#import "SecondModel.h"
#import "SearchBarController.h"
#import "ScanViewController.h"
#import "DetailViewController.h"
#import "DetailModel.h"
#import "ListViewController.h"
#import "RequestTools.h"
#import "SelectCell.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "UINavigationBar+Awesome.h"
#import "SystemMessageViewController.h"


@interface HomeViewController ()

@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) NSMutableArray * dataArray;
@property (strong,nonatomic) NSMutableArray * mArr;
@property (strong,nonatomic) NSMutableArray * scroArr;
@property (strong,nonatomic) NSArray * array;
@property (assign,nonatomic) NSInteger page;
@property (strong,nonatomic) UIView * searchBarView;
@property (strong,nonatomic) UISearchBar * searchBar;
@property (strong,nonatomic) UITextField * textField;
@property (strong,nonatomic) UIView * headerView;
@property (strong,nonatomic) UILabel * label3;
@property (strong,nonatomic) NSMutableArray * dataArr;
@property (strong,nonatomic) HomeCell * homeCell;
@property (strong,nonatomic) UIButton * backBtn;
@property (strong,nonatomic) UILabel * netLab;
@property (strong,nonatomic) NSMutableArray * picArr;
@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //设置导航不透明
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

}
-(void)viewWillDisappear:(BOOL)animated{

    //消失时删除UIView
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:KLoadDataBase object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    _homeCell.tapDelegate = self;
    
    [self createNav];
    [self createSearchBarView];
    [self createBackBtn];
    [self createNetTip];
    [self createTV];
    [self createBtn];
//    [self loadAdRequest];
    [self loadRefresh];
    [self loadScroData];

}

-(void)createNetTip{

    _netLab = [FactoryUI createLabelWithFrame:CGRectMake(0, 64, SW, 40) text:@"网络连接不可用,请检查您的网络设置" textColor:RGB(255, 255, 255, 1) font:[UIFont systemFontOfSize:15]];
    _netLab.backgroundColor = [UIColor grayColor];
    _netLab.textAlignment = NSTextAlignmentCenter;
    _netLab.alpha = 0.5;
    _netLab.hidden = YES;
    [self.view addSubview:_netLab];
    
}

-(void)loadScroData{

    _scroArr = [[NSMutableArray alloc]init];
    [RequestTools getWithURL:@"/goods_bargain.mob" params:nil success:^(NSDictionary *Dict) {

        NSLog(@"----------------%@",Dict);
        _scroArr = [Dict objectForKey:@"goods_bargain"];
    
        [self.tv reloadData];
    } failure:^(NSError *error) {

    }];

}

-(void)getLoadDataBase:(NSNotification *)text{

    NSLog(@"----------------%@",text.userInfo[@"netType"]);
    if ([text.userInfo[@"isConnect"]isEqualToString:@"1"]) {
        
        _netLab.hidden = YES;
        NSLog(@"----------------监听到网络连接通知");
        [self loadAdRequest];
        [self loadScroData];
        [self.tv.mj_header beginRefreshing];
        
    }else{
    
        _netLab.hidden = NO;
    }
    
}

-(void)tapImageDetailPushWithGoodsID:(NSString *)goodsID{
    
    DetailViewController * detailVC = [[DetailViewController alloc]init];
    NSNumber * goodID = [NSNumber numberWithInteger:[goodsID integerValue]];
    [detailVC loadDataWithID:goodID];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)loadData{
    
//    NSDictionary * dic = @{@"current_page":[NSString stringWithFormat:@"%ld",(long)_page],@"order_type":@"2"};
    
    NSDictionary * dic = @{@"current_page":[NSString stringWithFormat:@"%ld",(long)_page],@"goods_recommend_mobile":@"1"};
    [RequestTools postWithURL:@"/goods_list.mob" params:dic success:^(NSDictionary *Dict) {
        
//        NSLog(@"----------------%@",Dict);
        NSMutableArray * moreArr = [Dict[@"goods_list"]mutableCopy];
        for (NSDictionary * dict in moreArr) {
            [_dataArray addObject:dict];
        }
        
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    // 结束刷新
    [self.tv.mj_header endRefreshing];
    
    [self.tv.mj_footer endRefreshing];

}

-(void)loadListData{
 
    NSDictionary * dic = @{@"current_page":[NSString stringWithFormat:@"%ld",(long)_page],@"order_type":@"2"};

    [RequestTools postWithURL:@"/goods_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        NSMutableArray * moreArr = [Dict[@"goods_list"]mutableCopy];
        for (NSDictionary * dict in moreArr) {
            [_dataArray addObject:dict];
        }
        
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    // 结束刷新
    [self.tv.mj_header endRefreshing];
    
    [self.tv.mj_footer endRefreshing];
}


#pragma mark ----------------------创建首页btn
-(void)createBtn{

    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 190, 0.359*SW-1, 266);
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.tag = 32795;
    [btn1 addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"home_images_class_001"] forState:UIControlStateNormal];
    UILabel * lb1 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 50, 14) text:@"送恋人" textColor:RGB(73, 73, 74, 1) font:[UIFont systemFontOfSize:14]];
    [btn1 addSubview:lb1];
    UILabel * label1 = [FactoryUI createLabelWithFrame:CGRectMake(10, 32, 90, 10) text:@"给她/他最好的爱" textColor:RGB(236, 105, 65, 1) font:[UIFont systemFontOfSize:10]];
    [btn1 addSubview:label1];
    [self.headerView addSubview:btn1];

    float b = 0.320*SW;
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0.359*SW, 190, b-1, 133);
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.tag = 32796;
     [btn2 addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"home_images_class_002"] forState:UIControlStateNormal];
     UILabel * lb2 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 50, 14) text:@"送朋友" textColor:RGB(73, 73, 74, 1) font:[UIFont systemFontOfSize:14]];
    [btn2 addSubview:lb2];
    UILabel * label2 = [FactoryUI createLabelWithFrame:CGRectMake(10, 32, 90, 10) text:@"人生乐在相知心" textColor:RGB(2, 151, 255, 1) font:[UIFont systemFontOfSize:10]];
    [btn2 addSubview:label2];
    [self.headerView addSubview:btn2];
   
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0.359*SW+b, 190, b, 133);
    btn3.backgroundColor = [UIColor whiteColor];
    btn3.tag = 32797;
     [btn3 addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"home_images_class_003"] forState:UIControlStateNormal];
    UILabel * lb3 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 50, 14) text:@"送孩子" textColor:RGB(73, 73, 74, 1) font:[UIFont systemFontOfSize:14]];
    [btn3 addSubview:lb3];
    UILabel * label3 = [FactoryUI createLabelWithFrame:CGRectMake(10, 32, 90, 10) text:@"用心呵护的花朵" textColor:RGB(136, 136, 136, 1) font:[UIFont systemFontOfSize:10]];
    [btn3 addSubview:label3];
    [self.headerView addSubview:btn3];

    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0.359*SW, 190+133+1, b-1, 132);
    btn4.backgroundColor = [UIColor whiteColor];
    btn4.tag = 32798;
     [btn4 addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"home_images_class_004"] forState:UIControlStateNormal];
    UILabel * lb4 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 50, 14) text:@"送长辈" textColor:RGB(73, 73, 74, 1) font:[UIFont systemFontOfSize:14]];
    [btn4 addSubview:lb4];
    UILabel * label4 = [FactoryUI createLabelWithFrame:CGRectMake(10, 32, 110, 10) text:@"爱如清风 润无声" textColor:RGB(153, 153, 153, 1) font:[UIFont systemFontOfSize:10]];
    [btn4 addSubview:label4];
    [self.headerView addSubview:btn4];

    UIButton * btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(0.359*SW+b, 190+133+1, b, 132);
    btn5.backgroundColor = [UIColor whiteColor];
    btn5.tag = 32799;
     [btn5 addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setBackgroundImage:[UIImage imageNamed:@"home_images_product_001"] forState:UIControlStateNormal];
    UILabel * lb5 = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 50, 14) text:@"送自己" textColor:RGB(73, 73, 74, 1) font:[UIFont systemFontOfSize:14]];
    [btn5 addSubview:lb5];
    UILabel * label5 = [FactoryUI createLabelWithFrame:CGRectMake(10, 32, 90, 10) text:@"对自己好一点" textColor:RGB(153, 153, 153, 1) font:[UIFont systemFontOfSize:10]];
    [btn5 addSubview:label5];
    [self.headerView addSubview:btn5];
    
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 456, SW, 0.5)];
    lb.backgroundColor = RGB(233, 239, 242, 1);
    
    [self.headerView addSubview:lb];
    
}
//热门按钮点击方法
-(void)hotBtnClick:(UIButton *)btn{

    ListViewController * listVC = [[ListViewController alloc]init];
    listVC.listGoosID = [NSNumber numberWithInteger:btn.tag];
    [self.navigationController pushViewController:listVC animated:YES];

}
#pragma mark ----------------------创建搜索框
//创建搜索框底层view
-(void)createSearchBarView{
    
    self.searchBarView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW-100, 30)];
    self.searchBarView.backgroundColor = [UIColor clearColor];
    self.searchBarView.layer.cornerRadius = 10;
    self.searchBarView.layer.masksToBounds = YES;
    self.navigationItem.titleView = self.searchBarView;
    [self createSearchBar];
    
}

//创建搜索框
-(void)createSearchBar{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SW-100, 30)];
//    self.searchBar.searchBarStyle =UISearchBarStyleMinimal;
    // 修改搜索框占位符颜色
    // 找到searchbar的searchField属性
//    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
//    if (searchField) {
//        // 背景色
//        [searchField setBackgroundColor:[UIColor colorWithRed:0.074 green:0.649 blue:0.524 alpha:1.000]];
//        // 设置字体颜色 & 占位符 (必须)
//        searchField.textColor = [UIColor whiteColor];
//        searchField.placeholder = @"请输入商品名称、寓意";
//        // 根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
//        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//        // 圆角
//        searchField.layer.cornerRadius = 10.0f;
//        searchField.layer.masksToBounds = YES;
//        
//    }

    //自定义搜索框放大镜的图标
    [self.searchBar setImage:[UIImage imageNamed:@"nav_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.backgroundColor = RGB(236, 236, 236, 1);
    self.searchBar.barTintColor = RGB(236, 236, 236, 1);
    self.searchBar.alpha = 0.6;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入商品名称、寓意";
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    //背景图片与searchbar本身圆角设置冲突所以使用自定义searchbar
//    self.searchBar.backgroundImage = [UIImage imageNamed:@"search_gray"];
    self.searchBar.tintColor = RGB(236, 236, 236, 1);
    self.searchBar.layer.cornerRadius = 10.0f;
    self.searchBar.layer.masksToBounds = YES;
    [self.searchBarView addSubview:self.searchBar];
    [self createSearchBarBtn];

}

//创建搜索框btn
-(void)createSearchBarBtn{

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SW-100, 30);
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_searchBar addSubview:btn];
    
//   语音搜索
//  UIButton * audioBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-120, 4, 50, 22) title:@"" titleColor:[UIColor clearColor] imageName:@"audio_nav_icon" backgroundImageName:@"" target:self selector:@selector(audioBtnClick)];
//    [btn addSubview:audioBtn];
    
}

-(void)audioBtnClick{
    
}
-(void)searchBtnClick{
    
    SearchBarController * searchBar = [[SearchBarController alloc]init];
    [self.navigationController pushViewController:searchBar animated:YES];
    
}

#pragma mark ---------------------- 上拉加载下拉刷新
-(void)loadRefresh
{
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }

    //下拉刷新
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        
        [self loadData];
        
    }];
    
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.tv.mj_header = header;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tv.mj_header.automaticallyChangeAlpha = YES;
    
    // 进入界面先进性刷新
    [self.tv.mj_header beginRefreshing];
    

    
    //上拉加载更多
    MJRefreshAutoGifFooter * foot = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadListData];
        
        
    }];
    
    [foot setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [foot setImages:refreshingImages forState:MJRefreshStateRefreshing];

    self.tv.mj_footer = foot;

}

// 加载广告栏视图
-(void)loadAdRequest{
    
        NSMutableDictionary * dit = [[NSMutableDictionary alloc]init];
        [dit addEntriesFromDictionary:@{@"ap_id":@"32768"}];
        [RequestTools postWithURL:@"/advert.mob" params:dit success:^(NSDictionary *Dict) {
    
        NSDictionary * dic = [Dict objectForKey:@"advert_postion"];
        _dataArr = [dic objectForKey:@"advs"];
        self.picArr = [NSMutableArray array];
        for (int i=0; i<_dataArr.count; i++) {
            NSDictionary * dict  = [_dataArr objectAtIndex:i];
            NSDictionary * dittt = [dict objectForKey:@"ad_acc"];
            NSString * str = [dittt objectForKey:@"path"];
            NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
            [self.picArr addObject:appStr];
            
        }
        DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0,0,SW,185) WithImageUrls:self.picArr];
        picView1.AutoScrollDelay = 2.0f;
        picView1.backgroundColor = [UIColor clearColor];
        [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
            printf("你点到我了😳index:%zd\n",index);
        }];
        [self.headerView addSubview:picView1];

            [self.tv reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

//scrollview代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
   if (scrollView == self.tv)  //去掉 UItableview headerview 黏性(sticky)
    {
        CGFloat offsetYY = scrollView.contentOffset.y;
        
        if (offsetYY >600) {
            
            _backBtn.hidden = NO;
            
        }else{
        
            _backBtn.hidden = YES;
        }
        
        UIColor * color = [UIColor whiteColor];
        CGFloat offsetY = scrollView.contentOffset.y;
        //改变导航条内容
        if (offsetY > 50) {
            
            CGFloat alpha = MIN(1, 1 - ((50 + 80 - offsetY) / 80));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            [self.rightButton setImage:[UIImage imageNamed:@"nav_news"] forState:UIControlStateNormal];
            self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(237, 237, 237, 1) size:CGSizeMake(SW, 1)];
            self.searchBarView.backgroundColor = RGB(179, 179, 179, 1);
            
        } else {
            
            self.navigationController.navigationBar.shadowImage = [UIImage new];
            [self.rightButton setImage:[UIImage imageNamed:@"nav_news2"] forState:UIControlStateNormal];
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            self.searchBarView.backgroundColor = [UIColor clearColor];
        }

            //取消粘滞效果
            UITableView *tableview = (UITableView *)scrollView;
            CGFloat sectionHeaderHeight = 130;
            CGFloat sectionFooterHeight = 45;
//            CGFloat offsetY = tableview.contentOffset.y;
            if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
            {
                tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
            }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
            {
                tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
            }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
            {
                tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
            }

    }
 
}

#pragma mark ----------------------创建导航栏
-(void)createNav{
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"nav_news2"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    

//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.rightButton.bounds.origin.x+2, 14, 44, 44)];
//    label.text = @"消息";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:10];
//    label.textColor = [UIColor whiteColor];
//    [self.rightButton addSubview:label];

}

-(void)rightButtonClick{
    
      SystemMessageViewController * messageVC = [[SystemMessageViewController alloc]init];
      [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)createBackBtn{

    _backBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-20-40, SH-48-40-20, 40, 40) title:@"返回" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(backTopClick)];
    _backBtn.backgroundColor = [UIColor redColor];
    _backBtn.alpha = 0.5;
    _backBtn.layer.cornerRadius = 20;
    _backBtn.layer.masksToBounds = YES;
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _backBtn.hidden = YES;
    [self.view addSubview:self.backBtn];

}

-(void)backTopClick{

    [self.tv setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark ----------------------创建TableView
//创建TV
-(void)createTV{
    
    self.headerView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 459)];
    self.headerView.backgroundColor = RGB(247, 247, 247, 1);
    self.tv.tableHeaderView = self.headerView;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.showsVerticalScrollIndicator = NO;
    [self.tv registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.tv registerNib:[UINib nibWithNibName:@"SecondHomeCell" bundle:nil] forCellReuseIdentifier:@"secondCellID"];
    
}

//TableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return _dataArray.count;
    }
    
}

//设置不同的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section==0) {
        
        HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.quickBuy addTarget:self action:@selector(quickBuyClick) forControlEvents:UIControlEventTouchUpInside];
        cell.tapDelegate = self;
        [cell loadDataWithArray:self.scroArr];
        return cell;

    }else{
    
        SecondHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"secondCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
        cell.TitleLabelS.text = [_dataArray[indexPath.row]objectForKey:@"goods_name"];
        NSNumber * num = [_dataArray[indexPath.row]objectForKey:@"goods_current_price"];
        cell.priceLabelS.text = [NSString stringWithFormat:@"¥%@",num.stringValue];
        NSString * str = [[_dataArray[indexPath.row] objectForKey:@"goods_main_photo"]objectForKey:@"path"];
        
//        NSString * imageUrl = [NSString stringWithFormat:@"%@%@",Image_url,str];
//        NSLog(@"----------------%@",imageUrl);
//        CGSize size = [GetImageSize getImageSizeWithURL:imageUrl];
//        CGSize size = [ModelForMessageAndImage downloadImageSizeWithURL:[NSString stringWithFormat:@"%@%@",Image_url,str]];
//        NSLog(@"----------------%f",size.height);
        
        ImageWithUrl(cell.imageV, str);

        return cell;

    }
    
}

//设置分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}

//设置不同分区cell背景色
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        cell.backgroundColor = RGB(243, 243, 243, 1);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
}

//设置不同分区的header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UIView * view = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 50)];
        view.backgroundColor = RGB(247, 247, 247, 1);
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(10, 20, 20, 20) imageName:@"home_Sale"];
        [view addSubview:imageV];
        UILabel * label1 = [FactoryUI createLabelWithFrame:CGRectMake(35, 20, 70, 20) text:@"今日特卖" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:16]];
        label1.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:label1];
        
        UILabel * label2 = [FactoryUI createLabelWithFrame:CGRectMake(SW-150, 15, 40, 30) text:@"还剩" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:10]];
        [view addSubview:label2];
        
        _label3 = [FactoryUI createLabelWithFrame:CGRectMake(SW-110, 20, 95, 20) text:@"" textColor:RGB(0, 0, 0, 1) font:[UIFont systemFontOfSize:15]];
        _label3.backgroundColor = [UIColor grayColor];
        _label3.textAlignment = NSTextAlignmentCenter;
        _label3.textColor = [UIColor whiteColor];
        [view addSubview:_label3];
        
        //特卖倒计时定时器
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        return view;
    }else{
        UIView * view = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 150)];
        view.backgroundColor = RGB(247, 247, 247, 1);
        UIImageView * imageV1 = [FactoryUI createImageViewWithFrame:CGRectMake(10, 20, 20, 20) imageName:@"home_recommend"];
        [view addSubview:imageV1];
            UILabel * label1 = [FactoryUI createLabelWithFrame:CGRectMake(35, 20, 70, 20) text:@"精品推荐" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:16]];
        label1.font = [UIFont boldSystemFontOfSize:16];
            [view addSubview:label1];
        
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(SW-95, 15, 85, 30) title:@"查看往期推荐" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(recommendClick)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.hidden = YES;
//        btn.titleLabel.adjustsFontForContentSizeCategory = YES;
        [view addSubview:btn];
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(0, 50, SW, 80) imageName:@"other"];
        [view addSubview:imageV];
            return view;
    }
}

-(void)recommendClick{

    ListViewController * listVC = [[ListViewController alloc]init];
    
    [self.navigationController pushViewController:listVC animated:YES];
}

//设置不同分区的footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        UIView * view = [FactoryUI createViewWithFrame:CGRectMake(0, 0, 0, 0)];
        return view;
    }else{
        UIView * view = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 45)];
        view.backgroundColor = RGB(247, 247, 247, 1);
        UIButton * btn = [FactoryUI createButtonWithFrame:view.bounds title:@"点击查看更多" titleColor:RGB(71,71,71,1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(moreClick)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:btn];
        return view;
    }
}

-(void)quickBuyClick{

    NSString * goodsID = self.scroArr[0][@"bg_goods"][@"id"];
    DetailViewController * detailVC = [[DetailViewController alloc]init];
    NSNumber * goodID = [NSNumber numberWithInteger:[goodsID integerValue]];
    [detailVC loadDataWithID:goodID];
    [self.navigationController pushViewController:detailVC animated:YES];

}
//加载更多
-(void)moreClick{
    
    _page++;
    [self loadData];
    
}
//设置header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 50;
    }else{
        return 130;
    }
    
}

//设置footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else
        return 45;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) return 338;
    else return SW;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1) {
        
        DetailViewController * detailVC = [[DetailViewController alloc]init];
        NSDictionary * dic = _dataArray[indexPath.row];
        NSNumber * goodsID = [dic objectForKey:@"id"];
        [detailVC loadDataWithID:goodsID];
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    
}

#pragma mark ----------------------特卖倒计时
- (void)timerFireMethod:(NSTimer *)theTimer
{
    BOOL timeStart = YES;
    NSCalendar *cal = [NSCalendar currentCalendar]; //定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:@"2016-11-15 22:47:00"];
    NSString *overdate = [dateFormatter stringFromDate:dateString];
    //    NSLog(@"overdate=%@",overdate);
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    if(timeStart) { //从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[overdate substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[overdate substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[overdate substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[overdate substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[overdate substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[overdate substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
    }
    
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    NSDate *overTime = [cal dateFromComponents:endTime]; //把目标时间装载入date
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    NSString *t = [NSString stringWithFormat:@"%ld", (long)[d day]];
    NSString *h = [NSString stringWithFormat:@"%ld", (long)[d hour]];
    NSString *fen = [NSString stringWithFormat:@"%ld", (long)[d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"0%ld",(long)[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%ld", (long)[d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%ld",(long)[d second]];
    }
    //    NSLog(@"===%@天 %@:%@:%@",t,h,fen,miao);
    [_label3 setText:[NSString stringWithFormat:@"%@天 %@:%@:%@",t,h,fen,miao]];
    if([d second] > 0) {
        //计时尚未结束，do_something
        //        [_longtime setText:[NSString stringWithFormat:@"%@:%@:%@",d,fen,miao]];
    } else if([d second] == 0) {
        //计时结束 do_something
        
    } else{
        //计时器失效
        [theTimer invalidate];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
