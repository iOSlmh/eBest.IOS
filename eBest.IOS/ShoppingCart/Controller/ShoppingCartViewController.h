//
//  ShoppingCartViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

//************************************废弃代理*************************************
////传价格代理
//@protocol ShoppingCarPostPriceToOrderDelegate <NSObject>
//
//-(void)postPriceWith:(CGFloat)price;
//
//@end
////购物车数组ID代理
//@protocol OrderPostDelegate <NSObject>
//
//-(void)orderPostWitArr:(NSMutableArray *)goodsCarIdArr;
//
//@end
//************************************废弃代理*************************************
#import "RootViewController.h"
#import "ChooseRank.h"
#import "ChooseView.h"
@interface ShoppingCartViewController : RootViewController
@property(nonatomic,copy) NSString * statuFrom;
@property(strong,nonatomic) NSMutableArray * IDArr;

//-(void)allBtn:(BOOL)isbool;

-(void)editBtn:(BOOL)isbool;

-(void)deleteBtn:(BOOL)isbool;

@property(nonatomic,strong)ChooseView *chooseView;
@property(nonatomic,strong)ChooseRank *chooseRank;

@property(nonatomic,strong)NSMutableArray *rankArray;
//************************************废弃代理*************************************
//@property(nonatomic,weak)id<ShoppingCarPostPriceToOrderDelegate>pricedelegate;
//@property(nonatomic,weak)id<OrderPostDelegate>oderdelegate;
//************************************废弃代理*************************************
@end
