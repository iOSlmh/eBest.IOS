//
//  HomeModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/12.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//热门
@property(strong,nonatomic) NSString * advert_thumb_url;
@property(strong,nonatomic) NSString * zone_title;
@property(strong,nonatomic) NSString * zone_description;
@property(strong,nonatomic) NSString * zone_thumb_url;

//专区
@property(strong,nonatomic) NSString * goods_id;
@property(strong,nonatomic) NSString * goods_name;
@property(strong,nonatomic) NSString * goods_price;
@property(strong,nonatomic) NSString * store_price;
@property(strong,nonatomic) NSString * goods_thumb_url;

//精品推荐

@end
