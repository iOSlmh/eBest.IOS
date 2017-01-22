//
//  MyOderCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/16.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *deslabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
- (IBAction)rightBtn:(UIButton *)sender;
- (IBAction)leftBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *pLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *pRightBtn;

@end
