//
//  MyOderViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/15.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyOderViewController.h"
#import "LXSegmentScrollView.h"
#import "OderListFooterView.h"
#import "OrderXibCell.h"
#import "MyOderCell.h"
#import "OrderViewController.h"
#import "RetMoneyViewController.h"
#import "ReturnLogisticsViewController.h"
#import "RefuseViewController.h"
#import "CheckLogViewController.h"
#import "OderDetailViewController.h"
#import "MyCommentViewController.h"
#import "SearchOderViewController.h"
#import "TriangleView.h"
#import "AppDelegate.h"
#import "SystemMessageViewController.h"

@interface MyOderViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
//全部订单数据
@property(nonatomic,copy) NSMutableArray * groupArr;
@property(nonatomic,copy) NSMutableArray * dataArr;
//代付款订单数据
@property(nonatomic,copy) NSMutableArray * payGroupArr;
@property(nonatomic,copy) NSMutableArray * payDataArr;
//代发货订单数据
@property(nonatomic,copy) NSMutableArray * disGroupArr;
@property(nonatomic,copy) NSMutableArray * disDataArr;
//代收货订单数据
@property(nonatomic,copy) NSMutableArray * recGroupArr;
@property(nonatomic,copy) NSMutableArray * recDataArr;
//退货
@property(nonatomic,copy) NSMutableArray * retGoodsGroupArr;
@property(nonatomic,copy) NSMutableArray * retGoodsDataArr;
//退款
@property(nonatomic,copy) NSMutableArray * retMoneyGroupArr;
@property(nonatomic,copy) NSMutableArray * retMoneyDataArr;
//退货换货
@property(nonatomic,copy) NSMutableArray * retGroupArr;
@property(nonatomic,copy) NSMutableArray * retDataArr;
//全局属性
@property(nonatomic,strong) UITableView *tbale;
@property(nonatomic,strong) UITableView *payVC;
@property(nonatomic,strong) UITableView *disVC;
@property(nonatomic,strong) UITableView *recVC;
@property(nonatomic,strong) UITableView *retVC;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) UIView * moreView;
@property(nonatomic,strong) UIView * sanjiaoView;
@property(nonatomic,strong) UIView * emptyView;
@end

@implementation MyOderViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    //详情删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReload:) name:@"reloadata" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _retGroupArr = [NSMutableArray array];
    _retDataArr = [NSMutableArray array];
    [self createNav];
    [self createTV];
    [self loadRefresh];
//    [self loadData];
//    [self loadPayData];
//    [self loadDisData];
//    [self loadRecData];
    [self loadRetGoodsData];
    [self loadRetMoneyData];
    
}

-(void)deleteReload:(NSNotification *)notifice{

    //删除本地数据
    [_groupArr removeObjectAtIndex:[notifice.userInfo[@"indexSection"] integerValue]];
    //删除整个组
    [_tbale deleteSections:[NSIndexSet indexSetWithIndex:[notifice.userInfo[@"indexSection"] integerValue]]  withRowAnimation:UITableViewRowAnimationTop];
}
#pragma mark ---------------------- 上拉加载下拉刷新
-(void)loadRefresh
{
    
    // 下拉刷新
    self.tbale.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.groupArr = [NSMutableArray arrayWithCapacity:0];
        
        [self loadData];
        
    }];
    
    // 进入界面先进性刷新
    [self.tbale.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tbale.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tbale.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadData];
        
    }];
    
    
 /**********************************************/
    // 下拉刷新
    self.payVC.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.payGroupArr = [NSMutableArray arrayWithCapacity:0];
        
        [self loadPayData];
        
    }];
    
    // 进入界面先进性刷新
    [self.payVC.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.payVC.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.payVC.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadPayData];
        
    }];
    
    
    
    /**********************************************/
    // 下拉刷新
    self.disVC.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.disGroupArr = [NSMutableArray arrayWithCapacity:0];
        
        [self loadDisData];
        
    }];
    
    // 进入界面先进性刷新
    [self.disVC.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.disVC.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.disVC.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadDisData];
        
    }];


    /**********************************************/
    // 下拉刷新
    self.recVC.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.recGroupArr = [NSMutableArray arrayWithCapacity:0];
        
        [self loadRecData];
        [self.recVC reloadEmptyDataSet];
        
    }];
    
    // 进入界面先进性刷新
    [self.recVC.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.recVC.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.recVC.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadRecData];
        
    }];
    
}

