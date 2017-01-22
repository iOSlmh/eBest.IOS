//
//  MBProgressHUD+NJ.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/13.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
