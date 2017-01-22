//
//  TriangleView.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/9.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)col{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        self.col = col;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
    
}


- (void)drawRect:(CGRect)rect


{


    //设置背景颜色


    [[UIColor
      clearColor]set];


    UIRectFill([self bounds]);


    //拿到当前视图准备好的画板


    CGContextRef
    context = UIGraphicsGetCurrentContext();


    //利用path进行绘制三角形


    CGContextBeginPath(context);//标记


    CGContextMoveToPoint(context,
                         15, 0);//设置起点


    CGContextAddLineToPoint(context,
                            0, 20);


    CGContextAddLineToPoint(context,
                            30, 20);


    CGContextClosePath(context);//路径结束标志，不写默认封闭


    [self.col setFill];
    //设置填充色


    [self.col setStroke];
    //设置边框颜色


    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path


}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
