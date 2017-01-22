//
//  OrderViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/22.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderXibCell.h"
#import "OrderSysCell.h"
#import "PayViewController.h"
#import "ShoppingCartViewController.h"
#import "AddressViewController.h"
#import "ShoppingCarGroupModel.h"
#import "ShoppingCarModel.h"
#import "LoginViewController.h"
#import "MyOderViewController.h"
#import "OderDetailViewController.h"
#import "HomeViewController.h"
#import "CCPMultipleChoiceView.h"
#import "CCPActionSheetView.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <CommonCrypto/CommonDigest.h>
//231399

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,OderViewToPayDelegate,OderDetailToPayDelegate,UITextFieldDelegate>
{

    UILabel * _lb;
    CGFloat _postPrice;
}

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) NSMutableArray * addressDataArr;
@property(nonatomic,strong) UIView * tableHeaderView;
@property(nonatomic,strong) NSMutableArray * groupArr;
@property(nonatomic,copy) NSString * getStr;
@property(nonatomic,copy) NSMutableArray * goodsCarArr;
@property(nonatomic,strong) UIView * grayView;
@property(nonatomic,strong) UIView * selectView;
@property(nonatomic,strong) UIButton   *button;
@property(nonatomic,strong) UITextField * textFiled;
//支付参数
//@property (nonatomic,copy) NSString * partner;
//@property (nonatomic,copy) NSString * privateKey;
//第二次上传订单信息（批次号、产品描述、总价格）
@property(nonatomic,copy) NSString * oderDesc;
@property(nonatomic,copy) NSString * oderNumber;
@property(nonatomic,copy) NSString * oderPrice;
//服务器返回数据字典
@property(nonatomic,strong) NSDictionary * payDic;
//支付选择按钮
@property(nonatomic,strong) UIButton * wxBtn;
@property(nonatomic,strong) UIButton * zfbBtn;
//地址字符串
@property(nonatomic,copy) NSString * addrStr;
@property(nonatomic,copy) NSString * trueName;
@property(nonatomic,copy) NSString * mobile;
@property(nonatomic,copy) NSString * addrID;
@property(nonatomic,copy) NSString * reqState;

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
 self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(226, 226, 226, 1);
    _addressDataArr = [NSMutableArray array];
    [self setNav];
    [self createTV];
    [self createData];
    [self loadAddress];
    [self createBottomBtn];
    //更新地址观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddress) name:@"refreshAddr" object:nil];
}

-(void)reloadAddress{

    [self loadAddress];
}

-(void)loadAddress{

    [RequestTools getUserWithURL:@"/default_address.mob" params:nil success:^(NSDictionary *Dict) {
        
        _reqState = Dict[@"return_info"][@"errFlg"];
        if ([_reqState boolValue]) {
            
            self.tv.tableHeaderView = [self createTableheaderView];
            
        }else{
            
            NSDictionary * dic = Dict[@"def_addr"];
            NSString * str1 = dic[@"area"][@"areaName"];
            NSString * str2 = dic[@"area"][@"parent"][@"areaName"];
            NSString * str3 = dic[@"area"][@"parent"][@"parent"][@"areaName"];
            NSString * str4 = [dic objectForKey:@"area_info"];
            _addrStr = [NSString stringWithFormat:@"%@%@%@%@",str3,str2,str1,str4];
            _trueName = [dic objectForKey:@"trueName"];
            _mobile = [dic objectForKey:@"mobile"];
            _addrID = [dic objectForKey:@"id"];
            self.tv.tableHeaderView = [self createTableheaderView];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)createData{
    
    // 立即购买的订单
    if (self.dataArray.count == 0) {
        //初始化数组
        _groupArr = [NSMutableArray array];
        NSLog(@"----------------%@",self.IDString);
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"goods_cart_ids":self.IDString}];
        [RequestTools posUserWithURL:@"/order_confirm.mob" params:dict success:^(NSDictionary *Dict) {
            
            _groupArr = [Dict objectForKey:@"confirm_order"];
            _lb.text = [NSString stringWithFormat:@"实付:¥%.2f",[Dict[@"order_total_price"]floatValue]] ;
            
            [self.tv reloadData];

        } failure:^(NSError *error) {
                             
        }];
        
    }else{
        //购物车提交的订单
        //get数组参数拼接
        NSString * canshu = @"goods_cart_ids";
        NSLog(@"----------------%lu",(unsigned long)self.dataArray.count);
        NSMutableArray * muarr = [NSMutableArray array];
        for (int i = 0; i<_dataArray.count; i++) {
            NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,_dataArray[i]];
            NSLog(@"%@",appStr);
            [muarr addObject:appStr];
        }
        NSString *appString = [muarr componentsJoinedByString:@"&"];
        NSString * astr = @"/order_confirm.mob?";
        _getStr = [NSString stringWithFormat:@"%@%@",astr,appString];
        NSLog(@"最终的字符串是 %@",_getStr);
        //初始化数组
        _groupArr = [NSMutableArray array];
        //订单数据请求
        [RequestTools getUserWithURL:_getStr params:nil success:^(NSDictionary *Dict) {
            
            _groupArr = [Dict objectForKey:@"confirm_order"];
            _lb.text = [NSString stringWithFormat:@"实付:¥%.2f",[Dict[@"order_total_price"]floatValue]] ;
                
            [self.tv reloadData];
        } failure:^(NSError *error) {
                
        }];
    }
}

