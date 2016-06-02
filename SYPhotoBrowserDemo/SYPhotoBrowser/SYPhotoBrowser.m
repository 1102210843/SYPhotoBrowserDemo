//
//  SYPhotoBrowser.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYPhotoBrowser.h"
#import "SYPhotoView.h"
#import "UIImageView+WebCache.h"

@interface SYPhotoBrowser () <UIScrollViewDelegate>

@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;

@property (nonatomic,assign) CGFloat touchDistance; //拖动底部说明文字时，计算触摸点与底部视图y坐标的距离

@property (nonatomic, assign) CGFloat panStartY;    //拖动底部说明文字开始坐标

@end

@implementation SYPhotoBrowser
{
    UIScrollView *_backScroller;
    
    UIButton *_originalBtn; //显示原图按钮
    
    UIView *_bottomView;
    UILabel *_titleLabel;   //说明文字
    
    UILabel *_pageLabel;    //页码
    
    UIActivityIndicatorView *_activity;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //判断是不是第一次进入浏览器，避免控件重复创建
    if (!_hasShowedPhotoBrowser) {
        _hasShowedPhotoBrowser = YES;
        [self showPhotoBrowser];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addScrollerView];
    
    [self addTools];
}


- (void)addScrollerView
{
    _backScroller = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _backScroller.delegate = self;
    _backScroller.showsVerticalScrollIndicator = NO;
    _backScroller.showsHorizontalScrollIndicator = NO;
    _backScroller.pagingEnabled = YES;
    _backScroller.decelerationRate = 0;
    [self.view addSubview:_backScroller];
}

- (void)addTools
{
    if (_titles) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SYScreenHeight-100, SYScreenWidth, 300)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_bottomView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanClick:)];
        [_bottomView addGestureRecognizer:pan];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, SYScreenWidth-80, 0)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        [_bottomView addSubview:_titleLabel];
        
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 70, 30)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:15];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _originalImages.count];
        [_bottomView addSubview:_pageLabel];
        
    }else{
        
        _pageLabel = [[UILabel alloc]init];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:15];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _originalImages.count];
        [_pageLabel sizeToFit];
        _pageLabel.frame = CGRectMake((SYScreenWidth-_pageLabel.frame.size.width-10)/2, SYScreenHeight-40, _pageLabel.frame.size.width+10, 30);
        _pageLabel.layer.cornerRadius = 6;
        _pageLabel.layer.masksToBounds = YES;
        [self.view addSubview:_pageLabel];
    }
    
    _originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _originalBtn.frame = CGRectMake(10, SYScreenHeight-40, 50, 30);
    [_originalBtn setTitle:@"原图" forState:UIControlStateNormal];
    [_originalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_originalBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    _originalBtn.layer.cornerRadius = 6;
    _originalBtn.layer.masksToBounds = YES;
    _originalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_originalBtn addTarget:self action:@selector(onOriginalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _originalBtn.hidden = YES;
    [self.view addSubview:_originalBtn];
    
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    [_activity setCenter:CGPointMake(SYScreenWidth/2, SYScreenHeight/2)];//指定进度轮中心点
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    [self.view addSubview:_activity];
}

//拖动底部文字部分
- (void)onPanClick:(UIPanGestureRecognizer *)paramSender
{
    CGPoint location = [paramSender locationInView:paramSender.view.superview];
    
    //计算触摸点与y坐标距离
    if (UIGestureRecognizerStateBegan == paramSender.state) {
        _panStartY = location.y;
        _touchDistance = location.y-_bottomView.frame.origin.y;
    }
    
    //根据拖动距离移动底部视图
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGFloat y = location.y-_touchDistance;
        if (y < SYScreenHeight-_bottomView.frame.size.height) {
            y = SYScreenHeight-_bottomView.frame.size.height;
        }
        CGRect frame = paramSender.view.frame;
        frame.origin.y = y;
        paramSender.view.frame = frame;
        [paramSender setTranslation:CGPointZero inView:self.view];
    }else if (UIGestureRecognizerStateEnded == paramSender.state){
        
        if (_panStartY < location.y) {
            //拖动结束时回弹
            [UIView animateWithDuration:0.4 animations:^{
                CGRect frame = paramSender.view.frame;
                frame.origin.y = SYScreenHeight-100;
                paramSender.view.frame = frame;
                [paramSender setTranslation:CGPointZero inView:self.view];
            }];
        }else{
            //拖动结束时回弹
            [UIView animateWithDuration:0.4 animations:^{
                CGFloat bottomHeight = _titleLabel.frame.size.height+30;
                if (bottomHeight < 100) {
                    bottomHeight = 100;
                }
                CGRect frame = paramSender.view.frame;
                frame.origin.y = SYScreenHeight-bottomHeight;
                paramSender.view.frame = frame;
                [paramSender setTranslation:CGPointZero inView:self.view];
            }];
        }
    }
}



