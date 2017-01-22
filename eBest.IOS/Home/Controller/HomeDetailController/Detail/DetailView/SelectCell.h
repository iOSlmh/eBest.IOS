//
//  SelectCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

@protocol SelectCellHeight <NSObject>

-(void)backWithNum:(int)num;

@end
@protocol TypeSeleteDelegete <NSObject>

-(void)selectBtn:(UIButton *)btn btnID:(NSString *)IDStr selectPhoto:(NSString *)photoPath;

@end

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface SelectCell : UITableViewCell
{
    int _btnTag;
 
}

@property (nonatomic,retain) id<TypeSeleteDelegete> testdelegate;
@property(strong,nonatomic) NSString * selectColor;
@property (nonatomic,strong) UIButton   *button;
@property(nonatomic,retain) id<SelectCellHeight>delegate;
@property(nonatomic,strong) NSMutableArray * chicun;
@property(nonatomic,strong) NSMutableArray * idArr;
@property(nonatomic,strong) NSMutableArray * idGroupArr;
@property(nonatomic,strong) NSMutableArray * btnArr;
@property(nonatomic,strong) NSMutableArray * photoArr;

-(void)refreshUI:(NSDictionary *)dic sectionIndex:(NSInteger)section;
@end
