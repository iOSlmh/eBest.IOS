//
//  DetailViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/15.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

/*
 版本升级问题：
 
 1.规格选择界面中数量选择在多产品选择时footer后移产品数量不能初始化，因此为nil，不能写入字典，当前通过对不同机型等比适配将footer暴露
 */
#import "DetailViewController.h"
#import "DetailViewCell.h"
#import "DetailModel.h"
#import "SelectCell.h"
#import "OrderViewController.h"
#import "ShoppingCartViewController.h"
#import "LoginViewController.h"
#import "LXSegmentScrollView.h"
#import "HomeStoreViewController.h"
#import "CommetCell.h"
#import "CommentModel.h"
#import "AlertShow.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "EaseConversationListViewController.h"
#import "PicCell.h"
#import "TriangleView.h"
#import "SystemMessageViewController.h"
#import "PicModel.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>


//枚举类型
typedef enum {
    // 数据加载类型  与选择按钮tag值对应
    LoadTypesAllEvaluate = 300,
    LoadTypesGoodEvaluate,
    LoadTypesMiddleEvaluate,
    LoadTypesBadEvaluate
} LoadTypes;

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SelectCellHeight,TypeSeleteDelegete,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    __weak  UIPageControl *_PageControl;
    //规格选择界面成员变量
    NSInteger num;
    UIButton * _cutNumBtn;
    UIButton * _addNumBtn;
    UILabel * _countLabel;
    NSMutableArray *_btnMutableArr;
    
}

@property(nonatomic,assign) CGFloat selectHeight;
@property(strong,nonatomic) NSMutableArray * selectDataArr;
@property(strong,nonatomic) NSMutableArray * dicArr;
@property(strong,nonatomic) NSMutableArray * muArr;
@property(nonatomic,strong) NSString * gcID;
@property(nonatomic,strong) NSString * storeID;
@property(nonatomic,copy) NSString * properStr;
@property(nonatomic,assign) NSInteger stateBtn;
@property(nonatomic,assign) BOOL patternState;
@property(nonatomic,strong) UIButton * selectConfirmBtn;
@property(nonatomic,strong) UIButton * subAddBtn;
@property(nonatomic,strong) UIButton * subBuyBtn;

//请求数据源
@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) NSMutableArray * photoArr;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * currentPrice;
@property(nonatomic,strong) NSString * originalPrice;
@property(nonatomic,strong) NSNumber * goodsID;
@property(nonatomic,copy) NSString * chicunID;
@property(nonatomic,copy) NSString * yanseID;

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UITableView * anotherTV;
@property(nonatomic,strong) UITableView * picTV;
@property(nonatomic,strong) UIView * comBottomView;
@property(nonatomic,strong) UITableView * commentTV;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UIView * selectView;
@property(nonatomic,assign) NSInteger stock;
@property(nonatomic,assign) NSInteger noProperStock;
@property(nonatomic,strong) UITableView * selectTv;
@property(nonatomic,strong) UIView * grayView;
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UIView * moreView;
@property(nonatomic,strong) UIView * shareView;
@property(nonatomic,strong) UIScrollView * bottomScrollView;
@property(nonatomic,strong) TriangleView * sanjiaoView;
@property(nonatomic,strong) UIView * bgView;

/** 选择按钮工具条 */
@property (nonatomic, strong) UIView *selToolBar;
/** 评论字典 */
@property(nonatomic,strong) NSDictionary *evaDic;
/** 评论数据 */
@property(nonatomic,strong) NSMutableArray * commentArr;
/** 模型 */
@property(nonatomic,strong) NSMutableArray * modelArr;
/** 全部评价列表 */
@property (nonatomic, strong) UITableView *allEvaluateList;
/** 好评列表 */
@property (nonatomic, strong) UITableView *goodEvaluateList;
/** 中评列表 */
@property (nonatomic, strong) UITableView *middleEvaluateList;
/** 差评列表 */
@property (nonatomic, strong) UITableView *badEvaluateList;

//header组属性
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) LPLabel * oPriceLabel;
@property(nonatomic,strong) UILabel * nPriceLabel;
@property(nonatomic,strong) UILabel * postFreeLabel;
@property(nonatomic,strong) UILabel * retuneFreelabel;
@property(nonatomic,strong) UIButton * shareBtn;

@property(nonatomic,strong) UILabel * selectTitle;
@property(nonatomic,strong) UIButton * imageBtn;
@property(nonatomic,strong) UIImageView * photoImage;
@property (nonatomic,strong) NSMutableArray * picArr;
@property (nonatomic,strong) NSMutableArray * picModelArr;
@property (strong,nonatomic) UIButton * backBtn;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    num = 1;
     self.view.backgroundColor = RGB(226, 226, 226, 1);
    _modelArr = [NSMutableArray arrayWithCapacity:0];
    //设置导航栏
    [self setNav];
    //评论请求
    [self loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
    //创建scrollView
    [self createBottomScrollView];
    [self createBottomBtn];
    //详情图片
    [self loadPicDetail];
    //底部返回按钮
    [self createBackBtn];

}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
//    self.navigationController.navigationBar.translucent = YES;//方案二
}

#pragma mark ----------------------图文详情
-(void)loadPicDetail{
    
    NSDictionary * diccct = @{@"goods_id":_testID};
    
    [RequestTools postWithURL:@"/goods_details.mob" params:diccct success:^(NSDictionary *Dict) {
        
        self.picModelArr = [NSMutableArray array];
        _picArr = [Dict[@"goods_details"] mutableCopy];
        
        for (NSDictionary * dic in _picArr) {
            
            PicModel * model = [[PicModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.picModelArr addObject:model];
           
        }
        [self.picTV reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
//-(NSMutableArray *)picModelArr{
//    if (!_picModelArr) {
//        
//        _picModelArr = [[NSMutableArray alloc]init];
//    }
//    return _picModelArr;
//}
#pragma mark ----------------------规格选择代理
-(void)selectBtn:(UIButton *)btn btnID:(NSString *)IDStr selectPhoto:(NSString *)photoPath{
    
    //规格图片
    ImageWithUrl(_photoImage, photoPath);

    if (btn.tag>=2000) {
        
        self.chicunID = IDStr;
        
    }else{
    
        self.yanseID = IDStr;
       
    }
    //查询库存
    if (_yanseID.length >0||_chicunID.length >0) {
        
        NSMutableArray * gapArr = [NSMutableArray array];
        
        if (!kIsEmptyString(_yanseID)) {
            
            [gapArr addObject:_yanseID];
        }
        if (!kIsEmptyString(_chicunID)) {
            
            [gapArr addObject:_chicunID];
        }
        //get数组参数拼接
        NSString * canshu = @"gapd_ids";
        NSMutableArray * muarr = [NSMutableArray array];
        for (int i = 0; i<gapArr.count; i++) {
            NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,gapArr[i]];
            [muarr addObject:appStr];
        }
        NSString *appString = [muarr componentsJoinedByString:@"&"];
        NSString * astr = @"/goods_selection_stock.mob?";
        NSString * getStr = [NSString stringWithFormat:@"%@%@&goods_id=%@",astr,appString,_goodsID];
        NSLog(@"最终的字符串是 %@",getStr);
        [RequestTools getWithURL:getStr params:nil success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            
            self.stock = [Dict[@"stock"] integerValue];
            _selectTitle.text = [NSString stringWithFormat:@"库存%@件",[Dict[@"stock"] stringValue]];
            
        } failure:^(NSError *error) {
            
        }];
      
    }
}

#pragma mark --------------评价数据 getter
- (UITableView *)allEvaluateList {
    
    if (_allEvaluateList == nil) {
        _allEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, SW, SH-85-48-64) style:UITableViewStyleGrouped];
        _allEvaluateList.delegate = self;
        _allEvaluateList.dataSource = self;
        [self.comBottomView addSubview:_allEvaluateList];
        __weak typeof(self) weakSelf = self;
        [weakSelf loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
//        _allEvaluateList.header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
//        }];
//        
//        _allEvaluateList.footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesAllEvaluate-300] andType:LoadTypesAllEvaluate];
//        }];
        
    }
    return _allEvaluateList;
}

- (UITableView *)goodEvaluateList {
    
    if (_goodEvaluateList == nil) {
        _goodEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, SW, SH-85-48-64) style:UITableViewStyleGrouped];
        _goodEvaluateList.delegate = self;
        _goodEvaluateList.dataSource = self;
        [self.comBottomView addSubview:_goodEvaluateList];
        __weak typeof(self) weakSelf = self;
        [self loadNetDataWithPage:1 andType:LoadTypesGoodEvaluate];
//        _goodEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:1 andType:LoadTypesGoodEvaluate];
//        }];
//        
//        _goodEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesGoodEvaluate-300] andType:LoadTypesGoodEvaluate];
//        }];
//        _goodEvaluateList.mj_footer.automaticallyHidden = YES;
    }
    return _goodEvaluateList;
}

