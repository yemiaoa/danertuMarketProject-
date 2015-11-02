//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "WoodDataController.h"

#import <QuartzCore/QuartzCore.h>
#import "DanertuWoodsViewCell.h"
#import "UIImageView+WebCache.h"

@interface WoodDataController() {
    UIView *noDataView;
    NSDictionary *selectedDic;
    NSArray *sourceDataArr;
    DanModle *selectedM;
}
@end

@implementation WoodDataController

@synthesize gridView;

@synthesize isShowingActivity;
@synthesize isFirstToLoad;
@synthesize defaults;
@synthesize classifyLb;
@synthesize addStatusBarHeight;
@synthesize isClickedRefresh;
@synthesize isToDetailByFavoNotify;
@synthesize modleFromFavoarite;
@synthesize arrays;
@synthesize isFirstToPostInner;
@synthesize additionIcon;
@synthesize isShowActivity;
@synthesize activity;
@synthesize arrow;
@synthesize titleLb;
@synthesize reachTop;
@synthesize isDataByClassifyType;
@synthesize isToRefresh;
@synthesize refreshLb;
@synthesize scrollView;

@synthesize selectTypeDic;
@synthesize searchKeyWord;
@synthesize imageCache;
@synthesize shopID;

- (void)viewDidLoad
{
    [super viewDidLoad];//没有词句,会执行多次
    
    defaults =[NSUserDefaults standardUserDefaults];
    arrays = [[NSMutableArray alloc] init];//初始化
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    imageCache = [[NSCache alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    
    self.isNetWorkRight = YES;
    self.timerValue = 0;
    isFirstToPostInner = YES;
    
    isShowActivity = YES;//显示广告
    
//    [Waiting show];//loading  显示
    isShowingActivity = YES;
    
    
    
    self.view.backgroundColor = VIEWBGCOLOR;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, self.view.frame.size.height-(45+addStatusBarHeight)+84);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    gridView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, self.view.frame.size.height-(45+addStatusBarHeight))];//中间区域,出去不可滑动的区域
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.autoresizesSubviews = YES;
    gridView.delegate = self;
    gridView.dataSource = self;
    [scrollView addSubview:gridView];
    [Tools setExtraCellLineHidden:gridView];
    
    //-----下拉刷新的隐藏按钮------
    refreshLb = [[UILabel alloc] initWithFrame:CGRectMake(0, -84, MAINSCREEN_WIDTH, 84)];
    refreshLb.text = @"下拉即可刷新...";
    refreshLb.textColor = [UIColor grayColor];
    refreshLb.font = [UIFont systemFontOfSize:14];
    refreshLb.backgroundColor = [UIColor clearColor];//---背景透明色---
    refreshLb.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:refreshLb];//
    
    //-------回到顶部按钮------
    reachTop = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60,self.view.frame.size.height-60-49,  60, 60)];
    [reachTop setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8]];//
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-orange"] forState:UIControlStateNormal];
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-black"] forState:UIControlStateHighlighted];
    [reachTop addTarget:self action:@selector(pageTop) forControlEvents:UIControlEventTouchUpInside];
    reachTop.hidden = YES;
    [self.view addSubview:reachTop];
    
    //没有数据显示的view
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT + addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    [self.view addSubview:noDataView];
    //默认隐藏
    noDataView.hidden = YES;
    
    int topDistance = (CONTENTHEIGHT+49-130)/2;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(110, topDistance, 100, 100)];
    [noDataView addSubview:imgV];
    [imgV setImage:[UIImage imageNamed:@"noData"]];
    
    UILabel *textV = [[UILabel alloc] initWithFrame:CGRectMake(60, topDistance+100, 200, 30)];
    [noDataView addSubview:textV];
    textV.backgroundColor = [UIColor clearColor];
    textV.textAlignment = NSTextAlignmentCenter;
    textV.text = @"抱歉!没有数据";
    
    [self getShopDataByCity];  //加载数据
}

