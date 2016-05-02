//
//  SYImageView.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYImageView.h"

@implementation SYImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    if (!_isFirst && image) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        CGSize imageSize = image.size;
        
        CGFloat height = imageSize.height*screenWidth/imageSize.width;
        
        self.frame = CGRectMake(0, (screenHeight-height)/2, screenWidth, height);
        
        UIScrollView *scroller = (UIScrollView *)self.superview;
        [scroller setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        
        if (_sizeChangeBlock) {
            _sizeChangeBlock(self.frame.size);
        }
    }
}

@end
