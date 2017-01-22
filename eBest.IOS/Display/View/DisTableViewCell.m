//
//  DisTableViewCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/28.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DisTableViewCell.h"

@implementation DisTableViewCell

//-(id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.5)];
//        self.line.backgroundColor = RGB(236, 235, 235, 1);
//        [self.contentView addSubview:self.line];
//    }
//    
//    return self;
//}


- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collectBtn:(UIButton *)sender {
    
     [sender setImage:[UIImage imageNamed:@"list_Collection_selected"] forState:UIControlStateNormal];
   
    [self.delegate SwitchBtn:sender];
//    //取出开关所在的这个cell
//    UIView * view1 = [[sender superview] superview];
//    DisTableViewCell * cell =(DisTableViewCell *) view1;
    
    //在根据cell取出cell所在的行，这里的tableView是在vc里通过属性传值传过来的。
//    NSIndexPath * indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的row
    //代理方法传值，在vc里进行某些操作
//    [self.delegateSwitchIsOn:[sender isOn] andRow:indexPathAll.row];
}
@end
