//
//  AgreementViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/12/2.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;

@end

@implementation AgreementViewController

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
    [self setNav];
    self.webView  = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)];
    self.webView.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"agree" ofType:@"html"];
    
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:html baseURL:nil];
    [self.webView setScalesPageToFit:YES];
    
    [self.view addSubview:self.webView];
}
//- (void)webViewDidFinishLoad:(UIWebView *)theWebView
//{
//    NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
//                             "meta.name = 'viewport';"
//                             "meta.content = 'width=device-width, initial-scale=1.0,minimum-scale=0.2, maximum-scale=2.0, user-scalable=yes';"
//                             "document.getElementsByTagName('head')[0].appendChild(meta);"
//                             ];
//    [self.webView  stringByEvaluatingJavaScriptFromString:js_fit_code];
//
//}
-(void)setNav{

    self.title = @"用户协议";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
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
