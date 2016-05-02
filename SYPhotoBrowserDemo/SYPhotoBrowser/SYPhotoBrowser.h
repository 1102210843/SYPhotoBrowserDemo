//
//  SYPhotoBrowser.h
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPhotoBrowser : UIViewController

//显示图片浏览器
- (void)show;

/**
 *  原图数组（在有低画质图片时，点击原图按钮加载原图。必须有原图，所数据均以原图数组为准）
 */
@property (nonatomic, strong) NSArray *originalImages;

/*
 *  当前图片位置
 */
@property (nonatomic, assign) NSInteger currentIndex;


#pragma mark - 以上为必选属性， 下面为可选属性，不使用不传即可


//当前视图 currentView、imageViews、currentRect 三选一即可
@property (nonatomic, strong) UIView *currentView;
//所有图片控件 可选
@property (nonatomic, strong) NSArray *imageViews;
//当前视图位置
@property (nonatomic, assign) CGRect currentRect;

/**
 *  缩略图数据(作为加载图片时的占位图)
 */
@property (nonatomic, strong) NSArray <UIImage *>*thumbImages;

/**
 *  低画质图数据（加载图片时，首先加载低画质图片，若数组为nil，则直接加载原图）
 */
@property (nonatomic, strong) NSArray *lowQualityImages;

//文字数组（图片底部展示文字, 可选）
@property (nonatomic, strong) NSArray *titles;



@end
