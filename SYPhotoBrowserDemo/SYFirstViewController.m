//
//  SYFirstViewController.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYFirstViewController.h"
#import "UIImageView+WebCache.h"
#import "SYPhotoBrowser.h"

@interface SYFirstViewController ()

@end

@implementation SYFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-32)/3;
    
    for (NSInteger i = 0; i < 9; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8+(width+8)*(i%3), 100+((width+8)*(i/3)), width, width)];
        imageView.tag = i+100;
        [imageView sd_setImageWithURL:[NSURL URLWithString:SYThumbImages[i]]];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)];
        [imageView addGestureRecognizer:tap];
    }
    
    
    
}


- (void)onTapClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag-100;
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    
    NSMutableArray *imageViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [self.view viewWithTag:i+100];
        [thumbImages addObject:imageView.image];
        [imageViews addObject:imageView];
    }
    
    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];

    browser.originalImages = SYOriginalImages;
    browser.currentIndex = index;
    
    
//    browser.currentView = tap.view;
//    browser.currentRect = CGRectMake(100, 100, 0, 0);
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