- (UITableView *)middleEvaluateList {
    if (_middleEvaluateList == nil) {
        _middleEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, SW, SH-85-48-64) style:UITableViewStyleGrouped];
        _middleEvaluateList.delegate = self;
        _middleEvaluateList.dataSource = self;
        [self.comBottomView addSubview:_middleEvaluateList];
        [self loadNetDataWithPage:1 andType:LoadTypesMiddleEvaluate];
        __weak typeof(self) weakSelf = self;
//        _middleEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:1 andType:LoadTypesMiddleEvaluate];
//        }];
//        
//        _middleEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesMiddleEvaluate-300] andType:LoadTypesMiddleEvaluate];
//        }];
//        _middleEvaluateList.mj_footer.automaticallyHidden = YES;
    }
    return _middleEvaluateList;
}

- (UITableView *)badEvaluateList {
    if (_badEvaluateList == nil) {
        _badEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, SW, SH-85-48-64) style:UITableViewStyleGrouped];
        _badEvaluateList.delegate = self;
        _badEvaluateList.dataSource = self;
        [self.comBottomView addSubview:_badEvaluateList];
        __weak typeof(self) weakSelf = self;
        [self loadNetDataWithPage:1 andType:LoadTypesBadEvaluate];
//        _badEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:1 andType:LoadTypesBadEvaluate];
//        }];
//        
//        _badEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesBadEvaluate-300] andType:LoadTypesBadEvaluate];
//        }];
    }
    return _badEvaluateList;
}

#pragma mark - 网络数据加载
- (void)loadNetDataWithPage:(int)index andType:(LoadTypes)loadType {

    NSString *state;
    switch (loadType) {
        case LoadTypesAllEvaluate:
            state = @"";
            break;
        case LoadTypesBadEvaluate:
            state = @"-1";
            break;
        case LoadTypesMiddleEvaluate:
            state = @"0";
            break;
        case LoadTypesGoodEvaluate:
            state = @"1";
            break;
        default:
            break;
    }
    NSDictionary * dic = @{@"goods_id":_testID,@"evaluate_buyer_val":state};
    [RequestTools postWithURL:@"/goods_evaluation.mob" params:dic success:^(NSDictionary *Dict) {
        
        self.evaDic = [Dict mutableCopy];
        NSString * all = [NSString stringWithFormat:@"全部（%@）",_evaDic[@"eva_all_count"]];
        NSString * good = [NSString stringWithFormat:@"好评（%@）",_evaDic[@"eva_good_count"]];
        NSString * mid = [NSString stringWithFormat:@"中评（%@）",_evaDic[@"eva_medium_count"]];
        NSString * bad = [NSString stringWithFormat:@"差评（%@）",_evaDic[@"eva_bad_count"]];
        NSArray * countArray = @[all,good,mid,bad];
        for (int i = 0; i < countArray.count; i++) {
            UIButton *btn = (UIButton *)[_selToolBar viewWithTag:300 + i];
            [btn setTitle:countArray[i] forState:UIControlStateNormal];
        }
        
        _commentArr = [Dict[@"eva_list"]mutableCopy];
        if (kIsEmptyArray(_commentArr)) {
        
            self.commentTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }else{
        
            self.commentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
            for (NSDictionary * dic in _commentArr) {
                
                CommentModel * model = [[CommentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
            
                [_modelArr addObject:model];
            }
//        }
        [self.commentTV reloadData];
        [self.commentTV reloadEmptyDataSet];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

//- (NSMutableArray *)allEvaluateArr {
//    
//    if (_commentArr == nil) {
//        _commentArr = [[NSMutableArray alloc]init];
//    }
//    return _commentArr;
//}

#pragma mark ----------------------详情ID
-(void)loadDataWithID:(NSNumber *)ID{
    
    _dataArr = [[NSMutableArray alloc]init];
    _testID = [ID stringValue];
    NSDictionary * dic = @{@"goods_id":ID};
    [RequestTools postWithURL:@"/goods.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSDictionary * dataDic = [Dict objectForKey:@"goods"];
        self.noProperStock = [dataDic[@"goods_inventory"] integerValue];
        self.detailModel = [[DetailModel alloc]init];
        [self.detailModel setValuesForKeysWithDictionary:dataDic];
        NSLog(@"%@",self.detailModel.goods_name);
        
        //店铺ID
        _storeID = [dataDic[@"goods_store"][@"id"] stringValue];
        _dicArr = [[NSMutableArray alloc]init];
        _selectDataArr = [Dict objectForKey:@"goods_selection_property"];
        _muArr = [[NSMutableArray alloc]init];
        for (int i = 0;i<_selectDataArr.count;i++) {
            NSDictionary * dict = _selectDataArr[i];
            
            [_dicArr addObject:dict];
            
            NSString * dafenlei = [dict objectForKey:@"name"];
            [_muArr addObject:dafenlei];
        }
      
       _name = [dataDic objectForKey:@"goods_name"];
        NSNumber * num1 = [dataDic objectForKey:@"goods_current_price"];
        _currentPrice = [num1 stringValue];
        NSNumber * num2 = [dataDic objectForKey:@"goods_price"];
        _originalPrice = [num2 stringValue];
        _photoArr = [dataDic objectForKey:@"goods_photos"];
        _goodsID = [dataDic objectForKey:@"id"];
        
         [self createTV];
         [self createScrollView];
        
    } failure:^(NSError *error) {
        NSLog(@"分类接口错误");
    }];
}

#pragma mark ----------------------设置底层ScrollView
-(void)createBottomScrollView{
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, SW, SH)];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.contentSize = CGSizeMake(SW, 2*SH);
    self.bottomScrollView.backgroundColor = [UIColor whiteColor];
    [self createAnotherTV];
    [self.view addSubview:self.bottomScrollView];
}

-(void)createAnotherTV{
    
    //iOS7新增属性
    self.automaticallyAdjustsScrollViewInsets=NO;
    NSArray *array=[NSArray array];
    //第一个商品介绍界面
    self.picTV = [[UITableView alloc]init];
    self.picTV = [[UITableView alloc]initWithFrame:CGRectMake(0, SH, SW, SH)style:UITableViewStylePlain];
    self.picTV.showsVerticalScrollIndicator = NO;
    self.picTV.backgroundColor = RGB(247, 247, 247, 1);
    self.picTV.delegate = self;
    self.picTV.dataSource = self;
    [self.picTV registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellReuseIdentifier:@"picCellID"];
    [self.bottomScrollView addSubview:self.picTV];
    //第二个商品介绍
    self.comBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SH, SW, SH)];
//    [self createComBottomView];
    [self createSelBtnBar];
    [self creatCommentTV];
    [self.bottomScrollView addSubview:self.comBottomView];
    array= @[self.picTV,self.comBottomView];
    NSArray * imageNameArr = [NSArray array];
    imageNameArr = @[@"",@""];
    LXSegmentScrollView *scView= [[LXSegmentScrollView alloc]initWithFrame:CGRectMake(0, SH, SW, SH-64-44) titleArray:@[@"商品介绍",@"商品评价"] contentViewArray:array andStatePage:1 andImageArr:imageNameArr];
    [self.bottomScrollView addSubview:scView];
    
}
-(void)createBackBtn{
    
    _backBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-20-40, SH-48-40-64-20, 40, 40) title:@"返回" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(backTopClick)];
    _backBtn.backgroundColor = [UIColor redColor];
    _backBtn.alpha = 0.5;
    _backBtn.layer.cornerRadius = 20;
    _backBtn.layer.masksToBounds = YES;
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _backBtn.hidden = YES;
    [self.view addSubview:self.backBtn];
    
}

