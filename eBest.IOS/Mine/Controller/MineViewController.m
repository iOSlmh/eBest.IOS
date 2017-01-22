//
//  MineViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AddressViewController.h"
#import "MyOderViewController.h"
#import "CollectViewController.h"
#import "SettingViewController.h"
#import "PersonalViewController.h"
#import "StandingsViewController.h"
#import "DiscountViewController.h"
#import "ThirdTieViewController.h"
#import "MyCommentViewController.h"
#import "SystemMessageViewController.h"

@interface MineViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,GetmainNichengname>
{

    UILabel * _namelabel;
}

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UISegmentedControl * segementedControl;
@property (nonatomic,copy) NSString *selectedIndex;
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UIImageView * headImageV;
@property(nonatomic,strong) UIButton * loginBtn;
@property(nonatomic,strong) UIButton * registerBtn;
@property(nonatomic,strong) UILabel * midLine;
@property(nonatomic,strong) UIView * topView;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) NSDictionary * mesDict;

@property(nonatomic, strong) UITableView *commoditytableView;
@property(nonatomic, strong) UITableView *storetableView;

//个人中心数目信息属性
@property(nonatomic,copy) NSString *all_order_count;
@property(nonatomic,copy) NSString *coupon_count;
@property(nonatomic,copy) NSString *favorite_count;
@property(nonatomic,copy) NSString *finish_order_count;
@property(nonatomic,copy) NSString *integral;
@property(nonatomic,copy) NSString *paid_order_count;
@property(nonatomic,copy) NSString *return_order_count;
@property(nonatomic,copy) NSString *ship_order_count;
@property(nonatomic,copy) NSString *topay_order_count;
@property(nonatomic,strong) NSMutableArray * countArr;
@end

@implementation MineViewController

@synthesize storetableView,commoditytableView;

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden= NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = RGB(32, 179, 169, 1);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self loadPersonalMessage];
    [self loadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createCommoditytableView];
    [self createTV];
    [self setTopView];
    
}

-(void)loadPersonalMessage{

    [RequestTools getUserWithURL:@"/user_info.mob" params:nil success:^(NSDictionary *Dict) {
        
        _mesDict = Dict[@"user_info"];
        NSLog(@"----------------%@",_mesDict);
        [self reloadMessage];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)reloadMessage{

    if ([Function is_Login]) {
        
        self.loginBtn.hidden = YES;
        self.registerBtn.hidden = YES;
        self.midLine.hidden = YES;
        _namelabel.hidden = NO;
        NSString * nameStr = _mesDict[@"mobile"];
        _namelabel.text = nameStr;
        NSString *value = [_mesDict objectForKey:@"photo"];
        if (kIsEmptyString(value)) {
            [self.headImageV setImage:[UIImage imageNamed:@"默认头像"]];
        }else{
            NSString * str = _mesDict[@"photo"][@"path"];
            NSUserDefaults * header = [NSUserDefaults standardUserDefaults];
            NSString * headUrl = [NSString stringWithFormat:@"%@%@",Image_url,str];
            [header setValue:headUrl forKey:@"headImage"];
            [_headImageV sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
//            HeadImageWithUrl(_headImageV, str);
        }

    }else{
    
        self.loginBtn.hidden = NO;
        self.registerBtn.hidden = NO;
        self.midLine.hidden = NO;
        _namelabel.hidden = YES;
        [self.headImageV setImage:[UIImage imageNamed:@""]];
        _countArr = [NSMutableArray array];
        _coupon_count = @"0";
        _favorite_count = @"0";
        _integral = @"0";
        [self.tv reloadData];
    }
    
}

#pragma mark ----------------------个人中心数目信息
-(void)loadData{

    if ([Function is_Login]) {
        
        //打印测试
//        NSLog(@"----------------%@",[[NSUserDefaults standardUserDefaults] objectForKey:k_user]);
//        NSLog(@"----------------%@",[[NSUserDefaults standardUserDefaults] objectForKey:k_Key]);
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_Key];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_user];

        _countArr = [NSMutableArray array];
        [RequestTools getUserWithURL:@"/center.mob" params:nil success:^(NSDictionary *Dict) {
            
            NSLog(@"%@",Dict);
            if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                
                for (NSString *key in Dict.allKeys) {
                    if (![[Dict objectForKey:key] isEqual:[NSNull null]]) {
                        
                        _all_order_count = Dict[@"center_info"][@"all_order_count"];
                        _coupon_count = Dict[@"center_info"][@"coupon_count"];
                        _favorite_count = Dict[@"center_info"][@"favorite_count"];
                        _finish_order_count = Dict[@"center_info"][@"finish_order_count"];
                        _integral = Dict[@"center_info"][@"integral"];
                        _paid_order_count = Dict[@"center_info"][@"paid_order_count"];
                        _return_order_count = Dict[@"center_info"][@"return_order_count"];
                        _ship_order_count = Dict[@"center_info"][@"ship_order_count"];
                        _topay_order_count = Dict[@"center_info"][@"topay_order_count"];
                        
                        [_countArr addObject:_topay_order_count];
                        [_countArr addObject:_paid_order_count];
                        [_countArr addObject:_ship_order_count];
                        [_countArr addObject:_return_order_count];
                        
                    }
                }
            }else{
            
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_Key];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_user];
            }
            
            [self.tv reloadData];
        } failure:^(NSError *error) {
            
        }];

    }
    else{
        
        _countArr = [NSMutableArray array];
        _coupon_count = @"0";
        _favorite_count = @"0";
        _integral = @"0";
       [self.tv reloadData];
    }
    
}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, UNIT_HEIGHT(68), SW, SH-UNIT_HEIGHT(68)-64-44)];
    self.tv.backgroundColor = RGB(236, 235, 235, 1);
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.bounces = NO;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tv registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tv];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UNIT_HEIGHT(48);
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
//     return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else
        return 4;
