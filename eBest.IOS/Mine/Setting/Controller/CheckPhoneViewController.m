//
//  CheckPhoneViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import "TieNewPhoneViewController.h"
@interface CheckPhoneViewController ()

@end

@implementation CheckPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(245, 245, 245, 1);
    self.sendCode.layer.borderWidth = 1.0f;
    self.sendCode.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    [self.sendCode addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
    [self createNav];
    [self loadData];
    
}
-(void)getCheckCode{

    NSDictionary * dic = @{@"method":@"mobile",@"value":self.checkPhone,@"message_type":@"bind_mobile"};
    [RequestTools postWithURL:@"/send_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            
            [MyHUD showAllTextDialogWith:@"验证码发送成功!" showView:BaseView];
            [Function startTime:self.sendCode];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)loadData{

    self.phoneLb.text = [NSString stringWithFormat:@"    您已绑定手机%@",[self replaceStringWithAsterisk:self.checkPhone startLocation:3 lenght:self.checkPhone.length -7]];
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
    
    self.title = @"验证旧手机";
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

- (IBAction)nextTip:(UIButton *)sender {
    
    if (_checkCode.text.length>0) {
        
        NSDictionary * dic = @{@"method":@"mobile",@"value":self.checkPhone,@"verify_code":self.checkCode.text};
        [RequestTools postWithURL:@"/check_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
            
        NSLog(@"----------------%@",Dict);
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]){
                
            TieNewPhoneViewController * newVC = [[TieNewPhoneViewController alloc]init];
            [self.navigationController pushViewController:newVC animated:YES];
        }else{
        
            [MyHUD showAllTextDialogWith:@"验证码不正确!" showView:BaseView];
        
        }
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
    
        [MyHUD showAllTextDialogWith:@"请输入验证码!" showView:BaseView];
    }
}
@end
