//
//  HomeStoreViewController.m
//  eBest.IOS
//
//  Created by lianyanmin on 16/9/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HeaderView.h"
#import "SecondHeader.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"
#import "CollectionViewCell.h"
#import "TriangleView.h"
#import "HomeViewController.h"

@interface HomeStoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@property (nonatomic, strong) UICollectionView *secondCollectionView;
@property (nonatomic, strong) UICollectionViewLayout *secondcollectionViewLayout;

@property (nonatomic,strong) UIView * moreView;
@property (nonatomic,strong) NSMutableArray * itemArr;
@property (nonatomic,strong) NSDictionary * mesDic;
@property (nonatomic,strong) NSMutableArray * classArr;
@property (nonatomic,strong) UIView * sanjiaoView;
@property (nonatomic, assign) BOOL isHeaderViewReload;
@property (nonatomic, assign) BOOL isSecondHeaderViewReload;
@property (nonatomic, assign) BOOL isNotifiReload;
@property (nonatomic, assign) BOOL isFooterViewReload;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * navView;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * moreBtn;
@end

@implementation HomeStoreViewController

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isHeaderViewReload = NO;
    
    self.isSecondHeaderViewReload = NO;
    
    self.isNotifiReload = NO;
    
    self.isFooterViewReload = NO;
    
//    [self setNav];
    
    [self createNav];
    
    [self configUI];
    
    [self loadMesData];
    
    [self loadItemData];
    
//    [self loadPicData];
    
//    [self loadClassData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chan) name:@"change" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideGoods) name:@"HideGoods" object:nil];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    [_secondCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SecondHeader"];
    
    [_secondCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];

}
#pragma mark 创建导航条
-(void)createNav{

   _navView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 64)];
    _navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    
    _leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 22, 44, 44) title:@"" titleColor:nil imageName:@"nav_return2" backgroundImageName:@"" target:self selector:@selector(backClick)];
    [_navView addSubview:_leftBtn];
    
    _moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-10-50, 22, 44, 44) title:@"" titleColor:nil imageName:@"nav_more2" backgroundImageName:@"" target:self selector:@selector(moreClick:)];
    [_navView addSubview:_moreBtn];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    //改变导航条内容
    if (offsetY > 50) {
        
        CGFloat alpha = MIN(1, 1 - ((50 + 80 - offsetY) / 80));
        
        _navView.backgroundColor = RGB(255, 255, 255, alpha);
        _navView.layer.shadowOffset = CGSizeMake(0, 0.5);
        _navView.layer.shadowColor = RGB(71, 71, 71, 1).CGColor;
        _navView.layer.shadowOpacity = 0.5;
        _navView.clipsToBounds = NO;
        [_leftBtn setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
        
    } else {
        
        
        [_leftBtn setImage:[UIImage imageNamed:@"nav_return2"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"nav_more2"] forState:UIControlStateNormal];
        _navView.backgroundColor = RGB(255, 255, 255, 0);
    }

}

