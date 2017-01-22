//
//  RefuseViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RefuseViewController.h"

@interface RefuseViewController ()

@end

@implementation RefuseViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    [self createNav];
    [self loadData];
}
-(void)loadData{

    NSDictionary * dic = @{@"of_id":self.ofID};
    [RequestTools posUserWithURL:@"/refund_refuse_info.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        
    } failure:^(NSError *error) {
        
    }];

}
//创建导航栏
-(void)createNav{
    
    self.title = @"退货详情";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

    
}

-(void)backClick{
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
