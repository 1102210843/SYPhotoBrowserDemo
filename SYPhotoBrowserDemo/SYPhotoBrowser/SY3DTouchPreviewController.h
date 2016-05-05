//
//  SY3DTouchPreviewController.h
//  SYPhotoBrowserDemo
//
//  GitHub：https://github.com/1102210843
//
//  Created by 孙宇 on 16/5/5.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SY3DTouchPreviewController : UIViewController

//显示的图片
@property (nonatomic, strong) UIImageView *imageView;

//原图数据
@property (nonatomic, strong) id originalImage;

//可定制菜单项
@property (nonatomic, strong) NSArray *actions;

@end