//创建底部view
-(void)createBottomBtn{
    
    UIView * bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, SH-112, SW, 48)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel * topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SW, 1)];
    [bottomView addSubview:topLine];
    topLine.backgroundColor = RGB(245, 245, 245, 1);
    _lb = [FactoryUI createLabelWithFrame:CGRectMake(SW-285, 13.5, 150, 21) text:[NSString stringWithFormat:@"实付:¥%.2f",_allPrice] textColor:RGB(26, 83, 84, 1) font:[UIFont systemFontOfSize:14]];
    _lb.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_lb];
    UIButton * buyButton = [FactoryUI createButtonWithFrame:CGRectMake(0.7*SW, 0, 0.3*SW, 48) title:@"提交订单" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(submitOrder)];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    buyButton.backgroundColor = RGB(32, 179, 169, 1);
    [bottomView addSubview:buyButton];

}

// 提交订单
-(void)submitOrder{
    
    if (_addrID) {//判断有无收货地址
        
        //判断有无订单信息参数
        if (kIsEmptyArray(self.dataArray)||!kIsEmptyString(self.IDString)) {
            
             //判断订单类型
            if (self.dataArray.count>0) {//购物车订单
                
                //get数组参数拼接
                NSString * canshu = @"goods_cart_ids";
                NSLog(@"%lu",(unsigned long)self.dataArray[0]);
                NSMutableArray * muarr = [NSMutableArray array];
                NSLog(@"%lu",(unsigned long)_dataArray.count);
                for (int i = 0; i<_dataArray.count; i++) {
                    NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,_dataArray[i]];
                    NSLog(@"%@",appStr);
                    [muarr addObject:appStr];
                }
                NSString *appString = [muarr componentsJoinedByString:@"&"];
                NSString * astr = @"/order_submit.mob?";
                NSString * str1 = @"addr_id";
                NSString * str2 = _addrID;
                _getStr = [NSString stringWithFormat:@"%@%@&%@=%@",astr,appString,str1,str2];
                NSLog(@"最终的字符串是 %@",_getStr);
                
            }else{//立即购买订单
                
                NSString * canshu = @"goods_cart_ids";
                NSString * astr = @"/order_submit.mob?";
                NSString * str1 = @"addr_id";
                NSString * str2 = _addrID;
                _getStr = [NSString stringWithFormat:@"%@%@=%@&%@=%@",astr,canshu,_IDString,str1,str2];
                
            }
            //订单数据请求
            [RequestTools posUserWithURL:_getStr params:nil success:^(NSDictionary *Dict) {
                
                NSLog(@"----------------%@",Dict);
                //返回信息修改  不是errorFlog
                if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                    
                    _oderNumber = [[Dict[@"order_list"]firstObject]objectForKey:@"paymentBatchNo" ];
                    _oderPrice = [[[Dict[@"order_list"]firstObject]objectForKey:@"totalPrice"] stringValue];
                    //        [self.tv reloadData];  //reload之后订单刷新
                    [self createSelectView];
                    [self reqOderNum];
                
                }else{
                
                    [AlertShow showAlert:@"该订单已经提交过，请到买家中心继续付款!"];
                     [self performSelector:@selector(delayMethod) withObject:nil afterDelay:4.0f];
                   
                }
                
            } failure:^(NSError *error) {
                NSLog(@"----------------%@",error);
            }];

        }else{
        
            NSLog(@"----------------订单错误----------------");
        }
        
    }else{
    
        [MyHUD showAllTextDialogWith:@"请添加收货地址!" showView:BaseView];
    }
    
}
-(void)delayMethod{

    MyOderViewController * myOderVC = [[MyOderViewController alloc]init];
    myOderVC.statePage=1;
    [self.navigationController pushViewController:myOderVC animated:YES];

}
-(void)reqOderNum{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"out_trade_no":self.oderNumber,@"subject":@"臻玉堂",@"total_fee":self.oderPrice}];
    NSLog(@"----------------%@",self.oderNumber);
    [RequestTools posUserWithURL:@"/alipay_app.mob" params:dict success:^(NSDictionary *Dict) {
        
        _payDic = Dict;
//        _partner = _payDic[@"alipay_info"][@"partner"];
//        _privateKey = _payDic[@"alipay_info"][@"private_key"];
        
        NSLog(@"----------------%@",_payDic[@"alipay_info"][@"notify_url"]);
 
    } failure:^(NSError *error) {
        NSLog(@"----------------%@",error);
    }];

}
#pragma mark ----------------------oderToPay代理
-(void)oderToPay:(NSString *)oderPayID{

    [self zfbClick:oderPayID];

}
#pragma mark ----------------------oderDetailToPay代理
-(void)oderDetailToPay:(NSString *)oderPayID{

    [self zfbClick:oderPayID];

}
//创建支付界面
-(void)createSelectView{
    
    [self createGraview];
    self.selectView = [FactoryUI createViewWithFrame:CGRectMake(0, 0.44*SH-64, SW, 0.56*SH)];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    UIButton * cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 15, 18, 18) title:@"" titleColor:nil imageName:@"shopping_close" backgroundImageName:@"" target:self selector:@selector(cancelClickBtn)];
    [self.selectView addSubview:cancelBtn];
    // ********************************************************
    
    UILabel * selectTitle = [FactoryUI createLabelWithFrame:CGRectMake((SW-60)/2, 15, 70, 13) text:@"支付方式" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:15]];
    [self.selectView addSubview:selectTitle];

    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SW, 1)];
    line1.backgroundColor = RGB(236, 235, 235, 1);
    [self.selectView addSubview:line1];
    UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SW, 1)];
    line2.backgroundColor = RGB(236, 235, 235, 1);
    [self.selectView addSubview:line2];
    
    UIImageView * wxImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 23+45, 25, 25) imageName:@"order_payment_zfb"];
    [self.selectView addSubview:wxImageV];
    UIImageView * zfbImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 68+45, 25, 25) imageName:@"order_payment_wx"];
    [self.selectView addSubview:zfbImageV];
    _zfbBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-35, 23+45, 20, 20) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"shopping_default" target:self selector:@selector(wxSelect:)];
    _zfbBtn.tag =100;
    [self.selectView addSubview:_zfbBtn];
    _wxBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-35, 68+45, 20, 20) title:@"" titleColor:nil imageName:@"" backgroundImageName:@"shopping_default" target:self selector:@selector(wxSelect:)];
    _wxBtn.tag =101;
    [self.selectView addSubview:_wxBtn];
    UILabel * payLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, line2.frame.origin.y+20, 54, 13) text:@"需付款" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:16]];
    [self.selectView addSubview:payLabel];
    UILabel * priceLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-150, line2.frame.origin.y+20, 135, 25) text:[NSString stringWithFormat:@"¥%.2f",_allPrice] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:25]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.selectView addSubview:priceLabel];
    UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(15, self.selectView.frame.size.height-64, SW-30, 40) title:@"确认支付" titleColor:RGB(255, 255, 255, 1) imageName:nil backgroundImageName:nil target:self selector:@selector(confirmPayClick)];
    btn.backgroundColor = RGB(42, 150, 143, 1);
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    [self.selectView addSubview:btn];

    
}

