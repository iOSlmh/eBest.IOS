//
//  SetCodeViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/25.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SetCodeViewController.h"
#import "MineViewController.h"
#import "RegisterViewController.h"
#define kSucces @"123"
@interface SetCodeViewController ()

@property(nonatomic,strong) NSString * postPhoneNum;

@end

@implementation SetCodeViewController

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
 
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_up"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view from its nib.
}

//注册界面代理传值
-(void)postMobileWithPhoneNum:(NSString *)phoneNum{

    _postPhoneNum = phoneNum;

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

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)becomeMember:(UIButton *)sender {
    
     NSLog(@"密码是：%@",_secretCode.text);
    NSLog(@"传值电话号%@",_postPhoneNum);
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"mobile":_postPhoneNum,@"password":_secretCode.text}];
//        NSDictionary * dict = [[NSDictionary alloc]init];
//        dict = @{@"mobile":_postPhoneNum,@"password":_secretCode.text};
    NSLog(@"--------------------》》%@",dict);
        [RequestTools postWithURL:@"/register.mob" params:dict success:^(NSDictionary *Dict) {
            
//            ****************************保存用户名密码*****************************

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:_postPhoneNum forKey:@"name"];
            [userDefaults setObject:_secretCode.text forKey:@"password"];      [userDefaults synchronize];
            [userDefaults setValue:@"YES" forKey:kSucces];
            NSLog(@"*********%@",[userDefaults valueForKey:@"name"]);
            NSLog(@"*********%@",[userDefaults valueForKey:@"password"]);
//            *********************************************************************
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"设置密码" message:@"恭喜你！密码设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"欢迎来到臻玉网", nil];
            [alert show];
            NSLog(@"注册成功");
            NSLog(@"%@",dict);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    
}
@end
