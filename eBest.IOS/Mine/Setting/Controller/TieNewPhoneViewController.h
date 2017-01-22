//
//  TieNewPhoneViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieNewPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *setNewPhone;
@property (weak, nonatomic) IBOutlet UITextField *checkCode;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;
- (IBAction)saveBtn:(UIButton *)sender;


@end
