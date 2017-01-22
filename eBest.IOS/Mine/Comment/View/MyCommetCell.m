//
//  MyCommetCell.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/8/17.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "MyCommetCell.h"
#import <UIKit/UIKit.h>
@implementation MyCommetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.clipsToBounds = YES;
        self.backgroundColor = RGB(247, 247, 247, 1);
        [self createCell];
    }
    return self;
}

-(void)createCell{

    _topView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SW, 105)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_topView];
    _imageV = [FactoryUI createImageViewWithFrame:CGRectMake(15, 15, 75, 75) imageName:@"1"];
    _imageV.layer.borderWidth = 1;
    _imageV.layer.borderColor = RGB(226, 226, 226, 1).CGColor;
    [_topView addSubview:_imageV];
    _goodsName = [FactoryUI createLabelWithFrame:CGRectMake(102, 12, 254, 37) text:@"玉石对肯德基激活端口搭建和黑的可" textColor:RGB(71, 71, 71, 1) font:[UIFont systemFontOfSize:13]];
    [_topView addSubview:_goodsName];
    
    _ratingBar1 = [[RatingBar alloc]init];
    _ratingBar1.frame = CGRectMake(102, 65, 150, 30);
    [_ratingBar1 displayRating:3 andView:self.topView];
    [_ratingBar1 setImageDeselected:@"Star 19 Copy 16" halfSelected:nil fullSelected:@"Star 19 Copy 14" andDelegate:self];
    [_topView addSubview:_ratingBar1];
    
    _ptview=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 106, SW, 134)];
    _ptview.delegate = self;
    _ptview.placeholder=@"请输入评论";
    _ptview.font=[UIFont systemFontOfSize:14];
    _ptview.placeholderFont=[UIFont systemFontOfSize:13];
    _number = 0;
    lab = [[UILabel alloc]initWithFrame:CGRectMake(SW-65, _ptview.frame.size.height-20, 50, 10)];
    lab.textColor = RGB(175, 175, 175, 1);
    lab.font = [UIFont systemFontOfSize:10];
    lab.text = [NSString stringWithFormat:@"%ld/250",_number];
    [_ptview addSubview:lab];
    [self.contentView addSubview:_ptview];
    
    _botView = [FactoryUI createViewWithFrame:CGRectMake(0, 241, SW, 48)];
    _botView.backgroundColor = [UIColor whiteColor];
    _btn = [FactoryUI createButtonWithFrame:CGRectMake((SW-106)/2, 10, 106, 27) title:@"添加商品照片" titleColor:RGB(32, 179, 169, 1) imageName:@"button_upload photos" backgroundImageName:@"" target:self selector:@selector(addBtn:)];
    _btn.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    _btn.layer.borderWidth = 1;
    _btn.layer.cornerRadius = 0.5;
    _btn.layer.masksToBounds = YES;
    [_botView addSubview:_btn];
    [self.contentView addSubview:_botView];
    
    _selectView = [FactoryUI createViewWithFrame:CGRectMake(0, 241, SW, 198)];
    _selectView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_selectView];
    _selectImageV = [FactoryUI createImageViewWithFrame:CGRectMake(12.5, 12, SW-25, 135) imageName:@""];
    _selectImageV.backgroundColor = [UIColor lightGrayColor];
    [_selectView addSubview:_selectImageV];
    //隐藏
    _selectView.hidden = YES;
    
    UIButton * postBtn = [FactoryUI createButtonWithFrame:CGRectMake(52, 160, 104, 27) title:@"重新上传图片" titleColor:RGB(32, 179, 169, 1) imageName:@"button_upload photos" backgroundImageName:@"" target:self selector:@selector(addBtn)];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    postBtn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    postBtn.layer.borderWidth = 1;
    postBtn.layer.cornerRadius = 0.5;
    postBtn.layer.masksToBounds = YES;
    [_selectView addSubview:postBtn];

    UIButton * deleteBtn = [FactoryUI createButtonWithFrame:CGRectMake(219, 160, 104, 27) title:@"删除图片" titleColor:RGB(32, 179, 169, 1) imageName:@"button_delete photos" backgroundImageName:@"" target:self selector:@selector(addBtn)];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    deleteBtn.layer.borderColor = RGB(32, 179, 169, 1).CGColor;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.cornerRadius = 0.5;
    deleteBtn.layer.masksToBounds = YES;
    [_selectView addSubview:deleteBtn];

}
-(void)addBtn:(UIButton *)btn{
    
    NSNotification *notification =[NSNotification notificationWithName:@"DidPhoto" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

//实现计算字数代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location>=500)
    {
        return  NO;
    }else
    {
        return YES;
    }
    
}

//计算可输入剩余字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString  * nsTextContent=textView.text;
    _number=[nsTextContent length];
    lab.text = [NSString stringWithFormat:@"%ld/250",_number];
    NSLog(@"%ld",(long)_number);
}

-(void)ratingChanged:(float)newRating andView:(UIView *)baseView{
    
    NSNumber * num = [NSNumber numberWithInteger:baseView.tag];
    NSLog(@"----------------%ld",(long)baseView.tag);
    self.orderScore = [NSNumber numberWithFloat:newRating];
    NSLog(@"----------------%@",self.orderScore);
    NSDictionary * starDic = @{@"description_evaluate":self.orderScore,@"index":num};
    NSNotification *notification =[NSNotification notificationWithName:@"starValue" object:nil userInfo:starDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

-(void)giveCellWithDict:(NSDictionary *)dict{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
