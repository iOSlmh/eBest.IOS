//
//  AddAdressViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAdressViewController : UIViewController
{
    UIPickerView *picker;
    UIButton *button;
    UIView * bottomView;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString * districtStr;
    NSString *selectedProvince;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
- (IBAction)saveBtn:(UIButton *)sender;
@end
