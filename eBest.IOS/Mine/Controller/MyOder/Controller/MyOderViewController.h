//
//  MyOderViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/15.
//  Copyright © 2016年 shijiboao. All rights reserved.
//
@protocol OderViewToPayDelegate <NSObject>

-(void)oderToPay:(NSString *)oderPayID;

@end
#import <UIKit/UIKit.h>

@interface MyOderViewController : UIViewController
/**
 *  当前状态
 */
@property (assign, nonatomic)NSInteger statePage;
@property(nonatomic,weak) id<OderViewToPayDelegate>delegate;
@end
