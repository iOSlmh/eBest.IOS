//
//  SearchBarController.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SearchBarController.h"
#import "SearchTableViewCell.h"
#import "ListViewCell.h"
#import "DetailViewController.h"
@interface SearchBarController ()<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * notesTableView;//搜索记录的 tableview
@property (strong, nonatomic) UITableView * searchTableView;//搜索的 tableview
@property (strong, nonatomic) UIScrollView * notesHeadScrollView;
@property (strong, nonatomic) NSMutableArray * notesArray;// 存放搜索历史记录数组
@property (nonatomic,strong) NSArray * searchModelArray; // 存放网络数据 数组
@property (strong, nonatomic) NSMutableArray * muArr;

@property (strong, nonatomic) UIView * heatSearcheView;//热搜的 View
@property (nonatomic, strong) UIView * notesHeadView;// 搜索历史记录 页面 上面一个view
@property (nonatomic, strong) UIView * notesFootView;// 搜索历史记录 页面 下面一个view
@property (nonatomic, strong) UIView * cellHeadView;// 搜索商品时 设置cell 的headvie 的view
@property(nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic, strong) UIView * searchBarView;
@property (nonatomic, strong) UIButton * searchButton;
@property (nonatomic, strong) UIButton * audioButton;

@end

@implementation SearchBarController
@synthesize notesTableView,audioButton,searchButton,notesHeadScrollView,heatSearcheView,notesFootView,notesArray;
//当试图将要出现时隐藏
-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewDidAppear:(BOOL)animated{

 [self.searchBar becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)setNav{
    
    //修改状态栏背景颜色
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SW, 20)];
//    statusBarView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:statusBarView];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.shadowImage = [FactoryUI imageWithColor:RGB(237, 237, 237, 1) size:CGSizeMake(SW, 1)];
    
    UIButton * leftBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"" titleColor:nil imageName:@"nav_return" backgroundImageName:@"" target:self selector:@selector(backClick)];
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton * rightBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 0, 50, 30) title:@"搜索" titleColor:RGB(49, 28, 109, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(searchClick)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftBtnItem, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,rightBtnItem, nil];
    
    [self createSearchBarView];
    self.navigationItem.titleView = self.searchBarView;

}

//设置返回按钮点击事件
-(void)backClick{
  
    [self.navigationController popViewControllerAnimated:YES];
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
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索店铺/商品            ";
    self.searchBar.delegate = self;

    return self.searchBar;
}

//#pragma  mark 设置语音搜索
//- (UIButton *)createAudioButton
//{
//    audioButton = [[UIButton alloc]initWithFrame:CGRectMake(self.searchBar.frame.size.width*0.9, 5, 15 ,20)];
//    [audioButton setBackgroundImage:[UIImage imageNamed:@"audio_nav_icon"] forState:UIControlStateNormal];
//    [audioButton addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    return audioButton;
//}
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
    _searchTableView = [[ UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-66) style:UITableViewStylePlain];
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
    
    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:@"http://192.168.1.148:9000/site/mobile/search.mob" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        NSLog(@"qqqq");
////        NSArray * arr = responseObject[]
//        
//        
//                [_searchTableView reloadData];
//
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
//    [CTHttpTool postWithURL:URL params:dict success:^(NSDictionary *Dict) {
//        // NSLog(@"*****%@",Dict);
//        NSArray *array =[[Dict objectForKey:@"data"] objectForKey:@"items"];
//        
//        self.searchModelArray = [SearchViewModel mj_objectArrayWithKeyValuesArray:array];
//        
//        [_searchTableView reloadData];
//        
//    }failure:^(NSError *error) {
//        
//    }];
    
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
    self.notesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 96, SW, 30*notestable) style:UITableViewStylePlain];
    self.notesTableView.backgroundColor = RGB(220, 220, 220,1);
    self.notesTableView.delegate = self;
    self.notesTableView.dataSource = self;
    
    [self.view addSubview:self.notesTableView];
}

#pragma  mark 设置 历史搜索记录 头部分
- (UIView *)createNotesHeadView
{
    _notesHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 90)];
    _notesHeadView.backgroundColor = RGB(220, 220, 220,1);
    
    UIScrollView * notesScrollView = [self createNotesHeadScrollView];
    notesScrollView.backgroundColor = RGB(255, 250, 250,1);
    [_notesHeadView addSubview:notesScrollView];
    
    UIButton * historyBtn = [self historyNotesButtton];
    [_notesHeadView addSubview:historyBtn];
    
    [self.view addSubview:_notesHeadView];
    
    return _notesHeadView;
}

