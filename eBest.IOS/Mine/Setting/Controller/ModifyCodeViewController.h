//
//  ModifyCodeViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyCodeViewController : UIViewController
@property(weak, nonatomic) IBOutlet UITextField *setPassword;
@property(nonatomic,strong) NSString * mobile;
- (IBAction)saveBtn:(UIButton *)sender;

@end
