//
//  SearchOderViewController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/10.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SearchOderViewController.h"
#import "SearchTableViewCell.h"
#import "ListViewCell.h"

@interface SearchOderViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic, strong) UIView * searchBarView;
@property (strong, nonatomic) UITableView * notesTableView;//搜索记录的 tableview
@property (strong, nonatomic) UITableView * searchTableView;//搜索的 tableview
@property (strong, nonatomic) NSMutableArray * notesArray;// 存放搜索历史记录数组
@property (nonatomic,strong) NSArray * searchModelArray; // 存放网络数据 数组
@property (strong, nonatomic) NSMutableArray * muArr;
@property (nonatomic, strong) UIView * notesHeadView;// 搜索历史记录 页面 上面一个view
@property (nonatomic, strong) UIView * notesFootView;// 搜索历史记录 页面 下面一个view
@property (nonatomic, strong) UIView * cellHeadView;// 搜索商品时 设置cell 的headvie 的view
@property (strong, nonatomic) UIView * heatSearcheView;//热搜的 View

@end


@implementation SearchOderViewController
@synthesize notesTableView,notesFootView,notesArray,heatSearcheView;

-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
 
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNav];
    [self createKeyboard];
    
    if ([self readDatafromSandBox] != NULL) {
        
        notesArray = [[self readDatafromSandBox] mutableCopy];
    }else{
        
        notesArray = [NSMutableArray array];
    }

    
    if (notesArray.count == 0) {
        
        UIView *ver = [self createSearchHootView];
        [self.view addSubview:ver];
    }
    else{
        
        [self createNotesTableView];
        [self createNotesHeadView];
        [self createNotesFootView];
    }

}

#pragma  mark 设置 搜索历史 UI
- (void)createNotesTableView
{
    NSUInteger notestable;
    if (notesArray.count > 7) {
        notestable = 7;
    }
    else
        notestable = notesArray.count;
    NSLog(@"----------------%lu",(unsigned long)notestable);
    self.notesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SW, 30*notestable) style:UITableViewStylePlain];
    self.notesTableView.backgroundColor = RGB(220, 220, 220,1);
    self.notesTableView.delegate = self;
    self.notesTableView.dataSource = self;
    
    [self.view addSubview:self.notesTableView];
}
#pragma  mark 设置 cell 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.notesTableView) {
        if (notesArray.count > 7 ) {
            return 7;
        }
        else
            return notesArray.count;
    }
    else
        return _muArr.count;
}

#pragma  mark 设置每个 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"sss";
    if (tableView == self.notesTableView) {
        UITableViewCell * hootcell = nil;
        hootcell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (hootcell == nil) {
            hootcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        hootcell.textLabel.text = [notesArray objectAtIndex:indexPath.row];
        hootcell.textLabel.textColor = RGB(192, 192, 192,1);
        hootcell.textLabel.font=[UIFont boldSystemFontOfSize:15];
        return hootcell;
    }
    else if (tableView == _searchTableView) {
        
        ListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = RGB(247, 247, 247, 1).CGColor;
        NSDictionary * dic = _muArr[indexPath.row];
        cell.nameLabel.text = dic[@"goods_name"];
        cell.currentPriceLabel.text = [dic[@"goods_current_price"] stringValue];
        cell.originalPrice.text = [dic[@"goods_price"] stringValue];
        NSString * str = dic[@"goods_main_photo_path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
        
        
        
        
        return cell;
        
        
        //        SearchTableViewCell * searchCell = nil;
        //        searchCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        //        if (searchCell == nil) {
        //            searchCell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        //            [searchCell refreshSearchData];
        //        }
        
        //        searchCell.searchModel = self.searchModelArray[indexPath.row];
        //        [searchCell refreshSearchData];
        
        //        return searchCell;
    }
    else return nil;
}

#pragma  mark 设置 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.notesTableView) {
        return 30;
    }
    else if (tableView == _searchTableView) {
        return 125;
    }
    else
        return 0;
}

#pragma  mark 设置 cell 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma  mark 设置 cell 点击时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.notesTableView) {
        NSString *str = [notesArray objectAtIndex:indexPath.row];
        self.searchBar.text = str;
    }
}