//    if (section==0) {
//        return 1;
//    }else if (section==1){
//        return 1;
//    }else
//    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
            cell.cellImageV.image = [UIImage imageNamed:@"personal center_0"];
            cell.titleLabel.text = @"我的商城";
        cell.textLabel.textColor = RGB(71, 71, 71, 1);
            cell.messagelabel.text = @"全部订单";
    }
    //隐掉未开发模块
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.cellImageV.image = [UIImage imageNamed:@"personal center_6"];
            cell.titleLabel.text = @"我的收藏";
            cell.messagelabel.text = [NSString stringWithFormat:@"%@个",_favorite_count];
        }else if (indexPath.row==1){
            cell.cellImageV.image = [UIImage imageNamed:@"personal center_7"];
            cell.titleLabel.text = @"优惠券";
            cell.messagelabel.text = [NSString stringWithFormat:@"%@张",_coupon_count];
        }else if (indexPath.row==2){
            cell.cellImageV.image = [UIImage imageNamed:@"personal center_8"];
            cell.titleLabel.text = @"我的积分";
            cell.messagelabel.text = [NSString stringWithFormat:@"%@分",_integral];
        }else{
            cell.cellImageV.image = [UIImage imageNamed:@"personal center_9"];
            cell.titleLabel.text = @"地址管理";
            cell.messagelabel.text = @"";
        }
    }

    // 未隐藏模块
//    if (indexPath.section==1) {
//        cell.cellImageV.image = [UIImage imageNamed:@"personal center_5"];
//        cell.titleLabel.text = @"我的众筹";
//        cell.messagelabel.text = @"";
//
//    }
//    if (indexPath.section==2) {
//        if (indexPath.row==0) {
//            cell.cellImageV.image = [UIImage imageNamed:@"personal center_6"];
//            cell.titleLabel.text = @"我的收藏";
//            cell.messagelabel.text = [NSString stringWithFormat:@"%@个",_favorite_count];
//        }else if (indexPath.row==1){
//            cell.cellImageV.image = [UIImage imageNamed:@"personal center_7"];
//            cell.titleLabel.text = @"优惠券";
//            cell.messagelabel.text = [NSString stringWithFormat:@"%@张",_coupon_count];
//        }else if (indexPath.row==2){
//            cell.cellImageV.image = [UIImage imageNamed:@"personal center_8"];
//            cell.titleLabel.text = @"我的积分";
//            cell.messagelabel.text = [NSString stringWithFormat:@"%@分",_integral];
//        }else if (indexPath.row==3){
//            cell.cellImageV.image = [UIImage imageNamed:@"personal center_9"];
//            cell.titleLabel.text = @"地址管理";
//            cell.messagelabel.text = @"";
//        }else{
//            cell.cellImageV.image = [UIImage imageNamed:@"personal center_10"];
//            cell.titleLabel.text = @"卖家中心";
//            cell.messagelabel.text = @"";
//        }
//    }
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, UNIT_HEIGHT(10))];
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return UNIT_HEIGHT(10);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return UNIT_HEIGHT(79);
    }else{
        return 0;
    }
}
#pragma mark 返回table尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor whiteColor];
//        UILabel * topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, footer.bounds.size.width, 0.5)];
//        topLine.backgroundColor = RGB(236, 235, 235, 1);
//        [footer addSubview:topLine];
        
