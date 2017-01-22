//
//  UILabel+Extension.m
//  mallbuilderIOS
//
//  Created by yuanfeng on 15/10/15.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+(UILabel *)createLabelWithFrame:(CGRect )frame title:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment sizeTofit:(BOOL)sizeTiFit
{
    UILabel *label=[UILabel new];
    label.frame=frame;
    label.text=text;
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
    label.textAlignment=textAlignment;
    if (sizeTiFit)
    {
        [label sizeToFit];
    }
    
    return label;
}

//使用用Massory布局的时候可以调用
+(UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color
{
    UILabel *label=[UILabel new];
    label.text=text;
    label.textColor=color;
    label.font=[UIFont systemFontOfSize:font];
    
    
    return label;
}
@end
