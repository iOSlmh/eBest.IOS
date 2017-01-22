//
//  DetailViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/3/15.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

//@protocol DetailToSelectDelegate <NSObject>
//
//-(void)postSelectArr:(NSMutableArray *)arr;
//
//@end

@interface DetailViewController : UIViewController
@property(nonatomic,strong) NSString * testID;
@property(nonatomic,strong) DetailModel * detailModel;
-(void)loadDataWithID:(NSNumber *)ID;


//@property(weak,nonatomic)id<DetailToSelectDelegate>delegate;
@end
