//
//  UIButton+Extension.m
//
//

//

#import "UIButton+Extension.h"
#import "Header.h"

@implementation UIButton (Extension)

+(UIButton *)createBtnImageFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
 
    [btn setImage:[UIImage imageNamed:@"gg_love_press"] forState:UIControlStateSelected];
    
    [btn setImage:[UIImage imageNamed:@"attention_icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"attention_icon"] forState:UIControlStateHighlighted];

    
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}
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
+(UIButton *)createBtnWithNumber:(NSString *)num Title:(NSString *)title Frame:(CGRect)frame Target:(id)target Selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height/2)];
    numLabel.text = num;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor blackColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.height/2, btn.frame.size.width, btn.frame.size.height/2)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    btn.backgroundColor = [UIColor clearColor];
    
    [btn addSubview:numLabel];
    [btn addSubview:titleLabel];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}


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
+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed Title:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newImage = [UIImage imageNamed: image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = [UIImage imageNamed: imagePressed];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
/**
 *  UIButton文字图片垂直显示
 *
 *  @param image    图片
 *  @param title    文字
 *  @param target   self
 *  @param selector 点击时间
 *
 *  @return 返回button
 */
+ (UIButton*) createButtonWithImage:(NSString *)image Title:(NSString *)title Target:(id)target Selector:(SEL)selector{
    UIButton * button = [UIButton new];
    UIImage *Image = [[UIImage imageWithName:image] scaleImageWithSize:CGSizeMake(35, 35)];
    [button setImage:Image forState:UIControlStateNormal];
    //[button setImage:[UIImage imageWithName:nil] forState:UIControlStateHighlighted];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:nil forState:UIControlStateHighlighted];
        button.titleLabel.font =[UIFont systemFontOfSize:14 ];

    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
    //设置内容垂直或水平显示位置
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 20, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(40,-35, 0, 0);

    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}

/**
 *  图片按钮
 *
 *  @param frame        尺寸
 *  @param target       self
 *  @param selector     点击事件
 *  @param image        前景颜色
 *  @param imagePressed 高亮颜色
 *
 *  @return 返回button
 */
+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newImage = [UIImage imageNamed: image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = [UIImage imageNamed: imagePressed];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
/**
 *  文字按钮
 *
 *  @param frame    尺寸
 *  @param title    标题
 *  @param target   self
 *  @param selector 点击事件
 *
 *  @return 返回button
 */
+ (UIButton *) createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return button;
}


+ (UIButton *) createButtonWithTitle:(NSString *)title Image:(NSString *)image Target:(id)target Selector:(SEL)selector{
    UIButton * button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,16, 0, 0)];
    [button setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:nil] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//设置具有圆角的按钮
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)font titleColor:(UIColor *)titleColor buutonRadius:(CGFloat)buutonRadius  borderWidth:(CGFloat)borderWidth Target:(id)target Selector:(SEL)selector
{
    UIButton *button=[UIButton new];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.text=title;
    
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=buutonRadius;
    button.layer.borderWidth=borderWidth;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
//设置一个普通有图片按钮
+(UIButton *)createButtonWithFrame:(CGRect)frame image:(NSString *)image Target:(id)target Selector:(SEL)selector
{
    UIButton *button=[UIButton new];
    button.frame=frame;
    [button setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