//确认按钮
-(void)confirmPayClick{
    
    if (_wxBtn.selected) {
        NSLog(@"微信支付");
        NSString * strID = _payDic[@"alipay_info"][@"out_trade_no"];
        NSNumber * priceNum = _payDic[@"alipay_info"][@"total_fee"];
        NSLog(@"----------------%@",priceNum);
        NSLog(@"----------------%@",strID);
        //读取用户信息
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *key= [user objectForKey:k_Key];
        NSString *user_id = [user objectForKey:k_user];
        NSLog(@"==========%@",key);
        NSLog(@"==========%@",user_id);
        NSDictionary * dic = @{@"payment_batch_no":strID,@"total_price":priceNum};
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@_%@",user_id,key]forHTTPHeaderField:@"authorization"];
        [manager POST:@"http://www.jade-town.com/mobile/wechat_pay.mob" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"----------------%@",responseObject);
            NSLog(@"----------------%@",responseObject[@"return_info"][@"message"]);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"----------------%@",error);
        }];
        
        
    }else{
        NSLog(@"支付宝支付");
        NSString * strID = _payDic[@"alipay_info"][@"out_trade_no"];
        [self zfbClick:strID];
    }
    
}

//#pragma mark ----------------------微信支付
//- (void)weixinChooseAct {
//    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
//    //应用APPID
//    appid = @"wx46d95a358f1302a0";
//    //微信支付商户号
//    mch_id = @"";
//    //产生随机字符串，这里最好使用和安卓端一致的生成逻辑
//    nonce_str =[self generateTradeNO];
//    body =@"臻玉网";
//    //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
//    out_trade_no = _payDic[@"alipay_info"][@"out_trade_no"];
//    //交易价格1表示0.01元，10表示0.1元
//    total_fee = _payDic[@"alipay_info"][@"total_fee"];;
//    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
//    spbill_create_ip =[getIPhoneIP getIPAddress];
//    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
//    notify_url =@"www.cccuu.com";
//    trade_type =@"APP";
//    //商户密钥
//    partner = @"676a2c159f1810be7e33ddf0c2397a89";
//    //获取sign签名
//    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
//    sign = [data getSignForMD5];
//    //设置参数并转化成xml格式
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:appid forKey:@"appid"];//公众账号ID
//    [dic setValue:mch_id forKey:@"mch_id"];//商户号
//    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
//    [dic setValue:sign forKey:@"sign"];//签名
//    [dic setValue:body forKey:@"body"];//商品描述
//    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
//    [dic setValue:total_fee forKey:@"total_fee"];//金额
//    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
//    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
//    [dic setValue:trade_type forKey:@"trade_type"];//交易类型
//    // 转换成xml字符串
//    NSString *string = [dic XMLString];
//    [self http:string];
//}
//
////- ( NSString *)md5String:( NSString *)str
////
////{
////    
////    const char *myPasswd = [str UTF8String ];
////    
////    unsigned char mdc[ 16 ];
////    
////    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
////    
////    NSMutableString *md5String = [ NSMutableString string ];
////    
////    for ( int i = 0 ; i< 16 ; i++) {
////        
////        [md5String appendFormat : @"%02x" ,mdc[i]];
////        
////    }
////    
////    return md5String;
////    
////}
//#pragma mark - 拿到转换好的xml发送请求
//- (void)http:(NSString *)xml {
////    [MBProgressHUD showMessage:@"正在获取支付订单..."];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        return xml;
//    }];
//    //发起请求
//    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
//        // LXLog(@"responseString is %@",responseString);
//        //将微信返回的xml数据解析转义成字典
//        NSDictionary *dic = [NSDictionary  dictionaryWithXMLString:responseString];
//        //判断返回的许可
//        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
//            //发起微信支付，设置参数
//            PayReq *request = [[PayReq alloc] init];
//            request.openID = [dic objectForKey:@"appid"];
//            request.partnerId = [dic objectForKey:@"mch_id"];
//            request.prepayId= [dic objectForKey:@"prepay_id"];
//            request.package = @"Sign=WXPay";
//            request.nonceStr= [dic objectForKey:@"nonce_str"];
//            //将当前事件转化成时间戳
//            NSDate *datenow = [NSDate date];
//            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//            UInt32 timeStamp =[timeSp intValue];
//            request.timeStamp= timeStamp;
//            // 签名加密
//            DataMD5 *md5 = [[DataMD5 alloc] init];
//            request.sign=[md5 createMD5SingForPay:request.openID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
//            // 调用微信
//            [WXApi sendReq:request];
//            [MBProgressHUD hideHUD];
//        }else{
//            LXLog(@"参数不正确，请检查参数");
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"支付错误！"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        LXLog(@"error is %@",error);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"未完成支付"];
//    }];
//}
//
//#pragma mark - 产生随机订单号
//- (NSString *)generateTradeNO {
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand(time(0)); // 此行代码有警告:
//    for (int i = 0; i < kNumber; i++) {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
//
//



