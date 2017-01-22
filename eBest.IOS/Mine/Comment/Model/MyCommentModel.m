//
//  MyCommentModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.goods_id = value;
    }
}
@end
