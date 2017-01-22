//
//  CollectViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CollectViewController.h"
#import "StoreCollectViewController.h"
#import "GoodsCollectViewController.h"
#import "CollectCell.h"
#import "StoreCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "HomeStoreViewController.h"
#import "TriangleView.h"
#import "AppDelegate.h"
#import "SystemMessageViewController.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UISegmentedControl * segementedControl;
@property (nonatomic, copy) NSString *selectedIndex;
@property(nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView *commoditytableView;
@property (nonatomic, strong) UITableView *storetableView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) NSMutableArray * storeDataArr;
@property(nonatomic,strong) NSMutableArray * goodsDataArr;
@property(nonatomic,strong) UIView * moreView;
@property(nonatomic,strong) UIView * sanjiaoView;

@end

@implementation CollectViewController

@synthesize storetableView,commoditytableView;

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    //从店铺透明无下边线回来时添加 不能加载setNav中 因为返回方法不走viewDidLoad 属方案二
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];//方案二
    
    //新增方案  当店铺界面不使用导航条 隐藏导航条时  此处需要进行处理  使用原方案二则不需添加
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    //新增方案  当店铺界面不使用导航条 隐藏导航条时  此处不需要进行处理  使用原方案二则需添加
//    self.navigationController.navigationBar.translucent = YES;//方案二
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGB(247, 247, 247, 1);
    [self setNav];
    [self createStoretableView]; //设置店铺 tableView
    [self createCommoditytableView];
    [self loadGoodsData];
    [self loadStoreData];

}

-(void)setNav{
    
    [self createSegment];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];//方案二

    self.navigationItem.titleView = self.segementedControl;
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    UIButton * moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_more" backgroundImageName:@"" target:self selector:@selector(collectMoreClick:)];
    UIBarButtonItem* moreBtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    UIButton * editBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:RGB(255, 255, 255, 1) imageName:@"nav_shopping" backgroundImageName:@"" target:self selector:@selector(shopCarClick)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem* editBtnItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    NSArray * arr = @[negativeSpacer,moreBtnItem,negativeSpacer,editBtnItem];
    self.navigationItem.rightBarButtonItems = arr;
    
}

-(void)shopCarClick{
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] baseTabBar] setSelectedIndex:2];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)collectMoreClick:(UIButton *)btn{
    
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

#pragma mark ---------------------- 设置导航栏分段
-(void)createSegment{
    
    NSArray * segmentenArray = [[NSArray alloc]initWithObjects:@"商品",@"店铺", nil];
    self.segementedControl = [[UISegmentedControl alloc]initWithItems:segmentenArray];
    self.segementedControl.frame = CGRectMake(0, 0, 160, 30);
    self.segementedControl.tintColor = [UIColor lightGrayColor];
    self.segementedControl.selectedSegmentIndex = self.selectedIndex.intValue;
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName,RGB(32, 179, 169, 1),NSForegroundColorAttributeName, nil];
    //RGB(32, 179, 169, 1)方案二 方案一旧版本看备份
    [self.segementedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary * hightlightAttributes = [NSDictionary dictionaryWithObject:RGB(32, 179, 169, 1) forKey:NSForegroundColorAttributeName];
    //RGB(32, 179, 169, 1)方案二
    [self.segementedControl setTitleTextAttributes:hightlightAttributes forState:UIControlStateHighlighted];
    [self.segementedControl addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventValueChanged];
    
}
#pragma mark - segment响应方法
//segment改变的时候关联
-(void)changeOption:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    
    switch (index)
    {
        case 0 :
            
//            commoditytableView.hidden = NO;
//            storetableView.hidden = YES;
            
            [self.view bringSubviewToFront:commoditytableView];
            break;
            
        case 1 :
            
            [self.view bringSubviewToFront:storetableView];
//            commoditytableView.hidden = YES;
//            storetableView.hidden = NO;
            
            break;
            
        default :
            break;
    }

}
/**
 *  设置商品 UI
 */
- (void)createCommoditytableView
{

    commoditytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64) style:UITableViewStylePlain];
    commoditytableView.backgroundColor = RGB(247, 247, 247, 1);
    commoditytableView.delegate = self;
    commoditytableView.dataSource = self;
    commoditytableView.emptyDataSetSource = self;
    commoditytableView.emptyDataSetDelegate = self;
    commoditytableView.showsVerticalScrollIndicator = NO;
    [commoditytableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //    去除分割线
    commoditytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:commoditytableView];
//    //    设置headerView
//    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 45)];
//    self.headerView.backgroundColor = RGB(244, 244, 244, 1);
//    commoditytableView.tableHeaderView = self.headerView;
//    //    设置筛选下拉菜单的view
//    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 44)];
//    topView.backgroundColor = [UIColor whiteColor];
//    [self.headerView addSubview:topView];
//    //    添加分类btn
//    NSArray * selectTitle = @[@"默认",@"折扣",@"促销",@"编辑"];
//    for (int i =0; i<4; i++) {
//        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(i*SW/4, 0, SW/4, 44) title:selectTitle[i] titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(topSelectBtn)];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [topView addSubview:btn];
//    }
    
}
/**
 *  设置店铺 UI
 */
