//
//  OderDetailViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "OderDetailViewController.h"
#import "MyOderCell.h"
#import "OderDetailCell.h"
#import "CheckLogViewController.h"
#import "DetailViewController.h"
#import "OrderViewController.h"
#import "MyCommentViewController.h"
#import "RetMoneyViewController.h"

@interface OderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UIView * bottomView;
@property(nonatomic,strong) UIView * footerView;
@property(nonatomic,strong) NSDictionary * groupDic;
@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) NSArray * titleArr;
@property(strong,nonatomic) NSString * str1;
@property(strong,nonatomic) NSString * str2;
@property(strong,nonatomic) NSString * str3;
@property(strong,nonatomic) NSString * str4;
@property(strong,nonatomic) NSString * addrStr;

@end

@implementation OderDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    [self createTV];
    [self loadData];
    [self createBotView];
    self.tv.tableFooterView = [UIView new];
}

-(NSArray *)titleArr{

    if (!_titleArr) {
        _titleArr = [[NSArray alloc]init];
    }
    return _titleArr;
}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    _dataArr = [NSMutableArray array];
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64-48) style:UITableViewStyleGrouped];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv registerNib:[UINib nibWithNibName:@"MyOderCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.tv registerNib:[UINib nibWithNibName:@"OderDetailCell" bundle:nil] forCellReuseIdentifier:@"OderCellID"];
    [self.view addSubview:self.tv];
}

-(void)createBotView{
    
    switch (self.classify) {
        case 1:
            _titleArr = @[@"付款",@"取消订单"];
            break;
        case 2:
            _titleArr = @[@"确认收货"];
            break;
        case 3:
            _titleArr = @[@"去评价"];
            break;
        case 4:
            _titleArr = @[];
            break;
        case 5:
            _titleArr = @[@"删除订单"];
            break;

            
        default:
            break;
    }
    
    if (kIsEmptyArray(_titleArr)) {
        
        [self createBtnWithTitleArr:_titleArr];
        
    }else{
        
        self.tv.frame = CGRectMake(0, 0, SW, SH-64);
        
    }
    
}

-(void)createBtnWithTitleArr:(NSArray *)arr{

    self.bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-48-64, SW, 48)];
    UILabel * line = [FactoryUI createLineWithFrame:CGRectMake(0, 0, SW, 0.5) withColor:RGB(226, 226, 226, 1)];
    [self.bottomView addSubview:line];
    [self.view addSubview:self.bottomView];
    for (int i=0; i<arr.count; i++) {
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(SW-15-(i+1)*79-i*10, 9.5, 79, 29) title:arr[i] titleColor:nil imageName:nil backgroundImageName:nil target:self selector:@selector(btnClick:)];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.layer.borderWidth = 0.5f;
        [self.bottomView addSubview:btn];
        if (btn.tag==100) {
            [btn setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
            btn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
        }else{
            [btn setTitleColor:RGB(71, 71, 71, 1) forState:UIControlStateNormal];
            btn.layer.borderColor = RGB(123, 123, 123, 1).CGColor;
        }
    }

}

