//
//  OrderXibCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/22.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "OrderXibCell.h"

@implementation OrderXibCell

- (void)awakeFromNib {
    // Initialization code
    //    图片加边
    CALayer * layer = [self.imageV layer];
    layer.borderColor = RGB(244, 244, 244, 1).CGColor;
    layer.borderWidth = 1.0f;
//    
//    UILabel * midLine = [[UILabel alloc]initWithFrame:CGRectMake(self.originalPrice.frame.origin.x, self.originalPrice.frame.size.height/2, self.originalPrice.frame.size.width, 5)];
//    midLine.backgroundColor = [UIColor redColor];
//    [self.originalPrice addSubview:midLine];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
