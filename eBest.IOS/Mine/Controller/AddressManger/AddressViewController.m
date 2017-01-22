//
//  AddressViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressModel.h"
#import "AddAdressViewController.h"
#import "EditAddressViewController.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView * tv;
@property(strong,nonatomic) NSMutableArray * dataArr;
@property(strong,nonatomic) NSMutableArray * btnArr;
@property(strong,nonatomic) NSMutableArray * modelArr;
@property(strong,nonatomic) NSString * str1;
@property(strong,nonatomic) NSString * str2;
@property(strong,nonatomic) NSString * str3;
@property(strong,nonatomic) NSString * str4;

@end

@implementation AddressViewController


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self createTV];
    [self createBottomBtn];
    //[self loadData];
    _btnArr = [NSMutableArray array];
    //接收微博登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refUI:) name:@"refUI" object:nil];
}

//由于复用问题暂时使用刷新方法
-(void)refUI:(NSNotification *)refresh{

    [self loadData];
}

-(void)loadData{
    
    [RequestTools getUserWithURL:@"/address_display.mob" params:nil success:^(NSDictionary *Dict) {
        NSLog(@"----------------%@",Dict);
        _dataArr = [[NSMutableArray alloc]init];
        _dataArr = [[Dict objectForKey:@"address_list"]mutableCopy];
        _modelArr = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in _dataArr) {
            AddressModel * model = [[AddressModel alloc]init];
            _str1 = dic[@"area"][@"areaName"];
            _str2 = dic[@"area"][@"parent"][@"areaName"];
            _str3 = dic[@"area"][@"parent"][@"parent"][@"areaName"];
            _str4 = [dic objectForKey:@"area_info"];
            model.distr = _str1;
            model.trueName = [dic objectForKey:@"trueName"];
            model.mobile = [dic objectForKey:@"mobile"];
            model.addrID = [dic objectForKey:@"id"];
            model.type = [dic objectForKey:@"type"];
            model.thirdRank = [NSString stringWithFormat:@"%@%@%@",_str3,_str2,_str1];
            model.detailArea = _str4;
            model.area_info = [NSString stringWithFormat:@"%@%@%@%@",_str3,_str2,_str1,_str4];
            [self.modelArr addObject:model];

        }
        
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-48-64) style:UITableViewStyleGrouped];
    self.tv.separatorStyle = NO;
    self.tv.bounces = NO;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.showsVerticalScrollIndicator = NO;
    self.tv.backgroundColor = RGB(236, 235, 235, 1);
    [self.tv registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tv];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 112;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.propertyBtn.tag = indexPath.section;
    NSLog(@"%ld",(long)cell.propertyBtn.tag);
    [_btnArr addObject:cell.propertyBtn];
    AddressModel * model = _modelArr[indexPath.section];
    NSLog(@"%@",model.area_info);
    [cell getModel:model];
    cell.btnArray = _btnArr;
    NSLog(@"%lu",(unsigned long)cell.btnArray.count);
 
    [cell.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.section;
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footView = [[UIView alloc]init];
    footView.backgroundColor = RGB(236, 235, 235, 1);
    return footView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc]init];
    return headerView;
}
-(void)editClick:(UIButton *)btn{

    EditAddressViewController * editVC = [[EditAddressViewController alloc]init];
    editVC.addressModel = _modelArr[btn.tag];
    [self.navigationController pushViewController:editVC animated:YES];

}

#pragma mark ----------------------设置底层按钮
-(void)createBottomBtn{
    
    UIButton * bottomBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, SH-112, SW, 48) title:@"+新增地址" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(addAddress)];
    bottomBtn.backgroundColor = RGB(32, 179, 169, 1);
    bottomBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bottomBtn];
    
}

//新增地址点击方法
-(void)addAddress{

    AddAdressViewController * addAddressVC = [[AddAdressViewController alloc]init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
    

}

//设置导航
-(void)setNav{

    self.title = @"选择收货地址";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

}

//设置返回按钮点击事件
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------------实现cell滑动删除
//设置编辑cell的类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//设置cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//编辑方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        //        在数据从数组移除前取到想要删除的ID
        NSString * deleteID = _dataArr[indexPath.section][@"id"];
        NSLog(@"%@",deleteID);
        NSLog(@"%ld",(long)indexPath.row);
        [_dataArr removeObjectAtIndex:indexPath.section];
//        [self.tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tv deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationAutomatic];
        //        删除收藏商品网络数据
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"addr_id":deleteID}];
        [RequestTools posUserWithURL:@"/address_delete.mob" params:dict success:^(NSDictionary *Dict) {

        } failure:^(NSError *error) {
        
        }];
    
}


@end
