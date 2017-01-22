

#import <UIKit/UIKit.h>


/**
 *  要是用非 arc。。。。。。／／     -fno-objc-arc
 */
@interface PlaceholderTextView : UITextView

@property(copy,nonatomic) NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;
@end

