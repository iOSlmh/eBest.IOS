//
//  FactoryUI.m
//  PocketKichen
//
//  Created by 杨阳 on 15/11/23.
//  Copyright (c) 2015年 yangyang. All rights reserved.
//

#import "FactoryUI.h"

@implementation FactoryUI
//UIView
+(UIView *)createViewWithFrame:(CGRect)frame;
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    return view;
}
//UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}
//UILine
+(UILabel *)createLineWithFrame:(CGRect)frame withColor:(UIColor *)color{

    UILabel * lb = [[UILabel alloc]initWithFrame:frame];
    lb.backgroundColor = color;
    return lb;

}
//UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    //设置标题
    [button setTitle:title forState:UIControlStateNormal];
    //设置标题颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //设置图片
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //设置背景图片
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    //添加点击事件
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder
{
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.placeholder = placeHolder;
    return textField;
}

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


////订单界面btn
//+(UIButton *)createDingdanButtonWithFrame:(CGRect)frame titleArr:(NSArray *)title titleColorArr:(NSArray *)titleColor buutonRadius:(CGFloat)radius borderWidth:(CGFloat)width bordeWidthColor:(UIColor *)widthColor target:(id)target selector:(SEL)selector{
//    
//    for (int i = 0; i<title.count; i++) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = frame;
//        //设置标题
//        [button setTitle:title[i] forState:UIControlStateNormal];
//        //设置标题颜色
//        [button setTitleColor:titleColor[i] forState:UIControlStateNormal];
//        //添加点击事件
//        button.layer.cornerRadius = radius;
//        button.layer.masksToBounds = YES;
//        button.layer.borderWidth = width;
//        button.layer.borderColor = widthColor.CGColor;
//        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//        return button;
//    }
//    return nil;
//    
//}
@end
