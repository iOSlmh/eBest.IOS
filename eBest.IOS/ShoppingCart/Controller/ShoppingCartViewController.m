//
//  ShoppingCartViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCarCell.h"
#import "ShoppingCarGroupModel.h"
#import "ShoppingCarModel.h"
#import "OrderViewController.h"
#import "LoginViewController.h"
#import "HomeStoreViewController.h"
#import "DetailViewController.h"
#import "SystemMessageViewController.h"

@interface ShoppingCartViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ShoppingTableViewCellDelegate,ChooseRankDelegate>

{
    BOOL _allSelected;
    CGFloat _price;
    BOOL isbool;
    BOOL editbool;
    NSString *numString;
}

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) NSMutableArray * groupArr;
@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) ShoppingCarModel * shopCarModel;
@property(nonatomic,strong) ShoppingCarGroupModel * shopCarGroupModel;
@property(nonatomic,strong) NSMutableArray * groupModelArr;
@property(nonatomic,strong) NSMutableArray * modelArr;
@property(nonatomic,strong) NSMutableArray * removeArr;

@property(nonatomic,strong) UIButton * allSelectBtn;
@property(nonatomic,strong) UILabel * totalLb;
@property(nonatomic,strong) UILabel * maliLb;
@property(nonatomic,strong) UIView * bottomView;
@property(nonatomic,strong) UIButton * settleBtn;
@property(nonatomic,strong) UIView * emptyView;
@property(nonatomic,strong) UIView * selectView;
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * photoImage;
@property(nonatomic,strong) UILabel * selectTitle;
@property(nonatomic,strong) UIScrollView * selectScroll;

@property(nonatomic,strong) NSArray * standardList;
@property(nonatomic,strong) NSMutableArray * standardValueList;
@property(nonatomic,strong) NSMutableArray * properPathArr;
@property(nonatomic,strong) NSMutableArray * properIDArr;

@property(nonatomic,strong) UIView * backgroundView;
@property(nonatomic,assign) NSInteger selectSection;
@property(nonatomic,assign) NSInteger selectRow;
@property(nonatomic,copy) NSString * chicunID;
@property(nonatomic,copy) NSString * yanseID;
@property(nonatomic,copy) NSString * chicunStr;
@property(nonatomic,copy) NSString * yanseStr;
@property(nonatomic,copy) NSMutableString * sepcStr;
@property(nonatomic,strong) NSMutableArray * gaps_ids;
@property(nonatomic,strong) NSNumber * goodsCarID;
@property(nonatomic,assign) NSInteger selectStock;

//编辑按钮处理
@property(nonatomic,strong) UIButton * editBtn;

@end

@implementation ShoppingCartViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadRefresh];
    editbool = NO;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _removeArr = [NSMutableArray array];
    _price = 0.0;
    [self createNav];
    [self createTV];
    [self createBottomView];
    [self createEmptyView];
    [self loadRefresh];
    
}

#pragma mark ----------------------加载刷新
-(void)loadRefresh
{
    // 下拉刷新
    self.tv.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        self.groupModelArr = [NSMutableArray arrayWithCapacity:0];
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        self.modelArr = [NSMutableArray arrayWithCapacity:0];
        [self loadData];
        [self CalculationPrice];
    }];
    
    // 进入界面先进行刷新
    [self.tv.mj_header beginRefreshing];
    
//    // 上拉加载，购物车翻页用
//    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        _page ++;
//        [self loadData];
    
//    }];
    
}

