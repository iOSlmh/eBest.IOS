//
//  AddressViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@class AddressChoicePickerView;
typedef void (^AddressChoicePickerViewBlock)(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate);
@interface AddressChoicePickerView : UIView
{
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}
@property (copy, nonatomic)AddressChoicePickerViewBlock block;

- (void)show;
@end
