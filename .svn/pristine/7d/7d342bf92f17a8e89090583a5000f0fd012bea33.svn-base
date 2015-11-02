//
//  GoodsShopListController.m
//  单耳兔
//
//  Created by yang on 15/8/11.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//
//烟酒茶 + 住玩购

#import "GoodsShopListController.h"
#import "SDRefresh.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"
#import "DataModle.h"
#import "GoodsShopListCell.h"
#import "AsynImageView.h"
#import "DetailViewController.h"

@interface GoodsShopListController ()
{
    int addStatusBarHeight;
    UITableView *_tableView;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
    NSArray *classifyDataArr;
    NSMutableArray *dataSourceArr;
    UIButton *reachTop;
    UILabel *topNaviClassifyText;
    UIView *classifyView;
    NSInteger currentClassifyIndex;
    UIView *noDataView;
    NSInteger pageIndex; //当前页
    NSCache *imageCache;
}
@end

@implementation GoodsShopListController
@synthesize classifyType;
@synthesize keyWord;
@synthesize city;
@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self setupHeader];
    [self setupFooter];
    [self loadData];
    
}

- (void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeader{
    refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __block typeof(self) bself = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bself headRefresh];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
//下拉刷新
- (void)headRefresh{
    pageIndex = 1;
    if (dataSourceArr.count > 0 ) {
        [dataSourceArr removeAllObjects];
    }
    [self loadData];
}

-(void)setupFooter{
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}
//上拉加载更多
- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshFooter endRefreshing];
        if (dataSourceArr.count < (pageIndex-1) * 20) {
            //无下一页
            return;
        }
        [self loadData];
    });
}

- (void)initView{
    
    addStatusBarHeight = STATUSBAR_HEIGHT;
//    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    pageIndex = 1;
    
    //返回
    UIButton *goBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 2+addStatusBarHeight, 53.5, 40)];
    [self.view addSubview:goBack];
    [goBack setBackgroundImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    //分类,可以点击
    UIView *classifyBlock = [[UIView alloc] initWithFrame:CGRectMake(70, 0+addStatusBarHeight, 60, TOPNAVIHEIGHT)];
    [self.view addSubview:classifyBlock];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showClassify)];
    [classifyBlock addGestureRecognizer:singleTap];//添加大图片点击事件
    
    //选中的文字
    topNaviClassifyText = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 50, 25)];
    [classifyBlock addSubview:topNaviClassifyText];
    topNaviClassifyText.backgroundColor = [UIColor clearColor];
   
    
    //默认数据
    int type = [classifyType intValue];
    currentClassifyIndex = 0;
    if (type == 5) {
        classifyDataArr = @[@{@"Name":@"烟酒茶",@"Id":@"5"}];
        topNaviClassifyText.text = @"烟酒茶";
    }else{
        classifyDataArr = @[@{@"Name":@"住",@"Id":@"2"},
                            @{@"Name":@"玩",@"Id":@"3"},
                            @{@"Name":@"购",@"Id":@"4"},
                            @{@"Name":@"全部",@"Id":@""}];
        topNaviClassifyText.text = @"住";
    }
    topNaviClassifyText.font = [UIFont systemFontOfSize:18];
    topNaviClassifyText.textColor = [UIColor whiteColor];
    topNaviClassifyText.userInteractionEnabled = YES;//这样才可以点击
    [topNaviClassifyText setNumberOfLines:1];
    [topNaviClassifyText sizeToFit];//自适应
    
    int y = iOS7 ? 0 : 20;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - addStatusBarHeight-TOPNAVIHEIGHT-y)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [Tools setExtraCellLineHidden:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //没有数据显示的view
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    [self.view addSubview:noDataView];
    
    int topDistance = (CONTENTHEIGHT + 49- 130)/2;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(110, topDistance, 100, 100)];
    [noDataView addSubview:imgV];
    [imgV setImage:[UIImage imageNamed:@"noData"]];
    
    UILabel *textV = [[UILabel alloc] initWithFrame:CGRectMake(60, topDistance+100, 200, 30)];
    [noDataView addSubview:textV];
    textV.backgroundColor = [UIColor clearColor];
    textV.textAlignment = NSTextAlignmentCenter;
    textV.text = @"抱歉!没有数据";
    
    noDataView.hidden = YES;
    
    //下拉选项列表
    int itemH = 40;
    int itemW = 100;
    NSInteger count = classifyDataArr.count;
    //---------头部第一分类,下拉选择项-------
    classifyView = [[UIView alloc] initWithFrame:CGRectMake(70, TOPNAVIHEIGHT+addStatusBarHeight, itemW, itemH*count)];
    [self.view addSubview:classifyView];
    classifyView.hidden = YES;
    classifyView.userInteractionEnabled = YES;//这样才可以点击
    classifyView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    for (NSInteger i = 0; i < count; i++) {
        //顺便初始化,@""代替占位符
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, itemH*i, itemW, itemH)];
        [classifyView addSubview:item];
        item.tag = 100+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClassify:)];
        [item addGestureRecognizer:singleTap];//---添加大图片点击事件
        
        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
        [item addSubview:itemText];
        itemText.text = [classifyDataArr[i] objectForKey:@"Name"];
        itemText.backgroundColor = [UIColor clearColor];
        itemText.textColor = [UIColor whiteColor];
        itemText.textAlignment = NSTextAlignmentCenter;
        if (i < count-1) {
            UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0,itemH-1, itemW, 1)];
            [item addSubview:border];
            border.backgroundColor = BORDERCOLOR;
        }
    }
    
    //回到顶部按钮
    reachTop = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60,self.view.frame.size.height-60-49,  60, 60)];
    [reachTop setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8]];//
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-orange"] forState:UIControlStateNormal];
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-black"] forState:UIControlStateHighlighted];
    [reachTop addTarget:self action:@selector(pageTop) forControlEvents:UIControlEventTouchUpInside];
    reachTop.hidden = YES;
    [self.view addSubview:reachTop];
    
    dataSourceArr = [[NSMutableArray alloc] init];
    imageCache = [[NSCache alloc] init];
}