-(void)loadData{
    
    //    购物车请求
//    _groupModelArr=[NSMutableArray arrayWithCapacity:0];
//    _dataArr = [[NSMutableArray alloc]init];
//    _modelArr=[[NSMutableArray alloc]init];
    
    [RequestTools getUserWithURL:@"/cart.mob" params:nil success:^(NSDictionary *Dict) {
        
        _groupArr = [[Dict objectForKey:@"cart_list"]mutableCopy];
        //    判断购物车是否为空
        if (_groupArr.count==0) {
            
            _editBtn.hidden=YES;
            _emptyView.hidden=NO;
            
        }else{
            
            _editBtn.hidden=NO;
            _emptyView.hidden = YES;
            
            for (NSDictionary * dic in _groupArr) {
                ShoppingCarGroupModel * model = [[ShoppingCarGroupModel alloc]initWithShopDict:dic];
                [_groupModelArr addObject:model];
            }
            
            [MyHUD showAllTextDialogWith:@"购物车请求成功" showView:self.view];

        }
        [_tv.mj_header endRefreshing];
        
        //购物车翻页用
//        [_tv.mj_footer endRefreshing];
        
        [self.tv reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//去逛逛btn
-(void)goBtnClick{

}

-(void)createSelectView{
    
    [UIView animateWithDuration: 0.35 animations: ^{
        self.backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        self.chooseView.frame =CGRectMake(0, 0, SW, SH-64-48);
    } completion: nil];

}
-(void)initChooseView{
    
    self.chooseView = [[ChooseView alloc] initWithFrame:CGRectMake(0, SH-64-48, SW, SH-64-48)];
    self.chooseView.headImage.image = [UIImage imageNamed:@"1"];
    self.chooseView.LB_price.text = @"￥36.00";
    self.chooseView.LB_stock.text = [NSString stringWithFormat:@"库存%@件",@56];
    self.chooseView.LB_detail.text = @"请选择商品规格";
    self.chooseView.LB_stock.textColor = RGB(42, 150, 143, 1);
    self.chooseView.LB_detail.textColor = RGB(42, 150, 143, 1);
    self.chooseView.LB_detail.textColor = RGB(42, 150, 143, 1);
    [self.view addSubview:self.chooseView];
    
    CGFloat maxY = 0;
    CGFloat height = 0;
    for (int i = 0; i < self.standardList.count; i ++)
    {
        
        self.chooseRank = [[ChooseRank alloc] initWithTitle:self.standardList[i] titleArr:self.standardValueList[i] andFrame:CGRectMake(0, maxY, SW, 40)];
        maxY = CGRectGetMaxY(self.chooseRank.frame);
        height += self.chooseRank.height;
        self.chooseRank.tag = 8000+i;
        self.chooseRank.delegate = self;
        
        [self.chooseView.mainscrollview addSubview:self.chooseRank];
    }
    self.chooseView.mainscrollview.contentSize = CGSizeMake(0, height);
    
    [self.chooseView.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    [self.chooseView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.chooseView.alphaView addGestureRecognizer:tap];
}

/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.chooseView.frame =CGRectMake(0, SH-64-48, SW, SH-64-48);
        self.backgroundView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.chooseView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        
    }];
}
-(NSMutableArray *)rankArray{
    
    if (_rankArray == nil) {
        
        _rankArray = [[NSMutableArray alloc] init];
    }
    return _rankArray;
}
//代理方法
-(void)selectBtnTitle:(NSString *)title andBtn:(UIButton *)btn{

    self.gaps_ids = [NSMutableArray array];
    //区分组
    NSInteger secIndex = btn.superview.superview.superview.tag;
    
    [self.rankArray removeAllObjects];
    
    for (int i=0; i < _standardList.count; i++)
    {
        ChooseRank *view = [self.view viewWithTag:8000+i];
        
        for (UIButton *obj in  view.btnView.subviews)
        {
            if(obj.selected){
                
                for (NSArray *arr in self.standardValueList)
                {
                    for (NSString *title in arr) {
                        NSLog(@"----------------%@",view.selectBtn.titleLabel.text);
                        if ([view.selectBtn.titleLabel.text isEqualToString:title]) {
                            
                            [self.rankArray addObject:view.selectBtn.titleLabel.text];
                        }
                    }
                }
            }
        }
    }
    
    
    NSLog(@"%@",self.rankArray);

    if (secIndex==8000) {
        
        self.yanseStr = @"";
        self.chicunID = self.properIDArr[secIndex-8000][btn.tag-10000];
        self.yanseStr = [NSString stringWithFormat:@"%@",title];
        
    }else{
        
        self.chicunStr = @"";
        self.yanseID = self.properIDArr[secIndex-8000][btn.tag-10000];
        self.chicunStr = [NSString stringWithFormat:@"%@",title];

    }
    if (!kIsEmptyString(_yanseID)) {
        
        [self.gaps_ids addObject:_yanseID];
    }
    if (!kIsEmptyString(_chicunID)) {
        
        [self.gaps_ids addObject:_chicunID];
    }

    NSString * path = self.properPathArr[secIndex-8000][btn.tag-10000];
    ImageWithUrl(self.chooseView.headImage, path);
    [self getStock];
    
}

-(void)getStock{
    
    NSString * selectGoodsID = _groupArr[self.selectSection][@"gcs"][self.selectRow][@"goods"][@"id"];
    //get数组参数拼接
    NSString * canshu = @"gapd_ids";
    NSMutableArray * muarr = [NSMutableArray array];
    for (int i = 0; i<self.gaps_ids.count; i++) {
        NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,self.gaps_ids[i]];
        [muarr addObject:appStr];
    }
    NSString *appString = [muarr componentsJoinedByString:@"&"];
    NSString * astr = @"/goods_selection_stock.mob?";
    NSString * getStr = [NSString stringWithFormat:@"%@%@&goods_id=%@",astr,appString,selectGoodsID];
    NSLog(@"最终的字符串是 %@",getStr);
    [RequestTools getWithURL:getStr params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            
            self.selectStock = [Dict[@"stock"] integerValue];
            self.chooseView.LB_stock.text = [NSString stringWithFormat:@"库存%ld件",(long)self.selectStock];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

//确认按钮
-(void)confirmBtnClick{
    
    [self.tv reloadData];
    //post数组参数拼接
    NSString * canshu = @"gapd_ids";
    NSMutableArray * muarr = [NSMutableArray array];
    for (int i = 0; i<self.gaps_ids.count; i++) {
        NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,self.gaps_ids[i]];
        NSLog(@"%@",appStr);
        [muarr addObject:appStr];
    }
    NSString *appString = [muarr componentsJoinedByString:@"&"];
    NSString * astr = @"/update_goods_cart.mob?";
    NSString * getStr = [NSString stringWithFormat:@"%@gc_id=%@&%@",astr,self.goodsCarID,appString];
    NSLog(@"----------------%@",getStr);
    [RequestTools posUserWithURL:getStr params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        if (![Dict[@"return_info"][@"errFlg"]boolValue]) {
        
             [self dismiss];
            //改变规格存入model
            ShoppingCarGroupModel * groupModel = _groupModelArr[self.selectSection];
            ShoppingCarModel * shopCarModel = groupModel.gcs[self.selectRow];
            //将改变的规格存入model
            shopCarModel.gaps_ids = self.gaps_ids;
            NSMutableArray * specArr = [NSMutableArray array];
            self.sepcStr = [NSMutableString string];
            if (!kIsEmptyString(self.yanseStr)) {
                self.yanseStr = [NSString stringWithFormat:@"颜色:%@",self.yanseStr];
                [specArr addObject:self.yanseStr];
            }
            if (!kIsEmptyString(self.chicunStr)) {
                self.chicunStr = [NSString stringWithFormat:@"尺寸:%@",self.chicunStr];
                [specArr addObject:self.chicunStr];
            }
            shopCarModel.spec_info = [specArr componentsJoinedByString:@" "];;
            [self.tv reloadData];
            
        }else{
            //去当前数量
            ShoppingCarGroupModel * groupModel = _groupModelArr[self.selectSection];
            ShoppingCarModel * shopCarModel = groupModel.gcs[self.selectRow];
            [MyHUD showAllTextDialogWith:[NSString stringWithFormat:@"当前库存不足%@件!",shopCarModel.count] showView:BaseView];
        }
        
    } failure:^(NSError *error) {
        
    }];
   
}

//取消按钮
-(void)cancelClickBtn{
    
    [self dismiss];

}

//底部结算栏
-(void)createBottomView{
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllPrice:) name:@"AllPrice" object:nil];
    if ([_statuFrom isEqualToString:@"yes"] ) {
        _bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-64-44-1, SW, 44)];
    }else{
       _bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-64-44-44-1, SW, 44)];
    }
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    _allSelectBtn = [FactoryUI createButtonWithFrame:CGRectMake(13, 12, 20, 20) title:@"" titleColor:nil imageName:@"shopping_default" backgroundImageName:@"" target:self selector:@selector(allSelectClick:)];
    [_bottomView addSubview:_allSelectBtn];
    UILabel * allSelectLb = [FactoryUI createLabelWithFrame:CGRectMake(37, 15, 30, 14) text:@"全选" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
    [_bottomView addSubview:allSelectLb];
    _settleBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-104, 0, 104, 44) title:@"结算(0)" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(settleBtnClick)];
    _settleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _settleBtn.backgroundColor = RGB(11, 67, 109, 1);
    [_bottomView addSubview:_settleBtn];
    _totalLb = [FactoryUI createLabelWithFrame:CGRectMake(SW-(_settleBtn.frame.size.width+15+95), 9, 95, 12) text:[NSString stringWithFormat:@"合计:¥%.2f",_price] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:11]];
    [_bottomView addSubview:_totalLb];
    _maliLb = [FactoryUI createLabelWithFrame:CGRectMake(SW-(_settleBtn.frame.size.width+15+22), 25, 26, 11) text:@"免邮" textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:11]];
    [_bottomView addSubview:_maliLb];
    
}

