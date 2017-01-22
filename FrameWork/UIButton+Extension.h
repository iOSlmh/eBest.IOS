//
//  UIButton+Extension.h

//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+(UIButton *)createBtnImageFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector;
/**
 *  设置按钮上面显示两个label，上下显示
 *
 *  @param num      上面label
 *  @param title    下面label
 *  @param frame    位置
 *  @param target   self
 *  @param selector 点击事件
 *
 *  @return 返回button
 */
+(UIButton *)createBtnWithNumber:(NSString *)num Title:(NSString *)title Frame:(CGRect)frame Target:(id)target Selector:(SEL)selector;

/**
 *  图片和文字按钮
 *
 *  @param frame        尺寸
 *  @param target       self
 *  @param selector     点击事件
 *  @param image        前景颜色
 *  @param imagePressed 高亮颜色
 *  @param title    标题
 *
 *  @return 返回按钮
 */
+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed Title:(NSString *)title;

+ (UIButton*) createButtonWithImage:(NSString *)image Title:(NSString *)title Target:(id)target Selector:(SEL)selector;



+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;


+ (UIButton *) createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector;

+ (UIButton *) createButtonWithTitle:(NSString *)title Image:(NSString *)image Target:(id)target Selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)titleColor buutonRadius:(CGFloat)buutonRadius borderWidth:(CGFloat)borderWidth Target:(id)target Selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame image:(NSString *)image Target:(id)target Selector:(SEL)selector;
@end
