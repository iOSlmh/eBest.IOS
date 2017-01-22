//
//  RequestTools.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/13.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(NSDictionary *Dict);
typedef void (^failureBlock)(NSError *error);

@interface RequestTools : NSObject

/*
 ***不携带用户信息
 */
+ (void)getWithURL:(NSString *)spellUrl params:(NSDictionary *)params  success:(successBlock)success failure:(failureBlock)failure;
+ (void)postWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;
/*
 ***携带用户信息
 */
+ (void)getUserWithURL:(NSString *)spellUrl params:(NSDictionary *)params  success:(successBlock)success failure:(failureBlock)failure;
+ (void)posUserWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;
/*
 ***携带用户信息的json请求
 */
+ (void)posJsonWithURL:(NSString *)spellUrl params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

@end
