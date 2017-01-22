//
//  RetMoneyViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/18.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RetMoneyViewController.h"
#import "PlaceholderTextView.h"
@interface RetMoneyViewController ()<UITextViewDelegate,UITextViewDelegate>

{

    PlaceholderTextView * _ptview;
    NSInteger _number;
    UILabel * lab;
}
@end

@implementation RetMoneyViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNav];
    self.view.backgroundColor=RGB(236, 235, 235, 1);
    _ptview=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 51, SW, 120)];
    _ptview.delegate = self;
    _ptview.placeholder=@"请输入申请说明";
    _ptview.font=[UIFont systemFontOfSize:14];
    _ptview.placeholderFont=[UIFont systemFontOfSize:13];
    _number = 0;
    lab = [[UILabel alloc]initWithFrame:CGRectMake(SW-65, _ptview.frame.size.height-20, 50, 10)];
    lab.textColor = RGB(175, 175, 175, 1);
    lab.font = [UIFont systemFontOfSize:10];
    lab.text = [NSString stringWithFormat:@"%ld/250",_number];
    [_ptview addSubview:lab];
    [self.view addSubview:_ptview];
    

}
//实现计算字数代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        return NO;
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    else if (range.location>=500)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}
//计算可输入剩余字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString  * nsTextContent=textView.text;
    _number=[nsTextContent length];
   lab.text = [NSString stringWithFormat:@"%ld/250",_number];
    NSLog(@"%ld",(long)_number);
}
//创建导航栏
-(void)createNav{
    
    self.title = @"申请退款";
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];

    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)retMoneyClick:(UIButton *)sender {
    
    NSDictionary * dic = @{@"of_id":self.ofID,@"refund_reason":_ptview.text};
    [RequestTools posUserWithURL:@"/goods_refund.mob" params:dic success:^(NSDictionary *Dict) {
        
        NSLog(@"%@",Dict);
        NSLog(@"%@",Dict[@"return_info"][@"message"]);
    } failure:^(NSError *error) {
        
    }];
        
}

//点击return 按钮取消第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
