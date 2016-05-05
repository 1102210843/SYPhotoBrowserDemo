//
//  ViewController.m
//  SYPhotoBrowserDemo
//
//  Created by 孙宇 on 16/5/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "ViewController.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SYPhotoBrowser.h"
#import "SYFirstViewController.h"
#import "SYSecondViewController.h"
#import "SY3DTouchViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"图片浏览器";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *array = @[@"九宫格",@"瀑布流",@"3D Touch"];
    
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SYFirstViewController *VC = [[SYFirstViewController alloc]init];
        VC.title = @"九宫格";
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        SYSecondViewController *VC = [[SYSecondViewController alloc]init];
        VC.title = @"瀑布流";
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 2){
        SY3DTouchViewController *VC = [[SY3DTouchViewController alloc]init];
        VC.title = @"3D Touch";
        [self.navigationController pushViewController:VC animated:YES];
    }
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
