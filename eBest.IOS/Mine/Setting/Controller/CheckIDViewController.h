//
//  CheckIDViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/4.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
- (IBAction)checkBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *checkTF;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)kefuBtn:(UIButton *)sender;
@property(nonatomic,strong) NSString * mobile;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;

@end