//        UIImageView *bgView = [UIImageView new];
//        bgView.image = [UIImage imageNamed:@"MyAddressManager_line_new"];
//        [footer addSubview:bgView];
        
        NSArray * imageArr = @[@"personal center_1",@"personal center_2",@"personal center_3",@"personal center_4"];
        NSArray * lableArr = @[@"待付款",@"待发货",@"待收货",@"退换货"];
        for (int i=0; i<4; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((i+1)*(SW-UNIT_WIDTH(50)*4)/5+i*UNIT_WIDTH(50), UNIT_HEIGHT(15), UNIT_HEIGHT(50), UNIT_HEIGHT(50));
            btn.tag = 200+i;
            [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(fbtnClick:) forControlEvents:UIControlEventTouchUpInside];

            UILabel * la = [FactoryUI createLabelWithFrame:CGRectMake((i+1)*(SW-UNIT_WIDTH(50)*4)/5+i*UNIT_WIDTH(50), UNIT_HEIGHT(45), UNIT_HEIGHT(50), UNIT_HEIGHT(50)) text:lableArr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
            la.textAlignment = YES;
            [footer addSubview:btn];
            [footer addSubview:la];
//            对返回数据进行判断创建角标
            if (_countArr.count>0) {
                if (![_countArr[i] isEqualToString:@"0"]) {
                    
                    if ([_countArr[i] integerValue]<=9) {
                        
                        UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake((i+1)*(SW-UNIT_WIDTH(50)*4)/5+i*UNIT_WIDTH(50)+UNIT_WIDTH(30), UNIT_HEIGHT(19 ), 13, 13) text:_countArr[i] textColor:RGB(42, 150, 143, 1) font:[UIFont systemFontOfSize:13]];
                        lb.layer.cornerRadius = 6.5;
                        lb.layer.masksToBounds = YES;
                        lb.layer.borderWidth = 1;
                        lb.layer.borderColor = RGB(42, 150, 143, 1).CGColor;
                        lb.textAlignment = NSTextAlignmentCenter;
                        [footer addSubview:lb];

                    }
                    else
                    {
                    
                        UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake((i+1)*(SW-UNIT_WIDTH(50)*4)/5+i*UNIT_WIDTH(50)+UNIT_WIDTH(30), UNIT_HEIGHT(19 ), 20, 13) text:_countArr[i] textColor:RGB(42, 150, 143, 1) font:[UIFont systemFontOfSize:13]];
                        lb.layer.cornerRadius = 6;
                        lb.layer.masksToBounds = YES;
                        lb.layer.borderWidth = 1;
                        lb.layer.borderColor = RGB(42, 150, 143, 1).CGColor;
                        lb.textAlignment = NSTextAlignmentCenter;
                        [footer addSubview:lb];
 
                    }
                    
                }
            }
            
        }

        return footer;
        
    }else
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        if ([Function is_Login ]) {
            
            MyOderViewController * myOderVC = [[MyOderViewController alloc]init];
            myOderVC.statePage=1;
            [self.navigationController pushViewController:myOderVC animated:YES];
            
        }else{
        
            LoginViewController * logVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:logVC animated:YES];
        }
        
        
    }
    
    if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            if ([Function is_Login ]){
                
                CollectViewController * collectVC = [[CollectViewController alloc]init];
                [self.navigationController pushViewController:collectVC animated:YES];
                
            }else{
                
                LoginViewController * logVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:logVC animated:YES];
                
            }
            
        }else if (indexPath.row==1){
            
            if ([Function is_Login ]){
                
                DiscountViewController * disVC = [[DiscountViewController alloc]init];
                [self.navigationController pushViewController:disVC animated:YES];
                
            }else{
                
                LoginViewController * logVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:logVC animated:YES];
                
            }
            
        }else if (indexPath.row==2){
            
            if ([Function is_Login ]){
                
                StandingsViewController * standVC = [[StandingsViewController alloc]init];
                [self.navigationController pushViewController:standVC animated:YES];
                
            }else{
                
                LoginViewController * logVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:logVC animated:YES];
                
            }
            
            
        }else if (indexPath.row==3){
            
            if ([Function is_Login ]){
                
                AddressViewController * addressVC = [[AddressViewController alloc]init];
                [self.navigationController pushViewController:addressVC animated:YES];
                
            }else{
                
                LoginViewController * logVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:logVC animated:YES];
                
            }
            
            
        }else{
            
            
        }
        
    }

