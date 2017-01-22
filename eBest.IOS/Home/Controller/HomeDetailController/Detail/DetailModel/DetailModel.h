//
//  DetailModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/20.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property(nonatomic,copy) NSString * dataID;
@property(nonatomic,copy) NSString * goods_name;
@property(nonatomic,copy) NSString * goods_price;
@property(nonatomic,copy) NSString * goods_current_price;
@property(nonatomic,copy) NSString * goods_main_photo_path;
@property(nonatomic,copy) NSDictionary * goods_store;
@end
