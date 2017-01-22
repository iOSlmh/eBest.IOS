//
//  RequestTools.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/13.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RequestTools.h"
#import "AFNetworking.h"

@implementation RequestTools

static BOOL isFirst = NO;
static BOOL canCHeckNetwork = NO;

#pragma mark ----------------------普通拼接请求
//传入拼写字符串和参数即可分类请求
+(void)getWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [self checkNetWork];
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        failure(error);
        NSLog(@"网络错误");
        
        return;
    }

    NSString * url = [NSString stringWithFormat:@"%@%@",Base_Url,spellUrl];
    NSLog(@"当前URL是%@",url);
    // 1.创建AFN管理者
    AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [mange GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 请求成功
        NSDictionary *Dict=responseObject;
        if (success) {
            success(Dict);
            NSLog(@"类请求成功");

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
            return ;
        }
        
    }];
    
}
+(void)postWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [self checkNetWork];
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        failure(error);
        NSLog(@"网络错误,没有联网");
        [MyHUD showAllTextDialogWith:@"请连接网络！" showView:[[UIApplication sharedApplication].windows lastObject]];
        return;
        
    }
     
        NSString * url = [NSString stringWithFormat:@"%@%@",Base_Url,spellUrl];
        NSLog(@"当前URL是%@",url);
        //    [MBProgressHUD showMessage:@"等待数据更新"];
        
        //NSLog(@"等待数据更新");
        AFHTTPRequestOperationManager *mange = [AFHTTPRequestOperationManager manager];
        [mange POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // 请求成功, 通知调用者请求成功
            NSDictionary *Dict=responseObject;
            
            if (success) {
                success(Dict);
                NSLog(@"类请求成功");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (failure) {
                failure(error);
                
                return ;
                
            }
        }];
    
}

#pragma mark ----------------------携带用户信息的普通请求
+(void)getUserWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [self checkNetWork];
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        failure(error);
        [MyHUD showAllTextDialogWith:@"请检查网络" showView:[[UIApplication sharedApplication].windows lastObject]];
        NSLog(@"网络错误");
        return;
    }

    
    NSString * url = [NSString stringWithFormat:@"%@%@",Base_Url,spellUrl];
    NSLog(@"当前URL是%@",url);
    //读取用户信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key= [user objectForKey:k_Key];
    NSString *user_id = [user objectForKey:k_user];
    NSLog(@"==========%@",key);
    NSLog(@"==========%@",user_id);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@_%@",user_id,key]forHTTPHeaderField:@"authorization"];
    // 2.发送请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    // 请求成功
    NSDictionary *Dict=responseObject;
    if (success) {
        success(Dict);
        NSLog(@"类请求成功");
        //[MBProgressHUD hideHUD];
    }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
            return ;
        }
        
    }];

}
+(void)posUserWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [self checkNetWork];
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        failure(error);
        [MyHUD showAllTextDialogWith:@"请检查网络" showView:[[UIApplication sharedApplication].windows lastObject]];
        NSLog(@"网络错误");
        return;
    }

    
    NSString * url = [NSString stringWithFormat:@"%@%@",Base_Url,spellUrl];
    NSLog(@"当前URL是%@",url);
    //读取用户信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key= [user objectForKey:k_Key];
    NSString *user_id = [user objectForKey:k_user];
    NSLog(@"==========%@",key);
    NSLog(@"==========用户名：%@",user_id);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@_%@",user_id,key]forHTTPHeaderField:@"authorization"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        // 请求成功, 通知调用者请求成功
        NSDictionary *Dict=responseObject;
        
        if (success) {
            success(Dict);
            NSLog(@"类请求成功");

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);

            return ;
            
        }
    }];
}
#pragma mark ----------------------json请求
+(void)posJsonWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure{

    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [self checkNetWork];
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        failure(error);
        NSLog(@"网络错误");
        return;
    }

    //用户信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key= [user objectForKey:k_Key];
    NSString *user_id = [user objectForKey:k_user];
    NSLog(@"当前用户信息-----%@",[NSString stringWithFormat:@"%@_%@",user_id,key]);
    NSString * url = [NSString stringWithFormat:@"%@%@",Base_Url,spellUrl];
    NSLog(@"当前URL-----%@",url);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString * userMessage = [NSString stringWithFormat:@"%@_%@",user_id,key];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:userMessage forHTTPHeaderField:@"authorization"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 请求成功, 通知调用者请求成功
        NSDictionary *Dict=responseObject;
        
        if (success) {
            success(Dict);
            NSLog(@"****************json请求成功***************");
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
            
            return ;
            
        }
    }];
}

+(BOOL) checkNetWork{
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未识别的网络");
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"Unknown",@"isConnect":@"0"}]];
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"不可达的网络(未连接)");
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"NotReachable",@"isConnect":@"0"}]];
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"2G,3G,4G...的网络");
                    canCHeckNetwork = YES;
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"WWAN",@"isConnect":@"1"}]];
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"wifi的网络");
                    canCHeckNetwork = YES;
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"WiFi",@"isConnect":@"1"}]];
                    break;
                default:
                    break;
            }

        }];
        isFirst = YES;
    }
    
    return canCHeckNetwork;
    
}


@end
