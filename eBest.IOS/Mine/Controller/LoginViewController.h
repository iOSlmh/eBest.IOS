//
//  LoginViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/18.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)backBtn:(UIButton *)sender;
- (IBAction)joinBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)forgetNumBtn:(UIButton *)sender;
- (IBAction)loginQQ:(UIButton *)sender;
- (IBAction)loginWeibo:(UIButton *)sender;
- (IBAction)loginWeixin:(UIButton *)sender;

@end
