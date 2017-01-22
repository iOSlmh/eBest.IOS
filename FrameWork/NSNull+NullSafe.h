//
//  NSNull+NullSafe.h
//  mallbuilderIOS
//
//  Created by yuanfeng on 15/11/20.
//  Copyright © 2015年 yuanfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (NullSafe)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector;
@end
