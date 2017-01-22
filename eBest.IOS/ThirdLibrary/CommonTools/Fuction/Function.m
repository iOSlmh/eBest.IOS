//
//  Function.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/7.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "Function.h"

@implementation Function


+(BOOL)is_Login{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:k_user]) {
        
        NSLog(@"----------------%@",[[NSUserDefaults standardUserDefaults] objectForKey:k_user]);
        NSLog(@"----------------%@",[[NSUserDefaults standardUserDefaults] objectForKey:k_Key]);
        return YES;
        
    }else{
        return NO;
    }
    
}
+(NSString *)getKey{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"];
    
}

+(NSString *)getUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}

+ (void)removeKey {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_key"];
}

+(NSString *)getUserName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

+(BOOL)allow_camera{
    NSString *str = [NSString stringWithFormat:@"%@/Library/Caches/allowcamera.txt",NSHomeDirectory()];
    if ([[NSFileManager defaultManager]fileExistsAtPath:str ]) {
        return YES;
    }else{
        return NO;
    }
}
+(void)startTime:(UIButton *)btn{
    //    self.checkBtn .backgroundColor = [UIColor lightGrayColor];
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                //设置不可点击
                btn.userInteractionEnabled = YES;
                //                self.checkBtn .backgroundColor = [UIColor orangeColor];
                
            });
        }else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [btn  setTitle:[NSString stringWithFormat:@"%@秒后发送",strTime] forState:UIControlStateNormal];
                //设置可点击
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}


@end
