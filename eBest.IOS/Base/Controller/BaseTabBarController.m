//
//  BaseTabBarController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"
#import "DisplayViewController.h"
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createTabBarItem];
}
-(void)createViewControllers
{
//    //改变tabbar 线条颜色
//    CGRect rect = CGRectMake(0, 0, SW, 1);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,
//                                   RGB(247, 247, 247, 1).CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [self.tabBar setShadowImage:img];
//    
//    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
  
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self.tabBar setShadowImage:[FactoryUI imageWithColor:RGB(247, 247, 247, 1) size:CGSizeMake(SW, 0.5)]];
    //设置自定义tabbar背景色
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    imageV.image = [UIImage imageNamed:@"tab"];
    [bgView addSubview:imageV];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    //实例化子页面
    //首页
    HomeViewController * homeVC = [[HomeViewController alloc]init];
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];

    //众筹
    DisplayViewController * disVC = [[DisplayViewController alloc]init];
    UINavigationController * disNav = [[UINavigationController alloc]initWithRootViewController:disVC];
    
    //购物车
    ShoppingCartViewController * shoppingVC = [[ShoppingCartViewController alloc]init];
    UINavigationController * shoppingNav = [[UINavigationController alloc]initWithRootViewController:shoppingVC];
    
    //我的
    MineViewController * mineVC = [[MineViewController alloc]init];
    UINavigationController * MineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    
    //添加到viewControllers
    self.viewControllers = @[homeNav,disNav,shoppingNav,MineNav];
}

-(void)createTabBarItem
{
    //未选中的图片
    NSArray * unselectedImageArray = @[@"tab_home ",@"tab_classification",@"tab_shopping",@"tab_personal center"];
    //选中的图片
    NSArray * selectedImageArray = @[@"tab_selectde_home ",@"tab_selectde_classification",@"tab_selectde_shopping",@"tab_selectde_personal center"];
    //标题
    NSArray * titleArray = @[@"首页",@"臻玉展厅",@"购物车",@"个人中心"];
    
    for (int i= 0; i < self.tabBar.items.count; i ++)
    {
        //处理未选中的图片，使用图片原尺寸
        UIImage * unselectedImage = [UIImage imageNamed:unselectedImageArray[i]];
        unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedImage = [UIImage imageNamed:selectedImageArray[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //获取item并且赋值
        UITabBarItem * item = self.tabBar.items[i];
        item = [item initWithTitle:titleArray[i] image:unselectedImage selectedImage:selectedImage];
        
    }
    
    //设置选中时标题的颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(42, 150, 143, 1)} forState:UIControlStateSelected];
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
