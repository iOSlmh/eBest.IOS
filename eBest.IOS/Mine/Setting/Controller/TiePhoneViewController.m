//
//  TiePhoneViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/23.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "TiePhoneViewController.h"
#import "UnlockViewController.h"
@interface TiePhoneViewController ()<UITextFieldDelegate>
{
    UITextField *_phonetf;
    UITextField *_codetf;
    UIView * _view2;
}
@end

@implementation TiePhoneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    _dict=[[NSMutableDictionary alloc]init];
    [_dict addEntriesFromDictionary:@{@"birth":@""}];
    [super viewDidLoad];
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    [self createNav];
    [self creatUI];
    self.navigationItem.title = @"绑定手机";

}

-(void)creatUI{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 48)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SW, 48)];
    _view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view2];
//    手机号
    _phonetf = [[UITextField alloc]init];
    _phonetf.frame = CGRectMake(15, 0, SW-10,48);
    _phonetf.backgroundColor = [UIColor whiteColor];
    _phonetf.placeholder = @"手机号";
    //当文本框编辑时显示删除按钮
    _phonetf.clearButtonMode = UITextFieldViewModeWhileEditing;
    // _tf.secureTextEntry = YES;
    _phonetf.delegate = self;
    [view1 addSubview:_phonetf];
//    验证码
    _codetf = [[UITextField alloc]init];
    _codetf.frame = CGRectMake(15, 0, SW-120,48);
    _codetf.backgroundColor = [UIColor whiteColor];
    _codetf.placeholder = @"验证码";
    //当文本框编辑时显示删除按钮
    _codetf.clearButtonMode = UITextFieldViewModeWhileEditing;
    // _tf.secureTextEntry = YES;
    _codetf.delegate = self;
    [_view2 addSubview:_codetf];
//    验证按钮
    UIButton * checkBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-90, 10, 75, 27) title:@"发送验证码" titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(checkBtnClick)];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    checkBtn.layer.borderWidth = 1;
    checkBtn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    checkBtn.backgroundColor = [UIColor whiteColor];
    checkBtn.layer.cornerRadius = 4.2;
    checkBtn.layer.masksToBounds = YES;
    [_view2 addSubview:checkBtn];
//    完成按钮
    UIButton * saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 117, SW-30, 40) title:@"完成" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(saveBtnClick)];
    saveBtn.backgroundColor = RGB(32, 179, 169, 1);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    saveBtn.layer.cornerRadius = 4.2;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
//    客服label
    UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(SW-170, 172, 170-75, 13) text:@"验证遇到问题？" textColor:RGB(175,174,175,1) font:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lb];
    
//    客服按钮
    UIButton * kefuBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-75, 172, 60, 13) title:@"联系客服" titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(kefuClick)];
    kefuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:kefuBtn];
    //    [self setupNavgitionItem];
}

//-(void)initData{
//    [_dict addEntriesFromDictionary:@{@"ctl":@"Member",@"met":@"getMemberCash",@"typ":@"json",@"name":@"",@"k":kKey}];
//    NSString *URL=[NSString stringWithFormat:Base_URL];
//    [CTHttpTool postWithURL:URL params:_dict success:^(NSDictionary *Dict) {
//        NSLog(@"%@",Dict);
//
//    }failure:^(NSError *error) {
//        [ShowMessageTool showMessage:self.view andStr:@"服务器错误"];
//    }];
//}


-(void)saveBtnClick{
    
    UnlockViewController * unlockVC = [[UnlockViewController alloc]init];
    [self.navigationController pushViewController:unlockVC animated:YES];
//    [_dict setValue:_tf.text forKey:@"name"];
//    //    [self initData];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    [self.delegate getPhone:_tf.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//创建导航栏
-(void)createNav{
    
    self.title = @"绑定手机";
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

@end
