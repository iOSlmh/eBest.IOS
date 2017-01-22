//
//  DisplayModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/8.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DisplayModel.h"

@implementation DisplayModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.goodsID = value;
    }
}
@end