//回到顶部
- (void)pageTop{
    reachTop.hidden = YES;//隐藏
    [UIView animateWithDuration:1.0 animations:^{
        [gridView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
//    [gridView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
//----重写父类
-(NSString*)getTitle{
    NSString *title;
    if (searchKeyWord.length<=0&&[[selectTypeDic objectForKey:@"Name"] length]>0) {
        title = [selectTypeDic objectForKey:@"Name"];
    }else{
        title = [NSString stringWithFormat:@"关键字:%@",searchKeyWord];
        title = @"搜索结果";
    }
    return title;
}
//重写父类
-(void)onClickBack{
    //ASIHTTPRequestDelegate = nil;
    //跳转之前,delegate清除掉,否则跳转后  本身类不复存在,delegate方法找不到自身类,闪退
    [gridView removeFromSuperview];
    //httpRequest.delegate = nil;
    
    gridView.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
//---弹到第一页,到店铺详情页
-(void) popToRootDetailView:(NSNotification*) notification{
    modleFromFavoarite = [notification object];
    isToDetailByFavoNotify = YES;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];//弹到第一页
    [self performSegueWithIdentifier:@"detail" sender:self];//跳转到detail
}
//---弹到第一页
-(void) popToRootView{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];//弹到第一页
}
//重新加载数据
-(void)refreshHttp{
    self.isNetWorkRight = YES;//网络状态是否正常
    [arrays removeAllObjects];//移除所有元素
    [self getShopDataByCity];
}
/*恢复初始化状态
 *数据页数  置1
 *是否更多数据,是否有数据,是否网络正常,都  置 YES
 *arrays  清空,这样会把页面数据消掉
 */
//获取商品数据
-(void)getShopDataByCity{
    [Waiting show];
//    if(!isShowingActivity){
////        [Waiting show];
//    }
//    if (gridView) {
//        [self showHudInView:gridView hint:@"加载中..."];
//    }
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params;
    NSString *resultDataKeyPrefix,*resultDataKeyPrefix1;
    if ([[selectTypeDic objectForKey:@"Name"] length]>0&&searchKeyWord.length<=0) {
        params = @{@"apiid": @"0081",@"catoryid" :[selectTypeDic objectForKey:@"ID"]};
        resultDataKeyPrefix = @"productList";
        resultDataKeyPrefix1 = @"productbean";
    }else{
        params = @{@"apiid": @"0045",@"kword" :searchKeyWord};
        resultDataKeyPrefix = @"searchprocuctList";
        resultDataKeyPrefix1 = @"searchproductbean";
    }
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self hideHud];
        [Waiting dismiss];//隐藏loading
        isShowingActivity = NO;
        if(self.isNetWorkRight==NO){
            [arrays removeObjectAtIndex:0];//前一状态  网络异常时array有一个无效的cell,删除
        }
        self.isNetWorkRight = YES;
        DanModle *model = [[DanModle alloc] init];//对象数据模型
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
        NSMutableArray *temp = [[jsonData objectForKey:resultDataKeyPrefix] objectForKey:resultDataKeyPrefix1];
        sourceDataArr = [temp copy];
        //多个item数组
        if(temp.count>0){
            noDataView.hidden = YES;
            for(int i=0;i<temp.count;i++){
                NSString *imgUrl = @"";
                NSDictionary *modelDic = [temp objectAtIndex:i];
                model = [[DanModle alloc] initWithDataDic:modelDic];//对象属性的拷贝
                [model setAgentId:[modelDic objectForKey:@"AgentID"]];
                NSString *url = [[temp objectAtIndex:i] objectForKey:@"SmallImage"];
                if (model.SupplierLoginID.length>0) {
                    //供应商
                    imgUrl = [NSString stringWithFormat:@"%@%@/%@",SUPPLIERPRODUCT,model.SupplierLoginID,url];
                    [model setWoodFrom:@"supply"];
                }else if (model.AgentId.length>0){
                    //代理商
                    imgUrl = [NSString stringWithFormat:@"%@%@/%@" ,MEMBERPRODUCT,model.AgentId,url];
                    [model setWoodFrom:@"agent"];
                }else{
                    //平台
                    imgUrl = [NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,url];
                    [model setWoodFrom:@"danertu"];
                    if ([url hasPrefix:@"/ImgUpload/"]) {
                        url = [url stringByReplacingOccurrencesOfString:@"/ImgUpload/" withString:@""];
                        imgUrl = [NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,url];
                    }
                }
                
                [model setSmallImage:imgUrl];//单独修改  图片路径属性,小图,有的没有小图
                //一元礼包
                if (![model.Guid isEqualToString:LIBAOGUID]) {
                    [arrays addObject:model];//追加到数组
                }
            }
            
        }else{
            noDataView.hidden = NO;
            [self showHint:@"暂无数据"];
        }
        [gridView reloadData];//这里没有数据也用执行,因为不执行,就一直显示之前的数据,切换城市时出错
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self hideHud];
         [self showHint:REQUESTERRORTIP];
        //[Waiting dismiss];//隐藏loading
        
        [Waiting dismiss];//隐藏loading
        isShowingActivity = NO;
        //前一状态的 isNetWorkRight=YES,否则不再执行
        if(self.isNetWorkRight){
            
           
        }
    }];
    [operation start];
}
//,,,,,,,,,,scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollViewTmp
{
    if (gridView.contentOffset.y > 1000) {
        reachTop.hidden = NO;//显示回到顶部
    }else{
        reachTop.hidden = YES;//隐藏回到顶部
    }
    if (scrollView.contentOffset.y < -100) {
        isToRefresh = YES;
        refreshLb.text = @"释放即可刷新...";
    }
    if (gridView.contentOffset.y>0) {
        scrollView.scrollEnabled = NO;
    }else{
        scrollView.scrollEnabled = YES;
    }
}
//开始滑动或下拉
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViewTmp{
    isToRefresh = NO;
    refreshLb.text = @"下拉即可刷新...";
}
//停止滑动后判断是否滑到了底部,决定是否加载  新数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollViewTmp willDecelerate:(BOOL)decelerate
{
    if(isDataByClassifyType&&(gridView.contentOffset.y>=fmaxf(.0f, scrollViewTmp.contentSize.height - scrollViewTmp.frame.size.height))){
        [self getShopDataByCity];
    }
}

