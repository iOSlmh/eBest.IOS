//
//  LoginViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/18.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

//#define NOTIFICATION_WEIBO_LOGIN @"weiboLogin"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MineViewController.h"
#import "ThirdTieViewController.h"
#import "FindCodeViewController.h"
//QQ
#import <time.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>

#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface LoginViewController ()<UITextFieldDelegate,TencentSessionDelegate,TencentLoginDelegate,TencentApiInterfaceDelegate,QQApiInterfaceDelegate>

{
    TencentOAuth * tencentOAuth;
    NSArray * permissions;
    UILabel *resultLable;
    UILabel *tokenLable;

}
@property(nonatomic,strong) UIView * hiddenView;
@property(nonatomic,copy) NSString * OpenID;
@property(nonatomic,copy) NSString * NickName;
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接收微博登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wbLogPush:) name:@"wbLogin" object:nil];
    //接收微博登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLogPush:) name:@"wxLogin" object:nil];
    
    self.userName.layer.borderWidth = 1;
    self.userName.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    self.passWord.layer.borderWidth = 1;
    self.passWord.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    
    self.hiddenView = [FactoryUI createViewWithFrame:CGRectMake(64, 0, SW, 160)];
    self.hiddenView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapHidden = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHiddenClick)];
    [self.hiddenView addGestureRecognizer:tapHidden];
    [self.view addSubview:self.hiddenView];
    
    self.userName.returnKeyType = UIReturnKeyNext;
    self.userName.enablesReturnKeyAutomatically = YES;
    [self.userName setClearButtonMode:UITextFieldViewModeAlways];
    [self.userName setLeftViewMode:UITextFieldViewModeAlways];
    
    self.passWord.returnKeyType = UIReturnKeyDone;
    self.passWord.secureTextEntry = YES;
    self.passWord.enablesReturnKeyAutomatically = YES;
    [self.passWord setLeftViewMode:UITextFieldViewModeAlways];
}
/*
//新浪微博代理方法----获取openID和token后发送请求获取用户基本信息
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        NSString * userid = [(WBAuthorizeResponse *)response userID];
//        NSString * wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        NSString * oathString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",userid,wbtoken];
//        NSMutableString * msg = [NSMutableString string];
////        if (NO_VALUE(userid)) {
////            [msg setString:ALERT_WEIBO_LOGIN_ERROR];
////        }
//        NSDictionary* para = [NSDictionary dictionaryWithObjectsAndKeys:oathString,@"para",msg,@"msg",nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"weiboLogin"
// object:para];
//    }

    NSLog(@"%@",response);
    NSLog(@"%@",[(WBAuthorizeResponse *)response userID]);
    NSLog(@"%@",[(WBAuthorizeResponse *)response userInfo]);
    NSLog(@"%@",[(WBAuthorizeResponse *)response accessToken]);
    NSDictionary * dic = @{@"uid":[(WBAuthorizeResponse *)response userID],@"access_token":[(WBAuthorizeResponse *)response accessToken]};
    NSString * urlStr = @"https://api.weibo.com/2/users/show.json";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    

        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"screen_name"]);
        _OpenID = [(WBAuthorizeResponse *)response userID];
        _NickName = responseObject[@"screen_name"];
        ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
        thirdVC.wbOpenID = _OpenID;
        NSLog(@"%@",thirdVC.wbOpenID);
        thirdVC.wbNickName = _NickName;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:thirdVC animated:YES completion:nil];
//            [self.navigationController pushViewController:thirdVC animated:YES];

        });
//        ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
//        thirdVC.wbOpenID = _OpenID;
//        NSLog(@"%@",thirdVC.wbOpenID);
//        thirdVC.wbNickName = _NickName;
////        [self presentViewController:thirdNav animated:YES completion:nil];
//        [self.navigationController pushViewController:thirdVC animated:YES];
//        NSLog(@"%@",self);
//        NSLog(@"%@",self.navigationController);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
*/
-(void)tapHiddenClick{

    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

- (IBAction)backBtn:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)joinBtn:(UIButton *)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)loginBtn:(UIButton *)sender {
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",self.userName.text);
    [dict addEntriesFromDictionary:@{@"username":self.userName.text,@"password":self.passWord.text}];
    [RequestTools postWithURL:@"/user_login.mob" params:dict success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            NSLog(@"token是》》》》%@",ktoken);
            NSLog(@"user_id是》》》》%@",kuser_id);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:ktoken forKey:k_Key];
            [userDefaults setObject:kuser_id forKey:k_user];
            [userDefaults synchronize];
            [MyHUD showAllTextDialogWith:@"登陆成功!" showView:BaseView];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"登录状态" message:@"登陆失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"用户名或密码错误", nil];
            [alert show];
            NSLog(@"登录失败");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)delayMethod{

    [self.navigationController popToRootViewControllerAnimated:YES];
}
/***
 **QQ登录代理回调方法
 */
