//
//  PersonalViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/6/20.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GetmainNichengname <NSObject>

-(void)getmainNicheng:(NSString *)name;

@end

@interface PersonalViewController : UIViewController

@property(assign,nonatomic)id <GetmainNichengname>delegate;

@end