#pragma mark 通知
- (void)AllPrice:(NSNotification *)text{
    
    _totalLb.text = [NSString stringWithFormat:@"合计: %@",text.userInfo[@"allPrice"]];

    numString = text.userInfo[@"num"];
    
    [self setTlementLabel];

    [self setAllBtnState:[text.userInfo[@"allState"]  isEqual: @"YES"]?NO:YES];
    
}

#pragma mark 设置结算按钮状态
-(void)setTlementLabel{
    
    if (editbool) {
        
        _settleBtn.backgroundColor = RGB(255, 98, 72, 1);
        NSString *string = @"删除";
        [_settleBtn setTitle:[NSString stringWithFormat:@"%@(%@)",string,numString] forState:UIControlStateNormal];

    }else{
    
        _settleBtn.backgroundColor = RGB(11, 67, 109, 1);
         NSString *string = @"结算";
         [_settleBtn setTitle:[NSString stringWithFormat:@"%@(%@)",string,numString] forState:UIControlStateNormal];
    }

}

#pragma mark 全选
-(void)setAllBtnState:(BOOL)_bool{
    
    if (_bool) {
        
       [_allSelectBtn setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
        isbool = NO;
        
    }else{
        
        [_allSelectBtn setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
        isbool = YES;
    }
}

#pragma mark 编辑  遍历
-(void)editBtn:(BOOL)isbooll{
    
    for (ShoppingCarGroupModel *model in _groupModelArr) {
        
        if (!isbooll) {
            
            for (ShoppingCarModel *cellmodel in model.gcs) {
                
                cellmodel.cellEditState = 1;
            }
            
        }else{
            
            for (ShoppingCarModel *cellmodel in model.gcs) {
                
                cellmodel.cellEditState = 0;
            }
        }
    }
    
    [self.tv reloadData];
}

//-----------------------------------------结算/删除 按钮
-(void)settleBtnClick{

    if ([numString integerValue] >0) {
        
        if (editbool) {
            
            [self deleteBtn:editbool];
            
        }else{

             _IDArr = [NSMutableArray array];
            for (ShoppingCarGroupModel * groupModel in _groupModelArr) {
                for (ShoppingCarModel * model in groupModel.gcs) {
                   
                    if (model.cellClickState == 1) {
                        [_IDArr addObject:model.goodsCar_id];
                        NSLog(@"%@",model.goodsCar_id);
                        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%lu>>>>>>>>>>>",(unsigned long)_IDArr.count);
                  
                    }
                }
                
            }
           
            OrderViewController * orderVC = [[OrderViewController alloc]init];
            orderVC.dataArray = _IDArr;
            orderVC.allPrice = _price;
            NSLog(@"%f",_price);
            NSLog(@"%f",orderVC.allPrice);
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }

    }else{
        
        [MyHUD showAllTextDialogWith:@"请选择宝贝！！" showView:BaseView];

    }

}

-(void)deleteBtn:(BOOL)isbool{
    
    NSMutableArray *headDeleteArray = [[NSMutableArray alloc] init];
    for (ShoppingCarGroupModel *model in _groupModelArr) {
        
        if (model.headClickState == 1) {
            
            [headDeleteArray addObject:model];
            
        }else{
            
            NSMutableArray *cellDeleteArray = [[NSMutableArray alloc] init];
            for (ShoppingCarModel *cellmodel in model.gcs) {
                
                if (cellmodel.cellClickState == 1) {
                    
                    //需要删除的购物车ID
                   [_removeArr addObject:cellmodel.goodsCar_id];
                    [cellDeleteArray addObject:cellmodel];
                }
            }
            
            NSMutableArray *headcellArray = [NSMutableArray arrayWithArray:model.gcs];
            for (ShoppingCarModel *cellmodel in cellDeleteArray) {
                
                if ([headcellArray containsObject:cellmodel]) {
                    
                    [headcellArray removeObject:cellmodel];
                }
            }
            model.gcs = headcellArray;
        }
        
    }
    
    NSMutableArray *shopArray = [NSMutableArray arrayWithArray:_groupModelArr];
    for (ShoppingCarGroupModel *model in headDeleteArray) {
        
        if ([shopArray containsObject:model]) {
            
            [shopArray removeObject:model];
        }
        
        NSMutableArray *cellDeleteArray = [[NSMutableArray alloc] init];
        for (ShoppingCarModel *cellmodel in model.gcs) {
            
            if (cellmodel.cellClickState == 1) {
                
                //需要删除的购物车ID
                [_removeArr addObject:cellmodel.goodsCar_id];
                [cellDeleteArray addObject:cellmodel];
            }
        }
    }
    _groupModelArr = shopArray;
    
    //get数组参数拼接
    NSString * canshu = @"goods_cart_ids";
    NSMutableArray * muarr = [NSMutableArray array];
    for (int i = 0; i<_removeArr.count; i++) {
        NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,_removeArr[i]];
        NSLog(@"%@",appStr);
        [muarr addObject:appStr];
    }
    NSString *appString = [muarr componentsJoinedByString:@"&"];
    NSString * astr = @"/remove_goods_cart.mob?";
    NSString * lastestStr = [NSString stringWithFormat:@"%@%@",astr,appString];
    NSLog(@"最终的字符串是 %@",lastestStr);
    //删除服务器数据
    [RequestTools getUserWithURL:lastestStr params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        
    } failure:^(NSError *error) {
        
        NSLog(@"----------------%@",error);
    }];
    
//    //判断如果当前删除为最后一条数据，删除之后将区数组置为空，并刷新，达到必要界面效果
//    if (_groupModelArr.count==0) {
//        
//        _groupModelArr = [NSMutableArray arrayWithCapacity:0];
//        //此处两者配合使用 缺一不可 不可将刷新放置判断条件语句以外，否则客户端流量消耗较大
//        [self.tv reloadData];
//        [self loadData];
//    }
//    
//    [self CalculationPrice];
//    //此处亦不可省略
//    [self.tv reloadData];

    
    [self CalculationPrice];
    [self.tv reloadData];
    
    //如果删除之后已无数据则显示空界面
    if (_groupModelArr.count == 0) {
        
        _emptyView.hidden = NO;
        _editBtn.hidden = YES;
    }

}

