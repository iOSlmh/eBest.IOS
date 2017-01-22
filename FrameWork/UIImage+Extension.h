//
//  UIImage+Extension.h
//  
//
//  
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage*) imageWithName:(NSString *) imageName;
+ (UIImage*) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;
@end
