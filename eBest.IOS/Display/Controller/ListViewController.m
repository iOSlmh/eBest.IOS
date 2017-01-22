//
//  ListViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/1.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ListViewController.h"
#import "ListCollectionViewCell.h"
#import "SearchBarController.h"
#import "ListViewCell.h"
#import "DisplayViewController.h"
#import "DetailViewController.h"
#import "DOPDropDownMenu.h"
#import "LoginViewController.h"

@interface ListViewController ()<UITextFieldDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    
    UICollectionView * _collectionView;
    NSInteger _page;

}
@property(nonatomic,strong) UITextField * textField;
@property(nonatomic,strong) UIView * searchBarView;
@property(strong,nonatomic) UISearchBar * searchBar;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UITableView * topTableView;
@property(nonatomic,strong) UIView * bottomView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * array;
@property (nonatomic, assign) NSInteger collectState;
@property (nonatomic,strong) DOPDropDownMenu *menu;

//筛选ID
@property (nonatomic,copy) NSString * patternID;
@property (nonatomic,copy) NSString * materialsID;
@property (nonatomic,copy) NSString * subjectID;
@property (nonatomic,copy) NSString * implicationID;
@property (nonatomic,strong) NSDictionary * songDic;

//重新请求
@property (nonatomic,strong) NSMutableArray * groupArr;

@end

@implementation ListViewController

-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createTV];
    [self loadRefresh];
    [self loadProperty];
    [self loadClassify];
    [self createMenu];
    self.patternID = @"";
    self.materialsID = @"";
    self.subjectID = @"";
    self.implicationID = @"";
    
}

#pragma mark ---------------------- 上拉加载下拉刷新

-(void)loadRefresh
{
  
    // 下拉刷新
    self.tv.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [self loadData];
        
    }];
    
    // 进入界面先进性刷新
    [_tv.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tv.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadData];
        
    }];
    
    
