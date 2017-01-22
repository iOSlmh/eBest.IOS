//
//  StandingRuleViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/27.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "StandingRuleViewController.h"

@interface StandingRuleViewController ()

@end

@implementation StandingRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
}
-(void)viewWillAppear:(BOOL)animated{
    
    //设置状态栏颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //透明
    self.navigationController.navigationBar.translucent = NO;
    
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    //透明
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)createNav{
    
    self.title = @"积分规则";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
     self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(sdBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
}
- (void)sdBackClick{
    
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
