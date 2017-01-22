//
//  AppDelegate.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/4.
//  Copyright © 2016年 shijiboao. All rights reserved.WeiboSDKDelegate
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"

static NSString *appKey = @"750f1ed330f8d0d092a9b981";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentApiInterfaceDelegate,WBHttpRequestDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) BaseTabBarController * baseTabBar;

@end