-(void)chan{
    
//    [self.view bringSubviewToFront:_secondCollectionView];
    
    _secondCollectionView.hidden = NO;
    
    _collectionView.hidden = YES;
    
//    [self.secondCollectionView reloadData];
    
}
-(void)hideGoods{

//    [self.view bringSubviewToFront:_collectionView];
    
    _secondCollectionView.hidden = YES;
    
    _collectionView.hidden = NO;
    
}
#pragma mark ----------------------店铺信息
-(void)loadMesData{
    
    NSDictionary * dic = @{@"store_id":[self.store_ID stringValue]};
    
    [RequestTools postWithURL:@"/store.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        self.mesDic = Dict[@"store"];
        
        [self.collectionView reloadData];
        [self.secondCollectionView reloadData];
    } failure:^(NSError *error) {

    }];

}
#pragma mark ----------------------请求分类数据
-(void)loadClassData{
    
    _classArr = [NSMutableArray array];
    
    [RequestTools getWithURL:@"/category.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        
        _classArr = [Dict objectForKey:@"category"];
        
        NSLog(@"%lu",(unsigned long)_classArr.count);
    
        [self.collectionView reloadData];
        [self.secondCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

//    [RequestTools postWithURL:@"/user_category.mob" params:nil success:^(NSDictionary *Dict) {
//        
//        NSLog(@"----------------%@",Dict);
//    } failure:^(NSError *error) {
//        
//    }];
//    [RequestTools posUserWithURL:@"" params:nil success:^(NSDictionary *Dict) {
//        
//        NSLog(@"----------------%@",Dict);
//    } failure:^(NSError *error) {
//        NSLog(@"----------------%@",error);
//    }];

}
#pragma mark ----------------------请求商品数据
-(void)loadPicData{
    
    NSDictionary * dic = @{@"store_id":self.store_ID,@"show_num":@"4"};
    [RequestTools postWithURL:@"/goodsClass.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ----------------------请求轮播数据
-(void)loadItemData{
    
    self.itemArr = [NSMutableArray array];
    NSDictionary * dic = @{@"store_id":[self.store_ID stringValue],@"store_recommend_mobile":@"1"};
    [RequestTools posUserWithURL:@"/goods_list.mob" params:dic success:^(NSDictionary *Dict) {
        
         NSLog(@"----------------%@",Dict);
        //判空处理 
        for (NSString *key in Dict.allKeys) {
            if (![[Dict objectForKey:key] isEqual:[NSNull null]]) {
                
                self.itemArr = [Dict[@"goods_list"] mutableCopy];
                
                [self.collectionView reloadData];
                [self.secondCollectionView reloadData];
            }
        }
    
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- configUI
- (void)configUI {
    
#pragma mark -- collectionViewUI
   
    UICollectionViewFlowLayout *collctionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collctionViewFlowLayout.itemSize = CGSizeMake((SW-1)/2,(SW-1)/2);
    collctionViewFlowLayout.minimumInteritemSpacing = 0;
    collctionViewFlowLayout.minimumLineSpacing = 1;
    collctionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionViewLayout =  collctionViewFlowLayout;
    
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,-64,SW,SH-48+64) collectionViewLayout:collctionViewFlowLayout];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SW,SH) collectionViewLayout:collctionViewFlowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = RGB(247, 247, 247, 1);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    
    //注册单元格
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.view addSubview:collectionView];

    
#pragma mark -- secondCollectionViewUI
    
    UICollectionViewFlowLayout *secondcollctionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    secondcollctionViewFlowLayout.itemSize = CGSizeMake((SW-1)/2,(SW-1)/2);
    secondcollctionViewFlowLayout.minimumInteritemSpacing = 0;
    secondcollctionViewFlowLayout.minimumLineSpacing = 1;
    secondcollctionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.secondcollectionViewLayout =  secondcollctionViewFlowLayout;
    
    _secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SW,SH) collectionViewLayout:secondcollctionViewFlowLayout];
    
    _secondCollectionView.delegate = self;
    _secondCollectionView.dataSource = self;
    self.secondCollectionView.backgroundColor = RGB(247, 247, 247, 1);
    self.secondCollectionView.showsHorizontalScrollIndicator = NO;
    
    _secondCollectionView.hidden = YES;
    
    //注册单元格
    [_secondCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionView"];
    
    [self.view addSubview:_secondCollectionView];
    
    [self.view bringSubviewToFront:_navView];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.itemArr.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
        
    if (collectionView==_collectionView) {
        
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        cell.desclabel.text = _itemArr[indexPath.section][@"goods_name"];
        cell.cruPrice.text = [_itemArr[indexPath.section][@"goods_current_price"] stringValue];
        cell.oldPrice.text = [_itemArr[indexPath.section][@"goods_price"] stringValue];
        ImageWithUrl(cell.ImageV, _itemArr[indexPath.section][@"goods_main_photo"][@"path"]);
        
        return cell;
    }else{
        
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionView" forIndexPath:indexPath];
        cell.desclabel.text = _itemArr[indexPath.section][@"goods_name"];
        cell.cruPrice.text = [_itemArr[indexPath.section][@"goods_current_price"] stringValue];
        cell.oldPrice.text = [_itemArr[indexPath.section][@"goods_price"] stringValue];
        ImageWithUrl(cell.ImageV, _itemArr[indexPath.section][@"goods_main_photo"][@"path"]);

        return cell;
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (collectionView==_collectionView) {
            
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            
            if (indexPath.section == 0) {

                //判断header只创建一次
                if (!self.isHeaderViewReload) {
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = RGB(71, 71, 71, 1);
                    label.backgroundColor = [UIColor whiteColor];
                    label.text = _itemArr[indexPath.section][@"gc"][@"className"];
                    label.textAlignment = NSTextAlignmentCenter;
                    [reusableView addSubview:label];
                    
                    HeaderView *header = [HeaderView headerView];
                    
                    self.isHeaderViewReload = YES;
                    //header.storeDesc.text = self.mesDic[@""];
                    header.storeName.text = self.mesDic[@"store_name"];
                    
                    ImageWithUrl(header.storeImageV, self.mesDic[@"store_logo"][@"path"]);
                    
                    [reusableView addSubview:header];
                    
                    [header mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.and.top.trailing.equalTo(reusableView);
                        make.height.mas_equalTo(637);
                    }];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.mas_equalTo(header.mas_bottom).offset(15);
                        make.leading.and.trailing.equalTo(reusableView);
                        make.height.mas_equalTo(49);
                        
                    }];

                }
                
                //通知只要一次（header里面创建了轮播）因此需控制通知避免重复创建
                if (self.itemArr && !self.isNotifiReload) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemArr" object:self userInfo:@{@"itemArr":self.itemArr}];
                    
                    self.isNotifiReload = YES;
                }

                
            } else {
                
                //复用问题移除所有子视图之后重新加载
                NSArray *viewsToRemove = [reusableView subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }
                
                
                UILabel *label = [[UILabel alloc]init];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
                label.backgroundColor = [UIColor whiteColor];
                label.text = _itemArr[indexPath.section][@"gc"][@"className"];
                label.textAlignment = NSTextAlignmentCenter;
                [reusableView addSubview:label];

                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(reusableView.mas_top).offset(15);
                    make.leading.and.trailing.equalTo(reusableView);
                    make.height.mas_equalTo(49);
                    
                }];
            }
            return reusableView;
            
        }else{
            
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SecondHeader" forIndexPath:indexPath];
            
            
            if (indexPath.section == 0) {
                
                //判断header只创建一次
                if (!self.isSecondHeaderViewReload) {
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.backgroundColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
                    label.text = @"戒  指";
                    label.textAlignment = NSTextAlignmentCenter;
                    [reusableView addSubview:label];
                    
                    SecondHeader *header = [SecondHeader secondHeader];
                    
                    self.isSecondHeaderViewReload = YES;
                    
                    header.storeName.text = self.mesDic[@"store_name"];
                    
                    ImageWithUrl(header.storeImageV, self.mesDic[@"store_logo"][@"path"]);
                    
                    [reusableView addSubview:header];
                    
                    [header mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.and.top.trailing.equalTo(reusableView);
                        make.height.mas_equalTo(224);
                    }];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(header.mas_bottom).offset(15);
                        make.leading.and.trailing.equalTo(reusableView);
                        make.height.mas_equalTo(49);
                    }];

                }
                
                
            } else {
                
                NSArray *viewsToRemove = [reusableView subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc]init];
                label.font = [UIFont systemFontOfSize:15];
                label.backgroundColor = [UIColor whiteColor];
                label.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
                label.text = @"戒  指";
                label.textAlignment = NSTextAlignmentCenter;
                [reusableView addSubview:label];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.edges.equalTo(reusableView);
                }];
            }

            
            return reusableView;
            
        }
    }
    
    else {
        
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        if (!self.isFooterViewReload) {
            
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"查看更多 >" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
        [button setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
        [reusableView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(reusableView.mas_top).offset(1);
            make.leading.and.trailing.equalTo(reusableView);
            make.height.mas_equalTo(40);
//            make.edges.equalTo(reusableView);
        }];
            self.isFooterViewReload = YES;
            
        }
        return reusableView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (collectionView==self.collectionView&&collectionViewLayout==self.collectionViewLayout) {
        
        CGFloat height = 65;
        if (section == 0) {
            height += 637;
        }
        return CGSizeMake(375, height);
        
    }else{
        
        CGFloat height = 65;
        if (section == 0) {
            height += 224;
        }
        return CGSizeMake(375, height);
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(375, 40);

}

//设置导航条样式
-(void)setNav{
    
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return2" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton * cartBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_home2" backgroundImageName:@"" target:self selector:@selector(homeClick)];
    UIButton * moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_more2" backgroundImageName:@"" target:self selector:@selector(moreClick:)];
    UIBarButtonItem * cartItem = [[UIBarButtonItem alloc]initWithCustomView:cartBtn];
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    NSArray * arr = @[negativeSpacer,moreItem,negativeSpacer,cartItem];
    self.navigationItem.rightBarButtonItems = arr;
    
}