-(void)backTopClick{
    
    [self.picTV setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark 创建列表选择工具条
- (void)createSelBtnBar {
    
    _btnMutableArr = [NSMutableArray array];
    _selToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SW, 35)];
    _selToolBar.backgroundColor = [UIColor whiteColor];
    CGFloat weith= SW/4;
    for (int i=0; i<4; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn = [[UIButton alloc]initWithFrame:CGRectMake(weith*i, 0, weith, _selToolBar.frame.size.height)];
        [btn setTitleColor:RGB(123, 123, 123, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag=300+i;
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (btn.tag==300) {
            [btn setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
        }
        [_btnMutableArr addObject:btn];
        [_selToolBar addSubview:btn];
    }
    [self.comBottomView addSubview:_selToolBar];
    
}

-(void)titleBtnClick:(UIButton *)sender{
    
    //点击按钮改变标题颜色
    for (UIButton *btn in _btnMutableArr) {
        if (btn.tag == sender.tag) {
            [btn  setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
        }else {
            [btn  setTitleColor:RGB(123, 123, 123, 1) forState:UIControlStateNormal];
        }
    }

    //根据不同的Tag值加载不同界面
    switch (sender.tag) {
        case LoadTypesAllEvaluate: {
            
            
            [self loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
//            [self.comBottomView bringSubviewToFront:self.allEvaluateList];
            [self.commentTV reloadEmptyDataSet];
            
            break;
        }
        case LoadTypesGoodEvaluate: {
            
            [self loadNetDataWithPage:1 andType:LoadTypesGoodEvaluate];
            [self.commentTV reloadEmptyDataSet];
            
//            [self.comBottomView bringSubviewToFront:self.goodEvaluateList];
            break;
        }
        case LoadTypesMiddleEvaluate: {
            [self loadNetDataWithPage:1 andType:LoadTypesMiddleEvaluate];
            [self.commentTV reloadEmptyDataSet];
//            [self.comBottomView bringSubviewToFront:self.middleEvaluateList];
            break;
        }
        case LoadTypesBadEvaluate: {
            [self loadNetDataWithPage:1 andType:LoadTypesBadEvaluate];
            [self.commentTV reloadEmptyDataSet];
//            [self.comBottomView bringSubviewToFront:self.badEvaluateList];
            break;
        }
        default:
            break;
    }
}

-(void)creatCommentTV{
    
    self.commentTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SW, SH-85-44-64) style:UITableViewStylePlain];
    self.commentTV.delegate = self;
    self.commentTV.dataSource = self;
    self.commentTV.emptyDataSetDelegate = self;
    self.commentTV.emptyDataSetSource = self;
    self.commentTV.showsVerticalScrollIndicator = NO;
    [self.commentTV registerClass:[CommetCell class] forCellReuseIdentifier:@"commentCell"];
    [self.comBottomView addSubview:self.commentTV];

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
    NSString *text = @"当前没有评论哦(*^__^*)!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: RGB(123, 123, 123, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//副标题
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"可以去产品详情看看";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark ----------------------设置底层按钮
-(void)createBottomBtn{
  
//    CGFloat gap = (0.4*SW-24*2)/4;(i+1)*gap+i*gap+i*24, 12, 24, 24
    UIView * bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-112, SW, 48)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel * topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SW, 1)];
    [bottomView addSubview:topLine];
    topLine.backgroundColor = RGB(245, 245, 245, 1);
    UILabel * sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0.2*SW, 0, 1, 48)];
    [bottomView addSubview:sepLine];
    sepLine.backgroundColor = RGB(245, 245, 245, 1);
    NSArray * imageArray = @[@"icon_service",@"icon_default_collection"];
    for (int i=0; i<2; i++) {
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(i*0.2*SW, 0, 0.2*SW, 48) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(bottomBtnClick:)];
        btn.tag = 200+i;
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [bottomView addSubview:btn];
        
    }
    UIButton * addButton = [FactoryUI createButtonWithFrame:CGRectMake(0.4*SW, 0, 0.3*SW, 48) title:@"加入购物车" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(addBtnClick)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    addButton.backgroundColor = RGB(32, 179, 169, 1);
    [bottomView addSubview:addButton];
    
    UIButton * buyButton = [FactoryUI createButtonWithFrame:CGRectMake(0.7*SW, 0, 0.3*SW, 48) title:@"立即购买" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(buyBtnClick)];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    buyButton.backgroundColor = RGB(11, 67, 109, 1);
    [bottomView addSubview:buyButton];
}

