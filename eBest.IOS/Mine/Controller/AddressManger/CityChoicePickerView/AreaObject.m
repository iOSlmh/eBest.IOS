//
//  AddressViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area];
}

@end