//支付宝支付
-(void)zfbClick:(NSString *)oderID{
    
    NSString *partner = @"2088021754795279";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMmZDis8uW3vmXgnOhVTGEw1pI6VaFeADyEzPY48HzBEIQJeiimooLIH+Gv5qSDc2ywdfj+vHgjj0ROqjaQfikFd6A8Or49tYAvJ0tOsfOUyA688qer1KRgcHQW1eIuNVyS7dyNXNjKnW84NEsGM6GDEtMVIAnjuNQEYl0/O8SjfAgMBAAECgYAD4cyiDINNmKWN6MN3kagQH6BRlpLxzGd+LixrRsEa/tTb5NIoRzUA+KJSAfa9yUL3MIIz271qUmi+RjSACpNw8gVktAaYkwg+ELw06Neag4h0i1Ij65brRRzt3UQs0Jp7Qei94CcrPndttroNd9oY4uycW8NMyIp6cnLj4ibywQJBAPWL0N3woPX+pSF2v0KfJVVTG3/lojD7n/i7HWu7fJBy9aR8xkMgKi64dor/taq0Tr7nUvuOEhAAjAH324m/go8CQQDSLkBWNn4pUcL1y1Cmni8zUGjHLRwxjDrexyKrgWdGD59kD+jdgnqMYZS88vTHG/voSbzfY6g4A/pgmH1j29yxAkEA9F+aF8gL6cbtAUj1QJCyzyBPFhKsQKOsqhdPSJDnf7tpzbKAfv3b/XOIRv4HB0U7ubLvW3whbdude7f5vjXi8QJAEXjW0FPnWPf7BQPJyJANzG46x5PwbA4ENtDHCQrQ0vopfd/0s7VNCq5x9uMbhhHFdyHqGYfnTADIp48FnW+BgQJAYlzzCnR3U10Ao5lTL0WurKr3zq30KwdHGoz60Jf8LvEM/GjQaX+XujO654tLIiuCZH4mHH16LvoIJvabpypcyw==";
    NSString *seller = @"zhenyuwang@ebestlo.com";
    //partner和seller获取失败,提示
    
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少partner或者seller或者私钥。"delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];

    }
    
    /*
     *生成订单信息及签名
     */
    CGFloat  str = 0.01;
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = oderID; //订单ID（由商家自行制定）
    order.productName = @"臻玉网"; //商品标题
    order.productDescription = _payDic[@"alipay_info"][@"body"]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",str]; //商品价格
    order.notifyURL =  _payDic[@"alipay_info"][@"notify_url"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"aliebest";
    
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
            
            
            if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
                
            }
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
//选择按钮
-(void)wxSelect:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if ([btn isEqual:_wxBtn]) {
        [_wxBtn setBackgroundImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
        [_zfbBtn setBackgroundImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
        _wxBtn.selected = YES;
    }else {
        [_zfbBtn setBackgroundImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
        [_wxBtn setBackgroundImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
        _zfbBtn.selected = YES;
    }

//    btn.selected = (!btn.selected);
//    if (btn.selected) {
//        [btn setBackgroundImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
//    }else{
//    
//        [btn setBackgroundImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
//    }
    
//    // 状态切换
//    if (btn != self.button) {
//        self.button.selected = NO;
//        self.button = btn;
//        [self.button setBackgroundImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
//    }
//    [self.button setBackgroundImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
//    self.button.selected = YES;
}
//确认按钮
-(void)confirmClick{

    OrderViewController * orderVC = [[OrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    [self.selectView removeFromSuperview];
    [self.grayView removeFromSuperview];
    
}
//取消按钮
-(void)cancelClickBtn{
    [self.selectView removeFromSuperview];
    [self.grayView removeFromSuperview];
    
}
//调出规格窗口并创建灰色遮布
-(void)createGraview{
    self.grayView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, SH)];
    self.grayView.backgroundColor = [UIColor grayColor];
    self.grayView.alpha = 0.6;
    self.grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapMiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMissClick)];
    [self.grayView addGestureRecognizer:tapMiss];
    [self.view addSubview:self.grayView];
}
//遮布点击事件
-(void)tapMissClick{
    
    [self.selectView removeFromSuperview];
    [self.grayView removeFromSuperview];

}
#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, SW, SH-48-64)style:UITableViewStyleGrouped];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.showsVerticalScrollIndicator = NO;
    [self.tv registerClass:[OrderSysCell class] forCellReuseIdentifier:@"sysID"];
    [self.tv registerNib:[UINib nibWithNibName:@"OrderXibCell" bundle:nil] forCellReuseIdentifier:@"nibID"];
    [self.view addSubview:self.tv];
}
//创建tableView的headerView
-(UIView *)createTableheaderView{

    if ([_reqState boolValue]) {
        
        self.tableHeaderView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 50)];
        UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 18, 15, 15) imageName:@"order_address1"];
        [self.tableHeaderView addSubview:imageV];
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(35, 18, 98, 13) text:@"请添加收货地址" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        [self.tableHeaderView addSubview:label];
        UIButton * coverBtn = [FactoryUI createButtonWithFrame:self.tableHeaderView.bounds title:@"" titleColor:[UIColor clearColor] imageName:@"" backgroundImageName:@"" target:self selector:@selector(coverBtnClick)];
        [self.tableHeaderView addSubview:coverBtn];
        return self.tableHeaderView;
        
    }else{

        self.tableHeaderView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 102)];
        UIImageView * imageV1 = [FactoryUI createImageViewWithFrame:CGRectMake(15, 20, 15, 15) imageName:@"order_consignee1"];
        [self.tableHeaderView addSubview:imageV1];
        UIImageView * imageV2 = [FactoryUI createImageViewWithFrame:CGRectMake(15, 44, 15, 15) imageName:@"order_address1"];
        [self.tableHeaderView addSubview:imageV2];
        UILabel * nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(35, 20, 98, 13) text:[NSString stringWithFormat:@"收货人：%@",_trueName] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        [self.tableHeaderView addSubview:nameLabel];
        UILabel * mobileLabel = [FactoryUI createLabelWithFrame:CGRectMake(SW-65-92, 20, 98, 13) text:_mobile textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        [self.tableHeaderView addSubview:mobileLabel];
        UILabel * addressLabel = [FactoryUI createLabelWithFrame:CGRectMake(35, 44, SW-65, 40) text:[NSString stringWithFormat:@"收货地址：%@",_addrStr] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
        addressLabel.numberOfLines = 0;
        [addressLabel sizeToFit];
        [self.tableHeaderView addSubview:addressLabel];
        UIButton * coverBtn = [FactoryUI createButtonWithFrame:self.tableHeaderView.bounds title:@"" titleColor:[UIColor clearColor] imageName:@"" backgroundImageName:@"" target:self selector:@selector(coverBtnClick)];
        [self.tableHeaderView addSubview:coverBtn];
        return self.tableHeaderView;

    }
}

