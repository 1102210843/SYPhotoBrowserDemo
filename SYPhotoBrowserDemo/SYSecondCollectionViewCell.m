//
//  SYSecondCollectionViewCell.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYSecondCollectionViewCell.h"

@implementation SYSecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
