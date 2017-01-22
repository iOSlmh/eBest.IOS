//
//  LXSegmentScrollView.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//
#define MainScreen_W [UIScreen mainScreen].bounds.size.width

#import "LXSegmentScrollView.h"
#import "LiuXSegmentView.h"

@interface LXSegmentScrollView()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView *bgScrollView;
@property (strong,nonatomic)LiuXSegmentView *segmentToolView;

@end

@implementation LXSegmentScrollView


-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray andStatePage:(NSInteger)statePage andImageArr:(NSArray *)imageArray{
    if (self = [super initWithFrame:frame]) {
        
        [self bgScrollViewWithCount:titleArray.count];
        [self addSubview:_bgScrollView];
        

        _segmentToolView = [[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_W, 44) titles:titleArray andIndex:statePage andImageArr:imageArray clickBlick:^(NSInteger index) {

            [_bgScrollView setContentOffset:CGPointMake(MainScreen_W*(index-1), 0)];
        }];
        [self addSubview:_segmentToolView];
        
        
        for (int i=0;i<contentViewArray.count; i++ ) {
            
            UITableView *contentView = (UITableView *)contentViewArray[i];
            contentView.frame=CGRectMake(SW * i, _segmentToolView.bounds.size.height, SW, _bgScrollView.frame.size.height-_segmentToolView.bounds.size.height);
            [_bgScrollView addSubview:contentView];
        }
        
        [_bgScrollView setContentOffset:CGPointMake(MainScreen_W*(statePage-1), 0)];
    }
    
    return self;
}


-(UIScrollView *)bgScrollViewWithCount:(NSInteger)num{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentToolView.frame.size.height, MainScreen_W, self.bounds.size.height-_segmentToolView.bounds.size.height)];
        _bgScrollView.contentSize=CGSizeMake(MainScreen_W*num, self.bounds.size.height-_segmentToolView.bounds.size.height);
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.delegate=self;
        _bgScrollView.bounces=NO;
        _bgScrollView.pagingEnabled=YES;
    }
    return _bgScrollView;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_bgScrollView)
    {
        NSInteger p=_bgScrollView.contentOffset.x/MainScreen_W;
        _segmentToolView.defaultIndex=p+1;
        
    }
    
}

@end