-(void)bottomBtnClick:(UIButton *)btn{
    
    if (btn.tag == 201) {
        
        if ([Function is_Login ]){
            
            [btn setImage:[UIImage imageNamed:@"icon_selected_collection"] forState:UIControlStateNormal];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:@{@"goods_id":_goodsID}];
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
        
    }else{
    
        if ([Function is_Login ]){
        
            ChatViewController * chatVC = [[ChatViewController alloc]initWithConversationChatter:@"zhenyuwang" conversationType:EMConversationTypeChat];
            chatVC.title = @"臻玉商城客服";
            [self.navigationController  pushViewController:chatVC animated:YES];
            
        }else{
        
            LoginViewController * logVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];

        }
    }
}

//加入购物车
-(void)addBtnClick{
    
    if (![Function is_Login]) {
        
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [MyHUD showAllTextDialogWith:@"请先登录!" showView:self.view];
        
    }else{
    
        self.stateBtn=1000;
        if (kIsEmptyArray(_selectDataArr)) {
            
            self.patternState = NO;
            [self createGraview:0.6];
            [self createSelectView];
            
        }else{
            
            //库存判断
            if (self.noProperStock>=1) {
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:@{@"goods_id":_goodsID,@"count":@"1"}];
                [RequestTools posUserWithURL:@"/add_goods_cart.mob" params:dict success:^(NSDictionary *Dict) {
                    
                    NSLog(@"----------------%@",Dict);
                    if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                        
                        _gcID = [[Dict objectForKey:@"gc_id"] stringValue];
                        if (self.stateBtn==1000) {
                            [MyHUD showAllTextDialogWith:@"加入购物车成功!" showView:BaseView];
                        }
                    }
                    
                    [self.tv reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }else{
            
                [MyHUD showAllTextDialogWith:@"库存不足!" showView:BaseView];
            }
        }

    }

}

-(void)subBuyClick{
  
    self.stateBtn=2000;
    [self confirmClick];
    
}
-(void)subAddClick{
    
    self.stateBtn=1000;
    [self confirmClick];
}

//立即购买按钮
-(void)buyBtnClick{

    if (![Function is_Login]) {
        
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [MyHUD showAllTextDialogWith:@"请先登录!" showView:self.view];
        
    }else{
    
        self.stateBtn=2000;
        if (kIsEmptyArray(_selectDataArr)) {
            
            self.patternState = NO;
            [self createGraview:0.6];
            [self createSelectView];
            
        }else{
            
            //判断库存
            if (self.noProperStock>=1) {
                
                [self quickBuy];
                
            }else{
                
                [MyHUD showAllTextDialogWith:@"库存不足!" showView:BaseView];
            }
            
        }

    }
}

-(void)quickBuy{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"goods_id":_goodsID,@"count":@"1"}];
    [RequestTools posUserWithURL:@"/quick_buy.mob" params:dict success:^(NSDictionary *Dict) {
        
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            
            _gcID = [[Dict objectForKey:@"gc_id"] stringValue];
            OrderViewController * orderVC = [[OrderViewController alloc]init];
            orderVC.IDString = _gcID;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-44-64)style:UITableViewStyleGrouped];
    self.tv.showsVerticalScrollIndicator = NO;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.tag = 601;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tv registerNib:[UINib nibWithNibName:@"DetailViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.bottomScrollView addSubview:self.tv];
    [self setHeaderView];
    
}

//设置tableHeaderView
-(void)setHeaderView{

    self.headerView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, UNIT_HEIGHT(496))];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tv.tableHeaderView = self.headerView;
    self.titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(UNIT_WIDTH(15), UNIT_HEIGHT(SW+9), 0.76*SW, UNIT_HEIGHT(50)) text:_name textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:16]];
    self.titleLabel.numberOfLines = 0;
    [self.headerView addSubview:self.titleLabel];
    
    self.nPriceLabel = [FactoryUI createLabelWithFrame:CGRectMake(UNIT_WIDTH(15), UNIT_HEIGHT(SW+9+45+8), UNIT_WIDTH(80), UNIT_HEIGHT(20)) text:[NSString stringWithFormat:@"¥%@",_currentPrice] textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:17]];
    [self.headerView addSubview:self.nPriceLabel];
    
    self.oPriceLabel = [[LPLabel alloc]initWithFrame:CGRectMake(UNIT_WIDTH(110), UNIT_HEIGHT(SW+9+45+8), UNIT_WIDTH(55), UNIT_HEIGHT(20))];
    self.oPriceLabel.text = [NSString stringWithFormat:@"¥%@",_originalPrice];
    self.oPriceLabel.textColor = RGB(175, 175, 175, 1);
    self.oPriceLabel.font = [UIFont systemFontOfSize:11];
    self.oPriceLabel.strikeThroughColor = RGB(175, 175, 175, 1);
    [self.headerView addSubview:self.oPriceLabel];
    
    UIView * ColorView = [[UIView alloc]initWithFrame:CGRectMake(0, UNIT_HEIGHT(470), SW, UNIT_HEIGHT(26))];
    ColorView.backgroundColor = RGB(245, 245, 245, 1);
    self.postFreeLabel = [FactoryUI createLabelWithFrame:CGRectMake(UNIT_WIDTH(15), UNIT_HEIGHT(5), UNIT_WIDTH(50), UNIT_HEIGHT(15)) text:@"全国包邮" textColor:RGB(100, 70, 120, 1) font:[UIFont systemFontOfSize:UNIT_HEIGHT(11)]];
    [ColorView addSubview:self.postFreeLabel];
    
    self.retuneFreelabel = [FactoryUI createLabelWithFrame:CGRectMake(UNIT_WIDTH(105), UNIT_HEIGHT(5), UNIT_WIDTH(80), UNIT_HEIGHT(15)) text:@"七天无理由退货" textColor:RGB(100, 70, 120, 1) font:[UIFont systemFontOfSize:UNIT_HEIGHT(11)]];
    [ColorView addSubview:self.retuneFreelabel];
    [self.headerView addSubview:ColorView];

    self.shareBtn = [FactoryUI createButtonWithFrame:CGRectMake(0.8*SW, UNIT_HEIGHT(SW+9), UNIT_WIDTH(50), UNIT_HEIGHT(50)) title:@"" titleColor:RGB(100, 70, 120, 1) imageName:@"share_icon" backgroundImageName:@"" target:self selector:@selector(shareCkick)];
    self.shareBtn.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.shareBtn];
    
}

//分享按钮点击方法
-(void)shareCkick{
    
    [self createGraview:0.6];
    [self createShareView];
}