//登陆完调用
- (void)tencentDidLogin
{
     tencentOAuth.redirectURI = @"https://www.baidu.com";
    resultLable.text = @"登录完成";
    
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        tokenLable.text = tencentOAuth.accessToken;
        NSLog(@"%@",tencentOAuth.accessToken);
        NSLog(@"%@",tencentOAuth.openId);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //登陆成功后把用户名和密码存储到UserDefault
        [userDefaults setObject:tencentOAuth.openId forKey:k_qqOpenID];
        [userDefaults setObject:tencentOAuth.accessToken forKey:K_qqToken];
        [userDefaults synchronize];
        NSLog(@"*********%@",[userDefaults valueForKey:k_qqOpenID]);
        NSLog(@"*********%@",[userDefaults valueForKey:K_qqToken]);

//        ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
//        thirdVC.wbOpenID = tencentOAuth.openId;
//        thirdVC.wbToken = tencentOAuth.accessToken;
        
//        [self.navigationController pushViewController:thirdVC animated:YES];
//        _OpenID = tencentOAuth.openId;
//        _NickName = tencentOAuth.accessToken;
        
        [tencentOAuth getUserInfo];
        
    }
    else
    {
        tokenLable.text = @"登录不成功 没有获取accesstoken";
    }
}
//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        resultLable.text = @"用户取消登录";
    }else{
        resultLable.text = @"登录失败";
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
    resultLable.text = @"无网络连接，请设置网络";
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    NSLog(@"%@",response.jsonResponse[@"nickname"]);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //把用户名存储到UserDefault
    [userDefaults setObject:response.jsonResponse[@"nickname"] forKey:k_qqNickName];
    [userDefaults synchronize];
    NSLog(@"*********%@",[userDefaults valueForKey:k_qqNickName]);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * nickName= [user objectForKey:k_qqNickName];
    NSMutableDictionary *dict2=[[NSMutableDictionary alloc]init];
    [dict2 addEntriesFromDictionary:@{@"openId":tencentOAuth.openId,@"nickname":nickName}];
    [RequestTools postWithURL:@"/qq_authorize.mob" params:dict2 success:^(NSDictionary *Dict) {
        NSLog(@"----------------%@",Dict);
    } failure:^(NSError *error) {
        NSLog(@"----------------%@",error);
    }];
    ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
    thirdVC.classifyState = @"0";
    [self.navigationController pushViewController:thirdVC animated:YES];

}

- (IBAction)forgetNumBtn:(UIButton *)sender {
    
    FindCodeViewController * findVC = [[FindCodeViewController alloc]init];
    [self.navigationController pushViewController:findVC animated:YES];

}

- (IBAction)loginQQ:(UIButton *)sender {
    
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_wxToken];
//    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:k_wxOpenID];
//    NSLog(@"----------------%@",openID);
//    NSLog(@"----------------%@",accessToken);tencent222222

    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105538921" andDelegate:self];
    permissions= [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",nil];
    [tencentOAuth authorize:permissions inSafari:NO];
    

//    NSString *url =@"sports.qq.com/nba/";
//    NSString *utf8String =@"http://image.baidu.com/i?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&word=越前龙马&step_word=越前龙马&pn=33&spn=0&di=91758034940&pi=&rn=1&is=&istype=&ie=utf-8&oe=utf-8&in=32663&cl=2&lm=-1&st=&cs=3048474619%2C1612991872&os=2035090878%2C1902782440&adpicid=0&ln=1000&fr=acint&fmq=1422327488759_R&ic=&s=&se=&sme=0&tab=&width=&height=&face=&ist=&jit=&cg=&objurl=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201207%2F26%2F20120726071437_BhyLf.thumb.600_0.jpeg&fromurl=ippr_z2C%24qAzdH3FAzdH3F4_z%26e3B17tpwg2_z%26e3Bv54AzdH3Frj5rsjAzdH3F4ks52AzdH3F8cml9anmnAzdH3F1jpwtsAzdH3F";
//    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:@"腾讯空间分享测试Demo" description:@"貌似有点明白了" previewImageURL:[NSURL URLWithString:utf8String]];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
//    QQApiSendResultCode sent =0;
//    sent = [QQApiInterface SendReqToQZone:req];
//
//    [self handleSendResult:sent];//这是分享到空间
    

}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{

    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
                default:
        {
            break;
        }
    }

}
//wb978290066原文件
- (IBAction)loginWeibo:(UIButton *)sender {
    
    WBAuthorizeRequest * request  = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{};
    [WeiboSDK sendRequest:request];
}

//微博登录跳转
-(void)wbLogPush:(NSNotification *)wbNot{

    ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
    thirdVC.classifyState = @"1";
    [self.navigationController pushViewController:thirdVC animated:YES];
    
}
//微信登录跳转
-(void)wxLogPush:(NSNotification *)wxNot{
    
    ThirdTieViewController * thirdVC = [[ThirdTieViewController alloc]init];
    thirdVC.classifyState = @"2";
    [self.navigationController pushViewController:thirdVC animated:YES];
    
}

- (IBAction)loginWeixin:(UIButton *)sender {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_wxToken];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:k_wxOpenID];
    NSLog(@"----------------%@",openID);
    NSLog(@"----------------%@",accessToken);
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_wxRefreshToken];
//        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXPatient_App_ID, refreshToken];
//        [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"请求reAccess的response = %@", responseObject);
//            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
//            NSString *reAccessToken = [refreshDict objectForKey:@"access_token"];
//            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
//            if (reAccessToken) {
//                // 更新access_token、refresh_token、open_id
//                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:K_wxToken];
//                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"openid"] forKey:k_wxOpenID];
//                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"refresh_token"] forKey:K_wxRefreshToken];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
//                
////                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
////            }
////            else {
////                [self wechatLogin];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
//        }];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self wechatLogin];
    }
    
}
-(void)wechatLogin {
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"GSTDoctorApp";
        [WXApi sendReq:req];
        
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