//    if (indexPath.section ==1) {
//        
//        if ([Function is_Login ]){
//            
//            
//        }else{
//        
//        LoginViewController * logVC = [[LoginViewController alloc]init];
//        [self.navigationController pushViewController:logVC animated:YES];
//            
//        }
//        
//    }
//    if (indexPath.section==2) {
//        
//        if (indexPath.row==0) {
//            
//            if ([Function is_Login ]){
//                
//            CollectViewController * collectVC = [[CollectViewController alloc]init];
//            [self.navigationController pushViewController:collectVC animated:YES];
//                
//            }else{
//                
//            LoginViewController * logVC = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:logVC animated:YES];
//                
//            }
//            
//        }else if (indexPath.row==1){
//            
//            if ([Function is_Login ]){
//                
//            DiscountViewController * disVC = [[DiscountViewController alloc]init];
//            [self.navigationController pushViewController:disVC animated:YES];
//                
//            }else{
//            
//            LoginViewController * logVC = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:logVC animated:YES];
//                
//            }
//            
//        }else if (indexPath.row==2){
//            
//            if ([Function is_Login ]){
//                
//                StandingsViewController * standVC = [[StandingsViewController alloc]init];
//                [self.navigationController pushViewController:standVC animated:YES];
//                
//            }else{
//                
//                LoginViewController * logVC = [[LoginViewController alloc]init];
//                [self.navigationController pushViewController:logVC animated:YES];
//                
//            }
//           
//            
//        }else if (indexPath.row==3){
//            
//            if ([Function is_Login ]){
//                
//                AddressViewController * addressVC = [[AddressViewController alloc]init];
//                [self.navigationController pushViewController:addressVC animated:YES];
//                
//            }else{
//                
//                LoginViewController * logVC = [[LoginViewController alloc]init];
//                [self.navigationController pushViewController:logVC animated:YES];
//
//            }
//            
//
//        }else{
//            
//            
//        }
//
//    }

}
-(void)fbtnClick:(UIButton *)btn{

    if ([Function is_Login]) {
        
        MyOderViewController * myOrderVC = [MyOderViewController new];
        myOrderVC.statePage = btn.tag-200+2;
        [self.navigationController pushViewController:myOrderVC animated:YES];
        
    }else{
    
        LoginViewController * logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        
    }
    
}
//设置昵称代理方法
-(void)getmainNicheng:(NSString *)name{

    _namelabel.text =name;
}
//设置头部View
-(void)setTopView{
    
    self.topView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, UNIT_HEIGHT(68))];
    self.topView.backgroundColor = RGB(32, 179, 169, 1);
    [self.view addSubview:self.topView];
    self.headImageV = [FactoryUI createImageViewWithFrame:CGRectMake(UNIT_WIDTH(21), 0, 50, 50) imageName:@""];
    self.headImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.headImageV addGestureRecognizer:tapGest];
    self.headImageV.layer.cornerRadius = 25;
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:self.headImageV];
    
    _namelabel = [FactoryUI createLabelWithFrame:CGRectMake(79, 17, 100, 23) text:@"店小二" textColor:RGB(255, 255, 255, 1) font:[UIFont systemFontOfSize:15]];
    _namelabel.hidden = YES;
//        UILabel * vipLabel = [FactoryUI createLabelWithFrame:CGRectMake(126, 17, 45, 23) text:@"Lv.1" textColor:RGB(255, 255, 255, 1) font:[UIFont systemFontOfSize:15]];
    [self.topView addSubview:_namelabel];
//        [self.topView addSubview:vipLabel];
    
    self.loginBtn = [FactoryUI createButtonWithFrame:CGRectMake((UNIT_WIDTH(21)+75), 15, 35, 20) title:@"登录" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(loginClick)];
