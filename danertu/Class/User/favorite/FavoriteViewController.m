//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "FavoriteViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "NoItemView.h"
#import "FavoriteGoodsCell.h"
#import "FavoriteShopCell.h"

@interface FavoriteViewController (){
    NSMutableArray *dataSource;
    NoItemView *noDataView;
    NSInteger currentClickTag;
    DataModle *modleFromFavoarite1;
    UITableView *_tableView;
    NSCache *imageCache;
    
}
@end
@implementation FavoriteViewController
@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize segment1;
@synthesize segment2;
- (void)viewDidLoad
{
    [super viewDidLoad];//没有词句,会执行多次
    
    [self initializaiton];  //初始化
    [self getShopData];  //收藏店铺数据
}

- (NSString *)getTitle{
    return @"我的收藏";
}

//初始化方法
- (void)initializaiton
{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults           = [NSUserDefaults standardUserDefaults];
    dataSource         = [[NSMutableArray alloc] init];
    imageCache = [[NSCache alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];

    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:segmentView];
    segmentView.userInteractionEnabled = YES;
    segmentView.backgroundColor = [UIColor whiteColor];//白色
    
    segment1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 160, 30)];
    segment1.userInteractionEnabled = YES;
    segment1.text = @"店  铺";
    segment1.textColor = [UIColor redColor];//标红
    segment1.textAlignment = NSTextAlignmentCenter;
    segment1.tag = 0;
    [segmentView addSubview:segment1];
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change:)];
    [segment1 addGestureRecognizer:singleTap1];//---添加大图片点击事
    
    segment2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 160, 30)];
    segment2.userInteractionEnabled = YES;
    segment2.text = @"商  品";
    segment2.textAlignment = NSTextAlignmentCenter;
    segment2.tag = 1;
    [segmentView addSubview:segment2];
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change:)];
    [segment2 addGestureRecognizer:singleTap2];//---添加大图片点击事
    
    UILabel *cuttingline = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 0.7, 30)];
    [segmentView addSubview:cuttingline];
    cuttingline.backgroundColor = BORDERCOLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT+45, MAINSCREEN_WIDTH, self.view.frame.size.height - addStatusBarHeight-TOPNAVIHEIGHT-45)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [Tools setExtraCellLineHidden:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //没有数据显示的view,下方按钮高70
    noDataView = [[NoItemView alloc] initWithY:TOPNAVIHEIGHT+addStatusBarHeight+(CONTENTHEIGHT-150)/2+30 Image:[UIImage imageNamed:@"noData"] mes:@"您还没有收藏数据"];
    [self.view addSubview:noDataView];
    //默认隐藏
    noDataView.hidden = YES;
    
    //默认选中店铺收藏
    currentClickTag = 0;
    //滑动手势
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
}

// 滑动手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger indexs = currentClickTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (indexs == 1) return;
            [self showFavoriteWoods:YES];
            currentClickTag++;
        }
            break;
        default:
        {
            if (indexs == 0) return;
            [self showFavoriteWoods:NO];
            currentClickTag--;
        }
            break;
    }
}

//切换[店铺][商品]
-(void)change:(id)sender {
    NSInteger tag = [[sender view] tag];
    if (currentClickTag != tag) {
        if (tag == 1) {
            [self showFavoriteWoods:YES];
        }else if(tag == 0){
            [self showFavoriteWoods:NO];
        }
        currentClickTag = tag;
    }
}

-(void)showFavoriteWoods:(BOOL)isShow{

    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    if (isShow) {
        [self getWoodsData];
        
        segment1.textColor            = [UIColor blackColor];
        segment2.textColor            = [UIColor redColor];
        
    }else{
        [self getShopData];
        
        segment1.textColor = [UIColor redColor];
        segment2.textColor = [UIColor blackColor];
    }
    [_tableView reloadData];
}

//收藏店铺数据
-(void)getShopData{
    
    NSArray *temp = [defaults objectForKey:@"favoriteShopList"];
    DataModle *model = nil;//对象数据模型
    for(int i=0;i<temp.count;i++){
        model = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
        [dataSource addObject:model];//追加到数组
    }
    
    if (dataSource.count > 0) {
        noDataView.hidden = YES;
    }else{
        [noDataView setHidden:NO];
    }
}