#pragma  mark 设置 历史搜索记录 头部分
- (UIView *)createNotesHeadView
{
    _notesHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 35)];
    _notesHeadView.backgroundColor = RGB(220, 220, 220,1);
    
    UIButton * historyBtn = [self historyNotesButtton];
    [_notesHeadView addSubview:historyBtn];
    
    [self.view addSubview:_notesHeadView];
    
    return _notesHeadView;
}
#pragma  mark 设置 历史搜索记录 尾部分
- (UIView *)createNotesFootView
{
    NSUInteger notes;
    if (notesArray.count > 7) {
        notes = 7;
    }
    else
        notes = notesArray.count;
    notesFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 30*notes+35+30, SW, 30)];
    UIButton *cvi = [self emptyNotesButtton];
    [notesFootView addSubview:cvi];
    
    [self.view addSubview:notesFootView];
    
    return notesFootView;
}

#pragma  mark 设置 历史搜索 button
- (UIButton *)historyNotesButtton
{
    UIButton * historyNotesButtton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SW, 35)];
    [historyNotesButtton setTitle:@"   历史搜索" forState:UIControlStateNormal];
    [historyNotesButtton setTitleColor:RGB(192, 192, 192,1) forState:UIControlStateNormal];
    [historyNotesButtton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    historyNotesButtton.backgroundColor = [UIColor whiteColor];
    return historyNotesButtton;
}

#pragma  mark 设置 清空历史搜索 button
- (UIButton *)emptyNotesButtton
{
    UIButton * emptyButton = [[UIButton alloc] initWithFrame:CGRectMake(SW*0.2, 0, SW*0.6, 30)];
    [emptyButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [emptyButton setTitleColor:RGB(192, 192, 192,1) forState:UIControlStateNormal];
    emptyButton.backgroundColor = [UIColor whiteColor];
    emptyButton.layer.cornerRadius = 3;
    emptyButton.layer.borderWidth = 1.0f;
    emptyButton.layer.borderColor = RGB(179, 169, 169, 1).CGColor;
    [emptyButton addTarget:self action:@selector(emptyClick) forControlEvents:UIControlEventTouchUpInside];
    
    return emptyButton;
}

#pragma  mark 设置 清空历史搜索 button 触发事件
- (void)emptyClick
{
    notesArray = [[NSMutableArray alloc]init];
    
    [self saveDataToSandBox:notesArray];
    
    UIView *hootButtonView = [self createSearchHootView];
    [self.view addSubview:hootButtonView];
    [_notesHeadView removeFromSuperview];
    [self.notesTableView removeFromSuperview];
    [notesFootView removeFromSuperview];
}
#pragma  mark 设置无搜索历史时显示的 View
- (UIView *)createSearchHootView
{
    heatSearcheView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SW, SH)];
    heatSearcheView.userInteractionEnabled = YES;
    heatSearcheView.backgroundColor = [UIColor clearColor];
    UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake((SW-150)/2, 150, 150, 40)];
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setTitle:@"无搜索记录" forState:UIControlStateNormal];
    [btn3 setTitleColor:RGB(183, 183, 183, 1) forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn3.layer.cornerRadius = 10;
    btn3.layer.borderWidth = 1.0f;
    btn3.layer.borderColor = RGB(179, 169, 169, 1).CGColor;
    [btn3 addTarget:self action:@selector(buttonSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [heatSearcheView addSubview:btn3];

    [self.view addSubview:heatSearcheView];
    
    return heatSearcheView;
}

#pragma  mark 设置选择button点击触发事件
- (void)buttonSearchClick:(UIButton *)sender
{
    
    UIButton * button = (UIButton *)sender;
    NSString * buttonStr = button.currentTitle;
    NSLog(@"----------------%@",button.currentTitle);
    self.searchBar.text = buttonStr;
    [notesArray addObject:buttonStr];
    [self saveDataToSandBox:notesArray];
    [self.notesTableView reloadData];
    
}

#pragma  mark 设置 历史记录存入沙盒
- (void)saveDataToSandBox:(NSMutableArray *)dataArray
{
    NSString *path = NSHomeDirectory();
    NSLog(@"%@",path);
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/oder.txt",path];
    if ([dataArray writeToFile:filePath atomically:YES]) {
        // NSLog(@"文件写入成功");
    }
    else {
        //  NSLog(@"文件写入失败");
    }
}

#pragma  mark 设置 从沙盒读取 搜索历史记录
- (NSMutableArray *)readDatafromSandBox
{
    NSString *path =NSHomeDirectory();
    NSString *fileName = [NSString stringWithFormat:@"%@/documents/oder.txt",path];
    NSMutableArray *filedataArray = [NSMutableArray arrayWithContentsOfFile:fileName];
    if (filedataArray == nil) {
        //  NSLog(@"文件读取失败");
        
    }
    return filedataArray;
}

#pragma  mark 设置 搜索框内容改变时的 状态
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchTableView removeFromSuperview];
    if (self.searchBar.text != nil && self.searchBar.text.length > 0) {
        [self.searchTableView removeFromSuperview];
        
        [_notesHeadView removeFromSuperview];
        [self.notesTableView removeFromSuperview];
        [notesFootView removeFromSuperview];
        [self createSearchTableView];
        [self setShopURL];
    }
    else {
        NSMutableArray *tmpNotesArray = [NSMutableArray new];
        tmpNotesArray = [self readDatafromSandBox];
        NSLog(@"%ld",tmpNotesArray.count);
        if (tmpNotesArray.count == 0) {
            
            [_searchTableView removeFromSuperview];
            UIView * heatSearches = [self createSearchHootView];
            [self.view addSubview:heatSearches];
        }
        else {
            [_notesHeadView removeFromSuperview];
            [self.notesTableView removeFromSuperview];
            [notesFootView removeFromSuperview];
            [heatSearcheView removeFromSuperview];
            [self createNotesHeadView];
            [self createNotesTableView];
            [self createNotesFootView];
        }
    }
}