//创建分享界面
-(void)createShareView{
    
    CGFloat a = SW*44/375;
    CGFloat b = SW*55/375;
    CGFloat c = (SW-2*a-4*b)/3;
    NSArray * imageArr = @[@"share_WeChat2",@"share_WeChat1",@"share_QQ",@"share_Sina"];
    NSArray * nameArr = @[@"微信朋友圈",@"微信好友",@"QQ好友",@"新浪微博"];
   self.shareView = [FactoryUI createViewWithFrame:CGRectMake(0, 0.6*SH, SW, 0.4*SH)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shareView];
    UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, SW, 50) text:@"分享到社交平台" textColor:RGB( 123, 123, 123, 1) font:[UIFont systemFontOfSize:12]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:titleLabel];
    for (int i = 0; i<4; i++) {
        UIButton * friendCircleBtn = [FactoryUI createButtonWithFrame:CGRectMake(a+i*b+i*c, 65, b, b) title:@"" titleColor:nil imageName:imageArr[i] backgroundImageName:@"" target:self selector:@selector(shareAllBtn:)];
        friendCircleBtn.tag = 700+i;
        friendCircleBtn.layer.cornerRadius = b/2;
        friendCircleBtn.layer.masksToBounds = YES;
        [self.shareView addSubview:friendCircleBtn];
        UILabel * nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(a+i*b+i*c, 65+b+8, b, 16) text:nameArr[i] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:UNIT_WIDTH(12)]];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.shareView addSubview:nameLabel];
    }
    UIButton * cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake((SW-32)/2, 175, 32, 22) title:@"取消" titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(cancelClick)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareView addSubview:cancelBtn];
    
}

//单个分享功能
-(void)shareAllBtn:(UIButton *)btn{
    
    // 分享内容
    NSString * str = [NSString stringWithFormat:@"%@ http://www.jade-town.com/mobile/detail.html?goods_id=%@",_name,_goodsID];
    NSLog(@"----------------%@",str);
    NSString * urlStr = [NSString stringWithFormat:@"http://www.jade-town.com/mobile/detail.html?goods_id=%@",_goodsID];
    NSDictionary * dic = _photoArr[0];
    NSString * photoStr = [dic objectForKey:@"path"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_url,photoStr]];
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    UIImage * shareimage = [UIImage imageWithData:imageData];
    
    if (btn.tag==700) {
   
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:shareimage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//            NSLog(@"----------------%@",response);
//            if (response.responseCode==UMSResponseCodeSuccess) {
//                NSLog(@"分享成功");
//            }
//            
//        }];
        
        
        //原生分享图文
        WXMediaMessage *message = [WXMediaMessage message];
        message.title =str;
        
        
        [message setThumbImage:shareimage];
        
        message.description =str;
        WXWebpageObject *webpage = [[WXWebpageObject alloc]init];
        webpage.webpageUrl =urlStr;
        message.mediaObject = webpage;
        SendMessageToWXReq *req = [SendMessageToWXReq  alloc];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
        
        NSLog(@"------------%d",[WXApi sendReq:req]);
        
    }else if (btn.tag==701){
        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:str image:shareimage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode==UMSResponseCodeSuccess) {
//                NSLog(@"分享成功");
//            }
//            
//        }];
    
        
        //原生分享图文
        WXMediaMessage *message = [WXMediaMessage message];
        message.title =str;
        [message setThumbImage:shareimage];
        message.description =str;
        WXWebpageObject *webpage = [[WXWebpageObject alloc]init];
        webpage.webpageUrl =urlStr;
        message.mediaObject = webpage;
        SendMessageToWXReq *req = [SendMessageToWXReq  alloc];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];

    }else if (btn.tag==702){
        
        
//        NSString *shareTxt = str;
//        [UMSocialData defaultData].extConfig.title = @"分享";
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:@"568c83b067e58ef192001018"
//                                          shareText:shareTxt
//                                         shareImage:[UIImage imageNamed:@"1"]
//                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToSina]
//                                           delegate:nil];
        
//         [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToTencent] content:str image:shareimage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//                    if (response.responseCode==UMSResponseCodeSuccess) {
//                        NSLog(@"分享成功");
//                    }
//                
//                }];
        
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:str image:shareimage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//            if (response.responseCode==UMSResponseCodeSuccess) {
//                NSLog(@"分享成功");
//            }
//            
//        }];
        
        
        //原生分享图文
         TencentOAuth * tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1105538921" andDelegate:self];
        QQApiNewsObject * imgObj =
        [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:str description:str previewImageURL:url];
//        [imgObj setCflag:[self shareControlFlags]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
        //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //    QQApiSendResultCode sent =0;
        //        sent = [QQApiInterface SendReqToQZone:req];//空间分享
        
        [self handleSendResult:sent];
        
//        [TencentOAuth HandleOpenURL:url];
        
    
    }else{
      
        //友盟分享图文连接
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:shareimage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                
//                [MyHUD showAllTextDialogWith:@"分享成功!" showView:self.view];
//                [self.shareView removeFromSuperview];
//                [self.grayView removeFromSuperview];
//                NSLog(@"分享成功！");
//            }
//        }];
        
        
        //原生分享图文
        WBAuthorizeRequest * request  = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        //    request.userInfo = @{};
        request.userInfo =@{@"ShareMessageFrom":@"ChatRootViewController",
                            @"Other_Info_1": [NSNumber numberWithInt:123],
                            @"Other_Info_2": @[@"obj1",@"obj2"],
                            @"Other_Info_3":@{@"key1": @"obj1", @"key2": @"obj2"}};
        
        WBSendMessageToWeiboRequest * requestShare = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:request access_token:nil];
        
        [WeiboSDK sendRequest:requestShare];

        
    }

}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
    
}

- (uint64_t)shareControlFlags
{
    NSDictionary *context = [self currentNavContext];
    __block uint64_t cflag = 0;
    [context enumerateKeysAndObjectsUsingBlock:^(id key,id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]] &&
            [key isKindOfClass:[NSString class]] &&
            [key hasPrefix:@"kQQAPICtrlFlag"])
        {
            cflag |= [obj unsignedIntValue];
        }
    }];
    
    return cflag;
}

