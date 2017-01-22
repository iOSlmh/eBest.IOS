//
//  HeaderView.m
//  LYM
//
//  Created by 连艳敏 on 16/7/31.
//  Copyright © 2016年 连艳敏. All rights reserved.
//

#import "HeaderView.h"
#import "Masonry.h"
#import "YYImagesCarouselView.h"
#import "UIViewExt.h"
#import "ViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HeaderView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *header;

@property (weak, nonatomic) IBOutlet UIView *selectBtnView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIView *carouselView;

@property (strong, nonatomic) YYImagesCarouselView *imagesCarouselView;

@property (strong,nonatomic)UIView *scrollLineView;//btn下面的滑动条

@end

@implementation HeaderView

+ (instancetype)headerView {
    return [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self createdSubViews];
    
    
//    UIButton *storeHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    storeHomeBtn.backgroundColor = [UIColor redColor];
//    storeHomeBtn.frame = CGRectMake(0,0,kScreenWidth / 2.0,_selectBtnView.height);
//    [storeHomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//    [storeHomeBtn setTitle:@"商铺首页" forState:UIControlStateNormal];
//    
//    [_selectBtnView addSubview:storeHomeBtn];
// 
//    UIButton *stopHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    stopHomeBtn.backgroundColor = [UIColor greenColor];
//    stopHomeBtn.frame = CGRectMake(kScreenWidth / 2.0,0,kScreenWidth / 2.0,_selectBtnView.height);
//    [stopHomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [stopHomeBtn setTitle:@"商铺首页" forState:UIControlStateNormal];
//    [_selectBtnView addSubview:stopHomeBtn];
    
    
    
    NSDictionary *btnDic = @{
                             @"BGcolorArr":@[[UIColor redColor],[UIColor greenColor]],
                             @"titleArr":@[@"商铺首页1",@"商铺首页2"]
                             };
    for (int i = 0; i < 2; i ++) {
        UIButton *storeHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        storeHomeBtn.backgroundColor = btnDic[@"BGcolorArr"][i];
        storeHomeBtn.frame = CGRectMake(kScreenWidth / 2.0 * i,0,kScreenWidth / 2.0,_selectBtnView.height);
        [storeHomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [storeHomeBtn setTitle:btnDic[@"titleArr"][i] forState:UIControlStateNormal];
        [storeHomeBtn addTarget:self action:@selector(storeHomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        storeHomeBtn.tag = 500 + i;
        [_selectBtnView addSubview:storeHomeBtn];
        
    }
    
    //设置默认的滑动条
    _scrollLineView = [[UIView alloc]init];
    _scrollLineView.backgroundColor = [UIColor blueColor];
    [_selectBtnView addSubview:_scrollLineView];
    
    UIButton *storeHomeBtn = [self viewWithTag:500];
    
    [_scrollLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(storeHomeBtn.mas_bottom).offset(-3);
        make.left.mas_equalTo(storeHomeBtn.mas_left);
        make.width.mas_equalTo(storeHomeBtn.mas_width);
        make.height.mas_equalTo(3);
    }];

    
}

- (void)createdSubViews {
    
    CGFloat swidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (swidth - 45 - 30) / 4.0;
    
    _collectionViewLayout.itemSize = CGSizeMake(width, 25);
    _collectionViewLayout.minimumLineSpacing = 15;
    _collectionViewLayout.minimumInteritemSpacing = 10;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 22.5, 20, 22.5);
    
    _imagesCarouselView = [YYImagesCarouselView imagesCarouselView];
    [_carouselView addSubview:_imagesCarouselView];
    [_imagesCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_carouselView);
    }];
    _imagesCarouselView.timeAction = 2;
    _imagesCarouselView.itemSize = CGSizeMake(375, 256);
    [_imagesCarouselView cellClassWith:^id{
        return @"ImagesCarouselViewCell";
    }];
    
    [_imagesCarouselView itemNumberWith:^NSInteger{
        return 3;
    }];
    
    [_imagesCarouselView reloadData];
}



//MARK:~~  UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (![cell.contentView viewWithTag:1023]) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 2;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1].CGColor;
        label.layer.masksToBounds = YES;
        label.layer.drawsAsynchronously = YES;
        
        [cell.contentView addSubview:label];
        label.tag = 1023;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1023];
    label.text = @"手镯";
    
    return cell;
    
}

- (void)storeHomeBtnAction:(UIButton *)storeHomeBtn
{
    [_scrollLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(storeHomeBtn.mas_bottom).offset(-3);
        make.left.mas_equalTo(storeHomeBtn.mas_left);
        make.width.mas_equalTo(storeHomeBtn.mas_width);
        make.height.mas_equalTo(3);
    }];
    
    
    
//    
//    ViewController *ctrl;
//    
//    UIResponder *responder = self.nextResponder;
//    while (responder) {
//        if([responder isKindOfClass:[ViewController class]]){
//            ctrl = (ViewController *)responder;
//            break;
//        } else {
//            responder = responder.nextResponder;
//        }
//    }
//    
//
//    //点击第一个按扭,拿到控制器的collection隐藏
//    if(storeHomeBtn.tag == 500){
//        
//        ctrl.collectionView.height = 253;
//        ctrl.collectionView.scrollEnabled = NO;
//        
//    } else if (storeHomeBtn.tag == 501){
//        
//        ctrl.collectionView.scrollEnabled = YES;
//        ctrl.collectionView.height = kScreenHeight - 64;
//    }

}

@end