#pragma  mark 设置 搜索 UI
- (void)createSearchTableView
{
    _searchTableView = [[ UITableView alloc]initWithFrame:CGRectMake(0, 64, SW, SH-66) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    [_searchTableView registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    //    _searchTableView.tableHeaderView = [CellHeadView createCellHeadView];
    
    [self.view addSubview:_searchTableView];
}

- (void)setShopURL
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:@{@"keyword":self.searchBar.text}];
    [RequestTools postWithURL:@"/search.mob" params:dict success:^(NSDictionary *Dict) {
        NSLog(@"%@",Dict);
        _muArr = [NSMutableArray array];
        _muArr = Dict[@"goods_list"];
        
        
        [_searchTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma  mark 设置 搜索按钮点击 触发事件
- (void)searchClick
{
    [self.searchBar resignFirstResponder]; // 点击搜索时隐藏键盘
    
    if (self.searchBar.text != nil && self.searchBar.text.length > 0)
    {
        [self createSearchTableView];
        [heatSearcheView removeFromSuperview];
        [self setShopURL];
    }
    else {
        if (notesArray.count != 0) {
            
            [_notesHeadView removeFromSuperview];
            [self.notesTableView removeFromSuperview];
            [notesFootView removeFromSuperview];
            [heatSearcheView removeFromSuperview];
            [self createNotesTableView];
            [self createNotesHeadView];
            [self createNotesFootView];
        }
        else {
            [_searchTableView removeFromSuperview];
            UIView *heatvcr = [self createSearchHootView];
            [self.view addSubview:heatvcr];
        }
    }
}
#pragma  mark 点击空白处键盘隐藏
- (void)createKeyboard {
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SW, SH)];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [backView addGestureRecognizer:singleTouch];
    
    [self.view addSubview:backView];
    
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

-(void)setNav{
    
    //修改状态栏背景颜色
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, SW, 20)];
//    statusBarView.backgroundColor=[UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:statusBarView];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(237, 237, 237, 1) size:CGSizeMake(SW, 1)];
    
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton * rightBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"搜索" titleColor:RGB(49, 28, 109, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(searchClick)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    [self createSearchBarView];
    self.navigationItem.titleView = self.searchBarView;
}

//设置返回按钮点击事件
-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark 设置导航栏加载搜搜框
- (void)createSearchBarView
{
    self.searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW*0.6, 30)];
    self.searchBarView.backgroundColor = [UIColor clearColor];
    
    UISearchBar * search = [self createSearchBar];
    [self.searchBarView addSubview:search];
    
}

#pragma  mark 设置搜索框
- (UISearchBar *)createSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SW*0.6, 30)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索店铺/商品       ";
    self.searchBar.delegate = self;
    
    return self.searchBar;
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