- (NSMutableDictionary *)currentNavContext
{

    UINavigationController *navCtrl = [self navigationController];
    NSMutableDictionary *context = objc_getAssociatedObject(navCtrl,(__bridge void *)(@"currentNavContext"));
    if (nil == context)
    {
        context = [NSMutableDictionary dictionaryWithCapacity:3];
        objc_setAssociatedObject(navCtrl,(__bridge void *)(@"currentNavContext"), context,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return context;
}
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ http://www.jade-town.com/mobile/detail.html?goods_id=%@",_name,_goodsID];
    WBImageObject *image = [WBImageObject object];
    
    //image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"]];
    //message.imageObject = image;
    
    NSDictionary * dic = _photoArr[0];
    NSString * photoStr = [dic objectForKey:@"path"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_url,photoStr]];
    image.imageData = [NSData dataWithContentsOfURL:url];
    message.imageObject = image;
    
    
    //    if (self.textSwitch.on)
    //    {
    //        message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
    //    }
    //
    //    if (self.imageSwitch.on)
    //    {
    //        WBImageObject *image = [WBImageObject object];
    //        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    //        message.imageObject = image;
    //    }
    //
    //    if (self.mediaSwitch.on)
    //    {
    //    WBWebpageObject *webpage = [WBWebpageObject object];
    //    webpage.objectID =@"identifier1";
    //    webpage.title =NSLocalizedString(@"分享网页标题wwww",nil);
    //    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"测试来自你的应用名称-%.0f",nil), [[NSDate date] timeIntervalSince1970]];
    //    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1"ofType:@"png"]];
    //    webpage.webpageUrl =@"http://www.baidu.com";
    //    message.mediaObject = webpage;
    //    }
    
    return message;
}
//取消分享按钮
-(void)cancelClick{

    [self.shareView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

//创建滚动试图
-(void)createScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SW, SW)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.tag = 600;
    self.scrollView.contentSize = CGSizeMake(_photoArr.count*SW, SW);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.headerView addSubview:self.scrollView];
    //创建PageControl
    if (_photoArr.count>=2) {
        UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height - 25,self.scrollView.frame.size.width, 7)];
        page.pageIndicatorTintColor = [UIColor lightGrayColor];
        page.currentPageIndicatorTintColor =  RGB(32, 179, 169, 1);
        page.numberOfPages = _photoArr.count;
        page.currentPage = 0;
        [self.tv addSubview:page];
        _PageControl = page;
    }
    //添加imageView
    for (int i = 0; i<_photoArr.count; i++) {
        NSDictionary * dic = _photoArr[i];
        NSString * str = [dic objectForKey:@"path"];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*SW, 0, SW, SW)];
        ImageWithUrl(imageV, str);
        UILabel * bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, imageV.frame.size.height-2, SW, 2)];
        bottomLine.backgroundColor = RGB(244, 244, 244, 1);
        [imageV addSubview:bottomLine];
        [self.scrollView addSubview:imageV];
       
    }
    
    [self.headerView addSubview:self.scrollView];

}

#pragma mark ----------------------tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag==600) {
        
        return 40;
        
    }else if (tableView==_commentTV) {
        
        return 0;
        
    }else{
        
        if (kIsEmptyArray(_selectDataArr)) {
            
            return 5;
            
        }else{
            
            return 0;
        }

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView.tag==601) {
     
        return 220;
        
    }else if (tableView.tag==600){
        
        if (section==_selectDataArr.count-1) {
            
            return 100;
            
        }else{
            
            return 1;
        }
        
    }else if (tableView==self.picTV){
    
        return 40;
        
    }else{
        
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag==600) {
        UIView * sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 41)];
        sectionHeader.backgroundColor = [UIColor whiteColor];
        UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(20, 0, 60, 40) text:_muArr[section] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:14]];
        [sectionHeader addSubview:titleLabel];
        return sectionHeader;
    }
    return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSArray * nameArr = @[@"店铺首页",@"收藏店铺"];
    UIView * sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor whiteColor];
    
    if (tableView.tag==601) {
        
        UIView * storeView = [FactoryUI createViewWithFrame:CGRectMake(0, 5, SW, 170)];
        storeView.backgroundColor = [UIColor whiteColor];
        [sectionFooter addSubview:storeView];
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake((SW-95)/2, 15, 95, 95) imageName:@"1"];
        imageV.layer.borderWidth = 1;
        imageV.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
        NSString * str = _detailModel.goods_store[@"store_logo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        [storeView addSubview:imageV];
        for (int i = 0; i<2; i++) {
            UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake((SW-280-14)/2+i*154, 125, 140, 30) title:nameArr[i] titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(collectBtnClick:)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = 300+i;
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
            [storeView addSubview:btn];
        }
        sectionFooter.backgroundColor = RGB(244, 244, 244, 1);
        UILabel * footerLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 170, SW, 50) text:@"继续拖动，查看图文详情" textColor:RGB(162, 153,152,1) font:[UIFont systemFontOfSize:12]];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        [sectionFooter addSubview:footerLabel];
        
    }
    
    if (tableView.tag ==600) {
        
        if (section==_selectDataArr.count-1) {
            
            sectionFooter.backgroundColor = [UIColor whiteColor];
            sectionFooter.frame = CGRectMake(0, 0, SW, 100);
            UIView * lineView = [FactoryUI createViewWithFrame:CGRectMake(UNIT_WIDTH(15), 5, SW-UNIT_WIDTH(15), 1)];
            lineView.backgroundColor = RGB(236, 235, 235, 1);
            [sectionFooter addSubview:lineView];
            
            UILabel * countLb = [FactoryUI createLabelWithFrame:CGRectMake(20, 20, 34, 20) text:@"数量" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:15]];
            [sectionFooter addSubview:countLb];
            
            _addNumBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-30-27, 20, 27, 27) title:@"+" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(AddBtn:)];
            _addNumBtn.backgroundColor = RGB(220, 220, 220, 1);
            [sectionFooter addSubview:_addNumBtn];
            
            _cutNumBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-30-27-3-30-3-27, 20, 27, 27) title:@"-" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(MinusBtn:)];
            _cutNumBtn.backgroundColor = RGB(220, 220, 220, 1);
            [sectionFooter addSubview:_cutNumBtn];
            
            _countLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-30-27-3-30, 20, 30, 27) text:[NSString stringWithFormat:@"%ld",(long)num] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:15]];
            _countLabel.backgroundColor = RGB(220, 220, 220, 1);
            _countLabel.textAlignment = NSTextAlignmentCenter;
            [sectionFooter addSubview:_countLabel];

        }else{
            
            UIView * lineView = [FactoryUI createViewWithFrame:CGRectMake(UNIT_WIDTH(15), 0, SW-UNIT_WIDTH(15), 1)];
            lineView.backgroundColor = RGB(236, 235, 235, 1);
            [sectionFooter addSubview:lineView];
            
        }
            }
    
    if (tableView == self.picTV) {
        
        UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, SW, 40) text:@"亲，已经到底部啦😊！" textColor:RGB(175,175,175,1) font:[UIFont systemFontOfSize:12]];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.backgroundColor = RGB(236, 235, 235, 1);
        [sectionFooter addSubview:lb];
    }
    
    return sectionFooter;

}

