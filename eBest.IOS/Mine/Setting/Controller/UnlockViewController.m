//
//  UnlockViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/23.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "UnlockViewController.h"
#import "TiePhoneViewController.h"
@interface UnlockViewController ()

@end

@implementation UnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view from its nib.
    _dict=[[NSMutableDictionary alloc]init];
    [_dict addEntriesFromDictionary:@{@"birth":@""}];
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245, 1);
    [self createNav];
    [self creatUI];
    self.navigationItem.title = @"手机信息";

}

-(void)creatUI{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 48)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //    手机号
    UILabel * phonelb = [FactoryUI createLabelWithFrame:CGRectMake(15, 0, SW-15, 48) text:@"您已绑定手机18087394408" textColor:RGB(123,123,123,1) font:[UIFont systemFontOfSize:15]];
    [view1 addSubview:phonelb];
    //    完成按钮
    UIButton * saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 70, SW-30, 40) title:@"换绑手机" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(saveBtnClick)];
    saveBtn.backgroundColor = RGB(32, 179, 169, 1);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    saveBtn.layer.cornerRadius = 4.2;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
    //    客服label
    UILabel * lb = [FactoryUI createLabelWithFrame:CGRectMake(SW-170, 120, 170-75, 13) text:@"验证遇到问题？" textColor:RGB(175,174,175,1) font:[UIFont systemFontOfSize:13]];
    [self.view addSubview:lb];
    
    //    客服按钮
    UIButton * kefuBtn = [FactoryUI createButtonWithFrame:CGRectMake(SW-75, 120, 60, 13) title:@"联系客服" titleColor:RGB(32, 179, 169, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(kefuClick)];
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
    
    TiePhoneViewController * tieVC = [[TiePhoneViewController alloc]init];
    [self.navigationController pushViewController:tieVC animated:YES];
    //    [_dict setValue:_tf.text forKey:@"name"];
    //    //    [self initData];
    //    [self.navigationController popViewControllerAnimated:YES];
    //
    //    [self dismissViewControllerAnimated:YES completion:nil];
    //
    //    [self.delegate getPhone:_tf.text];
}


//创建导航栏
-(void)createNav{
    
    self.title = @"手机信息";
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
