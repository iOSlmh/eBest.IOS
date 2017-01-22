//
//  MailLockViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MailLockViewController.h"

@interface MailLockViewController ()<UITextFieldDelegate>

@end

@implementation MailLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(247, 247, 247, 1);
    self.mailTF.delegate = self;
    self.mailTF.text = _mailStr;
    [self createNav];
}

-(void)createNav{
    
    self.title = @"修改邮箱";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(maBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

}
- (void)maBackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtn:(UIButton *)sender {
    
    NSDictionary * dic = @{@"attr":@"email",@"value":_mailTF.text};
    [RequestTools posUserWithURL:@"/user_info_update.mob" params:dic success:^(NSDictionary *Dict) {
    
        if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
            [MyHUD showAllTextDialogWith:@"保存成功" showView:self.view];
            //延迟
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        }else{
        
            [MyHUD showAllTextDialogWith:@"保存失败" showView:self.view];
        }
    } failure:^(NSError *error) {
                
    }];
}

-(void)delayMethod{

    [self.navigationController popViewControllerAnimated:YES];
}

//定义return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