//数量加减
-(void)MinusBtn:(UIButton *)sender{
    
    if ((num - 1) <= 0 || num == 0) {
        
        NSLog(@"超出范围");
        NSLog(@"----------------%ld",(long)num);
        
    }else{
        
        num  = num -1;
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    NSLog(@"----------------%ld",(long)num);
}

-(void)AddBtn:(UIButton *)sender{
    
    if (num >= 10 ) {
        
        NSLog(@"超出范围");
        
    }else{
        
        num = num +1;
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
}

//店铺及收藏按钮点击事件
-(void)collectBtnClick:(UIButton *)btn{
    
    if (btn.tag == 301) {
        if ([Function is_Login ]){
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:@{@"store_id":_storeID}];
            [RequestTools posUserWithURL:@"/add_favorite_store.mob" params:dict success:^(NSDictionary *Dict) {
                
                if ([Dict[@"return_info"][@"errFlg"]boolValue]) {
                    
                    //说明已经收藏过
                    [MyHUD showAllTextDialogWith:@"已收藏过店铺" showView:self.view];
                    
                }else{
                    
                    [MyHUD showAllTextDialogWith:@"收藏成功!" showView:self.view];
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            
            LoginViewController * logVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
            
        }
        
    }else{
       
        HomeStoreViewController * hoStoVC = [[HomeStoreViewController alloc]init];
        hoStoVC.store_ID = [NSNumber numberWithInteger:[self.storeID integerValue]];
        [self.navigationController pushViewController:hoStoVC animated:YES];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==600) {
        
        return UNIT_HEIGHT(100);
        
    }else if (tableView==self.commentTV){
        
        CommentModel * model = _modelArr[indexPath.row];
        
        NSLog(@"%ld",(long)model.rowHeight);
        
        return model.rowHeight;
        
    }else if (tableView==self.picTV){
    
        PicModel * model = self.picModelArr[indexPath.row];
        NSInteger rowHeight = 0;
        rowHeight = model.model.imageHeight*SW/SH;
        NSLog(@"----------------%ld",(long)rowHeight);
        return rowHeight;
        
    }else{
       
        if (kIsEmptyArray(_selectDataArr)) {
            
            return 44;
            
        }else{

            return 0;
        }
    
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==601) {
        
        return 1;

    }
    if (tableView.tag==600) {
        
        return _selectDataArr.count;
    }
    if (tableView==self.picTV) {
        
        return 1;
    }
    if (tableView==self.commentTV) {
        
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==601){
        
        if (kIsEmptyArray(_selectDataArr)) {
            
            return 1;
            
        }else{
            
            return 0;
        }

    }
    if (tableView.tag==600){
        
        return 1;
    }
    if (tableView==self.picTV){
        
        return self.picModelArr.count;
    }
    if (tableView==self.commentTV){
        
        return _commentArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==600) { 
        
        SelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"selectID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.testdelegate = self;
        cell.tag=(indexPath.section+1)*1000;
        NSDictionary * modelDic = _dicArr[indexPath.section];
        [cell refreshUI:modelDic sectionIndex:indexPath.section];

        return cell;
    }
    if (tableView.tag==601) {
        
        DetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.properStr.length==0) {
            
            cell.propertiesLabel.text = @"请选择 颜色/尺寸";
            
        }else{
            
            cell.propertiesLabel.text = [NSString stringWithFormat:@"已选择 %@",self.properStr];
        }
        
        return cell;
    }
    if (tableView==self.picTV) {
        
        PicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"picCellID"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * picDic = _picArr[indexPath.row];
        
        ImageWithUrl(cell.picImageV, picDic[@"value"]);
        
        return cell;
        
    }
    if (tableView==self.commentTV) {
        
         NSLog(@"----------------%lu",(unsigned long)self.modelArr.count);
        CommetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.modelForEvaluate = self.modelArr[indexPath.row];
        
        return cell;
        
    }

    return nil;
  
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==601) {

        self.patternState = YES;
        [self createGraview:0.6];
        [self createSelectView];
    }
}

//调出规格窗口并创建灰色遮布
-(void)createGraview:(CGFloat)alph{

    self.grayView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, SH)];
    self.grayView.backgroundColor = [UIColor grayColor];
    self.grayView.alpha = alph;
    self.grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapMiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMissClick)];
    [self.grayView addGestureRecognizer:tapMiss];
    [self.view addSubview:self.grayView];
}

#pragma mark ----------------------实现传值代理代理方法(动态传值已完成，动态后加载view的大小随动态cell的高度缩小 *********************************************8   等待设计定方案)
-(void)backWithNum:(int)num{
    
    NSLog(@"我是%d",num);
    _selectHeight = (num+1)*25+num*10;
    NSLog(@"%f",_selectHeight);
    
}

//遮布点击事件
-(void)tapMissClick{

    [self.selectView removeFromSuperview];
    [self.grayView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
}

//创选择规格界面
-(void)createSelectView{

//    _count = @"1";
    self.selectView = [FactoryUI createViewWithFrame:CGRectMake(0, 0.2*(SH-64), SW, 0.8*(SH-64))];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    
    [self createselectTv];
    
    NSDictionary * dic = _photoArr[0];
    NSString * str = [dic objectForKey:@"path"];
    _photoImage = [FactoryUI createImageViewWithFrame:CGRectMake(40, -30, 100, 100) imageName:@""];
    //为选择规格前默认大图第一张为规格展示小图
    ImageWithUrl(_photoImage, str);
    _photoImage.layer.cornerRadius = 10;
    _photoImage.layer.masksToBounds = YES;
    _photoImage.layer.borderWidth = 1;
    _photoImage.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    _photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectPic:)];
    [_photoImage addGestureRecognizer:tap];
    [self.selectView addSubview:_photoImage];

    UIButton * cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-34, 16, 18, 18) title:@"" titleColor:nil imageName:@"nav_close" backgroundImageName:@"" target:self selector:@selector(cancelClickBtn)];
    [self.selectView addSubview:cancelBtn];

    if (self.patternState) {
        
        self.subAddBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, self.selectView.frame.size.height-48, SW/2, 48) title:@"加入购物车" titleColor:RGB(255, 255, 255, 1) imageName:nil backgroundImageName:nil target:self selector:@selector(subAddClick)];
        self.subAddBtn.backgroundColor = RGB(42, 150, 143, 1);
        self.subAddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.selectView addSubview:self.subAddBtn];
        
        self.subBuyBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW/2, self.selectView.frame.size.height-48, SW/2, 48) title:@"立即购买" titleColor:RGB(255, 255, 255, 1) imageName:nil backgroundImageName:nil target:self selector:@selector(subBuyClick)];
        self.subBuyBtn.backgroundColor = RGB(11, 67, 109, 1);
        self.subBuyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.selectView addSubview:self.subBuyBtn];

    }else{
    
        self.selectConfirmBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, self.selectView.frame.size.height-48, SW, 48) title:@"确认" titleColor:RGB(255, 255, 255, 1) imageName:nil backgroundImageName:nil target:self selector:@selector(confirmClick)];
        self.selectConfirmBtn.backgroundColor = RGB(42, 150, 143, 1);
        [self.selectView addSubview:self.selectConfirmBtn];
    
    }
    
    UILabel * selectPrice = [FactoryUI createLabelWithFrame:CGRectMake(160, 10, 150, 20) text:Money([_currentPrice floatValue]) textColor:RGB(42, 150, 143, 1) font:[UIFont systemFontOfSize:15]];
    [self.selectView addSubview:selectPrice];
    _selectTitle = [FactoryUI createLabelWithFrame:CGRectMake(160, 40, 150, 20) text:@"请选择分类" textColor:RGB(42, 150, 143, 1) font:[UIFont systemFontOfSize:15]];
    [self.selectView addSubview:_selectTitle];

}

//图片放大处理
-(void)didSelectPic:(UITapGestureRecognizer *)tap{

    NSDictionary * dic = _photoArr[0];
    NSString * str = [dic objectForKey:@"path"];
    //创建一个黑色背景
    self.bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.bgView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    //要显示的图片，即要放大的图片
    ImageWithUrl(imgView, str);
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.userInteractionEnabled = YES;
    
    [self.bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SW, SW));
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:self.bgView];//放大过程中的动画

}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
//点击空白关闭
-(void)closeView{
    
    [self.bgView removeFromSuperview];
    
}

