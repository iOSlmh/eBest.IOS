//
//  ModelForMessageAndImage.m
//  JYMallForEnterprise
//
//  Created by 91.Mall on 16/7/2.
//  Copyright © 2016年 91jksc. All rights reserved.
//

#import "ModelForMessageAndImage.h"
#import <UIKit/UIKit.h>
@implementation ModelForMessageAndImage

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  
}
-(void)setValue:(NSString *)value{
    
    if ([_type isEqualToString:@"text"]) {
        
        CGSize size = [value boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - UNIT_WIDTH(165),CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
        
        _textHeight = size.height;
        
    }
    _value = value;
    
}
-(void)setPath:(NSString *)path{
    
    
    _path = [Image_url stringByAppendingString:path];
    
    CGSize size = [self downloadImageSizeWithURL:_path];
    NSLog(@"----------------%@",_path);
    _imageHeight = size.height;
    
}
-(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    
    NSURL* URL = nil;
    
    if([imageURL isKindOfClass:[NSURL class]]){
        
        URL = imageURL;
        //以便在block中使用
        __block UIImage *image = [[UIImage alloc] init];
        
        //将图片下载在异步线程进行
        //创建异步线程执行队列
        dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue", NULL);
        //创建异步线程
        dispatch_async(asynchronousQueue, ^{
            //网络下载图片  NSData格式
            NSError *error;
            NSData *imageData = [NSData dataWithContentsOfURL:URL options:NSDataReadingMappedIfSafe error:&error];
            if (imageData) {
                image = [UIImage imageWithData:imageData];
            }
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        NSLog(@"----------------%f",image.size.height);
        return CGSizeMake(image.size.width, image.size.height);
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
        NSLog(@"----------------%@",URL);
        NSData * data = [NSData dataWithContentsOfURL:URL];
        UIImage * image = [UIImage imageWithData:data];
        NSLog(@"----------------%f",image.size.height);
        return CGSizeMake(image.size.width, image.size.height);
    }
    if(URL == nil)
        return CGSizeZero;
    
/*    NSString* absoluteString = URL.absoluteString;
 
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(image)
        {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
 */
    return CGSizeZero;
}
-(void)diskImageDataBySearchingAllPathsForKey:(id)message{
    
    NSLog(@"%@",message);
    
}
-(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
-(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
-(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage * image = [UIImage imageWithData:data];
    NSLog(@"----------------%f",image.size.height);
    NSLog(@"----------------%@",request);
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
        NSLog(@"----------------%hd",word);
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