-(void)createTV{

    self.view.backgroundColor=[UIColor whiteColor];
    //iOS7新增属性
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    NSArray *array=[NSArray array];

    _tbale=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStyleGrouped];
    _tbale.delegate=self;
    _tbale.dataSource=self;
    _tbale.emptyDataSetSource = self;
    _tbale.emptyDataSetDelegate = self;
    _tbale.backgroundColor = [UIColor whiteColor];
    [_tbale registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"nibID"];
    
    _payVC=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStyleGrouped];
    _payVC.delegate=self;
    _payVC.dataSource=self;
    _payVC.emptyDataSetSource = self;
    _payVC.emptyDataSetDelegate = self;
    _payVC.backgroundColor = [UIColor whiteColor];
    [_payVC registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"pnibID"];
    
    _disVC=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStyleGrouped];
    _disVC.delegate=self;
    _disVC.dataSource=self;
    _disVC.emptyDataSetDelegate = self;
    _disVC.emptyDataSetSource = self;
    _disVC.backgroundColor = [UIColor whiteColor];
    [_disVC registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"dnibID"];
    
    _recVC=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStyleGrouped];
    _recVC.delegate=self;
    _recVC.dataSource=self;
    _recVC.emptyDataSetSource = self;
    _recVC.emptyDataSetDelegate = self;
    _recVC.backgroundColor = [UIColor whiteColor];
    [_recVC registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"rnibID"];
    
    _retVC=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStyleGrouped];
    _retVC.delegate=self;
    _retVC.dataSource=self;
    _retVC.emptyDataSetDelegate = self;
    _retVC.emptyDataSetSource = self;
    _retVC.backgroundColor = [UIColor whiteColor];
    [_retVC registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"renibID"];

    array = @[_tbale,_payVC,_disVC,_recVC,_retVC];
    NSMutableArray * imageNameArr = [@[@"",@"",@"",@"",@""]mutableCopy];
    LXSegmentScrollView *scView=[[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, SW, SH-64) titleArray:@[@"全部",@"待付款",@"待发货",@"待收货",@"退货/退款"] contentViewArray:array andStatePage:self.statePage andImageArr:imageNameArr];
    [self.view addSubview:scView];
}
#pragma mark ----------------------空白页代理
//动画效果
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
//背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}
//中心图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"hollow_order"];
}
//提示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有相关的订单!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: RGB(123, 123, 123, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//副标题
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"可以去看看有哪些想买的";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//全部订单数据
-(void)loadData{

    [RequestTools getUserWithURL:@"/order_list.mob" params:nil success:^(NSDictionary *Dict) {
        
        _groupArr = [NSMutableArray array];
        _groupArr = [[Dict objectForKey:@"order_list"] mutableCopy];
        _dataArr = [NSMutableArray array];
            
        [self.tbale.mj_header endRefreshing];
        [self.tbale.mj_footer endRefreshing];
        [self.tbale reloadData];
        [self.tbale reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        
    }];
}
//请求待付款数据
-(void)loadPayData{

    NSDictionary * dic = @{@"order_status":@"order_toPay"};
    [RequestTools posUserWithURL:@"/order_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        _payGroupArr = [NSMutableArray array];
        _payGroupArr = [[Dict objectForKey:@"order_list"]mutableCopy];
        _payDataArr = [NSMutableArray array];
            
        [self.payVC.mj_header endRefreshing];
        [self.payVC.mj_footer endRefreshing];
        [self.payVC reloadData];
        [self.payVC reloadEmptyDataSet];

    } failure:^(NSError *error) {
        
    }];

}
//请求待发货数据
-(void)loadDisData{
    
    NSDictionary * dic = @{@"order_status":@"order_paid"};
    [RequestTools posUserWithURL:@"/order_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        _disGroupArr = [NSMutableArray array];
        _disGroupArr = [[Dict objectForKey:@"order_list"]mutableCopy];
        _disDataArr = [NSMutableArray array];
        
        [self.disVC.mj_header endRefreshing];
        [self.disVC.mj_footer endRefreshing];
        [self.disVC reloadData];
        [self.disVC reloadEmptyDataSet];

    } failure:^(NSError *error) {
        
    }];

}
//请求待收货数据
-(void)loadRecData{
    
    NSDictionary * dic = @{@"order_status":@"order_shipping"};
    [RequestTools posUserWithURL:@"/order_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        _recGroupArr = [NSMutableArray array];
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        _recGroupArr = [[Dict objectForKey:@"order_list"]mutableCopy];
        _recDataArr = [NSMutableArray array];
        [self.recVC.mj_header endRefreshing];
        [self.recVC.mj_footer endRefreshing];
        [self.recVC reloadData];
        [self.recVC reloadEmptyDataSet];

    } failure:^(NSError *error) {
        
    }];

}
//请求退换货数据
-(void)loadRetGoodsData{
    
    NSDictionary * dic = @{@"order_status":@"order_return"};
    [RequestTools posUserWithURL:@"/order_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        _retGoodsGroupArr = [NSMutableArray array];
        _retGoodsGroupArr = [[Dict objectForKey:@"order_list"]mutableCopy];
        for (NSDictionary * dic in _retGoodsGroupArr) {
            [_retGroupArr addObject:dic];
        }
        [self.retVC reloadData];
        [self.retVC reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        
    }];

}
//请求退换货数据
-(void)loadRetMoneyData{
    
    NSDictionary * dic = @{@"order_status":@"order_refund"};
    [RequestTools posUserWithURL:@"/order_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        _retMoneyGroupArr = [NSMutableArray array];
        _retMoneyGroupArr = [[Dict objectForKey:@"order_list"]mutableCopy];
        for (NSDictionary * dic in _retMoneyGroupArr) {
            [_retGroupArr addObject:dic];
        }
        
        [self.retVC reloadData];
        [self.retVC reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        
    }];
}
//创建导航栏
-(void)createNav{
    
    self.title = @"全部订单";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //重新添加导航下边线
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    UIButton * moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_more" backgroundImageName:@"" target:self selector:@selector(oderMoreClick:)];
    UIBarButtonItem* moreBtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    UIButton * searchBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:RGB(255, 255, 255, 1) imageName:@"nav_search" backgroundImageName:@"" target:self selector:@selector(searchClick)];
    UIBarButtonItem* searchBtnItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    NSArray * arr = @[negativeSpacer,moreBtnItem,negativeSpacer,searchBtnItem];
    self.navigationItem.rightBarButtonItems = arr;

}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)oderMoreClick:(UIButton *)btn{

    btn.selected = !(btn.selected);
    if (btn.selected==YES) {
        [self createMoreView];
    }else{
        [self.moreView removeFromSuperview];
        [self.sanjiaoView removeFromSuperview];
    }
    

}

