//
//  MyHUD.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/10.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyHUD.h"

@implementation MyHUD


+(void)showAllTextDialogWith:(NSString *)text showView:(UIView *)view{

    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];


}


@end
