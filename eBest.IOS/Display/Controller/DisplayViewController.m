//
//  DisplayViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/25.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DisplayViewController.h"
#import "DisCollectionViewCell.h"
#import "DisCollectionReusableView.h"
#import "DisTableViewCell.h"
#import "ListViewController.h"
#import "DetailViewController.h"
#import "SystemMessageViewController.h"
#import "LoginViewController.h"
#import "DefaultCell.h"
#import "DetailViewController.h"

@interface DisplayViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,DisTableViewCellCollectDelegate>
{
    DisCollectionReusableView * _label;
    UICollectionView * _collectionView;
}
@property (nonatomic,strong) UITableView * tv;
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic,strong) NSMutableArray * groupArr;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,strong) NSMutableArray * nameArr;
@property (nonatomic,strong) UITableView * rightTV;
@property (nonatomic,strong) NSMutableArray * leftListArr;
@property (nonatomic,strong) UILabel * lb;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString * IDStr;
@property (nonatomic,strong) NSMutableArray * picArr;
@property (nonatomic,strong) NSArray * array;
@property(assign,nonatomic,readonly) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger collectState;

@end

@implementation DisplayViewController

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.translucent = NO;
    //涉及到断网刷新问题
    [self loadData];
    [self createData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    _selectIndex = 0;
    [self createNav];
    [self createTV];
    [self createCollectionV];
    [self createRightTV];
    [self loadData];
    [self createData];
    self.edgesForExtendedLayout=NO;
}

