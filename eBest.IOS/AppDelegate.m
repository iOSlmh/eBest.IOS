//
//  AppDelegate.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//com.eBest.zhenyuwang   wx46d95a358f1302a0

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "GuidePageView.h"
#import "LoginViewController.h"
#import "ThirdTieViewController.h"

/***********极光推送***********/
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//支付宝
#import <AlipaySDK/AlipaySDK.h>

//友盟分享
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"


@interface AppDelegate ()<JPUSHRegisterDelegate>


@property(nonatomic,strong) GuidePageView * guidePageView;
@end

@implementation AppDelegate

/*** !!!
 ** 程序启动时：
 
 * ①告诉代理进程启动但还没进入状态保存
 
 * ②告诉代理启动基本完成程序准备开始运行
 
 * ④当应用程序进入活动状态执行
 
 ** 按下Home键返回主界面：
 
 *  ③当应用程序将要入非活动状态执行
 
 *  ⑤当程序被推送到后台的时候调用
 
 ** 再次打开程序：
 
 *  ⑥当程序从后台将要重新回到前台时候调用
 
 *  ④当应用程序进入活动状态执行
 */

#pragma mark 应用程序的生命周期 >>>>>>
#pragma mark ①告诉代理进程启动但还没进入状态保存

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    /******************环信注册*****************/
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"boao#zhenyuwang"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    EMError *registerror = [[EMClient sharedClient] registerWithUsername:@"xiaoli" password:@"1"];
    if (registerror==nil) {
        NSLog(@"注册成功");
    }
    EMError *loginerror = [[EMClient sharedClient] loginWithUsername:@"xiaoli" password:@"1"];
    if (!loginerror) {
        NSLog(@"登录成功");
    }
    
    /******************极光推送*****************/
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)categories:nil];
    } else {
        
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
   

    //新浪微博登录
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //umeng分享
    [self UMShareInit];
    
    //臻玉网注册
    [WXApi registerApp:WXPatient_App_ID];
    
    //实例化
    self.baseTabBar = [[BaseTabBarController alloc]init];
    
    //将TabBar设置为根视图
    self.window.rootViewController = self.baseTabBar;
    
    //修改状态栏的颜色（第二种方式）
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
    //添加引导页
    [self createGuidePage];
    
    return YES;
}

#pragma mark ----------------------极光代理方法
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"收到通知:%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);

}


#pragma mark ----------------------友盟注册
-(void)UMShareInit{
    
    //appkey需要到友盟开放平台注册应用获取
    [UMSocialData setAppKey:@"568c83b067e58ef192001018"];
    
    //初始化qq和qqzone
    
    //    APP ID  1104908293    APP KEY  MnGtpPN5AiB6MNvj
//    [UMSocialQQHandler setQQWithAppId:@"1104908293" appKey:@"MnGtpPN5AiB6MNvj" url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:@"1105538921" appKey:@"cumC8soIJmmMS1Ap" url:@"http://www.umeng.com/social"];

    //微信zAppID：wxe6b5b748cdcff60f AppSecret:d4624c36b6795d1d99dcf0547af5443d
//    [UMSocialWechatHandler setWXAppId:@"wxe6b5b748cdcff60f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    
//    //新浪appkey   978290066
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"978290066"
//                                              secret:@"04b48b094faeb16683c32669824ebdad"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];tencent222222 tencentApiIdentifier   tencent1104908293
    
}

