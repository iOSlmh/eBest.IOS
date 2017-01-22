//
//  AboutViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/9.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic,strong) UITextView * aboutTextView;
@end

@implementation AboutViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNav];
    
    self.aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-64)];
    NSString * str2 = @"\n    臻玉网致力于打造一个专业的玉石销售平台，提供国检认证、统一拍摄、统一包装、商品保价、全国包邮等服务。我们努力满足每一位臻玉网用户对于玉石的需求。我们坚决抵制假货，一经发现严格处理，让每一位消费者买到放心。我们的优势：\n    1.优质的供应商资源\n    臻玉网汇集了国内众多玉石生产商，而这些生产商在国内主要玉石产地及俄罗斯、阿富汗等海外玉石产地都有自己的原石矿山，每一个生产商所生产的产品品质能够得到保障。且臻玉网对入驻平台的每一个供应商都会进行严格的把控，保证每一个入驻臻玉网供应商的产品质量，无假货存在，确保为消费者提供高品质的玉石产品。\n    2.精细的产品生产线\n    与臻玉网合作的每一个生产商，从原石开采到生产加工的整个生产线，都是由同一个生产商负责，且此过程会有臻玉网的相关工作人员负责监督、把控，确保每一个环节的质量，不会存在造假情况。\n    玉器的加工主要有以下六道工序：\n    （1）开料，以翡翠而言，原石多被其他石料所包裹，要切开原石，才知道里边玉质的情况，然后再根据情况切成一片一片的玉材。\n    （2）选材，一般来说片料主要用来制作手镯，在片料上划好圈圈，镯子芯和边缘剩余部分，再考虑制作牌子花件一类的雕件。\n    （3）画样，根据剩下的镯子芯和边缘剩余部分的形态，色泽和纹裂的情况，在上面画出雕刻的图样。\n    （4）出样，根据画好的图样进行粗加工，雕出大致的形态。\n    （5）细修，在粗加工的基础上，对细节部分进行修饰和处理，使之达到最佳效果。\n    （6）抛光，对成品进行高抛光或揉抛光，又或是高抛和柔抛结合，最终得出成品。\n    3.直供直销模式的产品销售/n    臻玉网采用了由玉器生产商通过平台直接销售到消费者的直供直销模式，代替了传统销售模式，省去了传统模式中经销商、代理商、批发商、零售商各中间流通环节层层加利，降低了经营成本，为用户节省了30%-60%的费用和提供了最大的让利空间。";
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSParagraphStyleAttributeName:paragraphStyle
                                    };
    self.aboutTextView.bounces = NO;
    self.aboutTextView.backgroundColor = RGB(248, 248, 248, 1);
    self.aboutTextView.attributedText = [[NSAttributedString alloc] initWithString:str2 attributes:attributes];
    self.aboutTextView.textColor = RGB(100, 100, 100, 1);
    [self.view addSubview:self.aboutTextView];
    
}

#pragma mark ----------------------创建导航栏
-(void)createNav{
    
    self.title = @"关于臻玉堂";
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