- (void)createStoretableView
{
    storetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64) style:UITableViewStylePlain];
    storetableView.backgroundColor = RGB(247, 247, 247, 1);
    storetableView.delegate = self;
    storetableView.dataSource = self;
    storetableView.emptyDataSetSource = self;
    storetableView.emptyDataSetDelegate = self;
    storetableView.showsVerticalScrollIndicator = NO;
    [storetableView registerNib:[UINib nibWithNibName:@"StoreCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //    去除分割线
    storetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:storetableView];
    
}

//收藏商品列表请求
-(void)loadGoodsData{

    [RequestTools getUserWithURL:@"/favorite_goods.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        _goodsDataArr = [NSMutableArray array];
        _goodsDataArr = [Dict[@"favorite_goods"]mutableCopy];
        [self.commoditytableView reloadData];
        [self.commoditytableView reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        
    }];

}
//收藏店铺列表请求
-(void)loadStoreData{

    [RequestTools getUserWithURL:@"/favorite_store.mob" params:nil success:^(NSDictionary *Dict) {
        
        _storeDataArr = [NSMutableArray array];
        _storeDataArr = [Dict[@"favorite_store"]mutableCopy];
        [self.storetableView reloadData];
        [self.storetableView reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ----------------------空白页代理方法
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
    NSString *text = @"您还没有收藏的宝贝!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: RGB(123, 123, 123, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//副标题
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"可以去看看有哪些想要收藏";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark ----------------------tv代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == commoditytableView) {
        return 126;
    }else{
        return 100;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == storetableView) {
        return _storeDataArr.count;
    }else{
    
        return _goodsDataArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == storetableView) {
        
      StoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = _storeDataArr[indexPath.row][@"store"][@"store_name"];
        cell.nameLabel.textColor = RGB(71, 71, 71, 1);
        NSString * str = _storeDataArr[indexPath.row][@"store"][@"store_logo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        
        return cell;
        
    }else if (tableView == commoditytableView){
    
        CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.descLabel.text = _goodsDataArr[indexPath.row][@"goods"][@"goods_name"];
        cell.descLabel.textColor = RGB(71, 71, 71, 1);
        cell.currentPrice.text = [NSString stringWithFormat:@"¥%@",_goodsDataArr[indexPath.row][@"goods"][@"goods_current_price"]];
        cell.currentPrice.textColor = RGB(255, 98, 72, 1);
        cell.originalPrice.text = [NSString stringWithFormat:@"¥%@",_goodsDataArr[indexPath.row][@"goods"][@"goods_price"]];
        cell.originalPrice.textColor = RGB(183, 183, 183, 1);
        NSString * str = _goodsDataArr[indexPath.row][@"goods"][@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        
        [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];

        return cell;
    }

    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == commoditytableView) {
        
        DetailViewController * detailVC = [[DetailViewController alloc]init];
        NSNumber * numID = _goodsDataArr[indexPath.row][@"goods"][@"id"];
        [detailVC loadDataWithID:numID];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
    
        HomeStoreViewController * homeStVC = [[HomeStoreViewController alloc]init];
        NSNumber * numID = _storeDataArr[indexPath.row][@"store"][@"id"];
        NSLog(@"----------------%@",numID);
        homeStVC.store_ID = numID;
        [self.navigationController pushViewController:homeStVC animated:YES];
        
    }
    
}

//实现cell的删除
//设置编辑cell的类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//设置cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == commoditytableView) {
        //        在数据从数组移除前取到想要删除的ID
        NSString * deleteID = _goodsDataArr[indexPath.row][@"id"];
        [_goodsDataArr removeObjectAtIndex:indexPath.row];
        [commoditytableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //        删除收藏商品网络数据
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"fav_goods_ids":deleteID}];
        [RequestTools posUserWithURL:@"/remove_favorite_goods.mob" params:dict success:^(NSDictionary *Dict) {
            
        } failure:^(NSError *error) {
            
        }];
        
        [commoditytableView reloadData];
        
    }else if (tableView == storetableView){
        //        在数据从数组移除前取到想要删除的ID
        NSString * deleteID = _storeDataArr[indexPath.row][@"id"];
        [_storeDataArr removeObjectAtIndex:indexPath.row];
        [storetableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //        删除收藏店铺网络数据
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"fav_store_ids":deleteID}];
        [RequestTools posUserWithURL:@"/remove_favorite_store.mob" params:dict success:^(NSDictionary *Dict) {
            
        } failure:^(NSError *error) {
            
        }];
    
        [storetableView reloadData];
    }

}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

// 导航栏左右按钮点击事件
-(void)leftButtonClick{
    
}
-(void)rightButtonClick{
    
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
