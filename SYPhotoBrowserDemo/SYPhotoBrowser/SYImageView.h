//
//  SYImageView.h
//  SYPhotoBrowserDemo
//
//  GitHub：https://github.com/1102210843
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYImageView : UIImageView

@property (nonatomic, assign) BOOL isFirst; //第一个显示的图片不直接设置frame

@property (nonatomic, copy) void (^sizeChangeBlock)(CGSize size);

@end
