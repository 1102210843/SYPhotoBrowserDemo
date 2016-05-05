//
//  SYPhotoBrowserTool.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/5.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYPhotoBrowserTool.h"

@implementation SYPhotoBrowserTool

//获取缩略图
+ (UIImage *)getThumbImageWithIndex:(NSInteger)index thumbImages:(NSArray *)thumbImages
{
    if (thumbImages && index < thumbImages.count) {
        return thumbImages[index];
    }
    return nil;
}

//获取低画质图片
+ (id)getLowQualityImageWithIndex:(NSInteger)index lowQualityImages:(NSArray *)lowQualityImages
{
    if (lowQualityImages && index < lowQualityImages.count) {
        return lowQualityImages[index];
    }
    return nil;
}

//获取高画质图片（原图）
+ (id)getOriginalImageWithIndex:(NSInteger)index originalImages:(NSArray *)originalImages
{
    if (originalImages && index < originalImages.count) {
        return originalImages[index];
    }
    return nil;
}


//判断图片类型
+ (SYImageType)getImageTypeWithImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]]) {
        return SYImageTypeUIImage;
    }else if ([image isKindOfClass:[NSURL class]]){
        return SYImageTypeUrl;
    }else{
        NSString *imageString = image;
        if ([imageString hasPrefix:@"http"]) {
            return SYImageTypeStringUrl;
        }else{
            return SYImageTypeImageName;
        }
    }
}

//提示框
+ (void)promptWithTitle:(NSString *)title
{
    [SYPhotoBrowserTool promptWithTitle:title target:nil onSEL:nil];
}

//提示框
+ (void)promptWithTitle:(NSString *)title target:(id)target onSEL:(SEL)sel
{
    __block UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake((SYScreenWidth-100)/2, (SYScreenHeight-50)/2, 100, 50)];
    [view setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.8f]];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    view.textAlignment = NSTextAlignmentCenter;
    view.textColor = [UIColor whiteColor];
    view.text = title;
    [[[UIApplication sharedApplication].delegate window] addSubview:view];
    
    if ([title isEqualToString:@"下载失败,请点击重试"]){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
        [view addGestureRecognizer:tap];
    }else{
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [view removeFromSuperview];
            view = nil;
        });
    }
}

@end
