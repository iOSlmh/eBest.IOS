//
//  CommentModel.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/7/29.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}
-(void)setEvaluate_info:(NSString *)evaluate_info{
    
    CGSize size = [evaluate_info boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(9)-UNIT_WIDTH(57),CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
    
    _messageHight = size.height;
    
    NSLog(@"----------------%ld",(long)_messageHight);
    
    _rowHeight += size.height + 92;
    
    _evaluate_info = evaluate_info;
}

-(void)setImg_path:(NSString *)img_path{

    if (img_path) {
        _rowHeight += 85;
    }else{
        _rowHeight +=0;
    }
    _img_path = img_path;
}
-(void)setUser_img:(NSString *)user_img{

    _user_img = user_img;
}
-(void)setUsername:(NSString *)username{

    CGSize size = [username boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(9)-UNIT_WIDTH(57),CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
    _nameWeith = size.width;
    _username = username;
}
//-(void)setGeval_image:(NSArray *)geval_image{
//    
//    _rowHeight += geval_image.count>0?85:0;
//    
//    _geval_image = geval_image;
//    
//}

-(void)setAddTime:(NSString *)addTime{

    _addTime = addTime;
}
//-(void)setGeval_addtime:(NSString *)geval_addtime{
//    
//    NSString *confromTimespStr;
//    
//    if ([geval_addtime isEqualToString:@""]) {
//        
//        confromTimespStr =@"";
//        
//    }else{
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        
//        [formatter setDateFormat:@"YYYY-MM-dd"];
//        
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:geval_addtime.longLongValue];
//        
//        confromTimespStr = [formatter stringFromDate:confromTimesp];
//        
//        
//    }
//    _geval_addtime = confromTimespStr;
//}


@end
