//
//  DetailModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/20.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.dataID = value;
    }
}
@end
