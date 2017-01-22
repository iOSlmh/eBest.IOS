//
//  AddressViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//
//区域对象
#import <Foundation/Foundation.h>

@interface AreaObject : NSObject


//省名
@property (copy, nonatomic) NSString *province;
//城市名
@property (copy, nonatomic) NSString *city;
//区县名
@property (copy, nonatomic) NSString *area;

@end