//选择所有btn
-(void)allSelectClick:(UIButton *)btn{
    
    btn.selected = !(btn.selected);
    if (btn.selected) {
        
        for (ShoppingCarGroupModel *model in _groupModelArr) {
            
            model.headClickState = 0;
            [self RefreshAllCellState:model];
        }
        
        }else{

            for (ShoppingCarGroupModel *model in _groupModelArr) {
                
                model.headClickState = 1;
                [self RefreshAllCellState:model];
            }
            
    }
    [self CalculationPrice];
    [self.tv reloadData];
}

-(void)createEmptyView{

    _emptyView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, SH-44)];
    _emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake((SW-200)/2, 0.3*SH, 200, 21) text:@"人养玉三年，玉养人一生" textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:15]];
    lb.textAlignment  = NSTextAlignmentCenter;
//    lb.adjustsFontForContentSizeCategory = YES;
    [_emptyView addSubview:lb];
    
    UIButton * goBtn = [FactoryUI createButtonWithFrame:CGRectMake((SW-123)/2, 0.3*SH+17+21, 123, 36) title:@"去逛一逛吧" titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(goBtnClick)];
    goBtn.layer.borderWidth = 1;
    goBtn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    [_emptyView addSubview:goBtn];

    
}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    //判断界面是否为详情跳转
    if ([_statuFrom isEqualToString:@"yes"]) {
        self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64)style:UITableViewStyleGrouped];
    }else{
        self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64-45)style:UITableViewStyleGrouped];
    }
    self.tv.backgroundColor = RGB(236, 235, 235, 1);
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tv registerNib:[UINib nibWithNibName:@"ShoppingCarCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tv];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 121;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _groupModelArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ShoppingCarGroupModel * model = _groupModelArr[section];

    return model.gcs.count;
 
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_groupArr) {
        
        ShoppingCarGroupModel * groupModel = _groupModelArr[section];
        NSDictionary * storeDic = groupModel.store;
        
        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = RGB(244, 244, 244, 1);
        UIView *view=[UIView new];
        view.backgroundColor=[UIColor whiteColor];
        
        UIButton  * allSelectBtn = [FactoryUI createButtonWithFrame:CGRectMake(13, 10, 20, 20) title:@"" titleColor:nil imageName:@"shopping_default" backgroundImageName:@"" target:self selector:@selector(allSectionSelectClick:)];
        allSelectBtn.tag = section;
        [headView addSubview:allSelectBtn];
        
        UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(50, 10, 20, 20) imageName:@"button_shop"];
        imageView.contentMode = UIViewContentModeCenter;
        [headView addSubview:imageView];
        //计算标题宽度
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat length = [[storeDic objectForKey:@"store_name"] boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(75, 10, length, 20) text:[storeDic objectForKey:@"store_name"] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        [headView addSubview:label];

        UIButton  * jiantou = [FactoryUI createButtonWithFrame:CGRectMake(label.frame.origin.x+length+5, 10, 20, 20) title:@"" titleColor:nil imageName:@"shopping_right arrow" backgroundImageName:@"" target:self selector:@selector(toStoreClick:)];
        jiantou.tag = section;
        [headView addSubview:jiantou];
        
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(SW-15-27, 0, 27, 40) title:@"" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(singleEditBtn:)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = section;
        [headView addSubview:btn];
        
        //用来判断 section Header 是否被选中
        if (groupModel.headClickState == 1) {
            
            [allSelectBtn setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
            
        }else{
            
            [allSelectBtn setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
            
        }
        //用来判断 section Header 是否被编辑
        if (groupModel.headEditState == 1) {
            
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            
        }else{
            
           [btn setTitle:@"编辑" forState:UIControlStateNormal];
            
        }
        
        return headView;

    }
    return nil;
}

//跳转至店铺
-(void)toStoreClick:(UIButton *)btn{

    ShoppingCarGroupModel * groupModel = _groupModelArr[btn.tag];
    HomeStoreViewController * homeStoreVC = [[HomeStoreViewController alloc]init];
    homeStoreVC.store_ID = groupModel.store[@"id"];
    [self.navigationController pushViewController:homeStoreVC animated:YES];

}

//单选代理
-(void)ShoppingTableViewCell:(ShoppingCarModel *)model{
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%ld",(long)model.section);
    
    ShoppingCarGroupModel *headmodel = _groupModelArr[model.section];
    
    int i = 0;
    for (ShoppingCarModel * cellmodel in headmodel.gcs) {
        
        NSLog(@"%ld",(long)cellmodel.cellClickState);
        if ( cellmodel.cellClickState == 1) {
            
            i++;
        }
    }
    
    if (i == headmodel.gcs.count) {
        
        headmodel.headClickState = 1;
        
    }else{
        
        headmodel.headClickState = 0;
    }
    [self CalculationPrice];
    [self.tv reloadData];
}

//整个section全选
-(void)allSectionSelectClick:(UIButton *)btn{
    
  ShoppingCarGroupModel * model = _groupModelArr[btn.tag];
    [self RefreshAllCellState:model];
    [self CalculationPrice];
    [self.tv reloadData];
}

#pragma mark 刷新cell状态
-(void)RefreshAllCellState:(ShoppingCarGroupModel *)model{
    
    if (model.headClickState == 1) {
        
        model.headClickState = 0;
        
        for (ShoppingCarModel * cellmodel in model.gcs) {
            
            cellmodel.cellClickState = 0;
        }
        
    }else{
        
        model.headClickState = 1;
        
        for (ShoppingCarModel * cellmodel in model.gcs) {
            
            cellmodel.cellClickState = 1;
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ShoppingCarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    ShoppingCarGroupModel * groupModel = _groupModelArr[indexPath.section];
    _shopCarModel = groupModel.gcs[indexPath.row];
     _shopCarModel.section = indexPath.section;
    cell.delegate = self;
    cell.deleteBtn.tag = indexPath.row;
    cell.singleBtn.tag = indexPath.row;
    cell.editcartView.tag = indexPath.section;
    [cell.deleteBtn addTarget:self action:@selector(editDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.clearBtn addTarget:self action:@selector(selectClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.clearBtn.superview.tag = indexPath.section;
    cell.clearBtn.tag = indexPath.row;
    
    
    [cell refreshUI:_shopCarModel];//2
    
    return cell;
    
}

-(void)selectClearBtn:(UIButton *)btn{
    
    self.selectSection = btn.superview.tag;
    self.selectRow = btn.tag;
    self.goodsCarID = _groupArr[btn.superview.tag][@"gcs"][btn.tag][@"id"];
    self.standardValueList = [NSMutableArray arrayWithCapacity:0];
    self.properPathArr = [NSMutableArray arrayWithCapacity:0];
    self.properIDArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * properNameArr = _groupArr[btn.superview.tag][@"gcs"][btn.tag][@"goods"][@"add_goods_spec"];
    
    if (kIsEmptyArray(properNameArr)) {
        
        NSMutableArray * nameArr = [NSMutableArray array];
        for (NSDictionary * dic in properNameArr) {
            
            [nameArr addObject:dic[@"name"]];
        }
        self.standardList = nameArr;
        
        NSLog(@"%ld",self.standardList.count);
        
        for (NSDictionary * dic in properNameArr) {
            NSArray * arr1 = dic[@"addprodetail"];
            NSMutableArray * proArr = [NSMutableArray array];
            NSMutableArray * pathArr = [NSMutableArray array];
            NSMutableArray * IDArr = [NSMutableArray array];
            for (NSDictionary * dic in arr1) {
                
                [proArr addObject:dic[@"value"]];
                [pathArr addObject:dic[@"specImage"][@"path"]];
                [IDArr addObject:dic[@"id"]];
            }
            [self.standardValueList addObject:proArr];
            [self.properIDArr addObject:IDArr];
            [self.properPathArr addObject:pathArr];
        }
        
        [self initChooseView];
        [self createSelectView];
        
        NSString * path = _groupArr[btn.superview.tag][@"gcs"][btn.tag][@"goods"][@"goods_main_photo_path"];
        ImageWithUrl(self.chooseView.headImage, path);
        NSString * price = _groupArr[btn.superview.tag][@"gcs"][btn.tag][@"goods"][@"goods_current_price"];
        self.chooseView.LB_price.text = Money([price floatValue]);
        NSString * stock = _groupArr[btn.superview.tag][@"gcs"][btn.tag][@"goods"][@"goods_inventory"];
        self.chooseView.LB_stock.text = [NSString stringWithFormat:@"库存%@件",stock];
        self.chooseView.LB_detail.text = @"请选择商品规格";
        
    }

}

-(NSMutableArray *)standardValueList{

    if (!_standardValueList) {
        _standardValueList = [NSMutableArray array];
    }
    return _standardValueList;
}

-(NSMutableArray *)properPathArr{
    
    if (!_properPathArr) {
        _properPathArr = [NSMutableArray array];
    }
    return _properPathArr;
}

-(NSMutableArray *)properIDArr{
    
    if (!_properIDArr) {
        _properIDArr = [NSMutableArray array];
    }
    return _properIDArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController * detailVC = [[DetailViewController alloc]init];
    [detailVC loadDataWithID:[[_groupModelArr[indexPath.section] gcs][indexPath.row] goods][@"id"]];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//编辑状态单个删除
-(void)editDeleteBtn:(UIButton *)deleBtn{

    //获取删除ID
    NSNumber * deleteID = [[_groupModelArr[deleBtn.superview.tag] gcs][deleBtn.tag] goodsCar_id];
    //删除数据源数据
    [[_groupModelArr[deleBtn.superview.tag] gcs] removeObjectAtIndex:deleBtn.tag];
    //删除服务器数据
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"goods_cart_ids":deleteID}];
    [RequestTools posUserWithURL:@"/remove_goods_cart.mob" params:dict success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
        
    } failure:^(NSError *error) {
        
    }];
    
    //判断如果当前删除为最后一条数据，删除之后将区数组置为空，并刷新，达到必要界面效果
    if ([_groupModelArr[deleBtn.superview.tag] gcs].count==0) {
        
        _groupModelArr = [NSMutableArray arrayWithCapacity:0];
        //此处两者配合使用 缺一不可 不可将刷新放置判断条件语句以外，否则客户端流量消耗较大
        [self.tv reloadData];
        [self loadData];
    }

    [self CalculationPrice];
    [self.tv reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除数据源数据
    NSNumber * deleteID = [[_groupModelArr[indexPath.section] gcs][indexPath.row] goodsCar_id];
    [[_groupModelArr[indexPath.section] gcs] removeObjectAtIndex:indexPath.row];
    //删除当前行
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    //删除服务器数据
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"goods_cart_ids":deleteID}];
    [RequestTools posUserWithURL:@"/remove_goods_cart.mob" params:dict success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict[@"return_info"][@"message"]);
        
    } failure:^(NSError *error) {
        
    }];
    
    //判断如果当前删除为最后一条数据，删除之后将区数组置为空，并刷新，达到必要界面效果
    if ([_groupModelArr[indexPath.section] gcs].count==0) {
        
        _groupModelArr = [NSMutableArray arrayWithCapacity:0];
        //此处两者配合使用 缺一不可 不可将刷新放置判断条件语句以外，否则客户端流量消耗较大
        [self.tv reloadData];
        [self loadData];
    }
    
    [self CalculationPrice];
    //此处亦不可省略
    [self.tv reloadData];
    
 }

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!editbool){
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;

    }
}
//策划多按钮自定义
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"自定义" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [tableView setEditing:NO animated:YES];
//        //这里删除对应的Cell代码，刷新tableview
//    }];
//    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"自定义" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [tableView setEditing:NO animated:YES];
//        //这里删除对应的Cell代码，刷新tableview
//    }];
//    //UITableViewRowAction在IOS8以后系统提供的，所以不用自定义，可设置多个按钮
//    NSArray* arr = @[action1,action2];
//    return arr;
//}

