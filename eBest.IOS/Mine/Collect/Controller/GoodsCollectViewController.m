//
//  GoodsCollectViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "GoodsCollectViewController.h"
#import "CollectCell.h"
#import "DBManager.h"
#import "DetailModel.h"

@interface GoodsCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tv;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation GoodsCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createTV];
    [self loadData];
}

#pragma mark - 从数据库读取数据
-(void)loadData
{
    DBManager * manager = [DBManager defaultManager];
    NSArray * array =[manager getData];
    DetailModel * model = array[0];
    NSLog(@"%@",model.goods_name);
    NSLog(@"%@",model.dataID);
    NSLog(@"%@",model.goods_main_photo_path);
    NSLog(@"%@",model.goods_current_price);
    NSLog(@"---------*****************%lu",(unsigned long)array.count);
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    NSLog(@"---------*****************%lu",(unsigned long)self.dataArray.count);
    [self.tv reloadData];
}

#pragma mark ----------------------创建tableview并实现其代理方法
-(void)createTV{
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
//    self.tv.bounces = NO;
    [self.tv registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //    去除分割线
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tv];
    //    设置headerView
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 45)];
    self.headerView.backgroundColor = RGB(244, 244, 244, 1);
    self.tv.tableHeaderView = self.headerView;
    //    设置筛选下拉菜单的view
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:topView];
    //    添加分类btn
    NSArray * selectTitle = @[@"样式",@"材质",@"题材",@"寓意"];
    for (int i =0; i<4; i++) {
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(i*SW/4, 0, SW/4, 44) title:selectTitle[i] titleColor:RGB(71, 71, 71, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(topSelectBtn)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [topView addSubview:btn];
    }
    
}
////    创建顶部菜单展示TV
//-(void)topSelectBtn{
//    
//    self.topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SW, 374)];
//    self.topTableView.tag = 700;
//    self.topTableView.delegate = self;
//    self.topTableView.dataSource = self;
//    self.topTableView.bounces = NO;
//    self.topTableView.showsHorizontalScrollIndicator = NO;
//    self.topTableView.showsVerticalScrollIndicator = NO;
//    self.topTableView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:self.topTableView];
//    self.bottomView = [FactoryUI createViewWithFrame:self.tv.frame];
//    self.bottomView.alpha = 0.5;
//    self.bottomView.backgroundColor = [UIColor grayColor];
//    [self.tv addSubview:self.bottomView];
//    [_collectionView addSubview:self.bottomView];
//    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemove)];
//    [self.bottomView addGestureRecognizer:recognizer];
//    
//}
//     手势移除菜单展示
//-(void)tapRemove{
//    
//    [self.topTableView removeFromSuperview];
//    [self.bottomView removeFromSuperview];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 125;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    DetailModel * model = [[DetailModel alloc]init];
    if (self.dataArray) {
        
        DetailModel * model = self.dataArray[indexPath.row];
        cell.descLabel.text = model.goods_name;
        cell.descLabel.textColor = RGB(71, 71, 71, 1);

        cell.currentPrice.text = [NSString stringWithFormat:@"¥%@",model.goods_current_price];
        cell.currentPrice.textColor = RGB(255, 98, 72, 1);
        cell.originalPrice.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
        cell.originalPrice.textColor = RGB(183, 183, 183, 1);
        NSString * str = model.goods_main_photo_path;
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        
        [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        
    }
    
    
//        cell.layer.borderWidth = 0.5;
//        cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
        return cell;
    
}
//实现cell的删除
//设置编辑cell的类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//设置cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除的思路：1.先删除数据库中的数据，2.然后删除界面的cell，3.最后刷新界面
    DBManager * manager = [DBManager defaultManager];
    DetailModel * model = self.dataArray[indexPath.row];
    [manager deleteNameFromTable:model.dataID];
    
    //删除cell
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //刷新界面
    //[_tableView reloadData];
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