-(void)coverBtnClick{

    AddressViewController * addressVC = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:addressVC animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"当前组数------------------%lu",(unsigned long)_groupArr.count);
    return _groupArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * countArr = _groupArr[section][@"gcs"];
    NSLog(@"当前行数----------------%lu",(unsigned long)countArr.count);
    return countArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 45;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGB(249, 249, 249, 1);
    UIImageView * imageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 18, 15, 15) imageName:@"order_shop"];
    [headerView addSubview:imageV];
    NSString * store_name = _groupArr[section][@"store"][@"store_name"];
    UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(35, 18, 98, 15) text:store_name textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
    [headerView addSubview:label];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 260;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = RGB(255, 255, 255, 1);
    NSArray * titleArr = @[@"配送方式",@"优惠券",@"总计"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(15, 15+i*50, 60, 20) text:titleArr[i] textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:14]];
        [footerView addSubview:label];
        
    }
    
    UILabel * mailLb = [FactoryUI createLabelWithFrame:CGRectMake(SW-14-28, 15, 30, 20) text:@"免邮" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:14]];
    [footerView addSubview:mailLb];
    
    UIButton * discountBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-14-13, 65, 13, 20) title:@"" titleColor:RGB(71, 71, 71, 1) imageName:@"order_right arrow" backgroundImageName:@"" target:self selector:@selector(discountClick)];
    [footerView addSubview:discountBtn];
    
    UIButton * discountTipBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 65, SW, 50) title:@"" titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(discountClick)];
    [footerView addSubview:discountTipBtn];
    
    for (int i=0; i<titleArr.count-1; i++) {
        UILabel * line = [FactoryUI createLabelWithFrame:CGRectMake(15, 50*(i+1), SW-15, 1) text:@"" textColor:RGB(68, 63, 91, 1) font:[UIFont systemFontOfSize:14]];
        line.backgroundColor = RGB(236, 235, 235, 1);
        [footerView addSubview:line];
        
    }
    
    NSArray * totalArr = @[[NSString stringWithFormat:@"总计：¥%.2f",[_groupArr[section][@"store_total_price"] floatValue]],@"保价费：¥0.00",@"优惠券：¥0.00",@"邮费：¥0.00"];
    for (int i=0; i<totalArr.count; i++) {
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(SW-110-14, 115+i*23, 130, 20) text:totalArr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:12]];
        label.textAlignment = NSTextAlignmentNatural;
        [footerView addSubview:label];
    }

    UILabel * liuyan = [FactoryUI createLabelWithFrame:CGRectMake(15, 225, 100, 20) text:@"给商家留言：" textColor:RGB(123, 123, 123, 1) font:[UIFont systemFontOfSize:14]];
    [footerView addSubview:liuyan];
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(115, 225, SW-130, 20)];
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.placeholder = @"请输入文字（30字以内）";
    _textFiled.font = [UIFont systemFontOfSize:14];
    _textFiled.delegate = self;
    [footerView addSubview:_textFiled];
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderXibCell * cell = [tableView dequeueReusableCellWithIdentifier:@"nibID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = _groupArr[indexPath.section][@"gcs"][indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic[@"count"]stringValue]];
    cell.currentPrice.text = [NSString stringWithFormat:@"¥%@",[dic[@"price"]stringValue]];
    cell.titleLabel.text = dic[@"goods"][@"goods_name"];
    cell.sizeLabel.text = dic[@"spec_info"];
    cell.originalPrice.text = [NSString stringWithFormat:@"¥%@.00",[dic[@"price"]stringValue]];
    UILabel * midLine = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.originalPrice.frame.size.height/2, cell.originalPrice.frame.size.width, 0.5)];
    midLine.backgroundColor = RGB(183, 183, 183, 1);
    [cell.originalPrice addSubview:midLine];
    
    NSString * str = dic[@"goods"][@"goods_main_photo_path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        AddressViewController * addressVC = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    CGFloat sectionHeaderHeight = 310;//设置你footer高度
//    
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        
//    }
    
//    UITableView *tableview = (UITableView *)scrollView;
//    CGFloat sectionHeaderHeight = 45;
//    CGFloat sectionFooterHeight = 100;
//    CGFloat offsetY = tableview.contentOffset.y;
//    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
//    {
//        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
//    {
//        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
//    {
//        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
//    }
    
}
-(void)discountClick{

//     __weak typeof(self) weakSelf = self;
    NSArray * dataArray = @[@"已选优惠券0元",@"双十一满减特惠满199减100",@"臻玉网商品特惠20元优惠券"];
    CCPMultipleChoiceView *ChoiceView = [[CCPMultipleChoiceView alloc] initWithDataArr:dataArray andClickSureBtnBlock:^(NSString *combinedString, NSArray *backArray) {
//        weakSelf.selectedContentLabel.text = combinedString;
        NSLog(@"%@",backArray);
        
    } andClickCancelBtnBlock:^{
        
        
    }];

    //已经选中的选项数组
    ChoiceView.selectedArray = @[@"0"];
}
//点击return 按钮取消第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//键盘遮挡处理 向上偏移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    self.tv.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
    
    return YES;
}
//键盘遮挡处理 向下偏移复原
-(void)textFieldDidEndEditing:(UITextField *)textField{

   self.tv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置导航
-(void)setNav{
    
    self.title = @"提交订单";

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
-(void)backClick{
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
