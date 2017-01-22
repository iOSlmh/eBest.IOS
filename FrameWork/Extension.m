//
//  Extension.m
//  mallbuilderIOS
//
//  Created by yuanfeng on 15/10/15.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import "Extension.h"

@implementation Extension

+(UILabel *)createLabelWithFrame:(CGRect )frame title:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color
{
    UILabel *label=[UILabel new];
    label.frame=frame;
    label.text=text;
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
    
    return label;
}

@end
