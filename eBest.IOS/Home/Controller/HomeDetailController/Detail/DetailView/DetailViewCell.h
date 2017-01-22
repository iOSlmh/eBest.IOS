//
//  DetailViewCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertiesLabel;

//header组
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * oPriceLabel;
@property(nonatomic,strong) UILabel * nPriceLabel;
@property(nonatomic,strong) UILabel * postFreeLabel;
@property(nonatomic,strong) UILabel * retuneFreelabel;
//cell第一组
@property(nonatomic,strong) UILabel * selectLabel;
//cell第二组
@property(nonatomic,strong) UIImageView * storeImageV;
@property(nonatomic,strong) UILabel * storeTitleLabel;
@property(nonatomic,strong) UILabel * smallTitleLabel;
//cell第三组
@property(nonatomic,strong) UIImageView * headImageV;
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * commentLabel;
@property(nonatomic,strong) UIImageView * displayImageV;
@property(nonatomic,strong) UILabel * timeLabel;

@end
