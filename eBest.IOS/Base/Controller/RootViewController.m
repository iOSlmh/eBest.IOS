//
//  RootViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRootNav];
}

-(void)createRootNav
{
 
    //换掉下边线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(220, 220, 220, 1) size:CGSizeMake(SW, 1)];
    
    //设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航颜色
    self.navigationController.navigationBar.barTintColor = RGB(255, 255, 255, 1);
    
//    //改变状态栏背景色
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SW, 20)];
//    
//    statusBarView.backgroundColor=[UIColor blackColor];
//    
//    [self.view addSubview:statusBarView];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//
//    //第一种方式，修改状态栏的颜色
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    //设置字体样式
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: RGB(71, 71, 71, 1),NSFontAttributeName : [UIFont fontWithName:@"PingFang SC" size:17]};
    self.titleLabel.textColor = RGB(71, 71, 71, 1);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel;
    
    //左按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 50, 40);
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView: self.leftButton];
    
    //右按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame =CGRectMake(0, 0, 50, 40);
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView: self.rightButton];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,rightButtonItem,nil];
    self.navigationItem.leftBarButtonItems= [NSArray arrayWithObjects: negativeSpacer,leftButtonItem,nil];
}

//添加响应事件
-(void)setLeftButtonClick:(SEL)selector
{
    [self.leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(void)setRightButtonClick:(SEL)selector
{
    [self.rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
