//
//  CheckLogCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLb;
@property (weak, nonatomic) IBOutlet UILabel *bottomLb;
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageV;

@end