#pragma  mark 设置 历史搜索记录 头部分的 scrollView
- (UIScrollView *)createNotesHeadScrollView
{
    notesHeadScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SW, 50)];
    notesHeadScrollView.delegate = self;
    notesHeadScrollView.bounces = NO;
    notesHeadScrollView.showsHorizontalScrollIndicator = NO;
    notesHeadScrollView.pagingEnabled = NO;
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    NSArray * titleArr = @[@"热搜",@"吊坠",@"项链",@"戒指",@"手链",@"耳饰",@"摆件",@"把件",@"挂件",@"配饰",@"其他"];
    for (int i = 0; i < titleArr.count; i ++) {
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat length = [titleArr[i] boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //创建热搜按钮
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(10+w, 15, length+10, 20) title:titleArr[i] titleColor:RGB(90, 90, 90,1) imageName:nil backgroundImageName:nil target:self selector:@selector(buttonSearchClick:)];
        
         w = btn.frame.size.width + btn.frame.origin.x;
        //热搜标题区分
        if (i==0) {
            
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
        }else{
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.layer.cornerRadius = 5;
            btn.backgroundColor = RGB(220, 220, 220,1);
        }
        
        [notesHeadScrollView addSubview:btn];
    }
    notesHeadScrollView.contentSize = CGSizeMake(SW*2, 0);
    return notesHeadScrollView;
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
    notesFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 30*notes+96+30, SW, 30)];
    UIButton *cvi = [self emptyNotesButtton];
    [notesFootView addSubview:cvi];
    [self.view addSubview:notesFootView];
    
    return notesFootView;
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
        cell.currentPriceLabel.text = Money([dic[@"goods_current_price"] floatValue]);
//        cell.originalPrice.text = Money([dic[@"goods_price"] floatValue]);
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:Money([dic[@"goods_price"] floatValue]) attributes:attribtDic];
        
        // 赋值
        cell.originalPrice.attributedText = attribtStr;
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
        
    }else if (tableView == self.searchTableView){
        
        DetailViewController * detailVC = [[DetailViewController alloc]init];
        [detailVC loadDataWithID:self.muArr[indexPath.row][@"id"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma  mark 设置 历史搜索 button
- (UIButton *)historyNotesButtton
{
    UIButton * historyNotesButtton = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, SW, 35)];
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
    heatSearcheView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SW, SH/3)];
    heatSearcheView.userInteractionEnabled = YES;
    heatSearcheView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:heatSearcheView];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 30)];
    [btn1 setTitle:@"热搜" forState:UIControlStateNormal];
    [btn1 setTitleColor:RGB(41, 36, 33, 1) forState:UIControlStateNormal];
    [heatSearcheView addSubview:btn1];
    
    NSArray * hotArr = @[@"手镯",@"吊坠",@"项链",@"和田玉",@"智能手环",@"蛋糕",@"旅行箱",@"坚果",@"华为mate8",@"音响",@"格力品牌空调促销",@"童书优惠",@"豆浆机",@"红酒"];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 60;//用来控制button距离父视图的高
    int j = 0;  //记录行数
    for (int i = 0; i < hotArr.count; i++) {
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat length = [hotArr[i] boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        CGRect rect = CGRectMake(10 + w, h, length + 15+14 , 25);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > SW){
            j++;
            w = 0; //换行时将w置为0
            h = h + 25 + 15;//距离父视图也变化
            rect = CGRectMake(10 + w, h, length + 15, 25);//重设button的frame
        }
        
        //创建热搜按钮
        UIButton * btn = [FactoryUI createButtonWithFrame:CGRectMake(10+w, h+15, length+10, 25) title:hotArr[i] titleColor:RGB(90, 90, 90,1) imageName:nil backgroundImageName:nil target:self selector:@selector(buttonSearchClick:)];
        w = btn.frame.size.width + btn.frame.origin.x;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 10;
        btn.backgroundColor = RGB(255, 250, 250, 1);
        [btn setTitleColor:RGB(90, 90, 90, 1) forState:UIControlStateNormal];
        
        [heatSearcheView addSubview:btn];
        
    }
    
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
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/notes.txt",path];
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
    NSString *fileName = [NSString stringWithFormat:@"%@/Documents/notes.txt",path];
    NSMutableArray *filedataArray = [NSMutableArray arrayWithContentsOfFile:fileName];
    if (filedataArray == nil) {
        //  NSLog(@"文件读取失败");

    }
    return filedataArray;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    [self searchClick];
}
#pragma  mark 点击空白处键盘隐藏
- (void)createKeyboard {
    
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SW, SH)];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [backView addGestureRecognizer:singleTouch];
    [self.view addSubview:backView];
    
    
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}





//-(void)setSearchBar{
//
//    [self.searchBar becomeFirstResponder];
//    self.searchBar.delegate = self;
//    self.searchBar.tintColor = [UIColor whiteColor];
//    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
//    searchField.textColor = RGB(100, 80, 100, 1);
//
//}




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