-(void)homeClick{

        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] baseTabBar] setSelectedIndex:0];

}

//更多按钮点击事件
- (void)moreClick:(UIButton *)btn{
    
//    btn.selected = !(btn.selected);
//    if (btn.selected==YES) {
        //创建一个黑色背景
        self.bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgView setBackgroundColor:[UIColor clearColor]];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.bgView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [self.bgView addGestureRecognizer:tapGesture];
        
        [self createMoreView];
//    }else{
//        [self.moreView removeFromSuperview];
//        [self.sanjiaoView removeFromSuperview];
//    }
    
}
//点击空白关闭
-(void)closeView{
    
    [self.moreView removeFromSuperview];
    [self.sanjiaoView removeFromSuperview];
    [self.bgView removeFromSuperview];
    
}
//创建更多按钮选择框
-(void)createMoreView{
    
    _sanjiaoView = [[TriangleView alloc]initWithFrame:CGRectMake(SW-35, 64, 30, 10) color:[UIColor whiteColor]];
    [self.view addSubview:_sanjiaoView];
    NSArray * imageArr = @[@"nav_more_home",@"nav_more_news",@"nav_more_share"];
    NSArray * titleArr = @[@"首页",@"消息",@"分享"];
    self.moreView = [FactoryUI createViewWithFrame:CGRectMake(SW-135, 74, 130, 150)];
    self.moreView.backgroundColor = [UIColor whiteColor];
    self.moreView.layer.cornerRadius = 2;
    self.moreView.layer.masksToBounds = YES;
    self.moreView.layer.shadowOffset = CGSizeMake(0, 1);
    self.moreView.layer.shadowOpacity = 1.0;
    self.moreView.clipsToBounds = NO;
    self.moreView.layer.shadowColor = RGB(187, 187, 187, 1).CGColor;
    [self.bgView addSubview:self.moreView];
    for (int i =0; i<3; i++) {
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
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] baseTabBar] setSelectedIndex:0];
        
    }else if (btn.tag == 151){
        
        
    }else{
        
        
    }
    
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
