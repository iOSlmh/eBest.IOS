//
//  GuidePageView.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "GuidePageView.h"
#import "FactoryUI.h"
@interface GuidePageView ()
{
    UIScrollView * _scrollView;
}

@end


@implementation GuidePageView

-(id)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        //创建scrollView
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SW, SH)];
        //设置分页
        _scrollView.pagingEnabled = YES;
        //设置contentSize
        _scrollView.contentSize = CGSizeMake(imageArray.count * SW, SH);
        [self addSubview:_scrollView];
        
        //创建imageView
        for (int i = 0; i < imageArray.count; i ++)
        {
            UIImageView * imageView = [FactoryUI createImageViewWithFrame:CGRectMake(i * SW, 0, SW, SH) imageName:imageArray[i]];
            //打开用户交互
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            
            if (i == imageArray.count - 1) {
//                self.GoInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                self.GoInButton.frame = CGRectMake(200, (SH-100)/2, 100, 100);
//                [self.GoInButton setImage:[UIImage imageNamed:@"LinkedIn"] forState:UIControlStateNormal];
                self.GoInButton=[[UIButton alloc]initWithFrame:CGRectMake(SW*4-100, (SH-100)/2, 100, 100)];
                [self.GoInButton setTitle:@"进入" forState:UIControlStateNormal];
                [self.GoInButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.GoInButton.layer.cornerRadius=50;
                self.GoInButton.layer.borderWidth=2;
                self.GoInButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
                self.GoInButton.layer.masksToBounds=YES;

                [_scrollView addSubview:self.GoInButton];
            }
        }
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