//确认按钮
-(void)confirmClick{
    
    if (![Function is_Login]) {
        
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [MyHUD showAllTextDialogWith:@"请先登录!" showView:self.view];
        
    }else{
        //判断规格参数是否为空
        if (_yanseID.length >0||_chicunID.length >0) {
            
            //判断选购数量是否超过库存上线
            if (self.stock>=[_countLabel.text integerValue]) {
                
                //移除选择规格View
                [self.selectView removeFromSuperview];
                [self.grayView removeFromSuperview];
                
                //赋值默认
                if (_chicunID.length==0) {
                    _chicunID = @"";
                }
                if (_yanseID.length==0) {
                    _yanseID = @"";
                }
                
                //添加规格数组
                NSMutableArray * properCountArr = [NSMutableArray array];
                if (_chicunID.length>0) {
                    
                    [properCountArr addObject:_chicunID];
                }
                if (_yanseID.length>0) {
                    
                    [properCountArr addObject:_yanseID];
                }
                
                if (self.stateBtn==1000) {
                    
                    //get数组参数拼接
                    NSString * canshu = @"gapd_ids";
                    NSMutableArray * muarr = [NSMutableArray array];
                    for (int i = 0; i<properCountArr.count; i++) {
                        NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,properCountArr[i]];
                        NSLog(@"%@",appStr);
                        [muarr addObject:appStr];
                    }
                    NSString *appString = [muarr componentsJoinedByString:@"&"];
                    NSString * astr = @"/add_goods_cart.mob?";
                    NSString * getStr = [NSString stringWithFormat:@"%@%@&goods_id=%@&count=%@",astr,appString,_goodsID,_countLabel.text];
                    NSLog(@"----------------%@",getStr);
                    
                    //请求加入购物车
                    [RequestTools getUserWithURL:getStr params:nil success:^(NSDictionary *Dict) {
                        
                        NSLog(@"----------------%@",Dict);
                        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                            
                            _gcID = [[Dict objectForKey:@"gc_id"] stringValue];
                            if (self.stateBtn==1000) {
                                [MyHUD showAllTextDialogWith:@"加入购物车成功!" showView:BaseView];
                            }
                        }
                        
                        [self.tv reloadData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }else{
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    [dict addEntriesFromDictionary:@{@"goods_id":_goodsID,@"count":_countLabel.text,@"gapd_ids":_yanseID,@"gapd_ids":_chicunID}];
                    [RequestTools posUserWithURL:@"/quick_buy.mob" params:dict success:^(NSDictionary *Dict) {
                        
                        NSLog(@"----------------%@",Dict);
                        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                            
                            _gcID = [[Dict objectForKey:@"gc_id"] stringValue];
                            OrderViewController * orderVC = [[OrderViewController alloc]init];
                            orderVC.IDString = _gcID;
                            [self.navigationController pushViewController:orderVC animated:YES];
                        }
                        
                        [self.tv reloadData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                
                //重新置空（容易忽略）
                _chicunID = @"";
                _yanseID = @"";

            }else{
            
                [MyHUD showAllTextDialogWith:@"库存不足!" showView:BaseView];
            }
            
        }else{
        
            [MyHUD showAllTextDialogWith:@"请选择商品规格！" showView:self.view];

        }
    
    }
}

//取消按钮
-(void)cancelClickBtn{
    
    [self.selectView removeFromSuperview];
    [self.grayView removeFromSuperview];

}

//创建选择规格界面TV
-(void)createselectTv{

    self.selectTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, SW, 0.8*(SH-64)-80-50)style:UITableViewStyleGrouped];
    self.selectTv.backgroundColor = [UIColor whiteColor];
    self.selectTv.tag = 600;
    self.selectTv.separatorStyle = NO;
    self.selectTv.delegate = self;
    self.selectTv.dataSource = self;
    self.selectTv.bounces = NO;
    [self.selectTv registerClass:[SelectCell class] forCellReuseIdentifier:@"selectID"];
    [self.selectView addSubview:self.selectTv];
    
}

#pragma mark ----------------------scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView.tag == 600) {
        
        _PageControl.currentPage=scrollView.contentOffset.x/SW;
        
    }
    
    if (scrollView==_picTV&&offsetY<-100) {
        _bottomScrollView.contentOffset = CGPointMake(0, -1);
    }
    if (scrollView==_commentTV&&offsetY<-100) {
        _bottomScrollView.contentOffset = CGPointMake(0, -1);
    }
    
    if (scrollView==_picTV) {
        
        if (offsetY >600) {
            
            _backBtn.hidden = NO;
            
        }else{
            
            _backBtn.hidden = YES;
        }
        
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 0;
        CGFloat sectionFooterHeight = 40;
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

//设置导航条样式
-(void)setNav{

    self.title = @"商品详情";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton * cartBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_shopping" backgroundImageName:@"" target:self selector:@selector(cartClick)];
    UIButton * moreBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_more" backgroundImageName:@"" target:self selector:@selector(moreClick:)];
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

//返回按钮点击事件
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//更多按钮点击事件
- (void)moreClick:(UIButton *)btn{
    
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
 
    _sanjiaoView = [[TriangleView alloc]initWithFrame:CGRectMake(SW-35, 0, 30, 10) color:[UIColor lightGrayColor]];
    [self.view addSubview:_sanjiaoView];
    NSArray * imageArr = @[@"nav_more_news",@"nav_more_home",@"nav_more_share"];
    NSArray * titleArr = @[@"消息",@"首页",@"分享"];
    self.moreView = [FactoryUI createViewWithFrame:CGRectMake(SW-135, 10, 130, 150)];
    self.moreView.backgroundColor = [UIColor grayColor];
    self.moreView.alpha = 0.8;
    self.moreView.layer.cornerRadius = 2;
    self.moreView.layer.masksToBounds = YES;
    [self.view addSubview:self.moreView];
    for (int i =0; i<3; i++) {
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(0, i*50, 130, 50) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(moreBtnClick:)];
        btn.tag = 150+i;
        [self.moreView addSubview:btn];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, i*50, 130, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.moreView addSubview:line];
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(20, (i+1)*15+i*20+i*15, 20, 20) imageName:imageArr[i]];
        [self.moreView addSubview:imageV];
        UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(47, (i+1)*15+i*20+i*15, 30, 20) text:titleArr[i] textColor:RGB(255, 255, 255, 1) font:[UIFont systemFontOfSize:14]];
        [self.moreView addSubview:titleLabel];
    }
    
}

//更多子选项
-(void)moreBtnClick:(UIButton *)btn{
    
    if (btn.tag == 150) {
        
        SystemMessageViewController * messageVC = [[SystemMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];

    }else if (btn.tag == 151){
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }else{
    
        [self createGraview:0.6];
        [self createShareView];
    }
    
}

//购物车按钮点击事件
-(void)cartClick{
    
    ShoppingCartViewController * shopCar = [[ShoppingCartViewController alloc]init];
    shopCar.statuFrom =  @"yes";
    [self.navigationController pushViewController:shopCar animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
