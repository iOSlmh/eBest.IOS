//
//  MyCommetCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "PlaceholderTextView.h"
#import "MyCommentViewController.h"
@interface MyCommetCell : UITableViewCell<RatingBarDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    NSInteger _number;
    UILabel * lab;
}

/**
 *  评价文本
 */
@property (nonatomic,strong) PlaceholderTextView * ptview;
/**
 *  图片选择按钮
 */
@property (nonatomic,strong) UIButton * btn;
/**
 *  底部View
 */
@property (nonatomic,strong) UIView * botView;
/**
 *  评论商品图片
 */
@property (nonatomic,strong)UIImageView *imageV;
/**
 *  上传图片底图
 */
@property (nonatomic,strong) UIView * selectView;
/**
 *  上传图片
 */
@property (nonatomic,strong)UIImageView *selectImageV;
/**
 *  商品名称
 */
@property (nonatomic,strong)UILabel *goodsName;
/**
 *  评价星级分数
 */
@property (nonatomic,strong)NSNumber * orderScore;

@property (nonatomic,strong) UIView * topView;

@property (nonatomic,strong) NSMutableAttributedString *strForComment_message;

@property (nonatomic,strong) RatingBar *viewForRatingBar;

@property (nonatomic,assign)CGSize size;

@property (nonatomic,strong) RatingBar *ratingBar1;
@property (nonatomic,strong) RatingBar *ratingBar2;
@property (nonatomic,strong) RatingBar *ratingBar3;


-(void)giveCellWithDict:(NSDictionary *)dict;


@end
