//
//  DisCollectionReusableView.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/28.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "DisCollectionReusableView.h"

@implementation DisCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, self.bounds.size.width, 41) text:@"材料分类" textColor:RGB(42, 150, 143, 1) font:[UIFont systemFontOfSize:18]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        UILabel * topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.titleLabel.bounds.size.width, 0.5)];
        topLine.backgroundColor = RGB(236, 235, 235, 1);
        UILabel * bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLabel.bounds.size.height-0.5, self.titleLabel.bounds.size.width, 0.5)];
        bottomLine.backgroundColor = RGB(236, 235, 235, 1);
        [self.titleLabel addSubview:topLine];
        [self.titleLabel addSubview:bottomLine];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}


//-(void)getNameArr:(NSMutableArray *)arr{
//
//    self.nameArray = arr;
//
//}

//- (void)awakeFromNib {
//    // Initialization code
//}

@end
