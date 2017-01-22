//
//  NSDictionary+Extension.m
//  mallbuilderIOS
//
//  Created by yuanfeng on 15/11/9.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import <objc/runtime.h>

@implementation NSDictionary (Extension)
//+(void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class=[self class];
//        SEL originalSelector=@selector(setValue: forKey:);
//        SEL swizzledSelector=@selector(setCheckValue: forKey:);
//        
//        Method originalMethod=class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod=class_getInstanceMethod(class, swizzledSelector);
//        
//        BOOL didAddMethod =
//        class_addMethod(class,
//                        originalSelector,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod));
//        
//        if (didAddMethod) {
//            class_replaceMethod(class,
//                                swizzledSelector,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//        
//    });
//}
-(void)setCheckValue:(id)value forKey:(NSString *)key
{
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]])
    {
        [self setValue:@"" forKey:key];
        NSLog(@"1111111111");
    }
}

@end
