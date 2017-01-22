//
//  OrderViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/22.
//  Copyright © 2016年 shijiboao. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,assign) CGFloat allPrice;
@property(nonatomic,strong) NSString * IDString;

@end
