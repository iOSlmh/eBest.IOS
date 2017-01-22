//
//  SettingViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/20.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SettingViewController.h"
#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()
{
    CGFloat _huancun;
}

@property(nonatomic,strong) NSDictionary * mesDict;
@property(nonatomic,strong) UIImageView * headImageV;
@property(nonatomic,strong) UILabel * nameLabel;

@end


@implementation SettingViewController


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(236, 235, 235, 1);
    [self createNav];
    [self createUI];
    
}

-(void)loadData{
    
     
    [RequestTools getUserWithURL:@"/user_info.mob" params:nil success:^(NSDictionary *Dict) {
        
        _mesDict = Dict[@"user_info"];
        NSLog(@"----------------%@",_mesDict);
       
        if ([_mesDict[@"photo"] isEqual:[NSNull null]]){
        
            NSLog(@"----------------jdhjdk*********************");
        }
        NSLog(@"----------------%@",_mesDict[@"photo"]);
        NSString * path = _mesDict[@"photo"][@"path"];
        NSLog(@"----------------%@",path);
        NSString * nameStr = _mesDict[@"mobile"];
        //此处无头像是nsnull返回  无法判断
        //NSString * path = @"";
        if (kIsEmptyString(path)) {
            
            [_headImageV setImage:[UIImage imageNamed:@"默认头像"]];
            
        }else{
            
            HeadImageWithUrl(_headImageV, path);

        }
        if (kIsEmptyString(nameStr)) {
            
            _nameLabel.text = @"";
            
        }else{
            
            _nameLabel.text = nameStr;
            
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

//布局UI
-(void)createUI{
    
//第一个View
    UIView * topView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 225)];
    topView.backgroundColor = [UIColor whiteColor];
    NSArray * arr = @[@"清理缓存",@"当前版本",@"关于臻玉堂"];
    for (int i =0; i<3; i++) {
        UILabel * label = [FactoryUI createLabelWithFrame:CGRectMake(14, 93+i*50, 100, 15) text:arr[i] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:15]];
        [topView addSubview:label];
        UILabel * line = [FactoryUI createLabelWithFrame:CGRectMake(16.5, 74.5+i*50, SW-16.5, 1) text:@"" textColor:nil font:nil];
        line.backgroundColor = RGB(236, 235, 235, 1);
        [topView addSubview:line];
    }
//    添加个人信息编辑按钮
    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SW, 75)];
    [clearBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:clearBtn];
    [self.view addSubview:topView];
//    添加清理缓存按钮
//    UILabel * huancun = [FactoryUI createLabelWithFrame:CGRectMake(SW-65, 93, 50, 15) text:[NSString stringWithFormat:@"%.2fM",_huancun] textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:14]];
//    huancun.textAlignment = NSTextAlignmentRight;
//    [topView addSubview:huancun];
    UIImageView * hcarrow = [FactoryUI createImageViewWithFrame:CGRectMake(SW-30, 93, 8, 15) imageName:@"personal center_right arrow"];
    [topView addSubview:hcarrow];
    UIButton * huancunBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 75, SW, 50)];
    [huancunBtn addTarget:self action:@selector(huancunClick) forControlEvents:UIControlEventTouchUpInside];
    huancunBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:huancunBtn];
    UILabel * edition = [FactoryUI createLabelWithFrame:CGRectMake(SW-36, 125, 30, 50) text:@"1.0.1" textColor:RGB(210, 210, 210, 1) font:[UIFont systemFontOfSize:15]];
    [topView addSubview:edition];
    UIButton * aboutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 175, SW, 50)];
    [aboutBtn addTarget:self action:@selector(guayuClick) forControlEvents:UIControlEventTouchUpInside];
    aboutBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:aboutBtn];


//    头像
    _headImageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 15, 45, 45) imageName:@""];
    _headImageV.backgroundColor = RGB(32, 179, 169, 1);
    _headImageV.layer.cornerRadius = 22.5;
    _headImageV.layer.masksToBounds = YES;
    