//显示原图
- (void)onOriginalBtnClick
{
    NSInteger pageNum = _backScroller.contentOffset.x/SYScreenWidth;
    [self setPhotoViewImageWithIndex:pageNum origina:YES finshedBlock:nil];
}

//保存图片
- (void)saveImageWithImage:(UIImage *)image
{
    [_activity startAnimating];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    [_activity stopAnimating];
    
    if (!error) {
        [SYPhotoBrowserTool promptWithTitle:@"保存成功"];
    }else{
        [SYPhotoBrowserTool promptWithTitle:@"保存失败"];
    }
}

//下载失败时，点击重新加载图片
- (void)ontapDownLoadImage:(UITapGestureRecognizer *)sender
{
    NSInteger pageNum = _backScroller.contentOffset.x/SYScreenWidth;
    [self setPhotoViewImageWithIndex:pageNum origina:NO finshedBlock:nil];
}

//进入
- (void)show
{
    UIViewController *VC = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        VC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [VC presentViewController:self animated:NO completion:nil];
}

//退出
- (void)dismiss
{
    NSInteger pageNum = _backScroller.contentOffset.x/SYScreenWidth;
    __block SYPhotoView *photoView = [_backScroller viewWithTag:pageNum+1000];
    CGRect rect;
    if (_imageViews && _imageViews.count > 0) {
        rect = [self getRectOfwindowWithView:_imageViews[pageNum]];
    }else if (_currentView){
        rect = [self getRectOfwindowWithView:_currentView];
    }else if (!CGPointEqualToPoint(_currentRect.origin, CGPointMake(0, 0)) ||
              !CGSizeEqualToSize(_currentRect.size, CGSizeMake(0, 0))){
        rect = _currentRect;
    }else{
        rect = CGRectMake(SYScreenWidth/2, SYScreenHeight/2, 0, 0);
    }

    [UIView animateWithDuration:0.3 animations:^{
        photoView.imageView.frame = rect;
        [photoView setContentSize:CGSizeMake(SYScreenWidth, SYScreenHeight)];
        [photoView setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


//显示图片浏览器
- (void)showPhotoBrowser
{
    CGRect currentRect;
    
    if (_imageViews && _imageViews.count > 0) {
        currentRect = [self getRectOfwindowWithView:_imageViews[_currentIndex]];
    }else if (_currentView) {
        currentRect = [self getRectOfwindowWithView:_currentView];
    }else if (!CGPointEqualToPoint(_currentRect.origin, CGPointMake(0, 0)) ||
              !CGSizeEqualToSize(_currentRect.size, CGSizeMake(0, 0))){
        currentRect = _currentRect;
    }else{
        currentRect = CGRectMake(SYScreenWidth/2, SYScreenHeight/2, 0, 0);
    }
    
    __weak typeof(self)mySelf = self;
    for (NSInteger i = 0; i < _originalImages.count; i++) {
        
        SYPhotoView *photoView = [[SYPhotoView alloc]initWithFrame:CGRectMake(i*SYScreenWidth, 0, SYScreenWidth, SYScreenHeight)];
        photoView.tag = i + 1000;

        if (i == _currentIndex && !_is3DTouch) {
            photoView.imageView.isFirst = YES;
            photoView.imageView.frame = CGRectMake(currentRect.origin.x, currentRect.origin.y, currentRect.size.width, currentRect.size.height);
        }
        
        [photoView.imageView setImage:[SYPhotoBrowserTool getThumbImageWithIndex:i thumbImages:_thumbImages]];
        
        photoView.dismissBlock = ^(){
            [mySelf dismiss];
        };
        photoView.saveImageBlock = ^(SYImageView *imageView){
            [mySelf saveImageWithImage:imageView.image];
        };
        
        [_backScroller addSubview:photoView];
    }
    [_backScroller setContentSize:CGSizeMake(SYScreenWidth*_originalImages.count, 0)];
    [_backScroller setContentOffset:CGPointMake(SYScreenWidth*_currentIndex, 0)];
    
    
    if (mySelf.is3DTouch) {
        [self setPhotoViewImageWithIndex:_currentIndex origina:NO finshedBlock:nil];
    }else{
        [self setPhotoViewImageWithIndex:_currentIndex origina:NO finshedBlock:^(SYPhotoView *photoView, CGSize imageSize) {
            [UIView animateWithDuration:0.3 animations:^{
                CGSize imageSize = photoView.imageView.image.size;
                CGFloat height = imageSize.height*(SYScreenWidth/imageSize.width);
                photoView.imageView.frame = CGRectMake(0, (SYScreenHeight-height)/2, SYScreenWidth, height);
                photoView.imageSize = photoView.frame.size;
            } completion:^(BOOL finished) {
                photoView.imageView.isFirst = NO;
            }];
        }];
    }
}

//滑动切换图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageNum = scrollView.contentOffset.x/SYScreenWidth;
    _pageLabel.text = [NSString stringWithFormat:@"%.0f/%ld", pageNum+1, _originalImages.count];
    if (!_titles) {
        [_pageLabel sizeToFit];
        _pageLabel.frame = CGRectMake((SYScreenWidth-_pageLabel.frame.size.width-10)/2, SYScreenHeight-40, _pageLabel.frame.size.width+10, 30);
        _pageLabel.layer.cornerRadius = 6;
    }
    [self setPhotoViewImageWithIndex:pageNum origina:NO finshedBlock:nil];
}


/**
 *  设置图片
 *
 *  index           图片的位置
 *
 *  origina         是否显示原图
 *
 *  finshedBlock    图片设置完成回调
 *
 */
- (void)setPhotoViewImageWithIndex:(NSInteger)index
                           origina:(BOOL)origina
                      finshedBlock:(void(^)(SYPhotoView *photoView, CGSize imageSize))finshedBlock
{
    [self viewRestWithRuleOutIndex:index];
    
    SYPhotoView *photoView = [_backScroller viewWithTag:index+1000];
    
    if (origina) {
        photoView.photoStatus = SYPhotoStatusOriginal;
    }
    
    id image = nil;
    
    if (SYPhotoStatusNone == photoView.photoStatus ||
        SYPhotoStatusLowQuality == photoView.photoStatus) {
        
        image = [SYPhotoBrowserTool getLowQualityImageWithIndex:index lowQualityImages:_lowQualityImages];
        
        if (!image) {
            image = [SYPhotoBrowserTool getOriginalImageWithIndex:index originalImages:_originalImages];
            photoView.photoStatus = SYPhotoStatusOriginal;
        }else{
            photoView.photoStatus = SYPhotoStatusLowQuality;
        }
    }else{
        image = [SYPhotoBrowserTool getOriginalImageWithIndex:index originalImages:_originalImages];
        photoView.photoStatus = SYPhotoStatusOriginal;
    }
    
    SYImageType imageType = [SYPhotoBrowserTool getImageTypeWithImage:image];
    
    switch (imageType) {
        case SYImageTypeUIImage:{
            [photoView.imageView setImage:image];
            if (finshedBlock) {
                finshedBlock(photoView, photoView.imageView.image.size);
            }
        }
            break;
        case SYImageTypeImageName:{
            [photoView.imageView setImage:[UIImage imageNamed:image]];
            if (finshedBlock) {
                finshedBlock(photoView, photoView.imageView.image.size);
            }
        }
            break;
        case SYImageTypeStringUrl:{
            [_activity startAnimating];
            [photoView.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:photoView.imageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    [SYPhotoBrowserTool promptWithTitle:@"下载失败,请点击重试" target:self onSEL:@selector(ontapDownLoadImage:)];
                }else{
                    if (finshedBlock) {
                        finshedBlock(photoView, image.size);
                    }
                }
                [_activity stopAnimating];
                
            }];
        }
            break;
        case SYImageTypeUrl:{
            [_activity startAnimating];
            [photoView.imageView sd_setImageWithURL:image placeholderImage:photoView.imageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    [SYPhotoBrowserTool promptWithTitle:@"下载失败,请点击重试" target:self onSEL:@selector(ontapDownLoadImage:)];
                }else{
                    if (finshedBlock) {
                        finshedBlock(photoView, image.size);
                    }
                }
                [_activity stopAnimating];
                
            }];
        }
            break;
    }
    [self setTitleLabelTextWithIndex:index];
    
    if (photoView.photoStatus == SYPhotoStatusOriginal) {
        _originalBtn.hidden = YES;
    }else{
        _originalBtn.hidden = NO;
    }
}

