//
//  ShoppingCarModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/5/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel
@synthesize cellClickState;
@synthesize section;
//@synthesize indexState;
//@synthesize cellPriceDict;
@synthesize cellEditState;
-(instancetype)initWithShopDict:(NSDictionary *)dict{
   
    self.count = dict[@"count"];
    self.goodsCar_id = dict[@"id"];
    self.price = dict[@"price"];
    self.spec_info = dict[@"spec_info"];
    self.goods = dict[@"goods"];
    self.gaps_ids = dict[@"gaps_ids"];
    self.section = 0;
    self.cellClickState = 0;
    self.cellEditState = 0;
    return self ;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.goodsCar_id = value;
    }
}
@end
