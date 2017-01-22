//
//  AlertShow.m
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/9/9.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "AlertShow.h"

@implementation AlertShow

+ (void)showAlert:(NSString *) _message{
    
    //时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethods:)
                                   userInfo:promptAlert
                                    repeats:NO];
    [promptAlert show];
}

//定时提示弹框
+ (void)timerFireMethods:(NSTimer*)theTimer{
    
    //弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

@end
