//
//  CheckPhoneViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPhoneViewController : UIViewController

@property (nonatomic,copy) NSString * checkPhone;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UITextField *checkCode;
- (IBAction)nextTip:(UIButton *)sender;

@end
