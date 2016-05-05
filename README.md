# SYPhotoBrowserDemo 1.1
使用简单，需要与SDWebImage搭配使用，图片支持UIImage，NSURL，NSString和bundle图片等多种类型,可保存图片，

1.1 新增3DTouch预览界面及3DTouch方法进入方法指南

可显示文字说明，

//文字数组（图片底部展示文字, 可选）

@property (nonatomic, strong) NSArray *titles;

图片数据的数组为三个originalImages（原图）、lowQualityImages（低画质图片）、thumbImages（缩略图，缩略图为UIImage类型），其中为必选项，另外两个可以不传，其他所有数组数量均以原图数组为准。

//创建浏览器
SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];

#必选项， 
//原图数组

browser.originalImages = SYOriginalImages;

//当前图片的下标

browser.currentIndex = index;

#可选项
//获取控件的位置及尺寸，一下三个传一个即可

//    browser.currentView = tap.view;

//    browser.currentRect = CGRectMake(100, 100, 0, 0);

browser.imageViews = imageViews;

//缩略图

browser.thumbImages = thumbImages;

//低画质图片

browser.lowQualityImages = SYLowImages;

//底部文字说明

browser.titles = SYTitles;

//启动浏览器

[browser show];


#3D Touch 进入指南

新增3DTouch预览界面 SY3DTouchPreviewController

进入指南：

1.首先对控件进行注册3DTouch功能

//注册3D Touch

if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {

     NSLog(@"3D Touch  可用!");

     //给view注册3DTouch的peek（预览）和pop功能

     [self registerForPreviewingWithDelegate:self sourceView:imageView];

} else {

     NSLog(@"3D Touch 无效");

}

2.添加UIViewControllerPreviewingDelegate代理，实现UIViewControllerPreviewingDelegate代理方法

//peek(预览)，进入预览界面，预览界面菜单可根据自己的需求定制

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location


//pop（按用点力进入），进入图片浏览器

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit


SYPhotoBrowser 新增属性is3DTouch，识别是否是以3DTouch方式进入，使用3D Touch方式进入，图片将不会产生放大效果



大家如果觉得好用不要忘了star，另外如果有问题可以联系我QQ：1102210843，大家共同学习，谢谢