#pragma mark 计算价格
-(void)CalculationPrice{
    
    //所有商品的总价
    CGFloat allPrict = 0.0;
    
    //结算处的个数
    NSInteger numInteger = 0;
    
    //用于判断是否全选
    NSMutableArray *allClickArray = [[NSMutableArray alloc] init];
    
    //纪录选中的cellModel;
    NSMutableArray *cellModelArray = [[NSMutableArray alloc] init];
    
    for (ShoppingCarGroupModel *model in _groupModelArr) {
        
        //用于判断是否全选，当该数组个数和_shoppingArray个数一样时，说明我选中了全部产品
        if (model.headClickState ==1) {
            
            [allClickArray addObject:[NSString stringWithFormat:@"%ld",(long)model.headClickState]];
        }
        
        //每条数据下面的总价
        CGFloat allprice = 0.0;
        
        for (ShoppingCarModel *cellmodel in model.gcs) {
            
            //计算每个cell的总价
            if (cellmodel.cellClickState == 1) {
                
                [cellModelArray addObject:cellmodel];
                numInteger = numInteger +1;
                allprice = allprice + [(cellmodel.count)integerValue] * [cellmodel.price floatValue] ;
            }
            
        }
        
        allPrict = allPrict + allprice;
        
        _price = allprice;
        
    }

    NSDictionary *dict = @{
                           @"cellModel":cellModelArray,
                           @"allPrice":[NSString stringWithFormat:@"￥%.2f",allPrict],

                           @"num":[NSString stringWithFormat:@"%lu",(unsigned long)numInteger],
                           @"allState":allClickArray.count == _groupArr.count && _groupArr.count>0?@"YES":@"NO"
                           };
    
    NSNotification *notification =[NSNotification notificationWithName:@"AllPrice" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 0;
    CGFloat offsetY = tableview.contentOffset.y;
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

//创建导航栏
-(void)createNav{
    
    //第一种方式，修改状态栏的颜色
    self.titleLabel.text = @"购物车";
    if ([self.statuFrom isEqualToString:@"yes"]) {
        self.tabBarController.tabBar.hidden = YES;
        UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
        UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    UIButton * messageBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_news" backgroundImageName:@"" target:self selector:@selector(shopMessageClick)];
    UIBarButtonItem* messageBtnItem = [[UIBarButtonItem alloc]initWithCustomView:messageBtn];
    
    _editBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"编辑" titleColor:RGB(123, 123, 123, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(editCartClick:)];
    _editBtn.hidden = YES;
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem* editBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,messageBtnItem,editBtnItem,nil];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

// 导航栏左右按钮点击事件
-(void)shopMessageClick{
    
    SystemMessageViewController * messageVC = [[SystemMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];

}

//整组编辑
-(void)singleEditBtn:(UIButton *)btn{
    
    ShoppingCarGroupModel * shopGropModel = _groupModelArr[btn.tag];
    
    if (shopGropModel.headEditState == 1) {
        
        shopGropModel.headEditState = 0;
        
        for (ShoppingCarModel * cellmodel in shopGropModel.gcs) {
            
            cellmodel.cellEditState = 0;
        }
        
    }else{
        
        shopGropModel.headEditState = 1;
        
        for (ShoppingCarModel * cellmodel in shopGropModel.gcs) {
            
            cellmodel.cellEditState = 1;
            
        }
    }

    [self.tv reloadData];
}

//导航栏编辑按钮
-(void)editCartClick:(UIButton *)btn{
    if (editbool) {
        
        [self editBtn:editbool];
        editbool = NO;
//        [self.tv setEditing:YES animated:NO];
    }else{
        
        [self editBtn:editbool];
        editbool = YES;
//        [self.tv setEditing:NO animated:NO];
    }
    
    [btn setTitle:editbool?@"完成":@"编辑" forState:UIControlStateNormal];
    [self setTlementLabel];
    _totalLb.hidden = editbool;
    _maliLb.hidden = editbool;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
