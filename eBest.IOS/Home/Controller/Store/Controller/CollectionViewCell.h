//
//  CollectionViewCell.h
//  eBest.IOS
//
//  Created by 李明浩 on 16/9/11.
//  Copyright © 2016年 shijiboao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ImageV;
@property (weak, nonatomic) IBOutlet UILabel *desclabel;
@property (weak, nonatomic) IBOutlet UILabel *cruPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;

@end
