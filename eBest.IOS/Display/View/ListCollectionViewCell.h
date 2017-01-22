//
//  ListCollectionViewCell.h
//  eBest.IOS
//
//  Created by 世纪博奥 on 16/4/5.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *cruPriceL;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceL;

@end
