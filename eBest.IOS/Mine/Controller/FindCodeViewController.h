//
//  FindCodeViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/6.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIView *checkCode;
- (IBAction)nextBtn:(UIButton *)sender;

@end
