//
//  CollectionViewCell.m
//  eBest.IOS
//
//  Created by 李明浩 on 16/9/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Masonry.h"

@interface CollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceTagLabel;
@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
    [_priceTagLabel addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(_priceTagLabel);
        make.centerY.equalTo(_priceTagLabel);
        make.height.mas_equalTo(1);
    }];
}

@end
