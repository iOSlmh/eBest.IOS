//
//  RootViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
//左按钮
@property(nonatomic,strong) UIButton * leftButton;
//标题
@property(nonatomic,strong) UILabel * titleLabel;
//右按钮
@property(nonatomic,strong) UIButton * rightButton;

//响应事件
-(void)setLeftButtonClick:(SEL)selector;
-(void)setRightButtonClick:(SEL)selector;
@end
