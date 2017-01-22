//
//  ModelForMessageAndImage.h
//  JYMallForEnterprise
//
//  Created by 91.Mall on 16/7/2.
//  Copyright © 2016年 91jksc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelForMessageAndImage : NSObject

/**
 *  类型
 */
@property (strong, nonatomic) NSString *type;
/**
 *  值
 */
@property (strong, nonatomic) NSString *value;
/**
 *  text高
 */
@property (assign, nonatomic) NSInteger textHeight;

@property (nonatomic,copy) NSString * path;
/**
 *  image高
 */
@property (assign, nonatomic) NSInteger imageHeight;
/**
 *  rowHeight
 */
@property (assign, nonatomic) NSInteger messageRowHeight;


-(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
