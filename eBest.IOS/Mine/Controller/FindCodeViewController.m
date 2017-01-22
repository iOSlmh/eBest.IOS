//
//  FindCodeViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/6.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "FindCodeViewController.h"
#import "CheckIDViewController.h"
@interface FindCodeViewController ()
{
    WSAuthCode *wsCode;
}
@end

@implementation FindCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(247, 247, 247, 1);
    [self createUI];
    [self createNav];
}
-(void)createUI{
    
    self.phoneTF.layer.borderWidth = 1;
    self.phoneTF.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    self.codeTF.layer.borderWidth = 1;
    self.codeTF.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    wsCode = [[WSAuthCode alloc]initWithFrame:CGRectMake(0, 0, 90, 45)];
    wsCode.wordSpacingType = WordSpacingTypeNone;
    wsCode.disturbLineNumber = 5;
    wsCode.allWordArraytype = BlendWordAndNumbers;
    wsCode.fontSize = 20;
    [self.checkCode addSubview:wsCode];
    
}
-(void)createNav{
    
    self.title = @"找回密码";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(fBackClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

}
- (void)fBackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)reloadAction {
    [wsCode reloadAuthCodeView];
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

- (IBAction)nextBtn:(UIButton *)sender {
    
    if (self.phoneTF.text.length==11&&self.codeTF.text.length>0) {
        
        BOOL isOk = [wsCode startAuthWithString:self.codeTF.text];
        
        if (isOk) {
            
            CheckIDViewController * checkVC = [[CheckIDViewController alloc]init];
            checkVC.mobile = self.phoneTF.text;
            [self.navigationController pushViewController:checkVC animated:YES];
            //这里面写验证正确之后的动作.
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"匹配正确" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:2];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:2];
            
            
            //这里面写验证失败之后的动作.
            [wsCode reloadAuthCodeView];
        }

    }else{
    
        [MyHUD showAllTextDialogWith:@"手机号码不正确!" showView:BaseView];
    }
    
}
@end
