//
//  StandingsViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "StandingsViewController.h"
#import "TableViewCell.h"
#import "StandingRuleViewController.h"
#import "StandingDetailViewController.h"
@interface StandingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UIView * haderView;
@property(nonatomic,strong) NSDictionary * dic;
@property(nonatomic,strong) UILabel * scoreLb;
@property (nonatomic,strong) NSMutableArray * logArr;

@end

@implementation StandingsViewController

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
    //设置状态栏颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //透明
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
    //透明
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNav];
    [self createTV];
    [self loadData];
}

-(void)loadData{

    [RequestTools posUserWithURL:@"/integralInfo.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        _scoreLb.text = [Dict[@"integral_info"][@"integral"] stringValue];
        self.logArr = Dict[@"integral_info"][@"integral_type"];
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(NSMutableArray *)logArr{

    if (!_logArr) {
        _logArr = [[NSMutableArray alloc]init];
    }
    return _logArr;
}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.backgroundColor = RGB(247, 247, 247, 1);
//    self.tv.backgroundColor = [UIColor yellowColor];
    [self.tv registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"stcellIDs"];
    [self.view addSubview:self.tv];
    
    self.haderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 275)];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.haderView.bounds];
    imageV.image = [UIImage imageNamed:@"personal center_17"];
    [self.haderView addSubview:imageV];
//    UIButton * backBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 10, 25, 25) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(sdBackClick)];
//    [self.haderView addSubview:backBtn];
//    UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake((SW-68)/2, 10, 68, 24) text:@"我的积分" textColor:RGB(255, 255, 255, 1) font:[UIFont systemFontOfSize:17]];
//    [self.haderView addSubview:titleLabel];
    UIButton * headBtn = [FactoryUI createButtonWithFrame:CGRectMake((SW-110)/2, 82, 110, 110) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(btn)];
    headBtn.layer.borderWidth = 1;
    headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    headBtn.layer.cornerRadius = 55;
    headBtn.layer.masksToBounds = YES;
    
    [self.haderView addSubview:headBtn];
    
    UIImageView * headImageV = [[UIImageView alloc]initWithFrame:CGRectMake((SW-100)/2, 82, 100, 100)];
    headImageV.backgroundColor = [UIColor whiteColor];
    headImageV.layer.cornerRadius = 50;
    headImageV.layer.masksToBounds = YES;
    headImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail:)];
    [headImageV addGestureRecognizer:tap];
    [self.haderView addSubview:headImageV];
    headBtn.center = headImageV.center;
    _scoreLb = [FactoryUI createLabelWithFrame:CGRectMake(0, 30, 100, 25) text:@"598" textColor:RGB(32, 179, 169, 1) font:[UIFont systemFontOfSize:25]];
    _scoreLb.textAlignment = NSTextAlignmentCenter;
    [headImageV addSubview:_scoreLb];
    UILabel * jifen = [FactoryUI createLabelWithFrame:CGRectMake(0, 60, 100, 15) text:@"积分" textColor:RGB(32, 179, 169, 1) font:[UIFont systemFontOfSize:15]];
    jifen.textAlignment = NSTextAlignmentCenter;
    [headImageV addSubview:jifen];
    UIButton * checkBtn = [FactoryUI createButtonWithFrame:CGRectMake((SW-145)/2, headBtn.frame.origin.y+headBtn.frame.size.height+19, 145, 30) title:@"查看可兑换商品" titleColor:RGB(255, 255, 255, 1) imageName:@""backgroundImageName:@"" target:self selector:@selector(checkBtnClick)];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    checkBtn.layer.borderWidth = 1;
    checkBtn.layer.borderColor = RGB(255, 255, 255, 1).CGColor;
    checkBtn.layer.cornerRadius = 4.2;
    checkBtn.layer.masksToBounds = YES;
    [self.haderView addSubview:checkBtn];
    self.tv.tableHeaderView = self.haderView;
}
-(void)checkBtnClick{

    NSLog(@"----------------此功能暂不可用");
}
-(void)tapDetail:(UITapGestureRecognizer *)tap{

    StandingDetailViewController * standVC = [[StandingDetailViewController alloc]init];
    [self.navigationController pushViewController:standVC animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"----------------%lu", (unsigned long)self.logArr.count);
    return self.logArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"stcellIDs"];
    cell.logTime.hidden = YES;
    cell.scoreLb.text = [NSString stringWithFormat:@"+%@",[self.logArr[indexPath.row][@"integral_type_total"] stringValue]];
    return cell;
    
}

-(void)createNav{
    
    self.title = @"我的积分";
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(sdBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton * helpBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_help" backgroundImageName:@"" target:self selector:@selector(helpClick:)];
    UIBarButtonItem * moreItem = [[UIBarButtonItem alloc]initWithCustomView:helpBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    NSArray * arr = @[negativeSpacer,moreItem];
    self.navigationItem.rightBarButtonItems = arr;

}
-(void)helpClick:(UIButton *)helpBtn{
    
    StandingRuleViewController * ruleVC = [[StandingRuleViewController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
    
}
- (void)sdBackClick{
    
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