//创建更多按钮选择框
-(void)createMoreView{
    
    _sanjiaoView = [[TriangleView alloc]initWithFrame:CGRectMake(SW-35, 0, 30, 10) color:[UIColor whiteColor]];
    [self.view addSubview:_sanjiaoView];
    NSArray * imageArr = @[@"nav_more_news",@"nav_more_home"];
    NSArray * titleArr = @[@"消息",@"首页"];
    self.moreView = [FactoryUI createViewWithFrame:CGRectMake(SW-135, 10, 130, 100)];
    self.moreView.backgroundColor = [UIColor whiteColor];
    self.moreView.layer.cornerRadius = 2;
    self.moreView.layer.shadowRadius = 2.0f;
    self.moreView.layer.shadowOpacity = 1.0f;
    self.moreView.layer.shadowColor = RGB(183, 183, 183, 1).CGColor;
    self.moreView.layer.shadowOffset = CGSizeMake(-2, 2);
    [self.view addSubview:self.moreView];
    for (int i =0; i<2; i++) {
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(0, i*50, 130, 50) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(moreBtnClick:)];
        btn.tag = 150+i;
        [self.moreView addSubview:btn];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, i*50, 130, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.moreView addSubview:line];
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(20, (i+1)*15+i*20+i*15, 20, 20) imageName:imageArr[i]];
        [self.moreView addSubview:imageV];
        UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(47, (i+1)*15+i*20+i*15, 30, 20) text:titleArr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:14]];
        [self.moreView addSubview:titleLabel];
    }
    
}

//更多子选项
-(void)moreBtnClick:(UIButton *)btn{
    
    if (btn.tag == 150) {
        
        SystemMessageViewController * messageVC = [[SystemMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];

    }else{
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] baseTabBar] setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}

