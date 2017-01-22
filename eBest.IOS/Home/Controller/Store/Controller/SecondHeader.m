//
//  SecondHeader.m
//  eBest.IOS
//
//  Created by 李明浩 on 16/9/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SecondHeader.h"
#import "Masonry.h"
#import "UIViewExt.h"


@interface SecondHeader ()
@property (weak, nonatomic) IBOutlet UIView *secondSelectView;

@end
@implementation SecondHeader

+(instancetype)secondHeader{

return [[NSBundle mainBundle]loadNibNamed:@"SecondHeader" owner:nil options:nil].lastObject;
}

-(void)awakeFromNib{
    
    UIButton *storeHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeHomeBtn.backgroundColor = [UIColor whiteColor];
    storeHomeBtn.frame = CGRectMake(0,0,SW / 2.0,_secondSelectView.height-1);
    [storeHomeBtn setTitleColor:RGB(71, 71, 71, 1) forState:UIControlStateNormal];
    [storeHomeBtn addTarget:self action:@selector(didClickHide:) forControlEvents:UIControlEventTouchUpInside];
    [storeHomeBtn setTitle:@"商铺首页" forState:UIControlStateNormal];
     storeHomeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
     [storeHomeBtn setImage:[UIImage imageNamed:@"icon1_Shop home"] forState:UIControlStateNormal];
    [_secondSelectView addSubview:storeHomeBtn];
    
    
    UIButton *stopHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopHomeBtn.backgroundColor = [UIColor whiteColor];
    stopHomeBtn.frame = CGRectMake(SW / 2.0,0,SW / 2.0,_secondSelectView.height-1);
    [stopHomeBtn setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
    [stopHomeBtn addTarget:self action:@selector(didClickStopHomeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [stopHomeBtn setTitle:@"全部商品" forState:UIControlStateNormal];
    stopHomeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [stopHomeBtn setImage:[UIImage imageNamed:@"icon1_selected_all goods"] forState:UIControlStateNormal];
    [_secondSelectView addSubview:stopHomeBtn];
    
    
    //设置默认的滑动条
    _scrollLineView = [[UIView alloc]init];
    _scrollLineView.backgroundColor = RGB(32, 179, 169, 1);
    [_secondSelectView addSubview:_scrollLineView];
    [_scrollLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(stopHomeBtn.mas_bottom).offset(-3);
        make.left.mas_equalTo(stopHomeBtn.mas_left);
        make.width.mas_equalTo(stopHomeBtn.mas_width);
        make.height.mas_equalTo(3);
    }];

}

- (void)didClickHide:(UIButton *)sender {
    
    NSNotification *notification =[NSNotification notificationWithName:@"HideGoods" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
