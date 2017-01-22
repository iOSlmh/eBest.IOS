//
//  HeaderView.h
//  eBest.IOS
//
//  Created by 李明浩 on 16/9/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (strong,nonatomic)UIView *scrollLineView;//btn下面的滑动条
@property (nonatomic,strong) UIButton *storeHomeBtn;
@property (nonatomic,strong) UIButton *stopHomeBtn;

@property (weak, nonatomic) IBOutlet UIView *headerImageV;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageV;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeDesc;
@property (nonatomic,strong) NSString * store_status;
@property (nonatomic,strong) NSMutableArray * classArray;
+ (instancetype)headerView;

@end