//- (void)payOrder:(NSString *)orderStr
//      fromScheme:(NSString *)schemeStr
//        callback:(CompletionBlock)completionBlock{
//
//    
//}
#pragma mark ----------------------公用代理方法
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSString *urlStr =[[url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] substringToIndex:2];
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        NSLog(@"----------------%@",url);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回 authCode
        NSLog(@"----------------%@",url);
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if([urlStr isEqualToString:@"wx"]){
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if([urlStr isEqualToString:@"wb"]){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if([urlStr isEqualToString:@"te"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if ([urlStr isEqualToString:@"al"]){
    
    }else if([url.host isEqualToString:@"we"]){
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }

    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%@",url.host);
    
    NSString *urlStr =[[url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] substringToIndex:2];
    NSLog(@"--------------------%@",urlStr);
    NSLog(@"%@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"----------------%@",resultDic);
        }];
    }
    else if([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if([urlStr isEqualToString:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else if([urlStr isEqualToString:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if([urlStr isEqualToString:@"te"]) {
        return [TencentOAuth HandleOpenURL:url];
    }else if([url.host isEqualToString:@"we"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
 
    return true;
    
}
#pragma mark ----------------------新浪微博三方登录
/**
 *  新浪微博代理方法----获取openID和token后发送请求获取用户基本信息
 */
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *openID = [(WBAuthorizeResponse *)response userID];
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            
            //登录通知
            NSNotification *notification =[NSNotification notificationWithName:@"wbLogin" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSLog(@"%@",openID);
            NSLog(@"%@",accessToken);
            NSString * oathString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",openID,accessToken];
            NSLog(@"%@",oathString);
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            [manager GET:oathString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"%@",responseObject);
                NSLog(@"%@",responseObject[@"screen_name"]);
                //        _OpenID = [(WBAuthorizeResponse *)response userID];
                NSString * nickName = responseObject[@"screen_name"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:nickName forKey:k_wbNickName];
                [userDefaults setObject:openID forKey:k_wbOpenID];
                [userDefaults setObject:accessToken forKey:K_wbToken];
                [userDefaults synchronize];
                NSLog(@"*********%@",[userDefaults valueForKey:k_wbNickName]);
                NSLog(@"*********%@",[userDefaults valueForKey:k_wbOpenID]);
                NSLog(@"*********%@",[userDefaults valueForKey:K_wbToken]);
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];

        }
    }
}

#pragma mark ----------------------微信三方登录代理方法
/**
 *  微信代理方法----获取openID和token后发送请求获取用户基本信息
 */
-(void) onReq:(BaseReq*)req{

    NSLog(@"----------------%@",req);
}

//微信登录及支付回调响应
-(void)onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //微信登录
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSLog(@"----------------%@",aresp.code);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXPatient_App_ID, WXPatient_App_Secret, aresp.code];
            [manager GET:accessUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"请求access的response = %@", responseObject);
                NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
                NSString *accessToken = [accessDict objectForKey:@"access_token"];
                NSString *openID = [accessDict objectForKey:@"openid"];
                NSString *refreshToken = [accessDict objectForKey:@"refresh_token"];
                // 本地持久化，以便access_token的使用、刷新或者持续
                if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                    
                    //登录通知
                    NSNotification *notification =[NSNotification notificationWithName:@"wxLogin" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:K_wxToken];
                    [[NSUserDefaults standardUserDefaults] setObject:openID forKey:k_wxOpenID];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:K_wxRefreshToken];
                    [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
                }
                [self wechatLoginByRequestForUserInfo];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取access_token时出错 = %@", error);
            }];
        }

        
    }
        //微信支付
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    if ([resp isKindOfClass:NSClassFromString(@"SendMessageToWXResp")]) {
        switch (resp.errCode) {
            case 0:
                [MBProgressHUD showSuccess:@"微信分享成功"];
                break;
                
            default:
                [MBProgressHUD showError:@"微信分享失败"];
                break;
        }
    }
}

// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_wxToken];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:k_wxOpenID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    // 请求用户数据
    [manager GET:userUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求用户信息的response = %@", responseObject);
        NSString * nickName = responseObject[@"nickname"];
        NSLog(@"----------------%@",nickName);
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:k_wxNickName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
}

#pragma mark ----------------------引导欢迎页设置
-(void)createGuidePage
{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"isRuned"]boolValue]) {
        
        NSArray * imageArray = @[@"lead0",@"lead1",@"lead2",@"lead3"];
        self.guidePageView = [[GuidePageView alloc]initWithFrame:self.window.bounds ImageArray:imageArray];
        [self.baseTabBar.view addSubview:self.guidePageView];
        
        //第一次运行完成之后进行记录
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isRuned"];
    }
    [self.guidePageView.GoInButton addTarget:self action:@selector(goInButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goInButtonClick
{
    [self.guidePageView removeFromSuperview];
}
#pragma  mark - ③当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
#pragma mark ⑤当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //环信
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}
#pragma mark ⑥当程序从后台将要重新回到前台时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //环信
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
#pragma mark ④当应用程序进入活动状态执行
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark ⑦当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
