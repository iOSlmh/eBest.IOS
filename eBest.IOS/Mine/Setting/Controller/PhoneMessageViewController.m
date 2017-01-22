//
//  PhoneMessageViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "PhoneMessageViewController.h"
#import "CheckPhoneViewController.h"
@interface PhoneMessageViewController ()

@end

@implementation PhoneMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(245, 245, 245, 1);
    [self createNav];
    [self loadData];
}
-(void)loadData{

    self.phoneMessage.text = [NSString stringWithFormat:@"    您已绑定手机%@",[self replaceStringWithAsterisk:self.phoneNum startLocation:3 lenght:self.phoneNum.length -7]];
    
}
//把字符串替换成星号
-(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

//创建导航栏
-(void)createNav{
    
    self.title = @"手机信息";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem * leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    
}
- (void)backClick{
    
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

- (IBAction)changeNumBtn:(UIButton *)sender {
    
    CheckPhoneViewController * checkVC = [[CheckPhoneViewController alloc]init];
    checkVC.checkPhone = self.phoneNum;
    [self.navigationController pushViewController:checkVC animated:YES];
    
}
@end
