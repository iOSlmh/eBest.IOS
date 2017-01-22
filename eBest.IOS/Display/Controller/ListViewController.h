//
//  ListViewController.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/1.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import "RootViewController.h"

@interface ListViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic,copy) NSNumber * listGoosID;
@property (nonatomic,assign) NSInteger tapTag;

@property (nonatomic,strong) NSMutableArray * patternArr;
@property (nonatomic,strong) NSMutableArray * materialsArr;
@property (nonatomic,strong) NSMutableArray * subjectArr;
@property (nonatomic,strong) NSMutableArray * implicationArr;

@end
