//
//  NicknameViewController.h
//  mallbuilderIOS
//
//  Created by yuanfeng01 on 15/10/19.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NicknameViewControllerDelegate <NSObject>

-(void)getName:(NSString *)name;

@end

@interface NicknameViewController : UIViewController
@property(assign,nonatomic)id <NicknameViewControllerDelegate>delegate;
@property(nonatomic,strong) NSMutableDictionary *dict;
@end