//    // 下拉刷新
//    _collectionView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _page = 1;
//        self.dataArray = [NSMutableArray arrayWithCapacity:0];
//        
//        [self loadData];
//        
//    }];
//    
//    // 进入界面先进性刷新
//    [_collectionView.header beginRefreshing];
//    
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    _collectionView.footer.automaticallyChangeAlpha = YES;
//    
//    // 上拉刷新
//    _collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        _page ++;
//        [self loadData];
//        
//    }];

}
-(void)loadClassify{
    
    
    [RequestTools getWithURL:@"/category.mob" params:nil success:^(NSDictionary *Dict) {
        
        self.patternArr = [[Dict objectForKey:@"category"]mutableCopy];
        [self.patternArr insertObject:@{@"className":@"样式"} atIndex:0];
       
        self.menu.dataSource = self;
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)loadProperty{

    _groupArr = [NSMutableArray array];
    [RequestTools getWithURL:@"/property.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        _groupArr = [Dict objectForKey:@"property"];
        self.materialsArr = [self.groupArr[0][@"properties"] mutableCopy];
        self.subjectArr = [self.groupArr[1][@"properties"] mutableCopy];
        self.implicationArr = [self.groupArr[2][@"properties"] mutableCopy];
        [self.materialsArr insertObject:@{@"value":@"材质"} atIndex:0];
        [self.subjectArr insertObject:@{@"value":@"题材"} atIndex:0];
        [self.implicationArr insertObject:@{@"value":@"寓意"} atIndex:0];
    
        self.menu.dataSource = self;
    } failure:^(NSError *error) {
        
    }];

}

-(void)loadData{

    if (_listGoosID) {
    
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"properties":_listGoosID}];
        [RequestTools postWithURL:@"/goods_list.mob" params:dict success:^(NSDictionary *Dict) {
            NSLog(@"----------------%@",Dict);
            NSMutableArray * array = [Dict[@"goods_list"]mutableCopy];
            for (NSDictionary * dic in array) {
                NSMutableDictionary * dict = [dic mutableCopy];
                [dict setObject:@"0" forKey:@"collectState"];
                [_dataArr addObject:dict];
            }
            
            [self.tv.mj_header endRefreshing];
            [self.tv.mj_footer endRefreshing];
            [self.tv reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}

//-(void)loadDataWithID:(NSNumber *)properID{
//
//    [_dataArr removeAllObjects];
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
//    [dict addEntriesFromDictionary:@{@"gc_id":properID,@"properties":@"14"}];
//    [RequestTools postWithURL:@"/goods_list.mob" params:dict success:^(NSDictionary *Dict) {
//        NSLog(@"----------------%@",Dict);
//        NSMutableArray * array = [Dict[@"goods_list"]mutableCopy];
//        for (NSDictionary * dic in array) {
//            NSMutableDictionary * dict = [dic mutableCopy];
//            [dict setObject:@"0" forKey:@"collectState"];
//            [_dataArr addObject:dict];
//        }
//        
//        [self.tv.mj_header endRefreshing];
//        [self.tv.mj_footer endRefreshing];
//        [self.tv reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(void)loadDataWithPatternID:(NSString *)pID materialsID:(NSString *)mID subjectID:(NSString *)sID implicationID:(NSString *)iID{
    
    [_dataArr removeAllObjects];
    
    NSMutableArray * properCountArr = [NSMutableArray array];
//    if (pID.length>0) {
//        
//        [properCountArr addObject:pID];
//    }
    if (!kIsEmptyString(mID)) {
        
        [properCountArr addObject:mID];
    }
    if (!kIsEmptyString(sID)) {
        
        [properCountArr addObject:sID];
    }
    if (!kIsEmptyString(iID)) {
        
        [properCountArr addObject:iID];
    }

    //post数组参数拼接
    NSString * canshu = @"properties";
    NSLog(@"----------------%lu",(unsigned long)properCountArr.count);
    NSMutableArray * muarr = [NSMutableArray array];
    for (int i = 0; i<properCountArr.count; i++) {
        NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,properCountArr[i]];
        NSLog(@"%@",appStr);
        [muarr addObject:appStr];
    }
    NSString *appString = [muarr componentsJoinedByString:@"&"];
    
    NSString * astr = @"/goods_list.mob?";

    NSString * getStr = [NSString stringWithFormat:@"%@%@&gc_id=%@&properties=%@",astr,appString,pID,self.listGoosID];
    NSLog(@"----------------%@",getStr);

    [RequestTools getWithURL:getStr params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        NSMutableArray * array = [Dict[@"goods_list"]mutableCopy];
        for (NSDictionary * dic in array) {
            NSMutableDictionary * dict = [dic mutableCopy];
            [dict setObject:@"0" forKey:@"collectState"];
            [_dataArr addObject:dict];
        }
        
        [self.tv.mj_header endRefreshing];
        [self.tv.mj_footer endRefreshing];
        [self.tv reloadData];

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark ----------------------菜单及代理方法
-(void)createMenu{

    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    self.tv.tableHeaderView = self.menu;
    
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.patternArr.count;
    }else if (column == 1){
        return self.materialsArr.count;
    }else if (column == 2){
        return self.subjectArr.count;
    }else {
        return self.implicationArr.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{

    if (indexPath.column == 0) {
        return self.patternArr[indexPath.row][@"className"];
    } else if (indexPath.column == 1){
        return self.materialsArr[indexPath.row][@"value"];
    } else if (indexPath.column == 2){
        return self.subjectArr[indexPath.row][@"value"];
    }else {
        return self.implicationArr[indexPath.row][@"value"];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 0) {
//            return self.cates.count;
//        } else if (row == 2){
//            return self.movices.count;
//        } else if (row == 3){
//            return self.hostels.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
//        if (indexPath.row == 0) {
//            return self.cates[indexPath.item];
//        } else if (indexPath.row == 2){
//            return self.movices[indexPath.item];
//        } else if (indexPath.row == 3){
//            return self.hostels[indexPath.item];
//        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
       
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {

        if (indexPath.column == 0) {
            self.patternID = self.patternArr[indexPath.row][@"id"];
        }else if (indexPath.column == 1){
            self.materialsID = self.materialsArr[indexPath.row][@"id"];
        }else if (indexPath.column == 2){
            self.subjectID = self.subjectArr[indexPath.row][@"id"];
        }else{
            self.implicationID = self.implicationArr[indexPath.row][@"id"];
        }
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        [self loadDataWithPatternID:self.patternID materialsID:self.materialsID subjectID:self.subjectID implicationID:self.implicationID];
    }
}

#pragma mark ----------------------创建顶部菜单展示TV
-(void)topSelectBtn{

    self.topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SW, UNIT_HEIGHT(374))];
    self.topTableView.tag = 700;
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.topTableView.bounces = NO;
    self.topTableView.showsHorizontalScrollIndicator = NO;
    self.topTableView.showsVerticalScrollIndicator = NO;
    self.topTableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.topTableView];
    self.bottomView = [FactoryUI createViewWithFrame:self.tv.frame];
    self.bottomView.alpha = 0.5;
    self.bottomView.backgroundColor = [UIColor grayColor];
    [self.tv addSubview:self.bottomView];
    [_collectionView addSubview:self.bottomView];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemove)];
    [self.bottomView addGestureRecognizer:recognizer];
    
}
//     手势移除菜单展示
-(void)tapRemove{

    [self.topTableView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.tag = 800;
    [self.tv registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //去除分割线
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tv];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==700) return 50;
    else return 125;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 700) {
        return 10;
    }
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==700) {
        static NSString *tableViewIdentifier = @"TableViewCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier];
        }
        cell.textLabel.text = @"手镯";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = RGB(123, 123, 123, 1);
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
        return cell;
        
    }else{
        ListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
        NSDictionary * listDic = _dataArr[indexPath.row];
        cell.nameLabel.text = listDic[@"goods_name"];
        NSString * str = listDic[@"goods_main_photo"][@"path"];
        ImageWithUrl(cell.imageV, str);
        cell.currentPriceLabel.text = Money([listDic[@"goods_current_price"]floatValue]);
//        cell.originalPrice.text = Money([listDic[@"goods_price"]floatValue]);
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:Money([listDic[@"goods_price"]floatValue]) attributes:attribtDic];
        
        // 赋值
        cell.originalPrice.attributedText = attribtStr;

        cell.collectBtn.tag = indexPath.row;
        [cell.collectBtn addTarget:self action:@selector(collectBtn:) forControlEvents:UIControlEventTouchUpInside];
        //reload的时候已经改变数据源collectState 进行判断改变图片
        if ([listDic[@"collectState"]isEqualToString:@"1"]) {
            [cell.collectBtn setImage:[UIImage imageNamed:@"list_Collection_selected"] forState:UIControlStateNormal];
        }else{
            [cell.collectBtn setImage:[UIImage imageNamed:@"list_Collection_default"] forState:UIControlStateNormal];
        }

    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag==700) {
        
        
    }else{
    
        DetailViewController * detailVC = [[DetailViewController alloc]init];
        NSDictionary * listDic = _dataArr[indexPath.row];
        [detailVC loadDataWithID:listDic[@"id"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }
    
}

//收藏商品
-(void)collectBtn:(UIButton *)btn{
    
    if ([Function is_Login ]){
        
        //记录收藏状态
        _dataArr[btn.tag][@"collectState"] = @"1";
        [self.tv reloadData];
        
        NSString * goodsID = _dataArr[btn.tag][@"id"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"goods_id":goodsID}];
        [RequestTools posUserWithURL:@"/add_favorite_goods.mob" params:dict success:^(NSDictionary *Dict) {
            
            if ([Dict[@"return_info"][@"errFlg"]boolValue]) {
                
                //说明已经收藏过
                [MyHUD showAllTextDialogWith:@"已收藏过商品" showView:self.view];
                
            }else{
                
                [MyHUD showAllTextDialogWith:@"收藏成功!" showView:self.view];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        
        LoginViewController * logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}

#pragma  mark 设置导航栏加载搜搜框
- (void)createSearchBarView
{
    self.searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW*0.6, 30)];
    self.searchBarView.backgroundColor = [UIColor clearColor];
    
    UISearchBar * search = [self createSearchBar];
    [self.searchBarView addSubview:search];
    
}

#pragma  mark 设置搜索框
- (UISearchBar *)createSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SW*0.6, 30)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索店铺/商品              ";
    self.searchBar.delegate = self;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.searchBar.frame;
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(searchBarClick) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:btn];

    return self.searchBar;
}

