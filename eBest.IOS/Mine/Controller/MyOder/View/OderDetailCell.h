//
//  OderDetailCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/27.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *sizeLb;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end
