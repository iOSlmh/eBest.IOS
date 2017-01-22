//
//  NicknameViewController.m
//  mallbuilderIOS
//
//  Created by yuanfeng01 on 15/10/19.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()<UITextFieldDelegate>
{
    UITextField *_tf;
}
@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [self createNav];
    _dict=[[NSMutableDictionary alloc]init];
     [_dict addEntriesFromDictionary:@{@"birth":@""}];
    [super viewDidLoad];
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    [self creatUI];
    self.navigationItem.title = @"修改昵称";
    // Do any additional setup after loading the view.
}
-(void)creatUI{

    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 48)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    _tf = [[UITextField alloc]init];
    _tf.frame = CGRectMake(15, 0, SW-10,48);
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @"请输入昵称";
    //当文本框编辑时显示删除按钮
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
   // _tf.secureTextEntry = YES;
    _tf.delegate = self;
    [view1 addSubview:_tf];
    UILabel *lb = [[UILabel alloc]init];
    lb.font = [UIFont systemFontOfSize:13];
    lb.frame = CGRectMake(15, 50, SW, 20);
    lb.text = @"4-20个字符，可由中英文、数字 “_”、“-”组成";
    lb.textColor = RGB(175, 175, 175, 1);
    [self.view addSubview:lb];
    UIButton * saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 87, SW-30, 40) title:@"保存" titleColor:RGB(255, 255, 255, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(saveBtnClick)];
    saveBtn.backgroundColor = RGB(32, 179, 169, 1);
    saveBtn.layer.cornerRadius = 4.2;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
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
    [_dict setValue:_tf.text forKey:@"name"];
//    [self initData];
    [self.navigationController popViewControllerAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
 
    [self.delegate getName:_tf.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//创建导航栏
-(void)createNav{
    
    self.title = @"修改昵称";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
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