//        self.loginBtn.backgroundColor = [UIColor whiteColor];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.loginBtn];
    
    self.midLine = [FactoryUI createLineWithFrame:CGRectMake(_loginBtn.frame.origin.x+35+20, 15, 2, 20) withColor:[UIColor whiteColor]];
    [self.topView addSubview:self.midLine];
    
    self.registerBtn = [FactoryUI createButtonWithFrame:CGRectMake(self.midLine.frame.origin.x+2+20, 15, 35, 20) title:@"注册" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(registerClick)];
//        self.registerBtn.backgroundColor = [UIColor whiteColor];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.registerBtn];
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    SettingViewController * setVC = [[SettingViewController alloc]init];
    if ([_mesDict[@"photo"] isEqual:[NSNull null]]) {
        
        setVC.headImageStr = _mesDict[@"photo"];
        setVC.nameStr = _mesDict[@"mobile"];
    }else{
    
        NSString * str = _mesDict[@"photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        setVC.headImageStr = appStr;
        setVC.nameStr = _mesDict[@"mobile"];
    }
    [self.navigationController pushViewController:setVC animated:YES];
    
}

-(void)loginClick{

    LoginViewController * loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)registerClick{

    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark ---------------------- 设置导航栏分段
-(void)createSegment{
    
    NSArray * segmentenArray = [[NSArray alloc]initWithObjects:@"商品",@"详情", nil];
    self.segementedControl = [[UISegmentedControl alloc]initWithItems:segmentenArray];
    self.segementedControl.frame = CGRectMake(0, 0, 160, 30);
    self.segementedControl.tintColor = [UIColor lightGrayColor];
    self.segementedControl.selectedSegmentIndex = self.selectedIndex.intValue;
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName,RGB(248, 248, 255, 1),NSForegroundColorAttributeName, nil];
    [self.segementedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary * hightlightAttributes = [NSDictionary dictionaryWithObject:RGB(225, 225, 225, 0) forKey:NSForegroundColorAttributeName];
    [self.segementedControl setTitleTextAttributes:hightlightAttributes forState:UIControlStateHighlighted];
    [self.segementedControl addTarget:self action:@selector(changeOptiono:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - segment响应方法
//segment改变的时候关联scrollView
-(void)changeOptiono:(UISegmentedControl *)segment
{
    
    NSInteger index = self.segementedControl.selectedSegmentIndex;
    
    switch (index)
    {
        case 0 :
            
            //
                                    commoditytableView.hidden = NO;
                                    storetableView.hidden = YES;
            
//            [self createCommoditytableView]; //设置商品 tableView
            break;
            
        case 1 :
            //            [self.view bringSubviewToFront:_navMorelV];
            //
            //                        commoditytableView.hidden = YES;
            storetableView.hidden = NO;
            [self createStoretableView]; //设置店铺 tableView
            break;
            
        default :
            break;
    }
    //    self.scrollView.contentOffset = CGPointMake(segment.selectedSegmentIndex * SW, 0);
}

//scrollView滑动的时候关联segment
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.segementedControl.selectedSegmentIndex = scrollView.contentOffset.x / SW;
}

/**
 *  设置商品 UI
 */
- (void)createCommoditytableView
{
    commoditytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH-64) style:UITableViewStyleGrouped];
    commoditytableView.showsHorizontalScrollIndicator = YES;
    //commoditytableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    commoditytableView.backgroundColor = RGB(236, 235, 235, 1);
    commoditytableView.delegate = self;
    commoditytableView.dataSource = self;
     [commoditytableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:commoditytableView];
}
/**
 *  设置店铺 UI
 */
- (void)createStoretableView
{
    storetableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SW, SH-64) style:UITableViewStyleGrouped];
    storetableView.showsHorizontalScrollIndicator = YES;
    //storetableView.separatorStyle = UITableViewCellSelectionStyleNone;
    storetableView.backgroundColor = RGB(132, 249, 249,1);
    storetableView.delegate = self;
    storetableView.dataSource = self;
     [storetableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:storetableView];
}

//设置cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}

//创建导航栏
-(void)createNav{
    
    UIButton * messageBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_news2" backgroundImageName:@"" target:self selector:@selector(messageClick)];
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
