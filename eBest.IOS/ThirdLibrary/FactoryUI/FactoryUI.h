//
//  FactoryUI.h
//  PocketKichen
//
//  Created by 杨阳 on 15/11/23.
//  Copyright (c) 2015年 yangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FactoryUI : NSObject

//工厂，实际是大批量生产零件的地方，如果映射到代码中，其实就是将一类控件的所有属性用一个静态方法做一总结归纳，方便统一修改

//UIView
+(UIView *)createViewWithFrame:(CGRect)frame;
//UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;
//Line
+(UILabel *)createLineWithFrame:(CGRect)frame withColor:(UIColor *)color;
//UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector;
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
////UIButton
//+(UIButton *)createDingdanButtonWithFrame:(CGRect)frame titleArr:(NSArray *)title titleColorArr:(NSArray *)titleColor buutonRadius:(CGFloat)radius borderWidth:(CGFloat)width bordeWidthColor:(UIColor *)widthColor target:(id)target selector:(SEL)selector;

@end
