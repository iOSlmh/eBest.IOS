//
//  PicModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/11/21.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "PicModel.h"

@implementation PicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"value"]) {
        
        _path = value;
        
        self.model.path = value;
    }
}
-(ModelForMessageAndImage *)model{
    
    if (!_model) {
        
        _model = [[ModelForMessageAndImage alloc]init];
    }
    
    return _model;
}
@end
