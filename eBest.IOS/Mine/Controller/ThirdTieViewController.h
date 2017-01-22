//
//  ThirdTieViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/12.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdTieViewController : UIViewController

@property (nonatomic,copy) NSString * classifyState;
@property (nonatomic,copy) NSString * wbToken;
@property (nonatomic,copy) NSString * wbOpenID;
@property (nonatomic,copy) NSString * wbNickName;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)getCodeBtn:(UIButton *)sender;
- (IBAction)cofirmBtn:(UIButton *)sender;
- (IBAction)tieBtn:(UIButton *)sender;
- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *ggBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;


@end
