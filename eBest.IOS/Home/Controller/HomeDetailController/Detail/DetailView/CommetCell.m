//
//  CommetCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CommetCell.h"

@implementation CommetCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModelForEvaluate:(CommentModel *)modelForEvaluate{
    
    NSLog(@"----------------%ld",(long)modelForEvaluate.messageHight);
    
    _modelForEvaluate = modelForEvaluate;
    
    __weak typeof (self) weakSelf = self;
    
    CGSize size = [modelForEvaluate.evaluate_info boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(9)-UNIT_WIDTH(57),CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
    
    [self.labelForcomment mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.imageViewForHeaderImage.mas_bottom).offset(UNIT_HEIGHT(5));
        
        make.left.equalTo(weakSelf.contentView).offset(UNIT_WIDTH(15));
        
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(30), UNIT_HEIGHT(size.height)));
        
    }];
    
    [self.imageViewForHeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_url,modelForEvaluate.user_img]]];
    
    self.labelForuserName.text = modelForEvaluate.username;
    
    self.labelForTimeShow.text = modelForEvaluate.addTime;

    self.labelForcomment.text = modelForEvaluate.evaluate_info;

    self.labelForSize.text = modelForEvaluate.goods_spec;
    
    [self.viewForRatingBar displayRating:3 andView:self.contentView];

    if (modelForEvaluate.img_path) {
        
        [self.collectionViewForEvaluate reloadData];
        
        self.collectionViewForEvaluate.hidden = NO;
        
    }else {
        
        self.collectionViewForEvaluate.hidden = YES;
    }
    
}

#pragma mark --- 创建头像
-(UIImageView *)imageViewForHeaderImage{
    
    if (!_imageViewForHeaderImage) {
        
        __weak typeof(self) weakSelf = self;
        
        _imageViewForHeaderImage = [UIImageView new];
        _imageViewForHeaderImage.backgroundColor = [UIColor redColor];
        _imageViewForHeaderImage.layer.cornerRadius =UNIT_WIDTH(35)/2;
        
        _imageViewForHeaderImage.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_imageViewForHeaderImage];
        
    [_imageViewForHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(UNIT_HEIGHT(15));
    
        make.left.equalTo(weakSelf.contentView).offset(UNIT_WIDTH(15));
    
        make.size.mas_equalTo(CGSizeMake(UNIT_WIDTH(35), UNIT_WIDTH(35)));
    }];
    }
    return _imageViewForHeaderImage;
}

#pragma mark --- 创建用户名
-(UILabel *)labelForuserName{
    
    if (!_labelForuserName) {
        
        __weak typeof (self) weakSelf = self;
        
        _labelForuserName = [UILabel new];
        
        _labelForuserName.backgroundColor = [UIColor whiteColor];
        
        _labelForuserName.font = SYS_FONT(13);
        
        _labelForuserName.textColor = RGB(71, 71, 71, 1);
        
        [self.contentView addSubview:_labelForuserName];
        
        [_labelForuserName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.contentView).offset(UNIT_HEIGHT(24));
            
            make.left.equalTo(weakSelf.imageViewForHeaderImage.mas_right).offset(UNIT_HEIGHT(10));
            
            make.size.mas_equalTo(CGSizeMake(self.modelForEvaluate.nameWeith, UNIT_HEIGHT(18)));
            
        }];
        
        
    }
    return _labelForuserName;
}

#pragma mark --- 创建评价内容
-(UILabel *)labelForcomment{
    
    if (!_labelForcomment) {
        
        __weak typeof (self) weakSelf = self;
        
        _labelForcomment = [UILabel new];
        
        _labelForcomment.backgroundColor = [UIColor whiteColor];
        
        _labelForcomment.font = SYS_FONT(14);
        
        _labelForcomment.textColor = RGB(71, 71, 71, 1);
        
        _labelForcomment.numberOfLines = 0;
        
        [self.contentView addSubview:_labelForcomment];
        
        [_labelForcomment mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.imageViewForHeaderImage.mas_bottom).offset(UNIT_HEIGHT(5));
            
            make.left.equalTo(weakSelf.contentView).offset(UNIT_WIDTH(15));
            
            make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(30), UNIT_HEIGHT(self.modelForEvaluate.messageHight)));
            
        }];
        
        
    }
   
    return _labelForcomment;
}

