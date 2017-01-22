//
//  ConfirmTieViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/13.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmTieViewController : UIViewController

@property (nonatomic,copy) NSString * classifyState;
@property (weak, nonatomic) IBOutlet UITextField *phTF;
@property (weak, nonatomic) IBOutlet UITextField *psTF;
- (IBAction)confirmBtn:(UIButton *)sender;
- (IBAction)backBtn:(UIButton *)sender;

@end
