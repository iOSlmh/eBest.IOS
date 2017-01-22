//
//  PayViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/25.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "PayViewController.h"
#import "PayViewCell.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
//#import "WXApiRequestHandler.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tv;

@end

@implementation PayViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self createTV];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tv registerClass:[PayViewCell class] forCellReuseIdentifier:@"payID"];
    [self.view addSubview:self.tv];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 85;
    }else{
        return 40;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 3;
    }else {
        return 4;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else if (section==1){
        return 1;
    }else{
        return 235;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footerView = [[UIView alloc]init];
//    footerView.backgroundColor = RGB(244, 244, 244, 1);
    
    if (section==2) {
        UIView * footerView = [[UIView alloc]init];
        footerView.backgroundColor = RGB(244, 244, 244, 1);
        UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(148, 30, 78, 13) text:@"选择支付方式" textColor:RGB(123,123,123,1) font:[UIFont systemFontOfSize:13]];
        [footerView addSubview:lb];
    
        UIButton * zfbBtn = [FactoryUI createButtonWithFrame:CGRectMake(117, 58, 45, 45) title:@"" titleColor:nil imageName:@"jshop_share_icon_weibo" backgroundImageName:@"" target:self selector:@selector(zfbClick)];
        [footerView addSubview:zfbBtn];
        UILabel * zfbLb = [FactoryUI createLabelWithFrame:CGRectMake(117, 68+45, 45, 13) text:@"支付宝" textColor:RGB(71 ,71 ,71 ,1) font:[UIFont systemFontOfSize:13]];
        zfbLb.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:zfbLb];
        
        UIButton * weichatBtn = [FactoryUI createButtonWithFrame:CGRectMake(zfbBtn.frame.origin.x+50+45, 58, 45, 45) title:@"" titleColor:nil imageName:@"jshop_share_icon_wechat" backgroundImageName:@"" target:self selector:@selector(weichatClick)];
        [footerView addSubview:weichatBtn];
        UILabel * weiLb = [FactoryUI createLabelWithFrame:CGRectMake(zfbBtn.frame.origin.x+50+45, 68+45, 45, 13) text:@"微信" textColor:RGB(71 ,71 ,71 ,1) font:[UIFont systemFontOfSize:13]];
          weiLb.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:weiLb];

        return footerView;
    }
    
    return nil;
}
//支付宝支付
-(void)zfbClick{
    
    
    
    
    NSString *partner = @"2088611922925773";
    NSString *seller = @"esok@esok.cn";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANfEOGuHDyStqzetu37gO0Lxy9ucCVpT3t7oao/oYHyeQIhI4sxu7dnTbSdsR3DKglHg+9sNbIvubxxeLPvfjrF/Lvky0sYIGBRYyQXQb+kwOq0dwqHGvqN4FP1EwI69CfQP/a2J/z4D0stF/htv4B24dxag7mxZIKLJJvwstUbnAgMBAAECgYEAtVsDhTXPP6gNqs4HM3xrszgjfiIoJlkqkjfOIclTGEu3uBVzNBvlJdq0+5bicWZ1pTay2ors+qzdjX2G1+ovN2x9ZIZyVDL0P1CqgzwEu7hCIC5I/hlcMIux+h0U93stRxeimdCcbj2hCfzewE77hP4GQ6F4llzgDtvm9X41CYkCQQDy+63bcv7huWydUOuN7ObhOTAjoAe5SxJL89UkFkMGwJYqUm2cRNAkaJ3OPBBBXEeDpBjh323L6g0pUnM6q32lAkEA41NJY+GAXVUAWnAKNJHfXEi3XopnStsPRRL6gRCqTcceWEicq6CtyHEIxJuldiG0AP2u+Fh5faWx4phXKFEkmwJAFdGt2f/ojWJ2M2Y50MPOM7lL7lcHeocYPIPHxvbMzAVtNp2yRA8V1b8jNIrGNuhPb63DojzLAj2hMu25dTJDFQJAFi24CVCk73YtlKU9uadJvX0ytryWG02IDdsuKY1wsCnvIfnjnzMMAXRVwKjW2dGr+DTH717ia4nQ8ySdzEcuZQJAf1aGvpNuRP9Sf043ymPbhBVEb2bji6ltOr9R1VpCuaojP/EAYEAanzHLvcG+kc0QAk57+7hWp3smNQu+aYt1oQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
    
    /*
     *生成订单信息及签名
     */
    CGFloat  str = 0.1;
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"jgd"; //商品标题
    order.productDescription = @"udih"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",str]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

    
    
}
/**
 *  产生随机订单号
 *
 *  @return 订单号字符串
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//微信支付
-(void)weichatClick{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"Mobile_num":@"",@"Password":@""}];
    [RequestTools postWithURL:@"/user_login.mob" params:dict success:^(NSDictionary *Dict) {
        
//        int status=[[Dict objectForKey:@"status"] intValue];
//        
//        NSDictionary *backDict=[Dict objectForKey:@"data"];
//        if (status==200) {
//            
//            NSString *req = [WXApiRequestHandler jumpToBizPay:backDict];
//            if([@"YES" isEqual:req] ){//调起微信支付成功
//                
//            }
//        }

        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"登录状态" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"欢迎来到臻玉网", nil];
        [alert show];
        NSLog(@"登录成功");
        NSLog(@"%@",Dict);
    } failure:^(NSError *error) {
        //        NSLog(@"%@",error);
    }];

    
    
    
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payID"];
    if (indexPath.section==0) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(123, 123, 123, 1);
        cell.textLabel.text = @"支付金额：";
    }else if (indexPath.section==1){
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGB(123, 123, 123, 1);
        if (indexPath.row==0){
            cell.textLabel.text = @"收货人：";
            
        }else if (indexPath.row==1){
            cell.textLabel.text = @"联系电话：";
            
        }else if (indexPath.row==2){
            cell.textLabel.text = @"收货地址：";
        }
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGB(123, 123, 123, 1);
        if (indexPath.row==0){
            cell.textLabel.text = @"商品名称：";
            
        }else if (indexPath.row==1){
            cell.textLabel.text = @"商品规格：";
            
        }else if (indexPath.row==2){
            cell.textLabel.text = @"店铺名称：";
        }else if (indexPath.row==3){
            cell.textLabel.text = @"订单编号：";
        }

    }
    return cell;
    
    
}
//设置导航
-(void)setNav{
    
    self.title = @"支付方式选择";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}
//设置返回按钮点击事件
-(void)backClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
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
