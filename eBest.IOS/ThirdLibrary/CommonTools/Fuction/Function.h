//
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject
+(BOOL)is_Login;

+(NSString *)getKey;

+(void)removeKey;

+(NSString *)getUserName;

+(NSString *)getUserId;

+(void)startTime:(UIButton *)btn;

@end
