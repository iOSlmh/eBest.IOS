//
//  LXSegmentScrollView.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXSegmentScrollView : UIView

-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray andStatePage:(NSInteger)statePage andImageArr:(NSArray *)imageArray;


@end
