//
//  MyCommentModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject
/*
 评论ID
 */
@property (nonatomic,copy)NSString *of_id;
/*
 评论内容
 */
@property (nonatomic,copy)NSString *evaluate_info;
/*
 商品星级
 */
@property (nonatomic,copy)NSString *description_evaluate;
/*
 评价图片base64字符串
 */
@property (nonatomic,copy)NSString *evaluate_img;
/*
 物流星级
 */
@property (nonatomic,copy)NSString *ship_evaluate;
/*
 服务星级
 */
@property (nonatomic,copy)NSString *service_evaluate;
/*
 评论原图片
 */
@property (nonatomic,strong)UIImage *img_path;
/*
 评价内容的高
 */
@property (nonatomic,assign)NSInteger messageHight;
/*
  是否晒图
 */
@property (nonatomic,copy) NSString * showPic;
/*
 购物车ID
 */
@property (nonatomic,copy)NSString *gc_id;

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
@property (copy, nonatomic) NSString *goods_main_photo_path;
/**
 *  商品价格
 */
@property (copy, nonatomic) NSString *goods_amount;
/**
 *  商品评价数量
 */
@property (copy, nonatomic) NSString *num;
/**
 *  好评比例
 */
@property (assign, nonatomic) double percentage;
@end
