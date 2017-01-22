//
//  ShoppingCarGroupModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/5/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarGroupModel : NSObject

//@property(nonatomic,strong) NSString * store_name;
//头部 选中状态
@property (nonatomic, assign) NSInteger headClickState;
//头部编辑状态
@property (nonatomic, assign) NSInteger headEditState;
@property(nonatomic,strong) NSNumber * storeID;
@property(nonatomic,strong) NSMutableArray * gcs;
@property(nonatomic,strong) NSDictionary * store;
@property(nonatomic,strong) NSNumber * total_price;


-(instancetype)initWithShopDict:(NSDictionary *)dict;

@end
