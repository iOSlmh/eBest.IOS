//
//  ShoppingCarModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/5/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarModel : NSObject

//cell 选中状态
@property (nonatomic, assign) NSInteger cellClickState;
@property (nonatomic, assign) NSInteger section;
//编辑状态
@property (nonatomic, assign) NSInteger cellEditState;

@property(nonatomic,strong) NSString * spec_info;
@property(nonatomic,strong) NSNumber * count;
@property(nonatomic,strong) NSNumber * goodsCar_id;
@property(nonatomic,strong) NSDictionary * goods;
@property(nonatomic,strong) NSNumber * price;
@property(nonatomic,strong) NSArray * gaps_ids;

-(instancetype)initWithShopDict:(NSDictionary *)dict;
@end
