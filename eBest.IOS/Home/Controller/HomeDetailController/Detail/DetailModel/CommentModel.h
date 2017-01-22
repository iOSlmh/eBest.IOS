//
//  CommentModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/29.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/*
 评论ID
 */
@property (nonatomic,copy)NSString *comment_id;
/*
 评论内容
 */
@property (nonatomic,copy)NSString *evaluate_info;
/*
 评论人ID
 */
@property (nonatomic,copy)NSString *comment_member_id;
/*
 评论人昵称
 */
@property (nonatomic,copy)NSString *username;
/*
 评论人昵称
 */
@property (nonatomic,assign)NSInteger nameWeith;
/*
 评论人头像
 */
@property (nonatomic,copy)NSString *user_img;
/*
 添加评论时间
 */
@property (nonatomic,copy)NSString *addTime;
/*
 评论图片
 */
@property (nonatomic,copy)NSString *img_path;
/*
 评论分数
 */
@property (nonatomic,copy)NSString *geval_scores;

/*
 评价内容的高
 */
@property (nonatomic,assign)NSInteger messageHight;
/*
 评价的cell行高
 */
@property (nonatomic,assign)NSInteger rowHeight;
/*
 是否匿名显示
 */
@property (nonatomic,copy)NSNumber * geval_isanonymous;
/*
 评价内容
 */
@property (nonatomic,copy)NSString * geval_content;
/*
 再次评价的信息
 */
@property (nonatomic,copy)NSString * geval_content_again;
/*
 geval_explain
 */
@property (nonatomic,copy)NSString * geval_explain;
/**
 *  商品规格
 */
@property (copy, nonatomic) NSString *goods_spec;




#pragma amrk 商品评价的商品
/**
 *  商品名称
 */
@property (copy, nonatomic) NSString *goods_id;
/**
 *  商品id
 */
@property (copy, nonatomic) NSString *goods_name;
/**
 *  商品图片
 */
@property (copy, nonatomic) NSString *image;
/**
 *  商品价格
 */
@property (copy, nonatomic) NSString *price;
/**
 *  商品评价数量
 */
@property (copy, nonatomic) NSString *num;
/**
 *  好评比例
 */
@property (assign, nonatomic) double percentage;
@end
