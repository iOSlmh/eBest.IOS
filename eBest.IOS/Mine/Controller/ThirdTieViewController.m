//
//  ThirdTieViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/12.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ThirdTieViewController.h"
#import "LoginViewController.h"
#import "ConfirmTieViewController.h"
#import "MineViewController.h"
@interface ThirdTieViewController ()<UITextFieldDelegate>

@end

@implementation ThirdTieViewController

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    NSLog(@"%@",_wbOpenID);
    
}
/*
-(void) getWeiboLoginNoti:(NSNotification*) noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString* oath_url = [noti.userInfo objectForKey:@"para"];
    NSLog(@"%@",noti.userInfo);
    NSLog(@"%@",oath_url);
}

-(void)setNav{

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiboLoginNoti:)name:@"weiboLogin"object:nil];
}
*/

/**
 *  设置xib--UI
 */
-(void)createUI{

    self.phoneTF.layer.borderWidth = 1;
    self.phoneTF.layer.borderColor = RGB(246, 248, 247, 1).CGColor;
    self.phoneTF.delegate = self;
    
    self.codeTF.layer.borderWidth = 1;
    self.codeTF.layer.borderColor = RGB(246, 248, 247, 1).CGColor;
    self.codeTF.delegate = self;
    
    self.passwordTF.layer.borderWidth = 1;
    self.passwordTF.layer.borderColor = RGB(246, 248, 247, 1).CGColor;
    self.passwordTF.delegate = self;
    
    self.ggBtn.layer.borderWidth = 1;
    self.ggBtn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    self.ggBtn.layer.cornerRadius = 2;
    self.ggBtn.layer.masksToBounds = YES;

}

/**
 *  获取验证码
 */
- (IBAction)getCodeBtn:(UIButton *)sender {

    if (self.phoneTF.text.length==11) {
    NSDictionary * dic = @{@"method":@"mobile",@"value":self.phoneTF.text,@"message_type":@"bind_mobile"};
        [RequestTools postWithURL:@"/send_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
            
            if (![Dict[@"return_info"][@"errFlg"]boolValue]) {
            
                [AlertShow showAlert:@"验证码已发送"];
                [Function startTime:self.sendCode];
            }

        } failure:^(NSError *error) {
            
        }];
        
    }else{
       [AlertShow showAlert:@"手机号码不正确"];
    }

}

/**
 *  确认按钮首先进行验证，成功返回后调用接口进行绑定
 */
- (IBAction)cofirmBtn:(UIButton *)sender {
    
    NSDictionary * dic = @{@"method":@"mobile",@"value":self.phoneTF.text,@"verify_code":self.codeTF.text};
    [RequestTools postWithURL:@"/check_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
        if (![Dict[@"return_info"][@"successFlag"]  isEqualToString:@"success"]) {
            [AlertShow showAlert:@"验证码错误"];
            
        }else{
            
            [self tiePhone];
        }

    } failure:^(NSError *error) {
        
    }];
    
    LoginViewController * logVC = [[LoginViewController alloc]init];
    [self presentViewController:logVC animated:YES completion:nil];
}

/**
 *  绑定手机号
 */
-(void)tiePhone{
    
    if ([self.classifyState isEqualToString:@"0"] ) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString * nickName= [user objectForKey:k_qqNickName];
        NSString * openID = [user objectForKey:k_qqOpenID];
        NSString * token = [user objectForKey:K_qqToken];
        NSLog(@"%@",nickName);
        NSLog(@"%@",openID);
        //请求字典
        NSDictionary * dic = @{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"qq"};
        [RequestTools postWithURL:@"/mobile_bind.mob" params:dic success:^(NSDictionary *Dict) {
            
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"]  isEqualToString:@"success"]) {
                
                [AlertShow showAlert:@"绑定成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                NSLog(@"*********%@",[userDefaults valueForKey:k_Key]);
                NSLog(@"*********%@",[userDefaults valueForKey:k_user]);
                MineViewController * mineVC = [[MineViewController alloc]init];
                [self.navigationController pushViewController:mineVC animated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"----------------%@",error);
        }];

    }else if ([self.classifyState isEqualToString:@"1"]){
        
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * nickName= [user objectForKey:k_wbNickName];
    NSString * openID = [user objectForKey:k_wbOpenID];
    NSString * token = [user objectForKey:K_wbToken];
    NSLog(@"%@",nickName);
    NSLog(@"%@",openID);
    
    //请求字典
    NSDictionary * dic = @{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"sina"};
        [RequestTools postWithURL:@"/mobile_bind.mob" params:dic success:^(NSDictionary *Dict) {
            
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"]  isEqualToString:@"success"]) {
                
                [AlertShow showAlert:@"绑定成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                NSLog(@"*********%@",[userDefaults valueForKey:k_Key]);
                NSLog(@"*********%@",[userDefaults valueForKey:k_user]);
                MineViewController * mineVC = [[MineViewController alloc]init];
                [self.navigationController pushViewController:mineVC animated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];

    }else if ([self.classifyState isEqualToString:@"2"]){
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString * nickName= [user objectForKey:k_wxNickName];
        NSString * openID = [user objectForKey:k_wxOpenID];
        NSString * token = [user objectForKey:K_wxToken];
        NSLog(@"%@",nickName);
        NSLog(@"%@",openID);
        NSLog(@"----------------%@",token);
        //请求字典
        NSDictionary * dic = @{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"wx"};
        [RequestTools postWithURL:@"/mobile_bind.mob" params:dic success:^(NSDictionary *Dict) {
            
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"]  isEqualToString:@"success"]) {
                
                [AlertShow showAlert:@"绑定成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                NSLog(@"*********%@",[userDefaults valueForKey:k_Key]);
                NSLog(@"*********%@",[userDefaults valueForKey:k_user]);
                MineViewController * mineVC = [[MineViewController alloc]init];
                [self.navigationController pushViewController:mineVC animated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }

}

- (IBAction)tieBtn:(UIButton *)sender {
    ConfirmTieViewController * conVC = [[ConfirmTieViewController alloc]init];
    conVC.classifyState = self.classifyState;
    [self presentViewController:conVC animated:YES completion:nil];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ggBtn:(UIButton *)sender {
    NSLog(@"hidhfojwf");
}
//回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
