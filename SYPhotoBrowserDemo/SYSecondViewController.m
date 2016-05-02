//
//  SYSecondViewController.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/2.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYSecondViewController.h"
#import "SYSecondCollectionViewCell.h"

@interface SYSecondViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation SYSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((375-24)/2, (375-24)/2);
    layout.minimumInteritemSpacing = 8;
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 375, 667) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    collection.dataSource = self;
    
    [collection registerClass:[SYSecondCollectionViewCell class] forCellWithReuseIdentifier:@"SYSecondCollectionViewCell"];
    
    [self.view addSubview:collection];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return SYThumbImages.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYSecondCollectionViewCell" forIndexPath:indexPath];
    NSString *url = SYThumbImages[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYSecondCollectionViewCell *cell = (SYSecondCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
    
    browser.originalImages = SYOriginalImages;
    browser.currentIndex = indexPath.row;
    
    
    browser.currentView = cell.imageView;
//    browser.currentRect = CGRectMake(100, 100, 0, 0);
//    browser.imageViews = imageViews;
    
//    browser.thumbImages = thumbImages;
    browser.lowQualityImages = SYLowImages;
    browser.titles = SYTitles;
    [browser show];
    
    
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
