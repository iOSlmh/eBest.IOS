//
//  ImagesCarouselViewCell.m
//  LYM
//
//  Created by 连艳敏 on 16/7/31.
//  Copyright © 2016年 连艳敏. All rights reserved.
//

#import "ImagesCarouselViewCell.h"
#import "Masonry.h"

@interface ImagesCarouselViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceTagLabel;

@end

@implementation ImagesCarouselViewCell

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
