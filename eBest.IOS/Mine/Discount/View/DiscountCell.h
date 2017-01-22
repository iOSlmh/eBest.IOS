//
//  DiscountCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelTop;
@property (weak, nonatomic) IBOutlet UILabel *labelMid;
@property (weak, nonatomic) IBOutlet UILabel *labelBot;

@end
