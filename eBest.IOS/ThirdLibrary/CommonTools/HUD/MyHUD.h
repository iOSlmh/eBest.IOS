//
//  MyHUD.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/10.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHUD : NSObject


//+(void)showTextDialog;      //文本提示框，默认情况下
//+(void)showProgressOne;     //第一种加载提示框
//+(void)showProgressTwo;     //第二种加载提示框
//+(void)showProgressThree;   //第三种加载提示框
//+(void)showCustomDialog;    //自定义提示框，显示打钩效果
+(void)showAllTextDialogWith:(NSString *)text showView:(UIView *)view;   //显示纯文本提示框

@end