- (void)loadData{
    [Waiting show];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0037",@"apiid",
                                                                                    keyWord, @"kword" ,
                                                                                 coordinate,@"gps",
                                                                                   @"80000",@"less",
                                                               [city objectForKey:@"cName"],@"areaCode",
                                                                                      @"20",@"pageSize",
                                                     [NSNumber numberWithInteger:pageIndex],@"pageIndex",
                                                                               classifyType,@"type",nil];
    NSString *resultDataKeyPrefix = @"shoplist";
    NSString *resultDataKeyPrefix1 = @"shopbean";
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Waiting dismiss];//隐藏loading
        NSString* jsonDataStr  = [Tools deleteErrorStringInData:responseObject];
        NSData *jsonDataTmp    = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
        
        DataModle *model       = [[DataModle alloc] init];//对象数据模型
        NSMutableArray *temp   = [[jsonData objectForKey:resultDataKeyPrefix] objectForKey:resultDataKeyPrefix1];
        if (temp.count > 0){
            for(int i=0;i<temp.count;i++){
                model = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                [dataSourceArr addObject:model];//追加到数组
            }
            
            pageIndex = pageIndex + 1;
        }
        
        if (dataSourceArr.count == 0) {
            noDataView.hidden = NO;
        }else{
            noDataView.hidden = YES;
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
    
}

- (void)pageTop{
    reachTop.hidden = YES;//隐藏
    [UIView animateWithDuration:1.0 animations:^{
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

//隐藏,显示下拉选项
- (void)showClassify{
    classifyView.hidden = !classifyView.hidden;
}

//选择其他分类
-(void)selectClassify:(id)sender{
    
    classifyView.hidden = YES;
    
    int tag = (int)[[sender view] tag]-100;
    if (tag != currentClassifyIndex) {
        
        currentClassifyIndex = tag;
        topNaviClassifyText.text = [classifyDataArr[tag] objectForKey:@"Name"];
        //调整文字,小标大小
        [topNaviClassifyText sizeToFit];

        //选择分类,之后重新加载数据,,,,,,,住玩购,定送餐多要根据id刷新数据
        classifyType = [classifyDataArr[tag] objectForKey:@"Id"];
        [self headRefresh];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"GoodsShopListCell";
    GoodsShopListCell *cell = (GoodsShopListCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GoodsShopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger index = [indexPath row];
    DataModle *modle = nil;
    @try {
         modle = [dataSourceArr objectAtIndex:indexPath.item];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   
    //商品图片
    NSString *smallImage = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,modle.id, modle.e];
    NSString *imageKey = [NSString stringWithFormat:@"%@%lu",smallImage,(long)index];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image == nil) {
        cell.imageView.imageURL = smallImage;
        image = cell.imageView;
        [imageCache setObject:image forKey:imageKey];
    }
    else{
        cell.imageView = image;
    }

    if ([modle.s isEqualToString:@""]) {
        cell.nameL.text = @"--";
    }else{
        cell.nameL.text = [NSString stringWithFormat:@"%@",modle.s];
    }
    
    if ([modle.jyfw isEqualToString:@""]) {
        cell.shopProductL.text = @"主营:  --";
    }else{
        cell.shopProductL.text = [NSString stringWithFormat:@"主营:%@",modle.jyfw];
    }
    
    if ([modle.juli isEqualToString:@""]) {
        cell.distanceL.text = @"-- km";
    }else{
        cell.distanceL.text = [NSString stringWithFormat:@"%@ km",modle.juli];
    }
    
    NSArray *specailPro = [modle.shopshowproduct componentsSeparatedByString:@","] ;
    if (specailPro.count==5) {
        [cell.saleGoodL setText:specailPro[1]];
        NSInteger temp = [specailPro[4] integerValue] / 10000;
        NSString *priceStr = [NSString stringWithFormat:@"%@",specailPro[4]];
        if ( temp > 0) {
            priceStr = [NSString stringWithFormat:@"%.2fw",[specailPro[4] integerValue]/10000.00];
        }
        [cell.goodPriceL setText:[NSString stringWithFormat:@"￥%@", priceStr]];
        
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    DetailViewController *deView = [[DetailViewController alloc] init];
    deView.hidesBottomBarWhenPushed = YES;
    //取得选中的字典数据,
    DataModle *modle = [dataSourceArr objectAtIndex:index];
    deView.modle = modle;
    [self.navigationController pushViewController:deView animated:YES];
}

#pragma mark scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableView.contentOffset.y > 644) {
        reachTop.hidden = NO;//-----显示回到顶部----
    }else{
        reachTop.hidden = YES;//----隐藏回到顶部----
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
