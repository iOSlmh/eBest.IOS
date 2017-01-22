//
//  MyOderCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyOderCell.h"


@implementation MyOderCell

- (void)awakeFromNib {
    // Initialization code
    
    //    图片加边
    CALayer * layer = [self.imageV layer];
    layer.borderColor = RGB(244, 244, 244, 1).CGColor;
    layer.borderWidth = 1.0f;
    
    CALayer * leftLayer = [self.pLeftBtn layer];
    leftLayer.borderColor = RGB(244, 244, 244, 1).CGColor;
    leftLayer.borderWidth = 1.0f;
    CALayer * rightLayer = [self.pRightBtn layer];
    rightLayer.borderColor = RGB(244, 244, 244, 1).CGColor;
    rightLayer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)rightBtn:(UIButton *)sender {
    
    
}

- (IBAction)leftBtn:(UIButton *)sender {
}
@end
