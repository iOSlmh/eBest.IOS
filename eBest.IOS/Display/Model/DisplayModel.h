//
//  DisplayModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/8.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayModel : NSObject
@property (nonatomic, assign) NSInteger name;
@property(nonatomic,strong) NSNumber * sequence;
@property(nonatomic,strong) NSMutableArray * properties;
@property(nonatomic,strong) NSNumber * goodsID;
@end
