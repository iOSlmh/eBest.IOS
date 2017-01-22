//
//  ShoppingCarCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartViewController.h"
#import "ShoppingCarModel.h"

@protocol ShoppingTableViewCellDelegate <NSObject>

-(void)ShoppingTableViewCell:(ShoppingCarModel *)model;

@end
@interface ShoppingCarCell : UITableViewCell
{
    BOOL isbool;
    NSInteger num;
    UIButton * _cutNumBtn;
    UIButton * _addNumBtn;
    UILabel * _countLabel;
    UILabel * _systemLabel;
}

@property (nonatomic,strong) UIView * editcartView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
- (IBAction)singleSelectBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;
@property(nonatomic,assign) BOOL selectState;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UIButton * clearBtn;
@property(nonatomic,assign) NSInteger stock;

@property (nonatomic, strong) ShoppingCarModel *model;
@property (nonatomic, weak) id<ShoppingTableViewCellDelegate>delegate;

-(void)refreshUI:(ShoppingCarModel *)model;
@end
