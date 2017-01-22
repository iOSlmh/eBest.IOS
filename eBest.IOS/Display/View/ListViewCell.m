//
//  ListViewCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/1.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ListViewCell.h"

@implementation ListViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    NSString *textStr = [NSString stringWithFormat:@"%@元", primeCost];
    
    
//    //根据计算文字的大小
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
//    CGFloat length = [self.originalPrice.text boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//    UILabel * line = [FactoryUI createLineWithFrame:CGRectMake(0, self.originalPrice.frame.size.height/2, length, 2) withColor:RGB(71, 71, 71, 1)];
//    [self.originalPrice addSubview:line];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
