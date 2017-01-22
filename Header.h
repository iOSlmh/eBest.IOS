//
//  Header.h
//  mallbuilderIOS
//
//  Created by yuanfeng01 on 15/10/9.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

//#ifndef Header_h
#define Header_h

#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "UIButton+Extension.h"
#import "UILabel+Extension.h"
#import "Masonry.h"
#import "MasonyUtil.h"
#import "REFrostedViewController.h"
#import "StatusBar.h"
#import "JGProgressHUD.h"
#import "MJRefresh.h"
#import "CTHttpTool.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "NSNull+InternalNullExtention.h"
#import "UIImageView+WebCache.h"
#import "UIView+Rect.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD.h>
#import "MBProgressHUD+NJ.h"
#import "MJExtension.h"
#import "ShowMessageTool.h"
#import "NSNull+NullSafe.h"
#import "YFBaseID.h"
#import "CacheFile.h"

//全局通知商铺和商品关注否发送请求
#define KShopIsFaveriteChange         @"shopIsFaverite"
#define KGoodsIsFaveriteChange        @"goodsIsFaverite"
//全局通知购物车是否发送请求
#define kShoppingCartList         @"ShoppingCartList"
#define kShoppingCartNoPay        @"ShoppingCartNoPay"
#define kShopDetailToCart         @"ShopDetailToCart"
//为按钮设置图片
#define btnSetImage(button,imageStr) [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal]
//发送通知
#define sendNotification(key)          [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
//移除通知
#define removeNotification(key)         [[NSNotificationCenter defaultCenter]removeObserver:self name:key object:nil];

//域名
#define Domain_url @"http://119.90.133.156/mallbuilder-api/mobile_api/"

//地址
#define Base_URL @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php"


//首页滚动广告图
#define MallBuilder_url @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=Adv&met=slide&typ=json"
//首页精品分类
#define Competitive_url @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=Category&met=hot&typ=json"


//一级分类接口
#define Classifction_url @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=Category&met=getItem&typ=json"
//登陆接口
#define Login_url @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=User&met=login&typ=json"
//注册接口
#define Register_url @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=User&met=register&typ=json"

//地址界面保存接口

#define Save_url  @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=UserAddress&met=edit&typ=json"

#define Save1_url  @"http://119.90.133.156/mallbuilder-api/mobile_api/api.php?ctl=UserAddress&met=add&typ=json"



#define kUser_id @""
#define kKey @""

#define kUserName @""
#define kPassWord @""
#define kSucces @"NO"
#define _LolitaFunctions [LolitaFunctions sharedObject]
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define viewY_H_Padding(view1,view2,ls) view1.frame.size.height+view2.frame.origin.y+ls
#define viewX_W_Padding(view1,view2,ls) view1.frame.size.width+view2.frame.origin.x+ls

#define viewH(view1) view1.frame.size.height
#define viewW(view1) view1.frame.size.width
#define viewX(view1) view1.frame.origin.x
#define viewY(view1) view1.frame.origin.y

#define viewAlloc(view1,xs1,ys2,ws3,hs4)  [[view1 alloc]initWithFrame:CGRectMake(xs1, ys2, ws3, hs4)]
#define viewAlloc_(view1) [[view1 alloc]init]


#define VW (self.view.frame.size.width)
#define VH (self.view.frame.size.height)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//根据像素计算对应的宽度，适合任意屏幕
#define ActualW(w) [UIScreen mainScreen].bounds.size.width*w/640
//根据像素计算对应的高度，适合任意屏幕
#define ActualH(h) [UIScreen mainScreen].bounds.size.height*(h)/1136

//颜色
#define mallBuilderColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//导航栏标题字体大小
#define JDNavigationFont [UIFont boldSystemFontOfSize:16]
//公用颜色
#define JDCommonColor [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1]

//是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//是否为iOS8及以上系统
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//日至输出
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)



#endif /* Header_h */
