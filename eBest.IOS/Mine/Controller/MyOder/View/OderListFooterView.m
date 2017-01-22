//
//  OderListFooterView.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/28.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "OderListFooterView.h"

@implementation OderListFooterView

-(instancetype)initWithBtnTitleArray:(NSArray *)titleArray{

    self = [[OderListFooterView alloc]initWithFrame:CGRectMake(0, 0, SW, 50)];
    self.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(SW-15-(75*(i+1))-(i*10), 10, 75, 30);
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        //设置标题
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (button.tag==0) {
            //设置标题颜色
            [button setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
            //设置边框颜色
            button.layer.borderColor = RGB(32, 179, 169, 1).CGColor;

        }else{
            //设置标题颜色
            [button setTitleColor:RGB(123, 123, 123, 1) forState:UIControlStateNormal];
            //设置边框
            button.layer.borderColor = RGB(123, 123, 123, 1).CGColor;
        
        }
            [self addSubview:button];
    }
    return self;
}

@end
