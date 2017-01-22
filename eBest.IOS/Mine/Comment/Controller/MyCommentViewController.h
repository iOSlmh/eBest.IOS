//
//  MyCommentViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
@interface MyCommentViewController : UIViewController

@property (nonatomic,strong)UIButton * evaluateBtn;
@property (nonatomic,strong)NSNumber * orderScore;
@property (nonatomic,strong)NSNumber * serviceScore;
@property (nonatomic,strong)NSNumber * wuliuScore;
@property (nonatomic,strong)NSNumber *orderId;

@property (nonatomic,strong) RatingBar *ratingBar1;
@property (nonatomic,strong) RatingBar *ratingBar2;
@property (nonatomic,strong) RatingBar *ratingBar3;

-(void)giveCellWithDict:(NSDictionary *)dict;
@end
