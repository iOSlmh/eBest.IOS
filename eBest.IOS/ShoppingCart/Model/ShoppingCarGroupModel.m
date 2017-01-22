//
//  ShoppingCarGroupModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/5/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ShoppingCarGroupModel.h"
#import "ShoppingCarModel.h"
@implementation ShoppingCarGroupModel

@synthesize headClickState;

-(instancetype)initWithShopDict:(NSDictionary *)dict{
    
    self.total_price = dict[@"total_price"];
    
    self.storeID = dict[@"id"];
    
    self.store  = dict[@"store"];
    
    self.gcs = [NSMutableArray arrayWithArray:[self ReturnData:dict[@"gcs"]]];
    self.headClickState = 0;
    self.headEditState = 0;
    return self ;
}

-(NSArray *)ReturnData:(NSArray *)array{
    
    NSMutableArray *arrays= [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
//        
        ShoppingCarModel *model = [[ShoppingCarModel alloc] initWithShopDict:dict];
        [arrays addObject:model];
        
    }
    
    return arrays;
}


@end
