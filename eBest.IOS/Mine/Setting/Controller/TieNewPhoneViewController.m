//
//  TieNewPhoneViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "TieNewPhoneViewController.h"
#import "PersonalViewController.h"
@interface TieNewPhoneViewController ()

@end

@implementation TieNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(245, 245, 245, 1);
    self.sendCode.layer.borderWidth = 1.0f;
    self.sendCode.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    [self.sendCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self createNav];
    
}

-(void)getCode{
    
    if (kIsEmptyString(self.setNewPhone.text)) {
        
        [MyHUD showAllTextDialogWith:@"请输入手机号" showView:BaseView];
        
    }else{
        
        NSDictionary * dic = @{@"method":@"mobile",@"value":self.setNewPhone.text,@"message_type":@"bind_mobile"};
        [RequestTools postWithURL:@"/send_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            if ([Dict[@"return_info"][@"errFlg"]boolValue]) {
            
                [MyHUD showAllTextDialogWith:@"手机号已绑定!" showView:BaseView];
            }else{
            
                [MyHUD showAllTextDialogWith:@"验证码已发送!" showView:BaseView];

                [Function startTime:self.sendCode];
            }
            
        } failure:^(NSError *error) {
            
        }];
       
    }
    
}

//创建导航栏
-(void)createNav{
    
    self.title = @"绑定新手机";
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


- (IBAction)saveBtn:(UIButton *)sender {
    
    if (kIsEmptyString(self.checkCode.text)) {
        [MyHUD showAllTextDialogWith:@"请输入验证码!" showView:BaseView];
    }else{
        
        NSDictionary * dic = @{@"method":@"mobile",@"value":self.setNewPhone,@"verify_code":self.checkCode.text};
        [RequestTools postWithURL:@"/check_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            if (![Dict[@"return_info"][@"errFlg"]boolValue]) {
            
               [self savePhoneNum];

            }else{
                
                [MyHUD showAllTextDialogWith:@"验证码错误!" showView:BaseView];
               
            }
            
        } failure:^(NSError *error) {
            
        }];
    }

}
-(void)savePhoneNum{

    NSDictionary * dic = @{@"attr":@"mobile",@"value":self.setNewPhone.text};
    [RequestTools posUserWithURL:@"/user_info_update.mob" params:dic success:^(NSDictionary *Dict) {
        
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            
            [MyHUD showAllTextDialogWith:@"保存成功" showView:BaseView];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];

        }else{
            
            [MyHUD showAllTextDialogWith:@"保存失败" showView:BaseView];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
