//
//  RegisterViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/18.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetCodeViewController.h"
#import "AgreementViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    BOOL _state;
    NSString * _verify;
}
@property(nonatomic,strong) UIView * hiddenView;

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNum.layer.borderWidth = 1;
    self.phoneNum.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    self.checkNum.layer.borderWidth = 1;
    self.checkNum.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    
//    _state = NO;
    self.phoneNum.delegate = self;
    self.checkNum.delegate = self;
//    清除按钮
    self.phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.checkNum.clearButtonMode = UITextFieldViewModeWhileEditing;
//    添加点击事件
//    [self.phoneNum addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventAllEditingEvents];
//    顶部遮布
    self.hiddenView = [FactoryUI createViewWithFrame:CGRectMake(64, 0, SW, 160)];
    self.hiddenView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapHidden = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHiddenClick)];
    [self.hiddenView addGestureRecognizer:tapHidden];
    [self.view addSubview:self.hiddenView];
    
}

//遮布点击方法
-(void)tapHiddenClick{
    
    [self.phoneNum resignFirstResponder];
    [self.checkNum resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定义return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)backBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkBtnClick{

    if (self.phoneNum.text.length==11) {
        
        NSLog(@"%@",self.phoneNum.text);
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict addEntriesFromDictionary:@{@"mobile":self.phoneNum.text}];
        [RequestTools postWithURL:@"/check_mobile_num.mob" params:dict success:^(NSDictionary *Dict) {
            
            NSLog(@"%@",Dict);
            //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"注册状态" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"欢迎来到臻玉网", nil];
            //        [alert show];
            //        NSLog(@"登录成功");
            if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"failure"]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"验证状态" message:@"号码已注册" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"取消", nil];
                [alert show];
            }else{
            
                [Function startTime:self.checkBtn];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"验证状态" message:@"您输入的手机号码有误" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"取消", nil];
        [alert show];
        
    }
}

- (IBAction)singleBtn:(UIButton *)sender {
//    [sender setBackgroundImage:[UIImage imageNamed:@"syncart_round_check2"] forState:UIControlStateNormal];
    if (sender.tag==123) {
        sender.selected = !(sender.selected);
        if (sender.selected) {
            [sender setBackgroundImage:[UIImage imageNamed:@"syncart_round_check2"] forState:UIControlStateNormal];
        }
            else{
            [sender setBackgroundImage:[UIImage imageNamed:@"syncart_round_check1"] forState:UIControlStateNormal];
            }
    }
    
}

- (IBAction)contractBtn:(UIButton *)sender {
    
    AgreementViewController * agreeVC = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreeVC animated:YES];

}

- (IBAction)nextBtn:(UIButton *)sender {
    
// 验证信息请求 获取验证信息  供前端对照验证
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"value":self.phoneNum.text,@"verify_code":self.checkNum.text,@"method":@"mobile"}];
    [RequestTools postWithURL:@"/check_verify_code.mob" params:dict success:^(NSDictionary *Dict) {
        NSLog(@">>>>>>>>>>%@",Dict);
        
        NSString * str = Dict[@"return_info"][@"successFlag"];
        if ([str isEqualToString:@"success"]) {
            [MyHUD showAllTextDialogWith:@"验证成功!" showView:BaseView];
            SetCodeViewController * setCodeVC = [[SetCodeViewController alloc]init];
            self.delegate = setCodeVC;
            [self.delegate postMobileWithPhoneNum:_phoneNum.text];
            [self.navigationController pushViewController:setCodeVC animated:YES];
        }else{
        
            [MyHUD showAllTextDialogWith:@"验证失败!" showView:BaseView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
       
    }];
}
@end
