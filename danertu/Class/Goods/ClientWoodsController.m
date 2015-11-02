//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "ClientWoodsController.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#define ORDERLOADPAGECOUNT 8
@interface ClientWoodsController (){
    AFHTTPClient * httpClient;
}

@end

@implementation ClientWoodsController

@synthesize addStatusBarHeight;
@synthesize gridView;
@synthesize arrays;
- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    self.view.backgroundColor = VIEWBGCOLOR;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.itemSize = [CollectionViewCell sizeWithDataItem:nil];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.itemSize = CGSizeMake(160, 40);
    layout.minimumInteritemSpacing = 0;
    
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, self.view.frame.size.height-TOPNAVIHEIGHT-addStatusBarHeight) collectionViewLayout:layout];
    [self.view addSubview:gridView];
    gridView.backgroundColor = VIEWBGCOLOR;
    gridView.delegate = self;
    gridView.dataSource = self;
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}
//修改标题,重写父类方法
-(NSString*)getTitle{
    return @"超市线下产品";
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cellCount = 5;
    return cellCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    //@autoreleasepool {
    //最大整个view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 145)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    //边
    UILabel *border_top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 1)];
    [contentView addSubview:border_top];
    border_top.backgroundColor = VIEWBGCOLOR;
    //边
    UILabel *border_bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 144, 160, 1)];
    [contentView addSubview:border_bottom];
    border_top.backgroundColor = VIEWBGCOLOR;
    
    //--------标题view----40
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 150, 35)];
    [contentView addSubview:titleView];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(160,40);
    return size;
}
@end
