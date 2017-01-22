//
//  UILabel+Extension.h
//  mallbuilderIOS
//
//  Created by yuanfeng on 15/10/15.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
+(UILabel *)createLabelWithFrame:(CGRect )frame title:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment sizeTofit:(BOOL)sizeTiFit;

+(UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color;
@end
