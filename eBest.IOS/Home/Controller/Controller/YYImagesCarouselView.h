//
//  YYImagesCarouselView.h
//  YYPsychologist
//
//  Created by 连艳敏 on 16/5/3.
//  Copyright © 2016年 连艳敏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetupCell)(NSIndexPath *indexPath,UICollectionViewCell *cell);
typedef void(^DidSelectCell)(NSIndexPath *indexPath);
typedef id (^CellClassBlock)(void);
typedef NSInteger(^ItemNumberBlock)(void);

@interface YYImagesCarouselView : UIView

@property (assign, nonatomic) CGFloat timeAction;
@property (assign, nonatomic) CGSize itemSize;

+ (instancetype)imagesCarouselView;

/*---------- optional ----------*/
- (void)setupCell:(SetupCell)block;
- (void)didSelectCell:(DidSelectCell)block;
/**
 *  自定义cell
 *
 *  @param block 如果是代码创建的返回class xib返回xib名字
 */
- (void)cellClassWith:(CellClassBlock)block;
- (void)itemNumberWith:(ItemNumberBlock)block;
/*---------- optional ----------*/

- (void)reloadData;
@end
