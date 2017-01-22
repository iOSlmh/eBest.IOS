//
//  CheckLogViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CheckLogViewController.h"
#import "CheckLogCell.h"
@interface CheckLogViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) NSDictionary * dict;
@end

@implementation CheckLogViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    [self createNav];
    [self createTV];
    [self loadData];
}

-(void)loadData{

    _dataArr = [NSMutableArray array];
    NSDictionary * dic = @{@"of_id":_checkID};
    [RequestTools posUserWithURL:@"/ship_query.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        _dict = Dict[@"ship"];
        _dataArr = Dict[@"ship"][@"data"];
        [self.tv reloadData];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv registerNib:[UINib nibWithNibName:@"CheckLogCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tv];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckLogCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (indexPath.row ==0) {
        cell.topLb.hidden = YES;
        cell.bottomLb.hidden =NO;
        cell.messageLb.textColor = RGB(32, 179, 169, 1);
        cell.timeLb.textColor = RGB(32, 179, 169, 1);
        cell.pointImageV.image = [UIImage imageNamed:@"DNA_2"];
    }else if (indexPath.row ==_dataArr.count-1) {
        cell.bottomLb.hidden =YES;
        cell.topLb.hidden = NO;
        cell.messageLb.textColor = RGB(123, 123 , 123, 1);
        cell.timeLb.textColor = RGB(123, 123 , 123, 1);
        cell.pointImageV.image = [UIImage imageNamed:@"rank_red_dot"];
    }
//    else{
//        cell.messageLb.textColor = RGB(71, 71 , 71, 1);
//        cell.timeLb.textColor = RGB(71, 71 , 71, 1);
//        cell.pointImageV.image = [UIImage imageNamed:@"rank_red_dot"];
//    }
//    //设置样式
//    if (indexPath.row == 0) {
//        cell.iconImg.image = [UIImage imageNamed:@"logistics"];
//        cell.lineView.backgroundColor = [UIColor greenColor];
//    }else if(indexPath.row == (self.data.count-1)){
//        cell.iconImg.image = [UIImage imageNamed:@"logistics1"];
//        cell.lineView.backgroundColor = [UIColor whiteColor];
//    }else{
//        cell.iconImg.image = [UIImage imageNamed:@"logistics1"];
//        cell.lineView.backgroundColor = [UIColor lightGrayColor];
//    }
    cell.messageLb.text = _dataArr[indexPath.row][@"context"];
    cell.timeLb.text = _dataArr[indexPath.row][@"time"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 95;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, SW, 180))];
    view.backgroundColor = [UIColor whiteColor];
    NSString * stutaStr = @"";
    if ([_dict[@"state"]isEqualToString:@"3"]) {
        stutaStr = @"已签收";
    }
    UILabel *statuLb = [FactoryUI createLabelWithFrame:CGRectMake(15, 15, 200, 13) text:[NSString stringWithFormat:@"物流状态：%@",stutaStr] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:13]];
    [view addSubview:statuLb];
    
    UILabel *kindLb = [FactoryUI createLabelWithFrame:CGRectMake(CGRectGetMinX(statuLb.frame), CGRectGetMaxY(statuLb.frame)+8, 200, 13) text:[NSString stringWithFormat:@"快递公司：%@",_dict[@"com"]] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:13]];
    [view addSubview:kindLb];
    
    UILabel *numLb =  [FactoryUI createLabelWithFrame:CGRectMake(CGRectGetMinX(statuLb.frame), CGRectGetMaxY(kindLb.frame)+8, 200, 13) text:[NSString stringWithFormat:@"运单编号：%@",_dict[@"nu"]] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:13]];
    [view addSubview:numLb];
    
    UIView *midView = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(numLb.frame)+15, SW, 10))];
    [view addSubview:midView];
    midView.backgroundColor = RGB(236, 235, 235, 1);
    return view;
}

//创建导航栏
-(void)createNav{
    
    self.title = @"退货详情";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

    
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