-(void)searchClick{
    
    SearchOderViewController * searchVC = [[SearchOderViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];

}
#pragma mark ----------------------tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tbale) {
        NSArray * arr = [_groupArr[section]objectForKey:@"gcs"];
        return arr.count;
    }else if (tableView == _payVC){
        NSArray * payArr = [_payGroupArr[section]objectForKey:@"gcs"];
        return payArr.count;
    }else if (tableView == _recVC){
        NSArray * payArr = [_recGroupArr[section]objectForKey:@"gcs"];
        return payArr.count;
    }else if (tableView == _disVC){
        NSArray * payArr = [_disGroupArr[section]objectForKey:@"gcs"];
        return payArr.count;
    }else if (tableView == _retVC){
        NSArray * payArr = [_retGroupArr[section]objectForKey:@"gcs"];
        return payArr.count;
    }else{
    
        return 0;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tbale) {
        NSLog(@"%lu",(unsigned long)_groupArr.count);
        return _groupArr.count;
    }else if (tableView == _payVC){
        NSLog(@"%lu",(unsigned long)_payGroupArr.count);
        return _payGroupArr.count;
    }else if (tableView == _recVC){
        NSLog(@"%lu",(unsigned long)_recGroupArr.count);
        return _recGroupArr.count;
    }else if (tableView == _disVC){
        NSLog(@"%lu",(unsigned long)_disGroupArr.count);
        return _disGroupArr.count;
    }else if (tableView == _retVC){
        NSLog(@"%lu",(unsigned long)_retGroupArr.count);
        return _retGroupArr.count;
    }else{
    
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 105;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGB(245, 245, 245, 1);
    UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 15, 14, 14) imageName:@"order_shop"];
    [headerView addSubview:imageV];
    NSString * store_name = @"";
    NSString *status=@"";
    if (tableView==_tbale) {
        store_name = [[_groupArr[section]objectForKey:@"store"]objectForKey:@"store_name"];
        if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"10"]) {
            //已删除
            status=@"待付款";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"16"]){
            //交易关闭
            status=@"货到付款待发货";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"20"]){
            //交易关闭
            status=@"待发货";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"25"]){
            //交易关闭
            status=@"买家申请退款";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"26"]){
            //买家退款中
            status=@"买家退款中";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"27"]){
            //退款完成，已结束
            status=@"退款完成，已结束";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"28"]){
            //拒绝退款理由
            status=@"拒绝退款理由";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"29"]){
            //拒绝退款
            status=@"拒绝退款";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"30"]){
            //等待买家付款
            status=@"待收货";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"40"]){
            //买家已付款
            status=@"待评价";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"45"]){
            //买家申请退货
            status=@"买家申请退货";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"46"]){
            //买家退货中
            status=@"买家退货中";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"49"]){
            //买家退货中
            status=@"退货失败";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"50"]){
            //已完成,已评价
            status=@"已完成,已评价";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"51"]){
            //卖家拒绝退货
            status=@"卖家拒绝退货";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"60"]){
            //买家已付款
            status=@"已完成";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"65"]){
            //已结束，不可评价
            status=@"已结束，不可评价";
            
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"0"]){
            //买家已付款
            status=@"已取消";
            
        }

    }else if (tableView==_payVC){
        store_name = [[_payGroupArr[section]objectForKey:@"store"]objectForKey:@"store_name"];
        status=@"待付款";
    }else if (tableView==_recVC){
        store_name = [[_recGroupArr[section]objectForKey:@"store"]objectForKey:@"store_name"];
        status=@"待收货";
    }else if (tableView==_disVC){
        store_name = [[_disGroupArr[section]objectForKey:@"store"]objectForKey:@"store_name"];
        status=@"待发货";
    }else if (tableView==_retVC){
        store_name = [[_retGroupArr[section]objectForKey:@"store"]objectForKey:@"store_name"];
        if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"25"]) {
            //已删除
            status=@"退款中";
            
        }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"29"]){
            //交易关闭
            status=@"退款被拒绝";
            
        }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"45"]){
            //交易关闭
            status=@"退货中";
            
        }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"51"]){
            //交易关闭
            status=@"退货被拒绝";
            
        }
        
    }
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGFloat length = [store_name boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(35, 17, length, 12) text:store_name textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
//    label.center = headerView.center;
//    label.center = CGPointMake(headerView.bounds.size.width/2, headerView.bounds.size.height/2);
    [headerView addSubview:label];

    UILabel * stateLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-115, 17, 100, 12) text:status textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:13]];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:stateLabel];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (tableView.tag==1200) {
//        return 10;
//    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _tbale) {
        NSArray * titleArr = [NSArray array];
        NSArray * titleColorArr = [NSArray array];
        NSLog(@"%@",[[_groupArr[section]objectForKey:@"order_status"]stringValue]);
        if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"10"]) {
            titleArr = @[@"付款",@"取消订单"];
            titleColorArr = @[@"[UIColor redColor]",[UIColor yellowColor]];
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"20"]){
            titleArr = @[];
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"30"]){
            titleArr = @[@"查看物流",@"确认收货"];
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"40"]){
            titleArr = @[@"去评价"];
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"60"]){
            titleArr = @[];
        }else if ([[[_groupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"0"]){
            titleArr = @[@"删除订单"];
        }
        
        OderListFooterView * footerView = [[OderListFooterView alloc]initWithBtnTitleArray:titleArr];
        footerView.tag=section;
        for (UIButton *btn in footerView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        UILabel * totalLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 140, 10) text:[NSString stringWithFormat:@"合计：¥%@",_groupArr[section][@"totalPrice"]] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:totalLabel];
        return footerView;
    }

    if (tableView==_payVC) {
//        [self getSelOderID:tableView];
        NSArray * titleArr = [NSArray array];
        NSArray * titleColorArr = [NSArray array];
        NSLog(@"%@",[[_payGroupArr[section]objectForKey:@"order_status"]stringValue]);
        if ([[[_payGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"10"]) {
            titleArr = @[@"付款",@"取消订单"];
            titleColorArr = @[@"[UIColor redColor]",[UIColor yellowColor]];

        }
        OderListFooterView * footerView = [[OderListFooterView alloc]initWithBtnTitleArray:titleArr];
        footerView.tag=section;
        for (UIButton *btn in footerView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        UILabel * totalLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 140, 10) text:[NSString stringWithFormat:@"合计：¥%@",_payGroupArr[section][@"totalPrice"]] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:totalLabel];
        return footerView;

    }
    if (tableView==_disVC) {
        NSLog(@"%@",[[_disGroupArr[section]objectForKey:@"order_status"]stringValue]);
        OderListFooterView * footerView = [[OderListFooterView alloc]init];
        footerView.backgroundColor = [UIColor whiteColor];
        UILabel * totalLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 140, 10) text:[NSString stringWithFormat:@"合计：¥%@",_disGroupArr[section][@"totalPrice"]] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:totalLabel];
        return footerView;
    }
    if (tableView==_recVC) {
        NSArray * titleArr = [NSArray array];
        NSArray * titleColorArr = [NSArray array];
        NSLog(@"%@",[[_recGroupArr[section]objectForKey:@"order_status"]stringValue]);
        if ([[[_recGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"30"]) {
            titleArr = @[@"查看物流",@"确认收货"];
            titleColorArr = @[@"[UIColor redColor]",[UIColor yellowColor]];
            
        }
        OderListFooterView * footerView = [[OderListFooterView alloc]initWithBtnTitleArray:titleArr];
        footerView.tag=section;
        for (UIButton *btn in footerView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        UILabel * totalLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 140, 10) text:[NSString stringWithFormat:@"合计：¥%@",_recGroupArr[section][@"totalPrice"]] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:totalLabel];
        return footerView;
    }
    if (tableView==_retVC) {
            NSArray * titleArr = [NSArray array];
            NSLog(@"%@",[[_retGroupArr[section]objectForKey:@"order_status"]stringValue]);
            if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"25"]) {
                titleArr = @[@"查看详情"];
            }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"29"]){
                titleArr = @[@"拒绝理由",@"申请退款"];
            }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"45"]){
                titleArr = @[@"退货物流"];
            }else if ([[[_retGroupArr[section]objectForKey:@"order_status"]stringValue] isEqualToString:@"51"]){
                titleArr = @[@"拒绝理由",@"申请退款"];
            }
            OderListFooterView * footerView = [[OderListFooterView alloc]initWithBtnTitleArray:titleArr];
            footerView.tag=section;
            for (UIButton *btn in footerView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    [btn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        UILabel * totalLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 140, 10) text:[NSString stringWithFormat:@"合计：¥%@",_retGroupArr[section][@"totalPrice"]] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:totalLabel];
        return footerView;
        }

    
