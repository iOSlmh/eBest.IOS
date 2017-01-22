//
//  LeftViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftCell.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createTV];
//    [self createBtn];
}

//// 创建抽屉分类按钮
//-(void)createBtn{
//    
//    for (int i = 0; i<10; i++) {
//      
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(20, i*60+49, 60, 40);
//        [btn setTitle:@"分类" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//    }
//
//}
//
//-(void)btnClick:(UIButton *)btn{
//
//
//}

-(void)createTV{
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.backgroundColor = [UIColor whiteColor];
    [self.tv registerNib:[UINib nibWithNibName:@"LeftCell" bundle:nil] forCellReuseIdentifier:@"cellID"];

}

#pragma mark ---- 抽屉滚动TV代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LeftCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    if (cell == nil) {
//        cell = [[LeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
//        
//    }
    cell.classifyLabel.text = @"商品分类";
    cell.classifyLabel.layer.cornerRadius = 10;
    cell.classifyLabel.layer.masksToBounds = YES;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
