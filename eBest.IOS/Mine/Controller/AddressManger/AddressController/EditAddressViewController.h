//
//  EditAddressViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface EditAddressViewController : UIViewController
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
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *eCityTF;
@property (weak, nonatomic) IBOutlet UITextField *eAddressTF;
- (IBAction)eSaveBtn:(UIButton *)sender;

@property (nonatomic,strong) AddressModel * addressModel;
@end
