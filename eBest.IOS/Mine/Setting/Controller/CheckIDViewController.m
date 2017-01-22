//
//  CheckIDViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CheckIDViewController.h"
#import "ModifyCodeViewController.h"
@interface CheckIDViewController ()



@end

@implementation CheckIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(247, 247, 247, 1);
    [self createNav];
    self.phoneLb.text = [NSString stringWithFormat:@"手机号%@",[self replaceStringWithAsterisk:self.mobile startLocation:3 lenght:self.mobile.length -7]];
}

-(void)createNav{
    
    self.title = @"身份验证";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(chBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

}

- (void)chBackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)checkBtn:(UIButton *)sender {

    NSDictionary * dic = @{@"method":@"mobile",@"value":self.mobile,@"message_type":@"modify_pwd"};

    [RequestTools postWithURL:@"/send_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
        
        if (![Dict[@"return_info"][@"errFlg"]boolValue]) {
            
            [MyHUD showAllTextDialogWith:@"验证码已发送!" showView:BaseView];
            [Function startTime:self.sendCode];
            
        }else{
            
            [MyHUD showAllTextDialogWith:@"验证码发送失败!" showView:BaseView];
            
        }

    } failure:^(NSError *error) {
        
    }];

}

- (IBAction)nextBtn:(UIButton *)sender {
    
    NSDictionary * dic = @{@"method":@"mobile",@"value":self.mobile,@"verify_code":self.checkTF.text};
    [RequestTools posUserWithURL:@"/check_verify_code.mob" params:dic success:^(NSDictionary *Dict) {
        
        if (![Dict[@"return_info"][@"errFlg"]boolValue]) {
        
            ModifyCodeViewController * modifyVC = [[ModifyCodeViewController alloc]init];
            modifyVC.mobile = self.mobile;
            [self.navigationController pushViewController:modifyVC animated:YES];
            
        }else{
        
            [MyHUD showAllTextDialogWith:@"验证码错误!" showView:BaseView];
        
        }

    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)kefuBtn:(UIButton *)sender {
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