//    if (kIsEmptyString(_headImageStr)) {
//        
//        [_headImageV setImage:[UIImage imageNamed:@"默认头像"]];
//        
//    }else{
//    
//        [_headImageV sd_setImageWithURL:[NSURL URLWithString:_headImageStr] placeholderImage:[UIImage imageNamed:@"默认头像"]options:SDWebImageRefreshCached];
//    
//    }
//    
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(70, 17, 100, 21) text:@"" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:15]];
    UILabel * Label = [FactoryUI createLabelWithFrame:CGRectMake(70, 38, 120, 21) text:@"编辑个人信息" textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:14]];
;
//    _nameLabel.text = _nameStr;
    UIImageView * arrow = [FactoryUI createImageViewWithFrame:CGRectMake(SW-30, 30, 8, 15) imageName:@"personal center_right arrow"];
    [topView addSubview:arrow];
    [topView addSubview:_nameLabel];
    [topView addSubview:Label];
    [topView addSubview:_headImageV];
    
    UIView * bottomView = [FactoryUI createViewWithFrame:CGRectMake(0, 236, SW, 48)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];

    UIButton * exitBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 80, 15) title:@"退出登录" titleColor:RGB(37, 83, 183, 1) imageName:@"exit1" backgroundImageName:@"" target:self selector:@selector(exitClick)];
    exitBtn.center = bottomView.center;
    [self.view addSubview:exitBtn];
}
//退出点击事件
-(void)exitClick{

    UIAlertView * exitAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    exitAlert.tag = 0;
    
    [exitAlert show];
}
//清理缓存按钮点击事件
-(void)huancunClick{

    //清理缓存
    [self folderSizeWithPath:[self getPath]];

}
-(void)guayuClick{

    AboutViewController * aboutVC = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
    
}
//编辑个人信息按钮点击事件
-(void)btnClick{
    
    PersonalViewController * personalVC = [[PersonalViewController alloc]init];
    [self.navigationController pushViewController:personalVC animated:YES];

}

#pragma mark - 清理缓存
//计算缓存文件的大小
//首先需要获取缓存文件的路径
-(NSString *)getPath
{
    //缓存文件是存在于沙盒目录下library文件夹下的cache文件夹
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

-(CGFloat)folderSizeWithPath:(NSString *)path
{
    //初始化一个文件管理类
    NSFileManager * fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    
    //加以判断，如果文件夹存在的话计算大小
    if ([fileManager fileExistsAtPath:path])
    {
        //获取文件夹下的文件路径
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray)
        {
            //获取子文件
            NSString * subFile = [path stringByAppendingPathComponent:fileName];
            long fileSize = [fileManager attributesOfItemAtPath:subFile error:nil].fileSize;//字节数
            folderSize += fileSize / 1024.0 / 1024.0;
        }
        //删除文件
        [self showTipView:folderSize];
        return folderSize;
    }
   
    return 0;
    
}

-(void)showTipView:(CGFloat)folderSize
{
    if (folderSize > 0.01) {
        //提示用户清除缓存
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存文件有%.2fM,是否清除？",folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        //提示用户缓存已经清理过了
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存文件已经被清除" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

//实现alertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        if (buttonIndex == 1)
        {
            //调用接口退出
            [RequestTools posUserWithURL:@"/logout.mob" params:nil success:^(NSDictionary *Dict) {
                NSLog(@"----------------%@",Dict);
                if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]){
                
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_Key];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_user];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"********************退出成功**********************");
                    [AlertShow showAlert:@"退出成功!"];
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayAction) userInfo:nil repeats:NO];
                    
                }else{
                   
                    [AlertShow showAlert:@"退出失败!"];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    if (alertView.tag==1) {
    
        if (buttonIndex == 1)
        {
            //确定删除，彻底删除文件
            [self cleaderCacheFileWithPath:[self getPath]];
        }
    }
}

-(void)delayAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
/**
 *   清理缓存
 */
-(void)cleaderCacheFileWithPath:(NSString *)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray) {
            //可以按情况过滤掉不想删除的文件
            if ([fileName hasSuffix:@"mp3"]) {
                NSLog(@"不删除");
                return;
            }
            else
            {
                NSString * filepath = [path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:filepath error:nil];
            }
        }
        
    }
}

#pragma mark ----------------------创建导航栏
-(void)createNav{
    
    self.title = @"账户设置";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(226, 226, 226, 1) size:CGSizeMake(SW, 1)];
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
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


@end
