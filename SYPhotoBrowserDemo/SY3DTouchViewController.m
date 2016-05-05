//
//  SY3DTouchViewController.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/5.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SY3DTouchViewController.h"
#import "UIImageView+WebCache.h"
#import "SYPhotoBrowser.h"

@interface SY3DTouchViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation SY3DTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-32)/3;
    
    for (NSInteger i = 0; i < 9; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8+(width+8)*(i%3), 100+((width+8)*(i/3)), width, width)];
        imageView.tag = i+100;
        [imageView sd_setImageWithURL:[NSURL URLWithString:SYLowImages[i]]];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)];
        [imageView addGestureRecognizer:tap];
        
        //注册3D Touch
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            NSLog(@"3D Touch  可用!");
            //给view注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:imageView];
        } else {
            NSLog(@"3D Touch 无效");
        }
        
    }
}


- (void)onTapClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag-100;
    
    [self showPhotoBrowserWithIndex:index is3DTouch:NO];
}

#pragma - mark 实现UIViewControllerPreviewingDelegate方法
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的view，[previewingContext sourceView]就是按压的那个视图
    UIImageView *imageView = (UIImageView *)[previewingContext sourceView];
    
    NSInteger index = imageView.tag-100;
    
    //设置预览界面
    SY3DTouchPreviewController *viewControllr = [[SY3DTouchPreviewController alloc]init];
    
    viewControllr.view.tag = index;
    
    CGFloat width = imageView.image.size.width;
    CGFloat height = imageView.image.size.height;
    
    //设置预览内容尺寸
    viewControllr.preferredContentSize = CGSizeMake(width, height);
    
    //设置图片内容
    [viewControllr.imageView setImage:imageView.image];
    [viewControllr.imageView setFrame:CGRectMake(0, 0, width, height)];
    //设置原图数据，以便进行保存
    viewControllr.originalImage = SYOriginalImages[index];
    
    
    //设置菜单项
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"自定制菜单项" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"自定制菜单项 响应事件回调");
    }];
    viewControllr.actions = @[action2];
    
    
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    previewingContext.sourceRect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    
    //返回预览界面
    return viewControllr;
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showPhotoBrowserWithIndex:viewControllerToCommit.view.tag is3DTouch:YES];
}


//显示图片浏览器
- (void)showPhotoBrowserWithIndex:(NSInteger)index is3DTouch:(BOOL)is3DTouch
{
    //设定预览的界面
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    
    NSMutableArray *imageViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [self.view viewWithTag:i+100];
        [thumbImages addObject:imageView.image];
        [imageViews addObject:imageView];
    }
    
    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
    
    //设置3D Touch 功能所需参数
    browser.is3DTouch = is3DTouch;
    
    //设置数据
    browser.originalImages = SYOriginalImages;
    browser.currentIndex = index;
    
    browser.imageViews = imageViews;
    browser.thumbImages = thumbImages;
    browser.lowQualityImages = SYLowImages;
    browser.titles = SYTitles;
    
    [browser show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
