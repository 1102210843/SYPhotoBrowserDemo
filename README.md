# SYPhotoBrowserDemo
使用简单，需要与SDWebImage搭配使用，图片支持UIImage，NSURL，NSString和bundle图片等多种类型,
可保存图片，
可显示文字说明，
//文字数组（图片底部展示文字, 可选）
@property (nonatomic, strong) NSArray *titles;

图片数据的数组为三个originalImages（原图）、lowQualityImages（低画质图片）、thumbImages（缩略图，缩略图为UIImage类型），其中为必选项，另外两个可以不传，其他所有数组数量均以原图数组为准。

//创建浏览器
SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];

#必选项， 
//原图数组、
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


大家如果觉得好用不要忘了star，另外如果有问题可以联系我QQ：1102210843，大家共同学习，谢谢

