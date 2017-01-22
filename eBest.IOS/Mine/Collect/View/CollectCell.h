//
//  CollectCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@end
