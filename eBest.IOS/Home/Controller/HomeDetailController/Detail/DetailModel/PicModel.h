//
//  PicModel.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/11/21.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelForMessageAndImage.h"
@interface PicModel : NSObject

@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * path;
@property (nonatomic,strong) ModelForMessageAndImage * model;
@end
