//
//  ShoppingCarCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/19.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "ShoppingCarCell.h"
@implementation ShoppingCarCell

- (void)awakeFromNib {
    
//    cell已在XIB加底线，去掉默认线
   
//    图片加边
    CALayer * layer = [self.imageV layer];
    layer.borderColor = RGB(244, 244, 244, 1).CGColor;
    layer.borderWidth = 1.0f;
    
    CGSize size = CGSizeMake(SW-145, self.frame.size.height-1);
    
    _editcartView = [FactoryUI createViewWithFrame:CGRectMake(145, 0, size.width, size.height)];
    _editcartView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_editcartView];
    
    _cutNumBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 20, UNIT_WIDTH(60), 35) title:@"-" titleColor:RGB(175, 175, 175, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(MinusBtn:)];
    _cutNumBtn.backgroundColor = RGB(236, 235, 235, 1);
    [_editcartView addSubview:_cutNumBtn];
    
    _countLabel = [FactoryUI createLabelWithFrame:CGRectMake(UNIT_WIDTH(60)+5, 20, UNIT_WIDTH(45), 35) text:@"1" textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:15]];
    _countLabel.backgroundColor = RGB(236, 235, 235, 1);
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_editcartView addSubview:_countLabel];
    
    _addNumBtn = [FactoryUI createButtonWithFrame:CGRectMake(UNIT_WIDTH(105)+10, 20, UNIT_WIDTH(60), 35) title:@"+" titleColor:RGB(175, 175, 175, 1) imageName:@"" backgroundImageName:@"" target:self selector:@selector(AddBtn:)];
    _addNumBtn.backgroundColor = RGB(236, 235, 235, 1);
    [_editcartView addSubview:_addNumBtn];
    _systemLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 60, UNIT_WIDTH(165)+10, 40) text:@"颜色：尺寸：款式：" textColor:RGB(175, 175, 175, 1) font:[UIFont systemFontOfSize:10]];
    _systemLabel.backgroundColor = RGB(236, 235, 235, 1);
    [_editcartView addSubview:_systemLabel];
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.frame = CGRectMake(0, 60, UNIT_WIDTH(165)+10, 40);
    [_editcartView addSubview:_clearBtn];
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(UNIT_WIDTH(165)+10, 0, size.width-UNIT_WIDTH(165)-10, size.height);
    [_deleteBtn setImage:[UIImage imageNamed:@"shopping_delete"] forState:UIControlStateNormal];
    [_editcartView addSubview:_deleteBtn];
    _editcartView.hidden = YES;
}

