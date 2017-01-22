//
//  HomeCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/8.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "HomeCell.h"
#import "HomeViewController.h"
#import "DetailViewController.h"

@implementation HomeCell


- (void)awakeFromNib {
    // Initialization code
    
    
}

-(void)loadDataWithArray:(NSMutableArray *)array{

    _dataArr = [NSMutableArray arrayWithArray:array];
    NSDictionary * firstDict = [_dataArr firstObject];
    NSString * str = firstDict[@"bg_goods"][@"goods_main_photo"][@"path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"newbarcode_default_itemImage"]];
    self.firstImageV.tag = 1000;
    self.firstImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick:)];
    [self.firstImageV addGestureRecognizer:tapRecognizer];
    self.firstNPrice.text = Money([[_dataArr firstObject][@"bg_goods"][@"goods_current_price"] floatValue]);
    self.firstOPrice.text = Money([[_dataArr firstObject][@"bg_goods"][@"goods_price"] floatValue]);
    self.firstTitleLabel.text = [_dataArr firstObject][@"bg_goods"][@"goods_name"];
    [self createPicScrollView];

}

-(void)createPicScrollView{
    float a = SW/2.5;
    self.picScrollView.delegate = self;
    self.picScrollView.backgroundColor = RGB(247, 247, 247, 1);
    self.picScrollView.userInteractionEnabled = YES;
    self.picScrollView.bounces = NO;
    self.picScrollView.contentSize = CGSizeMake(a*self.dataArr.count, 0);
    
    for (int i =0; i<_dataArr.count; i++) {
        NSDictionary * dic = [_dataArr[i]objectForKey:@"bg_goods"];
        NSString * str = dic[@"goods_main_photo"][@"path"];
        NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*a, 0, a-0.5, 200)];
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.contentMode = UIViewContentModeScaleAspectFit;//等比适配剪切保留
        [imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"newbarcode_default_itemImage"]];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 1000+i;
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick:)];
        [imageV addGestureRecognizer:tapRecognizer];
        
        UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, 200-50, a-20, 13) text:_dataArr[i][@"bg_goods"][@"goods_name"] textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
//        titleLabel.textAlignment = NSTextAlignmentLeft;
        [imageV addSubview:titleLabel];
        UILabel * priceLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, 200-34, a-20, 14) text:Money([_dataArr[i][@"bg_goods"][@"goods_current_price"]floatValue]) textColor:RGB(255, 98, 72, 1) font:[UIFont systemFontOfSize:14]];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
        [imageV addSubview:priceLabel];
        UILabel * originalPriceLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, 200-16, a-20, 9) text:Money([_dataArr[i][@"bg_goods"][@"goods_price"]floatValue]) textColor:RGB(183, 183, 183, 1) font:[UIFont systemFontOfSize:11]];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
        [imageV addSubview:originalPriceLabel];
        [self.picScrollView addSubview:imageV];
        
    }
   
}

//ImageView点击事件
-(void)TapClick:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag-1000;
    NSString * goodsID = _dataArr[index][@"bg_goods"][@"id"];
    NSLog(@"%@",goodsID);
    if ([self.tapDelegate respondsToSelector:@selector(tapImageDetailPushWithGoodsID:)]) {
        [_tapDelegate tapImageDetailPushWithGoodsID:goodsID];
    }
    NSLog(@"被点击");
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
