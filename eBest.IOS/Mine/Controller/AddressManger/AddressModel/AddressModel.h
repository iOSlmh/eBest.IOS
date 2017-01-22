//
//  AddressModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic,copy) NSString * trueName;
@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * area_info;
@property (nonatomic,copy) NSString * thirdRank;
@property (nonatomic,copy) NSString * detailArea;
@property (nonatomic,copy) NSString * distr;
@property (nonatomic,strong) NSNumber * addrID;
@property (nonatomic,copy) NSString * type;

@end
