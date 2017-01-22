//
//  RegisterViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/18.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

@protocol RegisterMobileDelegate <NSObject>

-(void)postMobileWithPhoneNum:(NSString *)phoneNum;

@end
#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *checkNum;
- (IBAction)singleBtn:(UIButton *)sender;
- (IBAction)contractBtn:(UIButton *)sender;
- (IBAction)nextBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property(weak,nonatomic)id<RegisterMobileDelegate>delegate;
@end
