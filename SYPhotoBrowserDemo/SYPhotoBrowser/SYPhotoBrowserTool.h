//
//  SYPhotoBrowserTool.h
//  SYPhotoBrowserDemo
//
//  GitHub：https://github.com/1102210843
//
//  Created by 孙宇 on 16/5/5.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYScreenWidth [UIScreen mainScreen].bounds.size.width
#define SYScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, SYPhotoStatus) {
    SYPhotoStatusNone,          //未设置图片
    SYPhotoStatusLowQuality,    //低画质图片
    SYPhotoStatusOriginal       //高画质图片（原图）
};

typedef NS_ENUM(NSInteger, SYImageType) {
    SYImageTypeUIImage,
    SYImageTypeUrl,
    SYImageTypeStringUrl,
    SYImageTypeImageName
};

@interface SYPhotoBrowserTool : NSObject

//获取缩略图
+ (UIImage *)getThumbImageWithIndex:(NSInteger)index thumbImages:(NSArray *)thumbImages;

//获取低画质图片
+ (id)getLowQualityImageWithIndex:(NSInteger)index lowQualityImages:(NSArray *)lowQualityImages;

//获取高画质图片（原图）
+ (id)getOriginalImageWithIndex:(NSInteger)index originalImages:(NSArray *)originalImages;

//判断图片类型
+ (SYImageType)getImageTypeWithImage:(id)image;

//提示框
+ (void)promptWithTitle:(NSString *)title target:(id)target onSEL:(SEL)sel;
//提示框
+ (void)promptWithTitle:(NSString *)title;

@end
