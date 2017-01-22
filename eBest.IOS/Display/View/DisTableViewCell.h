//
//  DisTableViewCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/28.
//  Copyright © 2016年 shijiboao. All rights reserved.
//
@protocol DisTableViewCellCollectDelegate <NSObject>

-(void)SwitchBtn:(UIButton *)btn;

@end

#import <UIKit/UIKit.h>

@interface DisTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * line;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *curPrice;
@property (weak, nonatomic) IBOutlet UILabel *odPrice;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)collectBtn:(UIButton *)sender;
@property(nonatomic,strong) id<DisTableViewCellCollectDelegate>delegate;
@end
