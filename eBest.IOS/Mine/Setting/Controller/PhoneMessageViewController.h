//
//  PhoneMessageViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/10/31.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneMessageViewController : UIViewController

@property (nonatomic,copy) NSString * phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *phoneMessage;
- (IBAction)changeNumBtn:(UIButton *)sender;

@end