-(void)btnClick:(UIButton *)btn{

    NSLog(@"----------------%@",btn.currentTitle);
    if ([btn.currentTitle isEqualToString:@"付款"]) {
        NSString * payID = _groupDic[@"paymentBatchNo"];
        NSLog(@"----------------%@",payID);
        OrderViewController * oderVC = [[OrderViewController alloc]init];
        self.delegate = oderVC;
        [self.delegate oderDetailToPay:payID];
    }else if ([btn.currentTitle isEqualToString:@"取消订单"]){
        NSNumber * oderID =  [NSNumber numberWithInteger:[[_groupDic objectForKey:@"id"] integerValue]];
        [self cancelOderWithID:oderID];
    }else if ([btn.currentTitle isEqualToString:@"删除订单"]){
        NSNumber * oderID =  [NSNumber numberWithInteger:[[_groupDic objectForKey:@"id"] integerValue]];
        [self deleteOderWithID:oderID];
    }else if ([btn.currentTitle isEqualToString:@"确认收货"]){
        NSNumber * oderID =  [NSNumber numberWithInteger:[[_groupDic objectForKey:@"id"] integerValue]];
        [self confirmRecWithID:oderID];
    }else if ([btn.currentTitle isEqualToString:@"去评价"]){
        NSNumber * oderID =  [NSNumber numberWithInteger:[[_groupDic objectForKey:@"id"] integerValue]];
        [self commentOderWithID:oderID];
    }else if ([btn.currentTitle isEqualToString:@"付款"]){
        
    }else if ([btn.currentTitle isEqualToString:@"付款"]){
        
    }else if ([btn.currentTitle isEqualToString:@"付款"]){
        
    }else if ([btn.currentTitle isEqualToString:@"付款"]){
        
    }else if ([btn.currentTitle isEqualToString:@"付款"]){
        
    }else{
    
    }
}
//取消订单
-(void)cancelOderWithID:(NSNumber *)oderId{
    
    NSDictionary * dic = @{@"of_id":oderId,@"cancel_reason":@"不想要了"};
    [RequestTools posUserWithURL:@"/order_cancel.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}
//退款
-(void)returnMoneyWithID:(NSNumber *)num{
    
    RetMoneyViewController * moneyVC = [[RetMoneyViewController alloc]init];
    moneyVC.ofID = num;
    [self.navigationController pushViewController:moneyVC animated:YES];
}
//确认收货
-(void)confirmRecWithID:(NSNumber *)oderID{
    
    NSDictionary * dic = @{@"of_id":oderID};
    [RequestTools posUserWithURL:@"/goods_receive.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [AlertShow showAlert:@"成功收货"];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//查看物流
-(void)checkLogisticsWithID:(NSNumber *)oderID{
    
    CheckLogViewController * checkVC = [[CheckLogViewController alloc]init];
    checkVC.checkID = oderID;
    [self.navigationController pushViewController:checkVC animated:YES];
}
//删除订单
-(void)deleteOderWithID:(NSNumber *)oderID{
    
    NSDictionary * dic = @{@"of_id":oderID};
    [RequestTools posUserWithURL:@"/order_delete.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        [self.navigationController popViewControllerAnimated:YES];
        //发送删除通知给订单列表界面
        NSNotification *notification =[NSNotification notificationWithName:@"reloadata" object:nil userInfo:@{@"indexSection":[NSNumber numberWithInteger:self.indexSection]}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } failure:^(NSError *error) {
        
    }];
    
}

//评价订单
-(void)commentOderWithID:(NSNumber *)oderID{
    
    MyCommentViewController * comVC = [[MyCommentViewController alloc]init];
    comVC.orderId = oderID;
    [self.navigationController pushViewController:comVC animated:YES];
    
}

-(void)createFooterView{
    NSLog(@"%@",_groupDic[@"totalPrice"]);
    self.footerView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 193)];
    self.footerView.backgroundColor = RGB(245, 245, 245, 1);
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 148)];
    whiteView.backgroundColor = [UIColor whiteColor];
    NSArray * totalArr = @[@"总计：",@"保价费：",@"优惠券：",@"邮费："];
    for (int i=0; i<totalArr.count; i++) {
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(SW-81-60, 13+i*23, 60, 14) text:totalArr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        label.textAlignment = NSTextAlignmentRight;
        [whiteView addSubview:label];
    }
    UILabel * line = [FactoryUI createLabelWithFrame:CGRectMake(0, 103, SW, 1) text:@"" textColor:RGB(68, 63, 91, 1) font:[UIFont systemFontOfSize:14]];
    line.backgroundColor = RGB(236, 235, 235, 1);
    [whiteView addSubview:line];
    UILabel * fukuanLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-153, 119, 140, 14) text:[NSString stringWithFormat:@"实付款：¥%@.00",_groupDic[@"totalPrice"]] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13.5]];
    fukuanLabel.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:fukuanLabel];
    [self.footerView addSubview:whiteView];
    UILabel * numLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-193, 156, 180, 14) text:[NSString stringWithFormat:@"订单号：%@",_groupDic[@"order_id"] ] textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:10]];
    numLabel.textAlignment = NSTextAlignmentRight;
    [self.footerView addSubview:numLabel];
    UILabel * timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-183, 176, 170, 14) text:[NSString stringWithFormat:@"下单时间：%@",_groupDic[@"addTime"] ] textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:10]];
        timeLabel.textAlignment = NSTextAlignmentRight;
    [self.footerView addSubview:timeLabel];
    self.tv.tableFooterView = self.footerView;

}
-(void)createheaderView{
    
    if ([[_groupDic[@"order_status"] stringValue]isEqualToString:@"10"]) {
        
       self.headerView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 98)];
        self.headerView.backgroundColor = [UIColor whiteColor];
        UIImageView * iconImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 18, 16, 16) imageName:@"order_consignee2"];
        [self.headerView addSubview:iconImageV];
        UILabel * nameLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 18, 187, 14) text:_groupDic[@"addr"][@"trueName"] textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        [self.headerView addSubview:nameLB];
        UILabel * phoneLB = [FactoryUI createLabelWithFrame:CGRectMake(SW-90-15, 18, 90, 14) text:_groupDic[@"addr"][@"mobile"] textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        [self.headerView addSubview:phoneLB];
        UIImageView * addressImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 44, 16, 16) imageName:@"order_address2"];
        [self.headerView addSubview:addressImageV];
        UILabel * addressLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 42, SW-55, 40) text:_addrStr textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        addressLB.numberOfLines = 0;
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_addrStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_addrStr length])];
        addressLB.attributedText = attributedString;
        [addressLB sizeToFit];
        [self.headerView addSubview:addressLB];
        self.tv.tableHeaderView =  self.headerView;

    }else{
        self.headerView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 186)];
        self.headerView.backgroundColor = [UIColor whiteColor];
        UIImageView * wuliuImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 20, 15, 11) imageName:@"personal center_23"];
        [self.headerView addSubview:wuliuImageV];
        UILabel * wuliuLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 15, SW-40-UNIT_WIDTH(45), 40) text:@"的覅股东和歌词万人空车位都好看if辜负而福尔一胡覅和违反计划股护肤话文化" textColor:RGB(32,179,169,1) font:[UIFont systemFontOfSize:14]];
        wuliuLB.numberOfLines = 0;
        [self.headerView addSubview:wuliuLB];
        UILabel * timeLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 60, 130, 13) text:_groupDic[@"addTime"] textColor:RGB(32,179,169,1) font:[UIFont systemFontOfSize:11]];
        [self.headerView addSubview:timeLB];
        UIImageView * arrowImageV = [FactoryUI createImageViewWithFrame:CGRectMake(SW-18-8, 42, 8, 15) imageName:@"order_right arrow"];
        [self.headerView addSubview:arrowImageV];
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, SW, 88) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"" target:self selector:@selector(wuliuBtn)];
        btn.backgroundColor = [UIColor clearColor];
        [self.headerView addSubview:btn];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(15, 89, SW-15, 1)];
        line.backgroundColor = RGB(236, 235, 235, 1);
        [self.headerView addSubview:line];
        UIImageView * iconImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 108, 16, 16) imageName:@"order_consignee2"];
        [self.headerView addSubview:iconImageV];
        UILabel * nameLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 108, 187, 14) text:_groupDic[@"addr"][@"trueName"] textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        [self.headerView addSubview:nameLB];
        UILabel * phoneLB = [FactoryUI createLabelWithFrame:CGRectMake(SW-90-15, 108, 90, 14) text:_groupDic[@"addr"][@"mobile"] textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        [self.headerView addSubview:phoneLB];
        UIImageView * addressImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 134, 16, 16) imageName:@"order_address2"];
        [self.headerView addSubview:addressImageV];
        UILabel * addressLB = [FactoryUI createLabelWithFrame:CGRectMake(40, 132, SW-55, 40) text:_addrStr textColor:RGB(71,71,71,1) font:[UIFont systemFontOfSize:14]];
        addressLB.numberOfLines = 0;
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_addrStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_addrStr length])];
        addressLB.attributedText = attributedString;
        [addressLB sizeToFit];
        [self.headerView addSubview:addressLB];
        self.tv.tableHeaderView =  self.headerView;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_groupDic[@"order_status"] stringValue]isEqualToString:@"10"]) {
        return 105;
    }else{
        return 141;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[_groupDic[@"order_status"] stringValue]isEqualToString:@"10"]) {
        MyOderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = _dataArr[indexPath.row];
        cell.deslabel.text = dic[@"goods"][@"goods_name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
        cell.sizeLabel.text = dic[@"spec_info"];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",dic[@"count"]];
        NSString * str = dic[@"goods"][@"goods_main_photo_path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;
    }else{
        OderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OderCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = _dataArr[indexPath.row];
        cell.descLb.text = dic[@"goods"][@"goods_name"];
        cell.priceLb.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
        cell.sizeLb.text = dic[@"spec_info"];
        cell.countLb.text = [NSString stringWithFormat:@"x%@",dic[@"count"]];
        NSString * str = dic[@"goods"][@"goods_main_photo_path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGB(236, 235, 235, 1);
    UIView * contentView = [FactoryUI createViewWithFrame:CGRectMake(0, 10, SW, 45)];
    contentView.backgroundColor = RGB(249, 249, 249, 1);
    UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 15, 14, 14) imageName:@""];
    NSString * str = _groupDic[@"store"][@"store_logo"][@"path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
    
    [contentView addSubview:imageV];
    NSString * store_name = _groupDic[@"store"][@"store_name"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGFloat length = [store_name boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(35, 17, length, 12) text:store_name textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
       [contentView addSubview:label];
    UIImageView *jiantou = [FactoryUI createImageViewWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+4, 18, 10, 10) imageName:@"greyleftarrow"];
    [contentView addSubview:jiantou];
    [headerView addSubview:contentView];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = RGB(236, 235, 235, 1);
    return footerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController * detailVC = [[DetailViewController alloc]init];
    [detailVC loadDataWithID:_dataArr[indexPath.section][@"goods"][@"id"]];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//查看物流
-(void)wuliuBtn{
    CheckLogViewController * checkVC = [[CheckLogViewController alloc]init];
    checkVC.checkID = _groupDic[@"id"];
    [self.navigationController pushViewController:checkVC animated:YES];
}
#pragma mark ----------------------请求数据
-(void)loadData{

    NSNumber * numID = [NSNumber numberWithInteger:_selectID];
    NSDictionary * dic = @{@"of_id":numID};
    [RequestTools posUserWithURL:@"/order_details.mob" params:dic success:^(NSDictionary *Dict) {
        NSLog(@"----------------%@",Dict);
        _groupDic = [Dict objectForKey:@"order_details"];
        _dataArr = [NSMutableArray array];
        _dataArr = [Dict[@"order_details"][@"gcs"]mutableCopy];
        NSLog(@"%@",_groupDic[@"order_status"]);
        NSDictionary * addrDic = _groupDic[@"addr"];
        _str1 = addrDic[@"area"][@"parent"][@"parent"][@"areaName"];
        _str2 = addrDic[@"area"][@"parent"][@"areaName"];
        _str3 = addrDic[@"area"][@"areaName"];
        _str4 = addrDic[@"area_info"];
        _addrStr = [NSString stringWithFormat:@"%@%@%@%@",_str1,_str2,_str3,_str4];
        [self createheaderView];
        [self createFooterView];
        [self.tv reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}


-(void)createNav{

    self.navigationItem.title = @"订单详情";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(disBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBtnItem, nil];
}
- (void)disBackClick{
    
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
