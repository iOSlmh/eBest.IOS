//
//  AddressCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameStr;
@property (weak, nonatomic) IBOutlet UILabel *mobileStr;
@property (weak, nonatomic) IBOutlet UILabel *addressStr;
@property (weak, nonatomic) IBOutlet UIButton *propertyBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,strong) NSMutableArray * btnArray;
@property (nonatomic,strong) UIButton   *button;
@property (nonatomic,copy) NSNumber * addr_id;
@property (nonatomic,strong) AddressModel * adModel;

-(void)getModel:(AddressModel *)model;

@end
