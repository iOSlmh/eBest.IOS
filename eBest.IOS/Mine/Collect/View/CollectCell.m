//
//  CollectCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CollectCell.h"

@implementation CollectCell

- (void)awakeFromNib {
    // Initialization code
    //    图片加边
    CALayer * layer = [self.picImageV layer];
    layer.borderColor = RGB(236, 235, 235, 1).CGColor;
    layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
