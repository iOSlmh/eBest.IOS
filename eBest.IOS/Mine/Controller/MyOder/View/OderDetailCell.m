//
//  OderDetailCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/27.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "OderDetailCell.h"

@implementation OderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageV.layer.borderColor = RGB(226, 226, 226, 1).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
