//
//  UnlockViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/23.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TiePhoneViewControllerDelegate <NSObject>

-(void)getPhone:(NSString *)phoneNum;

@end
@interface UnlockViewController : UIViewController
@property(assign,nonatomic)id <TiePhoneViewControllerDelegate>delegate;
@property(nonatomic,strong) NSMutableDictionary *dict;
@end