// 广告轮播滑动,scrollview 委托函数,,,下拉停止,,,
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewTmp
{
    if (isToRefresh){
        [self refreshHttp];//刷新数据
    }
}

#pragma mark AQGridViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrays count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//数据填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PlainCell";
    DanertuWoodsViewCell * cell = (DanertuWoodsViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if(cell == nil){
        cell = [[DanertuWoodsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:identifier withCellSize:cellSize];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //取得每一个数据
    DanModle *danModle = [arrays objectAtIndex:indexPath.row];
    //这里加判断如果可以就去下载图片
    NSString *imageKey = [NSString stringWithFormat:@"%@%ld",danModle.SmallImage,indexPath.row];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image == nil) {
        cell.imageView.imageURL = danModle.SmallImage;
        image = cell.imageView;
        [self.imageCache setObject:image forKey:imageKey];
    }
    else{
        cell.imageView = image;
    }
    [cell.mainView addSubview:image];
    [cell.woodsLabel setText:danModle.Name];//店铺名称
    //原价
    if ([danModle.MarketPrice doubleValue] > 0) {
        [cell.marketPriceLabel setText:[NSString stringWithFormat:@"¥ %@", danModle.MarketPrice]];//价格
        //获取市场价格后,得到字符串的width,height
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
        CGSize size = CGSizeMake(500, 2000);//足够大的个CGSize
        CGSize labelsize = [[NSString stringWithFormat:@"¥ %@", danModle.MarketPrice] sizeWithFont:font constrainedToSize:size lineBreakMode: NSLineBreakByWordWrapping];
        cell.lineLabel.frame = CGRectMake(0, cell.lineLabel.frame.origin.y, labelsize.width, 1);//这里修改width,以适应市场价格的width
     
    }else{
        //隐藏
        cell.marketPriceLabel.hidden = YES;
        cell.lineLabel.hidden = YES;
    }
    //现价
    [cell.priceLabel setText:[NSString stringWithFormat:@"¥ %@", danModle.ShopPrice]];//价格
    return cell;
}
//选中Item
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedDic = sourceDataArr[indexPath.row];
    selectedM = arrays[indexPath.row];
    //为联系电话赋值
    if (selectedM.ContactTel.length <= 0) {
        if (selectedM.Mobile.length > 0) {
            [selectedM setContactTel:selectedM.Mobile];
        }else if (selectedM.AgentId.length > 0) {
            [selectedM setContactTel:selectedM.AgentId];
        }
    }
    
    
    GoodsDetailController *woodsController = [[GoodsDetailController alloc] init];
    woodsController.hidesBottomBarWhenPushed = NO;
    DataModle *d = [[DataModle alloc] init];
    if (shopID) {
        d.id = shopID;
    }
    else{
        if ([[selectedDic objectForKey:@"AgentId"] length]>0) {
            d.id = [selectedDic objectForKey:@"AgentId"];
        }else if([[selectedDic objectForKey:@"SupplierLoginID"] length]>0){
            d.id = [selectedDic objectForKey:@"SupplierLoginID"];
        }
    }
    
    woodsController.danModleGuid =  selectedM.Guid;
    woodsController.modle = d;
    [self.navigationController pushViewController:woodsController animated:YES];
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