- (void)viewRestWithRuleOutIndex:(NSInteger)index
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *views = _backScroller.subviews;
        
        for (UIView *view in views) {
            if ([view isMemberOfClass:[SYPhotoView class]]) {
                SYPhotoView *photoView = (SYPhotoView *)view;
                if (photoView.tag != index+1000) {
                    CGFloat height = CGRectGetHeight(photoView.imageView.frame)*(SYScreenWidth/CGRectGetWidth(photoView.imageView.frame));
                    CGRect frame = CGRectMake(0, (SYScreenHeight-height)/2, SYScreenWidth, height);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        photoView.imageView.frame = frame;
                        [photoView setContentSize:CGSizeMake(SYScreenWidth, (height>SYScreenHeight)?height:SYScreenHeight)];
                    });
                }
            }
        }
    });
}



//设置说明文字
- (void)setTitleLabelTextWithIndex:(NSInteger)index
{
    if (_titles) {
        _titleLabel.frame = CGRectMake(70, 10, SYScreenWidth-80, 0);
        
        _titleLabel.text = _titles[index];
        [_titleLabel sizeToFit];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y = SYScreenHeight-100;
        _bottomView.frame = frame;
    }
}



//获取控件在屏幕上的位置
- (CGRect)getRectOfwindowWithView:(UIView *)view
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[view convertRect:view.bounds toView:window];
    return rect;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
