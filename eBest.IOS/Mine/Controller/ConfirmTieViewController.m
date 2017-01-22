//
//  ConfirmTieViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/13.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ConfirmTieViewController.h"
#import "MineViewController.h"
@interface ConfirmTieViewController ()<UITextFieldDelegate>

@end

@implementation ConfirmTieViewController

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI{

    self.phTF.layer.borderWidth = 1;
    self.phTF.layer.borderColor = RGB(246, 248, 247, 1).CGColor;
    self.phTF.delegate = self;
    
    self.psTF.layer.borderWidth = 1;
    self.psTF.layer.borderColor = RGB(246, 248, 247, 1).CGColor;
    self.psTF.delegate = self;
}

- (IBAction)confirmBtn:(UIButton *)sender {
    
    if ([self.classifyState isEqualToString:@"0"] ) {//qq
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString * nickName= [user objectForKey:k_qqNickName];
        NSString * openID = [user objectForKey:k_qqOpenID];
        NSString * token = [user objectForKey:K_qqToken];
        NSLog(@"%@",nickName);
        NSLog(@"%@",openID);
        //请求字典
        NSDictionary * dic = @{@"username":self.phTF.text,@"password":self.psTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"qq"};
        //post请求
        [RequestTools postWithURL:@"/account_bind.mob" params:dic success:^(NSDictionary *Dict) {
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"] isEqualToString:@"success"]) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

 
    }else if ([self.classifyState isEqualToString:@"1"] ){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString * nickName= [user objectForKey:k_wbNickName];
        NSString * openID = [user objectForKey:k_wbOpenID];
        NSString * token = [user objectForKey:K_wbToken];
        NSLog(@"%@",nickName);
        NSLog(@"%@",openID);
        //请求字典
        NSDictionary * dic = @{@"username":self.phTF.text,@"password":self.psTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"sina"};
        //post请求
        [RequestTools postWithURL:@"/account_bind.mob" params:dic success:^(NSDictionary *Dict) {
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"] isEqualToString:@"success"]) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                

            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString * nickName= [user objectForKey:k_wxNickName];
        NSString * openID = [user objectForKey:k_wxOpenID];
        NSString * token = [user objectForKey:K_wxToken];
        NSLog(@"%@",nickName);
        NSLog(@"%@",openID);
        NSLog(@"----------------%@",token);
        //请求字典
        NSDictionary * dic = @{@"username":self.phTF.text,@"password":self.psTF.text,@"open_id":openID,@"nickname":nickName,@"bind_type":@"wx"};
        //post请求
        [RequestTools postWithURL:@"/account_bind.mob" params:dic success:^(NSDictionary *Dict) {
            NSLog(@"%@",Dict);
            NSLog(@"%@",Dict[@"return_info"][@"message"]);
            NSString * ktoken = Dict[@"token"][@"token"];
            NSString * kuser_id = Dict[@"token"][@"user_id"];
            if ([Dict[@"return_info"][@"successFlag"] isEqualToString:@"success"]) {
            
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:ktoken forKey:k_Key];
                [userDefaults setObject:kuser_id forKey:k_user];
                [userDefaults synchronize];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }

//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    MineViewController * mineVC = [[MineViewController alloc]init];
//    [self presentViewController:mineVC animated:YES completion:nil];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
