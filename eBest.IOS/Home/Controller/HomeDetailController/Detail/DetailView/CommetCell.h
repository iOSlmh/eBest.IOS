//
//  CommetCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "RatingBar.h"
@interface CommetCell : UITableViewCell<UICollectionViewDelegate , UICollectionViewDataSource>

/**
 *  评论头像
 */
@property (nonatomic,strong)UIImageView *imageViewForHeaderImage;
/**
 *  用户姓名
 */
@property (nonatomic,strong)UILabel *labelForuserName;


@property (nonatomic,strong) NSMutableAttributedString *strForComment_message;

@property (nonatomic,strong) RatingBar *viewForRatingBar;

@property (nonatomic,assign)CGSize size;
/**
 *  评价时间
 */
@property (nonatomic,strong) UILabel *labelForTimeShow;

@property (nonatomic,strong)NSString * commentStr;
/**
 *  评价内容
 */
@property (nonatomic,strong) UILabel * labelForcomment;

/**
 *  产品规格
 */
@property (nonatomic,strong) UILabel * labelForSize;
//测试
@property (nonatomic,strong) NSString * Str;

/**
 *  数据
 */
@property (strong, nonatomic) CommentModel * modelForEvaluate;

@property (strong,nonatomic) NSArray *examples;
/**
 *  图片显示
 */
@property (nonatomic,strong) UICollectionView *collectionViewForEvaluate;

@property (nonatomic , strong) NSMutableArray *assets;
/**
 *  所缓存的图片
 */
@property (nonatomic , strong) NSMutableArray *photos;
/**
 *  放大图片的view
 */
@property (nonatomic , strong) UIView * bgView;


@end