-(void)setNav{

    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton * rightBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(changeClick:)];
    [rightBtn setImage:[UIImage imageNamed:@"nav_small_image"] forState:UIControlStateNormal];//设置正常状态
    [rightBtn setImage:[UIImage imageNamed:@"nav_big_image"] forState:UIControlStateSelected];//设置选择状态
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,rightBtnItem, nil];

    [self createSearchBarView];
    self.navigationItem.titleView = self.searchBarView;

}
- (void)backClick{
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeClick:(UIButton *)btn{
    
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [self createCollectionV];
    }else{
        [_collectionView removeFromSuperview];
        
    }
}
-(void)searchBarClick{
    
    SearchBarController * searchBar = [[SearchBarController alloc]init];
    [self.navigationController pushViewController:searchBar animated:YES];
}

#pragma mark ----------------------collection的实现
-(void)createCollectionV
{

    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize=CGSizeMake(SW/2, SW/2);
    //item到父视图距离
    layout.sectionInset=UIEdgeInsetsMake(2, 0, 0, 0);
    //item列间距
    layout.minimumInteritemSpacing=0;
    //item行间距
    layout.minimumLineSpacing=0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, SW, SH-64-44)collectionViewLayout:layout];
    _collectionView.backgroundColor = RGB(236, 235, 235, 1);
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    // 不显示滚动条, 不允许下拉
//    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
//    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"ListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"listCellID"];
    [self.view addSubview:_collectionView];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    xib注册实现
    ListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    NSDictionary * listDic = _dataArr[indexPath.row];
//    cell.nameLabel.text = listDic[@"goods_name"];
    NSString * str = listDic[@"goods_main_photo"][@"path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
    cell.cruPriceL.text = Money([listDic[@"goods_current_price"]floatValue]);
    cell.originalPriceL.text = Money([listDic[@"goods_price"]floatValue]);

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailVC = [[DetailViewController alloc]init];
    NSDictionary * listDic = _dataArr[indexPath.row];
    [detailVC loadDataWithID:listDic[@"id"]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