//收藏商品数据
-(void)getWoodsData{
    
    NSArray *temp = [defaults objectForKey:FAVORITEWOODSARR];
    for(int i=0;i<temp.count;i++){
        FavoriteWoodsModle *model = [[FavoriteWoodsModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
        [dataSource addObject:model];//追加到数组
    }
    
    if(dataSource.count > 0){
        noDataView.hidden = YES;
    }else{
        noDataView.hidden = NO;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = [indexPath row];
    
    if (currentClickTag == 0) {
        DataModle *modle = [dataSource objectAtIndex:index];
        static NSString *cellIndentifier = @"FavoriteShopCell";
        FavoriteShopCell *cell = (FavoriteShopCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[FavoriteShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,modle.id,modle.e];
        if ([modle.e isEqualToString:@""]) {
            imageUrl = @"";
            cell.shopImage.image = [UIImage imageNamed:@"noData1"];
        }else{
            cell.shopImage.imageURL = imageUrl;
        }
        cell.shopName.text   = modle.s;
        cell.woodsLabel.text = [NSString stringWithFormat:@"主营:  %@",modle.jyfw];
        cell.addLabel.text   = modle.w;
        return cell;
    }else{
        FavoriteWoodsModle *modle = [dataSource objectAtIndex:index];
        static NSString *cellIndentifier = @"FavoriteGoodsCell";
        FavoriteGoodsCell *cell = (FavoriteGoodsCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[FavoriteGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *imageUrl = modle.img;
        NSString *imageKey = [NSString stringWithFormat:@"%@%ld",imageUrl,(long)index];
        AsynImageView *image = [imageCache objectForKey:imageKey];
        if (image) {
            cell.goodsImage = image;
        }else{
            if ([modle.img isEqualToString:@""]) {
                imageUrl = @"";
            }
            cell.goodsImage.imageURL = imageUrl;
        }
        cell.goodsLabel.text  = modle.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@", modle.price];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    
    if (currentClickTag == 0) {
        //从收藏跳转到店铺详情
        DataModle *modle = [dataSource objectAtIndex:index];
        modleFromFavoarite1                      = modle;
        
        DetailViewController *detailController    = [[DetailViewController alloc] init];
        detailController.modle                    = modleFromFavoarite1;
        detailController.agentid = modleFromFavoarite1.id;
        detailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailController animated:YES];
    }else{
        //从收藏跳转到商品详情
        FavoriteWoodsModle *model = [dataSource objectAtIndex:index];
        GoodsDetailController *woodsController = [[GoodsDetailController alloc] init];
        woodsController.hidesBottomBarWhenPushed = NO;
        
        NSString *agentId = @"",*supplierLoginID = @"";
        if (model.AgentId) {
            agentId = model.AgentId;
        }
        if (model.SupplierLoginID) {
            supplierLoginID = model.SupplierLoginID;
        }
        NSDictionary *modelDic = [NSDictionary dictionaryWithObjectsAndKeys:model.Guid,@"Guid",model.img,@"SmallImage",model.name,@"Name",model.market,@"MarketPrice",model.price,@"ShopPrice",model.woodFrom,@"woodFrom",model.mobileProductDetail,@"mobileProductDetail",supplierLoginID,@"SupplierLoginID",agentId,@"AgentId", nil];
        DanModle *danModle = [[DanModle alloc]initWithDataDic:modelDic];
        woodsController.danModleGuid = danModle.Guid;
        
        DataModle *modle = [[DataModle alloc]initWithDataDic:[NSDictionary dictionaryWithObjectsAndKeys:[model valueForKey:@"id"],@"id",[model valueForKey:@"s"],@"s",[model valueForKey:@"e"],@"e",[model valueForKey:@"w"],@"w",[model valueForKey:@"jyfw"],@"jyfw",[model valueForKey:@"m"],@"m",[model valueForKey:@"c"],@"c",[model valueForKey:@"z"],@"z",[model valueForKey:@"sc"],@"sc",[model valueForKey:@"om"],@"om",[model valueForKey:@"num"],@"num",[model valueForKey:@"Rank"],@"Rank",[model valueForKey:@"i"],@"i",[model valueForKey:@"ot"],@"ot",[model valueForKey:@"la"],@"la",[model valueForKey:@"lt"],@"lt", nil]];
        woodsController.modle = modle;
        NSDictionary *wood = @{@"productguid":model.Guid,@"agentID":agentId,@"SupplierLoginID":supplierLoginID};
        [defaults setObject:wood forKey:@"currentWoodsInfo"];
        [self.navigationController pushViewController:woodsController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (currentClickTag == 0) {
            NSMutableArray *temp = [defaults objectForKey:@"favoriteShopList"];
            NSMutableArray *shopListArray = [temp mutableCopy];
            [shopListArray removeObjectAtIndex:index];
            [defaults setObject:shopListArray forKey:@"favoriteShopList"];
        }else{
            NSMutableArray *temp = [defaults objectForKey:FAVORITEWOODSARR];
            NSMutableArray *woodsListArray = [temp mutableCopy];
            [woodsListArray removeObjectAtIndex:index];
            [defaults setObject:woodsListArray forKey:FAVORITEWOODSARR];
        }
        if (dataSource.count == 0) {
            noDataView.hidden = NO;
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    [_tableView reloadData];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
