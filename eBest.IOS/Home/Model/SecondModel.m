//
//  SecondModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/12.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SecondModel.h"

@implementation SecondModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.dataID = value;
    }
}
@end
