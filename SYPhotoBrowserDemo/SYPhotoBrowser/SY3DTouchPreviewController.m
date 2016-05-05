//
//  SY3DTouchPreviewController.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/5.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SY3DTouchPreviewController.h"
#import "SYPhotoBrowserTool.h"

@implementation SY3DTouchPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc]init];
    [self.view addSubview:_imageView];
}

//预览菜单、可自定制
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    __weak typeof(self)mySelf = self;
    
    //默认菜单项
    UIPreviewAction *saveAction = [UIPreviewAction actionWithTitle:@"保存原图" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        SYImageType imageType = [SYPhotoBrowserTool getImageTypeWithImage:mySelf.originalImage];
        
        switch (imageType) {
            case SYImageTypeImageName:
                [mySelf saveImageWithImage:[UIImage imageNamed:_originalImage]];
                break;
            case SYImageTypeUIImage:
                [mySelf saveImageWithImage:_originalImage];
                break;
            case SYImageTypeUrl:
            case SYImageTypeStringUrl:
                [mySelf downLoadImageWithType:imageType];
                break;
        }
    }];
    
    NSMutableArray *actions = [NSMutableArray arrayWithArray:_actions];
    [actions insertObject:saveAction atIndex:0];
    
    return actions;
}

//下载图片
- (void)downLoadImageWithType:(SYImageType)imageType
{
    NSURL *url = nil;
    if (SYImageTypeUrl == imageType) {
        url = _originalImage;
    }else if (SYImageTypeStringUrl == imageType){
        url = [NSURL URLWithString:_originalImage];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self saveImageWithImage:[UIImage imageWithData:data]];
}


//保存图片
- (void)saveImageWithImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (!error) {
        [SYPhotoBrowserTool promptWithTitle:@"保存成功"];
    }else{
        [SYPhotoBrowserTool promptWithTitle:@"保存失败"];
    }
}



@end
