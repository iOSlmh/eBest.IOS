//
//  HomeCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/8.
//  Copyright © 2016年 shijiboao. All rights reserved.
//




@protocol HomeCellDelegate <NSObject>

-(void)tapImageDetailPushWithGoodsID:(NSString *)goodsID;

@end
#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *picScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageV;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNPrice;
@property (weak, nonatomic) IBOutlet UILabel *firstOPrice;
@property (weak, nonatomic) IBOutlet UIButton *quickBuy;
@property (strong,nonatomic) NSMutableArray * dataArr;

@property(nonatomic,weak)id<HomeCellDelegate>tapDelegate;
-(void)loadDataWithArray:(NSMutableArray *)array;
@end
