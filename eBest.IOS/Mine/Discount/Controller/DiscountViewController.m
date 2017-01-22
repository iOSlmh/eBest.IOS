//
//  DiscountViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DiscountViewController.h"
#import "LXSegmentScrollView.h"
#import "DiscountCell.h"

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UITableView * unUseTv;
@property(nonatomic,strong) UITableView * overTimeTv;
@property (nonatomic,strong) NSMutableArray * unUseArr;
@property (nonatomic,strong) NSMutableArray * overTimeArr;

@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    [self createTV];
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = NO;

}
-(void)loadData{

    self.unUseArr = [NSMutableArray array];
    NSDictionary * dic = @{@"status":@"unused"};
    [RequestTools posUserWithURL:@"/coupon_list.mob" params:dic success:^(NSDictionary *Dict) {
        
        self.unUseArr = Dict[@"coupon_info"];
        [self.unUseTv reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    self.overTimeArr = [NSMutableArray array];
    NSDictionary * dict = @{@"status":@"expired"};
    [RequestTools posUserWithURL:@"/coupon_list.mob" params:dict success:^(NSDictionary *Dict) {
        
        self.overTimeArr = Dict[@"coupon_info"];
        [self.overTimeTv reloadData];
        [self.overTimeTv reloadEmptyDataSet];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    //iOS7新增属性
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    NSArray *array=[NSArray array];
    self.overTimeTv = [[UITableView alloc]init];
    self.overTimeTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)style:UITableViewStylePlain];
    self.overTimeTv.backgroundColor = RGB(248, 248, 248, 1);
    self.overTimeTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.overTimeTv.delegate = self;
    self.overTimeTv.dataSource = self;
    self.overTimeTv.emptyDataSetDelegate = self;
    self.overTimeTv.emptyDataSetSource = self;
    [self.overTimeTv registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.overTimeTv];
    
    self.unUseTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)style:UITableViewStylePlain];
    self.unUseTv.backgroundColor = RGB(248, 248, 248, 1);
     self.unUseTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.unUseTv.delegate = self;
    self.unUseTv.dataSource = self;
    self.unUseTv.emptyDataSetDelegate = self;
    self.unUseTv.emptyDataSetSource = self;
    [self.unUseTv registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.unUseTv];
    array= @[self.unUseTv,self.overTimeTv];
    NSArray * imageNameArr = [NSArray array];
    
    imageNameArr = @[@"",@""];
    LXSegmentScrollView *scView= [[LXSegmentScrollView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64) titleArray:@[@"未使用",@"已过期"] contentViewArray:array andStatePage:1 andImageArr:imageNameArr];
    [self.view addSubview:scView];
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
    NSString *text = @"暂无可用优惠哦!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: RGB(123, 123, 123, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//副标题
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"可以进入店铺看看";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//设置按钮
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//    
//    return [[NSAttributedString alloc] initWithString:@"领取优惠券" attributes:attributes];
//}
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return [UIImage imageNamed:@"button_image"];
//}
#pragma mark ----------------------tv代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView==self.unUseTv) return self.unUseArr.count;
    else if (tableView==self.overTimeTv) return self.overTimeArr.count;
    else return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    return 15 ;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscountCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (tableView == self.unUseTv) {
        
        NSDictionary * modelDic = _unUseArr[indexPath.row][@"coupon"];
        cell.priceLabel.text = [modelDic[@"coupon_amount"] stringValue];
        cell.labelTop.text = [NSString stringWithFormat:@"满¥%@可用",modelDic[@"coupon_order_amount"]];
        cell.labelMid.text = [NSString stringWithFormat:@"适用范围：%@",modelDic[@"ztc_store"][@"store"][@"store_name"]];
        cell.labelBot.text = [NSString stringWithFormat:@"有效期至：%@",modelDic[@"coupon_end_time"]];
        
    }
    if (tableView==self.overTimeTv) {
        
        cell.imageV.image = [UIImage imageNamed:@"personal center_19"];
        cell.priceLabel.textColor = RGB(175, 175, 175, 1);
        cell.labelTop.textColor = RGB(175, 175, 175, 1);
        cell.labelMid.textColor = RGB(175, 175, 175, 1);
        cell.labelBot.textColor = RGB(175, 175, 175, 1);
        NSDictionary * modelDic = _overTimeArr[indexPath.row][@"coupon"];
        cell.priceLabel.text = [modelDic[@"coupon_amount"] stringValue];
        cell.labelTop.text = [NSString stringWithFormat:@"满¥%@可用",modelDic[@"coupon_order_amount"]];
        cell.labelMid.text = [NSString stringWithFormat:@"适用范围：%@",modelDic[@"ztc_store"][@"store"][@"store_name"]];
        cell.labelBot.text = [NSString stringWithFormat:@"有效期至：%@",modelDic[@"coupon_end_time"]];
    }
    return cell;
}
-(void)createNav{
    
    self.title = @"我的优惠券";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(disBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton * helpBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_help" backgroundImageName:@"" target:self selector:@selector(helpClick:)];
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:helpBtn];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBtnItem, nil];
    NSArray * arr = @[negativeSpacer,moreItem];
    self.navigationItem.rightBarButtonItems = arr;

}
-(void)helpClick:(UIButton *)btn{

}
- (void)disBackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
