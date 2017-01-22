//
//  SetCodeViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/25.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
@interface SetCodeViewController : UIViewController<RegisterMobileDelegate>
- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *secretCode;

- (IBAction)becomeMember:(UIButton *)sender;

@end
