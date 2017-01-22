//
//  YYImagesCarouselView.m
//  YYPsychologist
//
//  Created by 连艳敏 on 16/5/3.
//  Copyright © 2016年 连艳敏. All rights reserved.
//

#import "YYImagesCarouselView.h"
#import "Masonry.h"

@interface YYImagesCarouselView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger currentItem;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (copy, nonatomic) SetupCell setupCellBlock;
@property (copy, nonatomic) DidSelectCell didSelectCellBlock;
@property (copy, nonatomic) CellClassBlock cellClassBlock;
@property (copy, nonatomic) ItemNumberBlock itemNumberBlock;

@end

@implementation YYImagesCarouselView

+ (instancetype)imagesCarouselView {
    YYImagesCarouselView *icv = [[YYImagesCarouselView alloc]init];
    [icv createSubViews];
    return icv;
}

- (void)createSubViews {
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake(375, 150);
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(0);
    }];
}

- (void)reloadData {
    if (_cellClassBlock) {
        id class = _cellClassBlock();
        if ([class isKindOfClass:[NSString class]]) {
            [_collectionView registerNib:[UINib nibWithNibName:class bundle:nil] forCellWithReuseIdentifier:class];
        } else {
            [_collectionView registerClass:class forCellWithReuseIdentifier:NSStringFromClass(class)];
        }
    } else {
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    
    [_collectionView reloadData];
    if (_itemNumberBlock) {
        if (_itemNumberBlock() > 0) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
    _layout.itemSize = _itemSize;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _itemNumberBlock();
     [self  addTimer];
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_itemNumberBlock()) {
        return _itemNumberBlock();
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    if (_cellClassBlock) {
        id class = _cellClassBlock();
        if ([class isKindOfClass:[NSString class]]) {
            identifier = class;
        } else {
            identifier = NSStringFromClass(class);
        }
    } else {
        identifier = @"UICollectionViewCell";
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!_cellClassBlock) {
        if (![cell.contentView viewWithTag:1024]) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = 1024;
            [cell.contentView addSubview:imageView];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectCellBlock) {
        _didSelectCellBlock(indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_setupCellBlock) {
        _setupCellBlock(indexPath,cell);
    }
}

#pragma mark - 轮播方法
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeAction target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage{
    
    NSIndexPath *resetIndexPath = [self resetIndexPath];
    
    NSInteger item = resetIndexPath.item + 1;
    NSInteger section = resetIndexPath.section;
    NSInteger itemNum = [self collectionView:_collectionView numberOfItemsInSection:0];
    if (item == itemNum) {
        item = 0;
        section ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (NSIndexPath *)resetIndexPath {
    //每调用这个方法时,就让Collection选中到最中间的那一组的这一个cell(无动画)
    //即显示的永远是最中间的那组
    NSIndexPath *currentIndexPath = [self.collectionView.indexPathsForVisibleItems lastObject];
    NSIndexPath *resetIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:2];
    [self.collectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return resetIndexPath;
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

//用户拖拽的时候 移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//停止滚动的时候 显示最中间的一组
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetIndexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offx = scrollView.contentOffset.x;
    if ([self collectionView:_collectionView numberOfItemsInSection:0]) {
        _currentItem = (NSInteger)((offx + (self.frame.size.width / 2.0)) / self.frame.size.width) % [self collectionView:_collectionView numberOfItemsInSection:0];
        _pageControl.currentPage = _currentItem;
    }
}

#pragma mark - 公有方法
- (void)setupCell:(SetupCell)block {
    _setupCellBlock = block;
}

- (void)didSelectCell:(DidSelectCell)block {
    _didSelectCellBlock = block;
}

- (void)cellClassWith:(CellClassBlock)block {
    _cellClassBlock = block;
}

- (void)itemNumberWith:(ItemNumberBlock)block {
    _itemNumberBlock = block;
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

@end