#pragma mark --- 创建时间
-(UILabel *)labelForTimeShow{
    
    if (!_labelForTimeShow) {
        
        __weak typeof (self) weakSelf = self;
        
        _labelForTimeShow = [UILabel new];
        
        _labelForTimeShow.font = SYS_FONT(10);
        
        _labelForTimeShow.textColor = RGB(179, 179, 179, 1);
        
        _labelForTimeShow.numberOfLines = 1;
        
        _labelForTimeShow.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_labelForTimeShow];
        
        [_labelForTimeShow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.labelForcomment.mas_bottom).offset(UNIT_HEIGHT(3));
            
            make.left.equalTo(weakSelf.contentView).offset(UNIT_WIDTH(15));
            
            make.size.mas_equalTo(CGSizeMake(UNIT_WIDTH(110), UNIT_HEIGHT(14)));
            
        }];
        
        
    }
    return _labelForTimeShow;
}

#pragma mark --- 产品规格

-(UILabel *)labelForSize{
    
    if (!_labelForSize) {
        
        __weak typeof (self) weakSelf = self;
        
        _labelForSize = [UILabel new];
        
        _labelForSize.backgroundColor = [UIColor whiteColor];
        
        _labelForSize.font = SYS_FONT(10);
        
        _labelForSize.numberOfLines = 1;
        
        _labelForSize.textColor = RGB(179, 179, 179, 1);
        
        [self.contentView addSubview:_labelForSize];
        
        [_labelForSize mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.labelForcomment.mas_bottom).offset(UNIT_HEIGHT(3));
            
            make.left.equalTo(weakSelf.labelForTimeShow.mas_right).offset(UNIT_WIDTH(10));
            
            make.size.mas_equalTo(CGSizeMake(UNIT_WIDTH(150), UNIT_HEIGHT(14)));
            
        }];
        
        
    }
    return _labelForSize;
}

-(RatingBar *)viewForRatingBar{
    if (!_viewForRatingBar) {
        
        _viewForRatingBar = [[RatingBar alloc] init];
        
        _viewForRatingBar.tag = 10;
        
        _viewForRatingBar.isIndicator = YES;
        
        [self.contentView addSubview:_viewForRatingBar];
        
        [_viewForRatingBar setImageDeselected:@"Star 19 Copy 16" halfSelected:nil fullSelected:@"Star 19 Copy 14" andDelegate:nil];
        
        __weak typeof (self) weakSelf = self;
        
        [_viewForRatingBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.contentView).offset(UNIT_HEIGHT(21));
            
            make.left.equalTo(weakSelf.labelForuserName.mas_right).offset(UNIT_WIDTH(15));
            make.size.mas_equalTo(CGSizeMake(UNIT_WIDTH(120), UNIT_WIDTH(10)));
            
        }];
    }
    return _viewForRatingBar;
}
#pragma mark --- 创建图片
-(UICollectionView *)collectionViewForEvaluate{
    
    if (!_collectionViewForEvaluate) {
        
        UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        headerFlowLayout.minimumLineSpacing = 5;
        
        _collectionViewForEvaluate = [[UICollectionView alloc] initWithFrame:self.bounds
                                                        collectionViewLayout:headerFlowLayout];
        _collectionViewForEvaluate.delegate = self;
        
        _collectionViewForEvaluate.dataSource = self;
        
        _collectionViewForEvaluate.alwaysBounceHorizontal =YES;
        
        _collectionViewForEvaluate.pagingEnabled = YES;
        
        _collectionViewForEvaluate.tag = 200;
        
        _collectionViewForEvaluate.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_collectionViewForEvaluate];
        
        [_collectionViewForEvaluate registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        __weak typeof (self) weakSelf = self;
        [_collectionViewForEvaluate mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.labelForTimeShow.mas_bottom).offset(UNIT_HEIGHT(12));
            
            make.left.equalTo(weakSelf.contentView).offset(UNIT_WIDTH(15));
            
            make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(30), UNIT_HEIGHT(85)));
        }];
        
        
    }
    
    return _collectionViewForEvaluate;
}
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return 1;
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(UNIT_WIDTH(85), UNIT_WIDTH(85));
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellID = @"UICollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
        
    }
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.bounds];
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_url,self.modelForEvaluate.img_path]]];
    
    cell.backgroundView = imageV;
    
    cell.layer.cornerRadius = 3;
    
    cell.layer.borderWidth = 1;
    
    cell.layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    
    cell.layer.masksToBounds = YES;
    
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //创建一个黑色背景
    self.bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.bgView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    //要显示的图片，即要放大的图片
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_url,self.modelForEvaluate.img_path]]];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.userInteractionEnabled = YES;
    
    [self.bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SW, UNIT_HEIGHT(350)));
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:self.bgView];//放大过程中的动画

}
//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
//点击空白关闭
-(void)closeView{

    [self.bgView removeFromSuperview];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