//    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SW, 148)];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    footerView.backgroundColor = RGB(245, 245, 245, 1);
//    NSArray * totalArr = @[@"总计：",@"保价费：",@"优惠券：",@"邮费："];
//    for (int i=0; i<totalArr.count; i++) {
//        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(SW-81-60, 13+i*23, 60, 14) text:totalArr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
//        label.textAlignment = NSTextAlignmentRight;
//        [whiteView addSubview:label];
//    }
//    UILabel * line = [FactoryUI createLabelWithFrame:CGRectMake(0, 103, SW, 1) text:@"" textColor:RGB(68, 63, 91, 1) font:[UIFont systemFontOfSize:14]];
//    line.backgroundColor = RGB(236, 235, 235, 1);
//    [whiteView addSubview:line];
//    UILabel * fukuanLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-153, 119, 140, 14) text:@"实付款：¥1834.00" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13.5]];
//    fukuanLabel.textAlignment = NSTextAlignmentRight;
//    [whiteView addSubview:fukuanLabel];
//    [footerView addSubview:whiteView];
//    UILabel * numLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-153, 166, 140, 14) text:@"订单号：54165736868" textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:10]];
//    numLabel.textAlignment = NSTextAlignmentRight;
//    [footerView addSubview:numLabel];
//    UILabel * timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-153, 186, 140, 14) text:@"下单时间：2016-13:42:19" textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:10]];
//    timeLabel.textAlignment = NSTextAlignmentRight;
//    [footerView addSubview:timeLabel];
    return nil;
}
//footer里面的按钮点击方法
-(void)footerBtnClick:(UIButton *)sender
{
    NSDictionary * dict = [[NSDictionary alloc]init];
    UIView *view =[sender superview];
//    NSLog(@"%ld",(long)view.tag);
    if ([[sender superview]superview]==_tbale) {
        dict = _groupArr[view.tag];
        //获取网络数据ID
        NSNumber * oderID =  [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
        if ([sender.titleLabel.text isEqualToString:@"删除订单"]) {
            //删除本地数据
            [_groupArr removeObjectAtIndex:view.tag];
            NSLog(@"%lu",(unsigned long)_groupArr.count);
            //删除整个组
            [_tbale deleteSections:[NSIndexSet indexSetWithIndex:view.tag]  withRowAnimation:UITableViewRowAnimationTop];
            //调用删除服务器数据方法
            [self deleteOderWithID:oderID];
        }
        else if ([sender.titleLabel.text isEqualToString:@"去评价"]) {
            //调用请求服务器数据方法
            [self commentOderWithID:oderID];
        }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
            //调用请求服务器数据方法
            [self confirmRecWithID:oderID];
        }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]) {
            //调用请求服务器数据方法
            [self checkLogisticsWithID:oderID];
        }
    }else if ([[sender superview]superview]==_payVC){
        dict = _payGroupArr[view.tag];
        if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
            //删除本地数据
            [_payGroupArr removeObjectAtIndex:view.tag];
            //删除整个组
            [_payVC deleteSections:[NSIndexSet indexSetWithIndex:view.tag]  withRowAnimation:UITableViewRowAnimationTop];
        }else if ([sender.titleLabel.text isEqualToString:@"付款"]){
//            NSString * payID = [dict objectForKey:@"paymentBatchNo"];
//            OrderViewController * oderVC = [[OrderViewController alloc]init];
//            self.delegate = oderVC;
//            [self.delegate oderToPay:payID];
            
        }
    }else if ([[sender superview]superview]==_recVC){
        dict = _recGroupArr[view.tag];
        //获取网络数据ID
        NSNumber * oderID =  [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
        NSLog(@"%@",oderID);
        if ([sender.titleLabel.text isEqualToString:@"查看物流"]) {
            //调用请求服务器数据方法
            [self checkLogisticsWithID:oderID];
        }else{
             //调用请求服务器数据方法
            [self confirmRecWithID:oderID];
        }
    }else if ([[sender superview]superview]==_retVC){
        dict = _retGroupArr[view.tag];
        //获取网络数据ID
        NSNumber * oderID =  [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
        if ([sender.titleLabel.text isEqualToString:@"申请退款"]) {
            //调用请求服务器数据方法
            [self returnMoneyWithID:oderID];
        }else if ([sender.titleLabel.text isEqualToString:@"退货物流"]){
            ReturnLogisticsViewController * retLogVC = [[ReturnLogisticsViewController alloc]init];
            retLogVC.ofID = oderID;
            [self.navigationController pushViewController:retLogVC animated:YES];
        }else{
            RefuseViewController * refVC = [[RefuseViewController alloc]init];
            refVC.ofID = oderID;
            [self.navigationController pushViewController:refVC animated:YES];
        }
    }

    NSNumber * oderID =  [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
    NSLog(@"%@",oderID);
    NSString * payID = [dict objectForKey:@"paymentBatchNo"];
    if ([[[dict objectForKey:@"order_status"]stringValue] isEqualToString:@"10"]) {
        if (sender.tag==1) {
            NSLog(@"我是取消");
            [self cancelOderWithID:oderID];
        }else{
            NSLog(@"我是付款");
            OrderViewController * oderVC = [[OrderViewController alloc]init];
            self.delegate = oderVC;
            [self.delegate oderToPay:payID];
        }
    }
    
/*    items *model=[_orderArray objectAtIndexCheck:view.tag];
    
    if ([model.status isEqualToString:@"1"]) {//等待付款
        if (sender.tag==0) {//付款
            YFShoppingCartPayViewController *VC=viewAlloc_(YFShoppingCartPayViewController);
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{//取消订单
            [self cancelOrderList:model.order_id];
        }
        
    }else if ([model.status isEqualToString:@"0"]){//等待付款的订单取消订单->交易关闭
        if (sender.tag==0) {//再次购买
            
            YFOrderListCommonCell *cell=(YFOrderListCommonCell *)[sender superview];
            NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
            items *model=[_orderArray objectAtIndexCheck:indexPath.section];
            YFOrderListProductModel*product=model.productArray[indexPath.row];
            YFShopDetailController *vc1=viewAlloc_(YFShopDetailController);
            vc1.good_id=product.ID;//商品详情界面需要参数
            //            vc.ID=[dic objectForKey:@""];
            //            vc.member_id=[dic objectForKey:@"member_id"];//跳转店铺需要的参数
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }else{//删除订单
            [self cancelOrderList:model.order_id];
        }
    }else if ([model.status isEqualToString:@"2"]){//待发货
        //退款
        YFOrderListCommonCell *cell=(YFOrderListCommonCell *)[sender superview];
        NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
        items *model=[_orderArray objectAtIndexCheck:indexPath.section];
        YFOrderListProductModel*product=model.productArray[indexPath.row];
        YFApplyForRefundController *vc=viewAlloc_(YFApplyForRefundController);
        vc.orderid=product.order_id;
        vc.proid=product.ID;
        vc.price=product.price;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.status isEqualToString:@"3"]){//待收货
        if (sender.tag==0) {//确认收货
            
        }else{//查看物流
            YFLogisticalDetailController *vc=viewAlloc_(YFLogisticalDetailController);
            vc.orderModel=model;//订单组模型
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
 */
}
//退款
-(void)returnMoneyWithID:(NSNumber *)num{

    RetMoneyViewController * moneyVC = [[RetMoneyViewController alloc]init];
    moneyVC.ofID = num;
    [self.navigationController pushViewController:moneyVC animated:YES];
}
//确认收货
-(void)confirmRecWithID:(NSNumber *)oderID{

    NSDictionary * dic = @{@"of_id":oderID};
    [RequestTools posUserWithURL:@"/goods_receive.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [AlertShow showAlert:@"成功收货"];
        [self.recVC reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
//查看物流
-(void)checkLogisticsWithID:(NSNumber *)oderID{

    CheckLogViewController * checkVC = [[CheckLogViewController alloc]init];
    checkVC.checkID = oderID;
    [self.navigationController pushViewController:checkVC animated:YES];
}
//删除订单
-(void)deleteOderWithID:(NSNumber *)oderID{
    
    NSDictionary * dic = @{@"of_id":oderID};
    [RequestTools posUserWithURL:@"/order_delete.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [self.tbale reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//取消订单
-(void)cancelOderWithID:(NSNumber *)oderId{
    
    NSDictionary * dic = @{@"of_id":oderId,@"cancel_reason":@"不想要了"};
    [RequestTools posUserWithURL:@"/order_cancel.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [self.payVC reloadData];
        [self.tbale reloadData];
        [self loadRefresh];
    } failure:^(NSError *error) {
        
    }];
        
}

//评价订单
-(void)commentOderWithID:(NSNumber *)oderID{
    
    MyCommentViewController * comVC = [[MyCommentViewController alloc]init];
    comVC.orderId = oderID;
    [self.navigationController pushViewController:comVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tbale) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"nibID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _dataArr = [_groupArr[indexPath.section]objectForKey:@"gcs"];
        NSLog(@"%lu",(unsigned long)_dataArr.count);
        NSDictionary * dic = _dataArr[indexPath.row];
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
        cell.sizeLabel.text = dic[@"spec_info"];
        NSString * str = dic[@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"25"]) {
            UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(SW-100, 80, 40, 12) text:@"退款中" textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:lb];
        }
        if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"45"]) {
            UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(SW-100, 80, 40, 12) text:@"退货中" textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:lb];
        }
        return cell;
    }if (tableView == _payVC) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pnibID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _payDataArr = [_payGroupArr[indexPath.section]objectForKey:@"gcs"];
        NSLog(@"%lu",(unsigned long)_payDataArr.count);
        NSDictionary * dic = _payDataArr[indexPath.row];
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
        cell.sizeLabel.text = dic[@"spec_info"];
        NSString * str = dic[@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;
    }if (tableView == _disVC) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dnibID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _disDataArr = [_disGroupArr[indexPath.section]objectForKey:@"gcs"];
        NSLog(@"%lu",(unsigned long)_disDataArr.count);
        NSDictionary * dic = _disDataArr[indexPath.row];
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
        cell.sizeLabel.text = dic[@"spec_info"];
        NSString * str = dic[@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;
    }if (tableView == _recVC) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rnibID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _recDataArr = [_recGroupArr[indexPath.section]objectForKey:@"gcs"];
        NSLog(@"%lu",(unsigned long)_recDataArr.count);
        NSDictionary * dic = _recDataArr[indexPath.row];
        NSLog(@"%@",dic);
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
        cell.sizeLabel.text = dic[@"spec_info"];
        NSString * str = dic[@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;
    }if (tableView == _retVC) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"renibID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _retDataArr = [_retGroupArr[indexPath.section]objectForKey:@"gcs"];
        NSLog(@"%lu",(unsigned long)_retDataArr.count);
        NSDictionary * dic = _retDataArr[indexPath.row];
        NSLog(@"%@",dic);
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
        cell.sizeLabel.text = dic[@"spec_info"];
        NSString * str = dic[@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;

    }
    
    return nil;
//    NSNumber * oderID =  [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OderDetailViewController * oderDetailVC = [[OderDetailViewController alloc]init];
    if (tableView==_tbale) {
        oderDetailVC.selectID = [[_groupArr[indexPath.section]objectForKey:@"id"] integerValue];
        if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"10"]) {
//            titleArr = @[@"付款",@"取消"];
            oderDetailVC.classify = 1;
        }else if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"20"]){
//            titleArr = @[];
            oderDetailVC.classify = 4;
        }else if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"30"]){
//            titleArr = @[@"查看物流",@"确认收货"];
            oderDetailVC.classify = 1;
        }else if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"40"]){
//            titleArr = @[@"去评价"];
            oderDetailVC.classify = 3;
        }else if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"60"]){
//            titleArr = @[];
            oderDetailVC.classify = 4;
        }else if ([[[_groupArr[indexPath.section]objectForKey:@"order_status"]stringValue] isEqualToString:@"0"]){
//            titleArr = @[@"删除订单"];
            oderDetailVC.classify = 5;
            oderDetailVC.indexSection = indexPath.section;
        }

    }else if (tableView==_payVC){
        oderDetailVC.selectID = [[_payGroupArr[indexPath.section]objectForKey:@"id"] integerValue];
        oderDetailVC.classify = 1;
    }
    else if (tableView == _disVC){
        oderDetailVC.selectID = [[_disGroupArr[indexPath.section]objectForKey:@"id"] integerValue];
        oderDetailVC.classify = 4;
    }else if (tableView == _recVC){
        oderDetailVC.selectID = [[_recGroupArr[indexPath.section]objectForKey:@"id"] integerValue];
        oderDetailVC.classify = 2;
    }else{
        oderDetailVC.selectID = [[_retGroupArr[indexPath.section]objectForKey:@"id"] integerValue];
        oderDetailVC.classify = 3;
    }
    [self.navigationController pushViewController:oderDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
