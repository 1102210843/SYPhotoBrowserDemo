//
//  SYPhotoView.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYPhotoView.h"

@interface SYPhotoView () <UIActionSheetDelegate>

@end

@implementation SYPhotoView
{
    CGFloat currentScale;
    CGPoint _currentCenter;
    CGSize _currentSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = 0;
        
        _imageView = [[SYImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.sizeChangeBlock = ^(CGSize size){
            _imageSize = size;
        };
        [self addSubview:_imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick)];
        [self addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(onPinchClick:)];
        pinchRecognizer.scale = 1.0;
        [self addGestureRecognizer:pinchRecognizer];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDoubleTapClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongGesClick:)];
        
        [self addGestureRecognizer:longGes];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    [_imageView setImage:thumbImage];
}

//长按弹出菜单
- (void)onLongGesClick:(UILongPressGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateBegan == sender.state) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [actionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if (_saveImageBlock) {
            _saveImageBlock(self.imageView);
        }
    }
}



//双指缩放
- (void)onPinchClick:(UIPinchGestureRecognizer *)pinch
{
    CGFloat scale = pinch.scale;
    
    CGPoint screntPoint = CGPointMake(self.contentOffset.x+ SYScreenWidth/2, self.contentOffset.y+SYScreenHeight/2);
    
    // 如果捏合手势刚刚开始
    if (pinch.state == UIGestureRecognizerStateBegan){
        // 计算当前缩放比
        currentScale = _imageView.frame.size.width / _imageSize.width;
        _currentCenter = _imageView.center;
        _currentSize = _imageView.frame.size;
        
        
        
    }else if (pinch.state == UIGestureRecognizerStateEnded){
        
        //捏合手势结束，计算图片位置和scrollerView偏移量
        [UIView animateWithDuration:0.3 animations:^{
            [self setContentSize:CGSizeMake(_imageView.frame.size.width<SYScreenWidth?SYScreenWidth:_imageView.frame.size.width, _imageView.frame.size.height<SYScreenHeight?SYScreenHeight:_imageView.frame.size.height)];
            
            _imageView.center = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
            
            CGFloat width = (screntPoint.x-(screntPoint.x-_currentSize.width/2));
            CGFloat height = (screntPoint.y-(screntPoint.y-_currentSize.height/2));
            
            if (_currentSize.width > SYScreenWidth) {
                width = screntPoint.x;
            }
            
            if (_currentSize.height > SYScreenHeight) {
                height = screntPoint.y;
            }
            
            
            CGFloat X = _imageView.frame.size.width*(width/_currentSize.width)-SYScreenWidth/2;
            
            CGFloat Y = _imageView.frame.size.height*(height/_currentSize.height)-SYScreenHeight/2;
            
            X=(X<0)?0.0:X;
            Y=(Y<0)?0.0:Y;
            
            if (_imageView.frame.size.width<SYScreenWidth) {
                X = 0;
            }else if (X +SYScreenWidth > _imageView.frame.size.width) {
                X -= (X + SYScreenWidth - _imageView.frame.size.width);
            }
            
            if (_imageView.frame.size.height<SYScreenHeight){
                Y = 0;
            }else if (Y + SYScreenHeight > _imageView.frame.size.height) {
                Y -= (Y + SYScreenHeight - _imageView.frame.size.height);
            }
            
            [self setContentOffset:CGPointMake( X, Y)];
        } completion:^(BOOL finished) {
            if (_imageView.frame.size.width < SYScreenWidth) {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGFloat height = _imageView.image.size.height*SYScreenWidth/_imageView.image.size.width;
                    _imageView.frame = CGRectMake(0, (SYScreenHeight-height)/2, SYScreenWidth, height);
                    [self setContentSize:CGSizeMake(0, 0)];
                    [self setContentOffset:CGPointMake(0, 0)];
                }];
            }
        }];
        
        return;
    }
    
    
    if (scale * currentScale > 3) {
        return;
    }
    
    // 根据手势处理器的缩放比例计算图片缩放后的目标大小
    CGSize targetSize = CGSizeMake(_imageSize.width * scale * currentScale,
                                   _imageSize.height * scale * currentScale);
    
    CGRect rect = _imageView.frame;
    rect.size = targetSize;
    _imageView.frame = rect;
    
    _imageView.center = CGPointMake(screntPoint.x+(_currentCenter.x-screntPoint.x)*scale, screntPoint.y+(_currentCenter.y-screntPoint.y)*scale);
    
}

//双击放大
- (void)onDoubleTapClick:(UITapGestureRecognizer *)doubleTap
{
    CGFloat scale = 1;
    if (_imageView.frame.size.width == SYScreenWidth){  //放大
        scale = 3;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        // 根据手势处理器的缩放比例计算图片缩放后的目标大小
        CGSize targetSize = CGSizeMake(SYScreenWidth * scale,
                                       _imageView.frame.size.height*SYScreenWidth/_imageView.frame.size.width * scale);
        
        //点击的坐标
        CGPoint location = [doubleTap locationInView:doubleTap.view];
        
        CGFloat contentOffX = (location.x-_imageView.frame.origin.x) * scale - SYScreenWidth/2;
        CGFloat contentOffY = (location.y-_imageView.frame.origin.y) * scale - SYScreenHeight/2;
        
        if (contentOffX < 0 || scale == 1){
            contentOffX = 0;
        }
        if (contentOffY < 0 || scale == 1){
            contentOffY = 0;
        }
        
        CGRect rect = _imageView.frame;
        rect.size = targetSize;
        _imageView.frame = rect;
        
        [self setContentSize:CGSizeMake(targetSize.width<SYScreenWidth?SYScreenWidth:targetSize.width, targetSize.height<SYScreenHeight?SYScreenHeight:targetSize.height)];
        _imageView.center = CGPointMake(self.contentSize.width * 0.5, self.contentSize.height * 0.5);
        
        
        
        if (contentOffX + SYScreenWidth > self.contentSize.width) {
            contentOffX = self.contentSize.width-SYScreenWidth;
        }
        if (contentOffY + SYScreenHeight > self.contentSize.height) {
            contentOffY = self.contentSize.height-SYScreenHeight;
        }
        
        //设置焦点
        [self setContentOffset:CGPointMake(contentOffX, contentOffY)];
    }];
}




#pragma mark - UIGestureRecognizerDelegate
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
//单击退出浏览器
- (void)onTapClick
{
    if (_dismissBlock) {
        _dismissBlock();
    }
}


@end
