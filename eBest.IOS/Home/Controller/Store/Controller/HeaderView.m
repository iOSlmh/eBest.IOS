//
//  HeaderView.h
//  eBest.IOS
//
//  Created by 李明浩 on 16/9/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "HeaderView.h"
#import "Masonry.h"
#import "YYImagesCarouselView.h"
#import "UIViewExt.h"
#import "ViewController.h"
#import "DCPicScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HeaderView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *header;

@property (weak, nonatomic) IBOutlet UIView *selectBtnView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIView *carouselView;

@property (strong, nonatomic) YYImagesCarouselView *imagesCarouselView;

@property (weak, nonatomic) IBOutlet UIView *JingpinView;


@end

@implementation HeaderView

+ (instancetype)headerView {
    
    return [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createdSubViews:) name:@"itemArr" object:nil];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self createdSubViews];
    [self loadClass];
    
    _storeHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _storeHomeBtn.backgroundColor = [UIColor whiteColor];
    _storeHomeBtn.frame = CGRectMake(0,0,kScreenWidth / 2.0,_selectBtnView.height-1);
    [_storeHomeBtn setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
    [_storeHomeBtn addTarget:self action:@selector(didClickStoreHomeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_storeHomeBtn setTitle:@"商铺首页" forState:UIControlStateNormal];
    _storeHomeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_storeHomeBtn setImage:[UIImage imageNamed:@"icon1_selected_Shop home"] forState:UIControlStateNormal];
    [_selectBtnView addSubview:_storeHomeBtn];
    
 
    _stopHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopHomeBtn.backgroundColor = [UIColor whiteColor];
    _stopHomeBtn.frame = CGRectMake(kScreenWidth / 2.0,0,kScreenWidth / 2.0,_selectBtnView.height-1);
    [_stopHomeBtn setTitleColor:RGB(71, 71, 71, 1) forState:UIControlStateNormal];
    [_stopHomeBtn addTarget:self action:@selector(didClickStopHomeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_stopHomeBtn setTitle:@"全部商品" forState:UIControlStateNormal];
    _stopHomeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_stopHomeBtn setImage:[UIImage imageNamed:@"icon1_all goods"] forState:UIControlStateNormal];

    [_selectBtnView addSubview:_stopHomeBtn];
    

    //设置默认的滑动条
    _scrollLineView = [[UIView alloc]init];
    _scrollLineView.backgroundColor = RGB(32, 179, 169, 1);
    [_selectBtnView addSubview:_scrollLineView];
    [_scrollLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_storeHomeBtn.mas_bottom).offset(-3);
        make.left.mas_equalTo(_storeHomeBtn.mas_left);
        make.width.mas_equalTo(_storeHomeBtn.mas_width);
        make.height.mas_equalTo(3);
    }];
    
}
-(void)loadClass{

    _classArray = [NSMutableArray array];
    
    [RequestTools getWithURL:@"/category.mob" params:nil success:^(NSDictionary *Dict) {
        
        NSLog(@"----------------%@",Dict);
        
        _classArray = [Dict objectForKey:@"category"];
        
        NSLog(@"%lu",(unsigned long)_classArray.count);
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}

//商铺首页
//didClickStoreHomeBtn
- (void)didClickStoreHomeBtn:(UIButton *)sender {

//    [_scrollLineView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(1);
//    }];
    
}


//全部商品
//didClickStopHomeBtn
- (void)didClickStopHomeBtn:(UIButton *)sender {

    NSNotification *notification =[NSNotification notificationWithName:@"change" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (void)createdSubViews:(NSNotification*)center {
    
    NSMutableArray * marr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dic in center.userInfo[@"itemArr"]) {
        
        [marr addObject:[Image_url stringByAppendingString:dic[@"goods_main_photo_path"]]];
    }
    
    NSArray * picArr = marr;
    DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake((SW-_carouselView.size.height)/2, 0, _carouselView.size.height, _carouselView.size.height) WithImageUrls:picArr];
    picView1.AutoScrollDelay = 2.0f;
    picView1.backgroundColor = [UIColor clearColor];
    [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("你点到我了😳index:%zd\n",index);
    }];
    [_carouselView addSubview:picView1];
}

- (void)createdSubViews {
    
    CGFloat swidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (swidth - 45 - 30) / 4.0;
    
    _collectionViewLayout.itemSize = CGSizeMake(width, 25);
    _collectionViewLayout.minimumLineSpacing = 15;
    _collectionViewLayout.minimumInteritemSpacing = 10;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 22.5, 20, 22.5);
    
}

//MARK:~~  UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _classArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (![cell.contentView viewWithTag:1023]) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = RGB(123, 123, 123, 1);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 2;
        label.layer.shadowColor = RGB(0, 0, 0, 0.15).CGColor;
        label.layer.shadowOpacity = 1.0;
        label.layer.shadowRadius = 1.0;
        label.layer.shadowOffset = CGSizeMake(0, 1);
        label.clipsToBounds = NO;
        [cell.contentView addSubview:label];
        label.tag = 1023;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    NSDictionary * dic = _classArray[indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1023];
    label.text = [dic objectForKey:@"className"];
    
    return cell;
}


@end
