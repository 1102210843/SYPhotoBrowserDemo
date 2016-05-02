//
//  SYPhotoView.h
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageView.h"

#define SYScreenWidth [UIScreen mainScreen].bounds.size.width
#define SYScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, SYPhotoStatus) {
    SYPhotoStatusNone,          //未设置图片
    SYPhotoStatusLowQuality,    //低画质图片
    SYPhotoStatusOriginal       //高画质图片（原图）
};


@interface SYPhotoView : UIScrollView

@property (nonatomic, strong) SYImageView *imageView;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, assign) SYPhotoStatus photoStatus;

@property (nonatomic, strong) UILabel *showTitle;

@property (nonatomic, copy) void (^dismissBlock)();

@property (nonatomic, copy) void (^saveImageBlock)(SYImageView *imageView);


@end