-(void)SwitchBtn:(UIButton *)btn{



}
-(void)loadData{
    
    [RequestTools getWithURL:@"/category.mob" params:nil success:^(NSDictionary *Dict) {
        
        _dataArr = [Dict objectForKey:@"category"];
        
//        NSLog(@"----------------%@",Dict);
//        NSLog(@"%lu",(unsigned long)_dataArr.count);
       
        [self.tv reloadData];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
        [self.tv selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        NSIndexPath * path = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
        [self tableView:self.tv didSelectRowAtIndexPath:path];

    } failure:^(NSError *error) {
        
    }];
    
}
//请求轮播图片
-(void)loadScrollPicWithID:(NSString *)gc_id{
    
    _picArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary * dic = @{@"gc_id":gc_id,@"exhibition_slide_mobile":@"exhibition_slide_mobile",@"show_num":@"3"};
    [RequestTools postWithURL:@"/goods_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        _array =  Dict[@"goods_list"];
        for (NSDictionary * dic in self.array) {
            NSString * picUrl = [NSString stringWithFormat:@"%@%@",Image_url,dic[@"goods_main_photo_path"]];
            [self.picArr addObject:picUrl];
        }
        [self.rightTV reloadData];
    } failure:^(NSError *error) {
        
    }];

}
//加载数据
-(void)createData
{
    _groupArr = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _modelArr = [NSMutableArray array];
    _nameArr = [NSMutableArray array];
    [RequestTools getWithURL:@"/property.mob" params:nil success:^(NSDictionary *Dict) {
        
//        NSLog(@"----------------%@",Dict);
        _groupArr = [Dict objectForKey:@"property"];
        for (NSDictionary * dict in _groupArr) {
            //提取collection分类头标题
            NSString * nameStr = dict[@"name"];
            [_nameArr addObject:nameStr];
            //存数据大模型
            DisplayModel * disModel = [[DisplayModel alloc]init];
            [disModel setValuesForKeysWithDictionary:dict];
            [_modelArr addObject:disModel];
        }

        [_collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)createCollectionV
{
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize=CGSizeMake(70, 100);
    //item到父视图距离
    layout.sectionInset=UIEdgeInsetsMake(0, 15, 0, 15);
    //item列间距
    layout.minimumInteritemSpacing=1;
    //item行间距
    layout.minimumLineSpacing=0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(UNIT_WIDTH(80), UNIT_HEIGHT(5), SW-UNIT_WIDTH(85), SH-64-44-5)collectionViewLayout:layout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    // 不显示滚动条, 不允许下拉
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"DisCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"disCellID"];
    [_collectionView registerClass:[DisCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellR"];
    [self.view addSubview:_collectionView];
    
}
//设置header和footer的view
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    _label = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellR" forIndexPath:indexPath];
    _label.backgroundColor = RGB(255, 255, 255, 1);
    _label.titleLabel.text = _nameArr[indexPath.section];
    
    return _label;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(SW, 41);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DisplayModel * disModel = _modelArr[section];
    return disModel.properties.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _groupArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    xib注册实现
    DisCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"disCellID" forIndexPath:indexPath];
    DisplayModel * disModel = _modelArr[indexPath.section];
    NSLog(@"----------------%@",disModel.properties[indexPath.item][@"id"]);
    cell.nameLabel.text = disModel.properties[indexPath.item][@"value"];
    NSLog(@"%@",disModel.properties[indexPath.item][@"value"]);
    NSString * str = disModel.properties[indexPath.item][@"specImage"][@"path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"newbarcode_default_itemImage"]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DisplayModel * disModel = _modelArr[indexPath.section];
    ListViewController * listVC = [[ListViewController alloc]init];
    listVC.listGoosID = disModel.properties[indexPath.item][@"id"];
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark ----------------------tv代理协议
-(void)createTV
{
 
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UNIT_WIDTH(75), SH-64-48)style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.tag = 400;
    // 去除分割线
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tv registerNib:[UINib nibWithNibName:@"KindCell.h" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.tv registerNib:[UINib nibWithNibName:@"DefaultCell" bundle:nil] forCellReuseIdentifier:@"defaultCellID"];
    self.tv.bounces = NO;
    self.tv.showsHorizontalScrollIndicator = NO;
    self.tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tv];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView.tag==400)  return _dataArr.count+1;
    if (tableView.tag==500)  return _leftListArr.count;
    return 0;
        
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 400)
    {
//        static NSString *tableViewIdentifier = @"TableViewCellIdentifier";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray; 
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier];
//            
//        }
       
        DefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellID"];
        
        if (indexPath.row==0) {
            
            cell.defaultLb.text = @"热门分类";
            cell.defaultLb.adjustsFontSizeToFitWidth = YES;
//            [cell.defaultLb sizeToFit];
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = RGB(236, 235, 235, 1);
            
        }else{
            
                NSDictionary * dic = _dataArr[indexPath.row-1];
                cell.defaultLb.text = [dic objectForKey:@"className"];
                cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = RGB(236, 235, 235, 1);
            }
        
        return cell;
        
    }else if (tableView.tag == 500)
    {
        DisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rightID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5)];
        line.backgroundColor = RGB(236, 235, 235, 1);
        [cell addSubview:line];
        
        NSDictionary * listDic = _leftListArr[indexPath.row];
        cell.nameLb.text = listDic[@"goods_name"];
        NSString * str = listDic[@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        cell.curPrice.text = Money([listDic[@"goods_current_price"]floatValue]);
        cell.odPrice.text = Money([listDic[@"goods_price"]floatValue]);
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
    return nil;
    
}
//收藏商品
-(void)collectBtn:(UIButton *)btn{

    if ([Function is_Login ]){
        
        //记录收藏状态
        _leftListArr[btn.tag][@"collectState"] = @"1";
        [self.rightTV reloadData];
        
        NSString * goodsID = _leftListArr[btn.tag][@"id"];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 400)
    {
        return 46;
    }else{
        
        return 110;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 500)
    {
        return 200;
    }else
    {
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    int a = SW-85;
    if (tableView.tag == 500) {
        UIView * headerView = [[UIView alloc]init];
        DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0,0,SW-85,200) WithImageUrls:self.picArr];
        picView1.AutoScrollDelay = 2.0f;
        picView1.backgroundColor = [UIColor clearColor];
        [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
            printf("你点到我了😳index:%zd\n",index);
            DetailViewController * detailVC = [[DetailViewController alloc]init];
            [detailVC loadDataWithID:self.array[index][@"id"]];
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
        [headerView addSubview:picView1];

//        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 200)];
//        scrollView.tag = 600;
//        scrollView.delegate = self;
//        scrollView.pagingEnabled = YES;
//        scrollView.contentSize = CGSizeMake(3*(SW-85), 200);
//                for (int i =0; i<10; i++) {
//            UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(i*a, 0, a, 200) imageName:[NSString stringWithFormat:@"%d",i+1]];
//    //轮播产品标题
//    UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(imageV.frame.size.width*0.3/2, imageV.frame.size.height*0.6, imageV.frame.size.width*0.7, 35) text:@"天然玛瑙紫玛瑙南红紫玛瑙玉石" textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
//    lb.textAlignment = NSTextAlignmentCenter;
//        lb.numberOfLines = 0;
//        [imageV addSubview:lb];
//    //轮播产品价格
//    UILabel * sPriceLabel = [FactoryUI createLabelWithFrame:CGRectMake(imageV.frame.size.width*0.3/2, imageV.frame.size.height*0.6+45, imageV.frame.size.width*0.7, 14) text:@"¥3678.00" textColor:RGB(255,98,72,1) font:[UIFont systemFontOfSize:14]];
//    sPriceLabel.textAlignment = NSTextAlignmentCenter;
//            [imageV addSubview:sPriceLabel];
//            [scrollView addSubview:imageV];
//        }
//        scrollView.backgroundColor = [UIColor grayColor];
//        return scrollView;
        return headerView;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==400)
    {
        
        if (indexPath.row == 0)
        {
            self.rightTV.hidden = YES;
            _collectionView.hidden = NO;
            [_collectionView reloadData];
        }
        else
        {
            //滚到顶端
            [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
            _collectionView.hidden = YES;
            _rightTV.hidden = NO;
            [self loadRefresh];
            //传商品分类ID
            _IDStr = _dataArr[indexPath.row-1][@"id"];
            [self loadScrollPicWithID:_IDStr];
        }
            //字体变色
            [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = RGB(71, 71, 71, 1);
            _selectIndex=indexPath.row;
        
    }
    
    if (tableView.tag==500)
    {
        
        DetailViewController * detailVC = [[DetailViewController alloc]init];
        NSDictionary * listDic = _leftListArr[indexPath.row];
        [detailVC loadDataWithID:listDic[@"id"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark ---------------------- 上拉加载下拉刷新

-(void)loadRefresh
{
     _leftListArr = [NSMutableArray array];
    // 下拉刷新
    self.rightTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        self.leftListArr = [NSMutableArray arrayWithCapacity:0];
        
        [self loadListDatalistID:_IDStr];
        
    }];
    
    // 进入界面先进性刷新
    [self.rightTV.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.rightTV.mj_footer.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.rightTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++;
        [self loadListDatalistID:_IDStr];
        
    }];
}

//请求左侧列表对应TV数据
-(void)loadListDatalistID:(NSString *)str{
    
    NSLog(@"----------------%@",str);
    NSDictionary * dic = @{@"gc_id":str,@"current_page":[NSString stringWithFormat:@"%ld",(long)_page]};
    [RequestTools postWithURL:@"/goods_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSMutableArray * array = [Dict[@"goods_list"]mutableCopy];
        for (NSDictionary * dic in array) {
            NSMutableDictionary * dict = [dic mutableCopy];
            [dict setObject:@"0" forKey:@"collectState"];
            [_leftListArr addObject:dict];
        }
        
        [self.rightTV.mj_header endRefreshing];
        [self.rightTV.mj_footer endRefreshing];
        [self.rightTV reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 取消选中后做什么
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark ----------------------------------- 创建右侧tableview
-(void)createRightTV{
    
    self.rightTV = [[UITableView alloc]initWithFrame:CGRectMake(UNIT_WIDTH(80), UNIT_HEIGHT(5), SW-UNIT_WIDTH(85), SH-64-44-5)];
    self.rightTV.delegate = self;
    self.rightTV.dataSource = self;
//    self.rightTV.backgroundColor = RGB(236, 235, 235, 1)
    //去除分割线
    self.rightTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTV registerNib:[UINib nibWithNibName:@"DisTableViewCell" bundle:nil] forCellReuseIdentifier:@"rightID"];
    self.rightTV.tag = 500;
    self.rightTV.separatorStyle = NO;
    self.rightTV.showsVerticalScrollIndicator = NO;
    self.rightTV.hidden = YES;
    [self.view addSubview:self.rightTV];
    
}

//取消右侧TV的header粘滞效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag==500) {
        CGFloat sectionHeaderHeight = 200;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//创建导航栏
-(void)createNav{
    
    self.titleLabel.text = @"臻玉展厅";
    UIButton * messageBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_news" backgroundImageName:@"" target:self selector:@selector(messageClick)];
    UIBarButtonItem* messageBtnItem = [[UIBarButtonItem alloc]initWithCustomView:messageBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,messageBtnItem,nil];
}

// 导航栏左右按钮点击事件
-(void)messageClick{
    
    SystemMessageViewController * messageVC = [[SystemMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
