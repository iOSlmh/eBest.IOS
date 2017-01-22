//
//  OderDetailViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

@protocol OderDetailToPayDelegate <NSObject>

-(void)oderDetailToPay:(NSString *)oderPayID;

@end
#import <UIKit/UIKit.h>

@interface OderDetailViewController : UIViewController
@property(nonatomic,assign) NSInteger selectID;
@property(nonatomic,assign) NSInteger classify;
@property(nonatomic,assign) NSInteger indexSection;
@property(nonatomic,weak) id<OderDetailToPayDelegate>delegate;
@end
