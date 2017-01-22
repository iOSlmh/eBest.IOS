//
//  StandingDetailViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/27.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "StandingDetailViewController.h"
#import "StandingRuleViewController.h"
#import "TableViewCell.h"

@interface StandingDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tv;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation StandingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(255, 255, 255, 1);
    [self createNav];
    [self createTV];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{

    //设置状态栏颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //透明
    self.navigationController.navigationBar.translucent = NO;

    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
 
    //透明
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)loadData{

    [RequestTools posUserWithURL:@"/integral_detail.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        self.dataArr = [Dict[@"integral_info"][@"integral_log"]mutableCopy];
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"stcellID"];
    [self.view addSubview:self.tv];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"stcellID"];
    cell.logTime.text = self.dataArr[indexPath.row][@"addTime"];
    return cell;
    
}

-(void)createNav{
    
    self.title = @"积分明细";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];

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
