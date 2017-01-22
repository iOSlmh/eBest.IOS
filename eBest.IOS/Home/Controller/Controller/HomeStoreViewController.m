//
//  HomeStoreViewController.m
//  eBest.IOS
//
//  Created by lianyanmin on 16/9/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HeaderView.h"


@interface HomeStoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@end

@implementation HomeStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

#pragma mark -- configUI
- (void)configUI {
    
#pragma mark -- collectionViewUI
   
    UICollectionViewFlowLayout *collctionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collctionViewFlowLayout.itemSize = CGSizeMake(187,187);
    collctionViewFlowLayout.minimumInteritemSpacing = 0;
    collctionViewFlowLayout.minimumLineSpacing = 25;
    collctionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionViewLayout =  collctionViewFlowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,20,SW,SH-20) collectionViewLayout:collctionViewFlowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    //注册单元格
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];
        label.text = @"戒  指";
        label.textAlignment = NSTextAlignmentCenter;
        [reusableView addSubview:label];
        
        if (indexPath.section == 0) {
            
            HeaderView *header = [HeaderView headerView];
            [reusableView addSubview:header];
            
            [header mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.top.trailing.equalTo(reusableView);
                make.height.mas_equalTo(667);
            }];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(header.mas_bottom).offset(15);
                make.leading.and.trailing.equalTo(reusableView);
                make.height.mas_equalTo(50);
            }];
            
        } else {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(reusableView);
            }];
        }
        return reusableView;
    }
    
    else {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看更多 >" forState:UIControlStateNormal];
        [reusableView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(reusableView);
        }];
        
        return reusableView;
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 65;
    if (section == 0) {
        height += 667;
    }
    return CGSizeMake(375, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(375, 40);
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