-(void)refreshUI:(ShoppingCarModel *)model{
   
    self.model = model;
    NSLog(@"----------------%@",model.count);
    self.showCount.text = [NSString stringWithFormat:@"x%@",[model.count stringValue]];
    _countLabel.text = [model.count stringValue];
    num = [model.count integerValue];
    self.guigeLabel.text = model.spec_info;
    self.nameLabel.text = [model.goods objectForKey:@"goods_name"];
    self.currentPrice.text = [NSString stringWithFormat:@"¥%.2ld",(long)[model.price floatValue]];
    self.oldPrice.text = [NSString stringWithFormat:@"¥%.2ld",(long)[model.goods[@"goods_current_price"] floatValue]];
    NSDictionary * photoDic = [model.goods objectForKey:@"goods_main_photo"];
    NSString * str = [photoDic objectForKey:@"path"];
    NSString * appStr = [NSString stringWithFormat:@"%@%@",Image_url,str];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:appStr] placeholderImage:[UIImage imageNamed:@"defaultFocusImage@3x"]];
    _systemLabel.text = model.spec_info;
    if (model.cellClickState == 1) {

        isbool = YES;
        [self.singleBtn setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
        
    } else {
        
        isbool = NO;
        [self.singleBtn setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
    }
    
    if (model.cellEditState ==1) {

        _editcartView.hidden = NO;
        
    }else{
        
        _editcartView.hidden = YES;
        
    }

    //判断库存
    [self getStock];
}

-(void)getStock{

    if (kIsEmptyArray(self.model.gaps_ids)) {
        
        //get数组参数拼接
        NSString * canshu = @"gapd_ids";
        NSMutableArray * muarr = [NSMutableArray array];
        for (int i = 0; i<self.model.gaps_ids.count; i++) {
            NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,self.model.gaps_ids[i]];
            [muarr addObject:appStr];
        }
        NSString *appString = [muarr componentsJoinedByString:@"&"];
        NSString * astr = @"/goods_selection_stock.mob?";
        NSString * getStr = [NSString stringWithFormat:@"%@%@&goods_id=%@",astr,appString,self.model.goods[@"id"]];
        NSLog(@"最终的字符串是 %@",getStr);
        [RequestTools getWithURL:getStr params:nil success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            
            self.stock = [Dict[@"stock"] integerValue];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        
        self.stock = [self.model.goods[@"goods_inventory"] integerValue];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)singleSelectBtn:(UIButton *)sender {
    
    if (isbool) {
        
        _model.cellClickState = 0;
        [_delegate ShoppingTableViewCell:_model];
        [sender setImage:[UIImage imageNamed:@"shopping_default"] forState:UIControlStateNormal];
        isbool = NO;
        
    }else{
        
        _model.cellClickState = 1;
        [_delegate ShoppingTableViewCell:_model ];
        [sender setImage:[UIImage imageNamed:@"shopping_selectde"] forState:UIControlStateNormal];
        isbool = YES;
    }
    
}
-(void)MinusBtn:(UIButton *)sender{
    
    if ((num - 1) <= 0 || num == 0) {
        
        NSLog(@"超出范围");
        [MyHUD showAllTextDialogWith:@"留一件吧!" showView:self];
        
    }else{
        
        num  = num -1;
        
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        _showCount.text = [NSString stringWithFormat:@"x%ld",(long)num];
        self.model.count = [NSNumber numberWithInteger:num];
        [_delegate ShoppingTableViewCell:_model];
        
        //更新数量
        NSString * canshu = @"gapd_ids";
        NSMutableArray * muarr = [NSMutableArray array];
        for (int i = 0; i<self.model.gaps_ids.count; i++) {
            NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,self.model.gaps_ids[i]];
            NSLog(@"%@",appStr);
            [muarr addObject:appStr];
        }
        NSString *appString = [muarr componentsJoinedByString:@"&"];
        NSString * astr = @"/update_goods_cart.mob?";
        NSString * getStr = [NSString stringWithFormat:@"%@gc_id=%@&count=%@&%@",astr,self.model.goodsCar_id,[NSNumber numberWithInteger:num],appString];
        NSLog(@"最终的字符串是 %@",getStr);
        [RequestTools posUserWithURL:getStr params:nil success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            
        } failure:^(NSError *error) {
            
        }];

    }
    
}

-(void)AddBtn:(UIButton *)sender{
    
    
    
    if (num+1<=self.stock) {
        
        num = num +1;
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        _showCount.text = [NSString stringWithFormat:@"x%ld",(long)num];
        self.model.count = [NSNumber numberWithInteger:num];
        [_delegate ShoppingTableViewCell:_model];
        
        //更新数量
        NSString * canshu = @"gapd_ids";
        NSMutableArray * muarr = [NSMutableArray array];
        for (int i = 0; i<self.model.gaps_ids.count; i++) {
            NSString * appStr = [NSString stringWithFormat:@"%@=%@",canshu,self.model.gaps_ids[i]];
            NSLog(@"%@",appStr);
            [muarr addObject:appStr];
        }
        NSString *appString = [muarr componentsJoinedByString:@"&"];
        NSString * astr = @"/update_goods_cart.mob?";
        NSString * getStr = [NSString stringWithFormat:@"%@gc_id=%@&count=%@&%@",astr,self.model.goodsCar_id,[NSNumber numberWithInteger:num],appString];
        NSLog(@"最终的字符串是 %@",getStr);
        [RequestTools posUserWithURL:getStr params:nil success:^(NSDictionary *Dict) {
            
            NSLog(@"----------------%@",Dict);
            
        } failure:^(NSError *error) {
            
        }];

    }else{
    
        [MyHUD showAllTextDialogWith:@"库存不足!" showView:self];
    }
    
}

@end
