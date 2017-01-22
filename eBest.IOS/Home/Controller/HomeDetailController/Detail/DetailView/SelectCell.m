//
//  SelectCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "SelectCell.h"
#import "DetailViewController.h"
#import "HomeViewController.h"

@implementation SelectCell
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//       
//        NSLog(@"%@",reuseIdentifier);
//        [self createUI];
//    }
//    
//    return self;
//}
//-(void)postSelectArr:(NSMutableArray *)arr{
//
//}

-(void)refreshUI:(NSDictionary *)dic sectionIndex:(NSInteger)section{
    
    NSLog(@"测试---------------------------------%@",[dic objectForKey:@"name"]);
    _idArr = [[NSMutableArray alloc]init];
    _chicun = [[NSMutableArray alloc]init];
    _idGroupArr = [[NSMutableArray alloc]init];
    _photoArr = [[NSMutableArray alloc]init];
    
    NSArray * detailArr = [dic objectForKey:@"addprodetail"];
    
//    for (int i=0; i<2; i++) {
//        for (int j = 0; j<detailArr.count; j++) {
//            NSDictionary * dic = detailArr[j];
//            NSString * guigeID = [[dic objectForKey:@"id"]stringValue];
//            [_idArr addObject:guigeID];
//            NSString * detailStr = [dic objectForKey:@"value"];
//            [_chicun addObject:detailStr];
//            
//        }
//           [_idGroupArr addObject:_idArr];
//        NSLog(@"%lu",(unsigned long)_idGroupArr.count);
//        
//    }
    for (NSDictionary * dic in detailArr) {
        
        NSString * guigeID = [[dic objectForKey:@"id"]stringValue];
        [_idArr addObject:guigeID];
        
        NSString * photoPath = dic[@"specImage"][@"path"];
        [_photoArr addObject:photoPath];

        NSString * detailStr = [dic objectForKey:@"value"];
        [_chicun addObject:detailStr];
    }
    [_idGroupArr addObject:_idArr];
    
    NSLog(@"组个数=======================================%lu",(unsigned long)_idGroupArr.count);
    NSLog(@"数组个数=======================================%lu",(unsigned long)_chicun.count);
    NSLog(@"id个数=======================================%lu",(unsigned long)_idArr.count);
//    NSLog(@"第二个地市%@",_idArr[2]);
    [self createUI:section];
}

-(void)createUI:(NSInteger)sectionIndex{
    
    self.btnArr = [NSMutableArray array];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    int j = 0;  //记录行数
    for (int i = 0; i < _chicun.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = self.tag + i;
        NSLog(@"----------------%ld",(long)button.tag);
        button.superview.tag = sectionIndex;
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGB(175, 175, 175, 1).CGColor;
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGB(71, 71, 71, 1) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        [self.btnArr addObject:button];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat length = [_chicun[i] boundingRectWithSize:CGSizeMake(SW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:_chicun[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15+14 , 25);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > SW){
            j++;
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 25);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.contentView addSubview:button];
    }

    DetailViewController * detailVC = [[DetailViewController alloc]init];
    self.delegate = detailVC;
    [_delegate backWithNum:j];
    
    NSLog(@"************************%d",j);

}

//    点击事件
- (void)handleClick:(UIButton *)btn{

    NSInteger index = btn.tag-self.tag;
    NSString * str = _idArr[index];
    NSString * selectPhoto = _photoArr[index];
    [self.testdelegate selectBtn:btn btnID:str selectPhoto:selectPhoto];
    
    //点击按钮改变标题颜色
    for (UIButton *button in _btnArr) {
        NSLog(@"----------------%ld",(long)button.tag);
        NSLog(@"----------------%ld",(long)btn.tag);
        if (button.tag == btn.tag) {
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
            [button setTitleColor:RGB(32, 179, 169, 1) forState:UIControlStateNormal];
            
        }else {
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = RGB(175, 175, 175, 1).CGColor;
            [button setTitleColor:RGB(71, 71, 71, 1) forState:UIControlStateNormal];
            
        }
    }
    
//    // 状态切换
//    if (btn != self.button) {
//        self.button.selected = NO;
//        self.button = btn;
//        
//    }
//    self.button.selected = YES;
//    self.selectColor = btn.titleLabel.text;
//
//    NSLog(@"%@",self.selectColor);
//    NSLog(@"%ld",(long)btn.tag);
//    NSInteger i = btn.tag-100;
//    NSLog(@"%@",_idArr[i]);
}
-(void)btnClick{

}
- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor redColor];

   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
