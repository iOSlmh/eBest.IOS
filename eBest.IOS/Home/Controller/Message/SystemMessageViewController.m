//
//  SystemMessageViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()

@end

@implementation SystemMessageViewController

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    [self crateUI];
}

-(void)crateUI{

    self.view.backgroundColor = RGB(246, 246, 246, 1);
    UILabel * remindLabel = [FactoryUI createLabelWithFrame:CGRectMake((SW-200)/2, 200, 200, 40) text:@"暂无系统消息" textColor:RGB(183, 183, 183, 1) font:[UIFont boldSystemFontOfSize:16]];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];

}

//创建导航栏
-(void)createNav{
    
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(237, 237, 237, 1) size:CGSizeMake(SW, 1)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.title = @"消息中心";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(messageBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    
}

-(void)messageBackClick{
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
