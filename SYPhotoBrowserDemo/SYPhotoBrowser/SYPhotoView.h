//
//  SYPhotoView.h
//  SYPhotoBrowserDemo
//
//  GitHub：https://github.com/1102210843
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageView.h"
#import "SYPhotoBrowserTool.h"


@interface SYPhotoView : UIScrollView

@property (nonatomic, strong) SYImageView *imageView;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, assign) SYPhotoStatus photoStatus;

@property (nonatomic, copy) void (^dismissBlock)();

@property (nonatomic, copy) void (^saveImageBlock)(SYImageView *imageView);

@end
