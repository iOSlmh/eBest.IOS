//
//  AddressCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/26.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code

}

- (IBAction)selectBtn:(UIButton *)sender {

    NSDictionary * dic = @{@"addr_id":self.addr_id};
    //点击按钮改变标题颜色
    for (UIButton *btn in _btnArray) {
        
        if (btn.tag == sender.tag) {
            NSLog(@"----------------%ld",(long)btn.tag);
//            [btn  setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
            [RequestTools posUserWithURL:@"/default_address_save.mob" params:dic success:^(NSDictionary *Dict) {
                
                if ([Dict[@"return_info"][@"successFlag"]isEqualToString:@"success"]) {
                
                    NSNotification *notification =[NSNotification notificationWithName:@"refreshAddr" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [MyHUD showAllTextDialogWith:@"已设置为默认地址" showView:self];
                    
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }else {
//            [btn  setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
        }
    }
    
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.1f];

}
-(void)delay{

    //复用问题暂时使用刷新方法
    //刷新通知
    NSNotification * renotification =[NSNotification notificationWithName:@"refUI" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:renotification];

}
-(void)getModel:(AddressModel *)model{

    //判断是否为默认地址
    if ([model.type isEqualToString:@"default"]) {
        [self.propertyBtn setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];

    }else{
        
        [self.propertyBtn  setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
    }
    
    //赋值
    self.nameStr.text = model.trueName;
    self.mobileStr.text = model.mobile;
    self.addressStr.text = model.area_info;
    self.addr_id = model.addrID;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
