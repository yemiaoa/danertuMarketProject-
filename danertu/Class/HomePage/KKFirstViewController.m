//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKFirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GridViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HeMerchantDetailVC.h"
#import "Waiting.h"
#import "GoodsShopListController.h"

@interface KKFirstViewController()
{
    NSString *goWoodsListKeyWord;
    DataModle *specialShopModle;
    AFHTTPClient * httpClient;
    BOOL isSpecialShop;
    BOOL isToLoginForActivity;
    NSString *bindShopId;   //绑定店铺的id
    int danertuWoodsSegmentNo;   //单耳兔商城酒分类tag
    NSMutableArray *pageStackArr;   //记录页面加载顺序
    
    UIScrollView *adsScrollView_guid ;
    NSArray *slideImages_guid;
    UIPageControl *pageControl_guid ;
    NSString *styleStr;   //定送餐,住玩够
    LocationSingleton *locationObj ;
    NSTimer *myTimer;
    int timerNum;
    UIWindow *windows;
    UIImageView *_launchView;
}

@end

@implementation KKFirstViewController
@synthesize gridView;
@synthesize city;
@synthesize coordinate;
@synthesize preCoordinate;
@synthesize keyWord;
@synthesize distanceParameter;
@synthesize cityLb;
@synthesize refreshIcon;
@synthesize isShowingActivity;
@synthesize isToGetShopByCity;
@synthesize isFirstToLoad;
@synthesize classifyType;
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
@synthesize adsScrollView;
@synthesize pageControl;
@synthesize slideImages;
@synthesize scrollView;
@synthesize reachTop;
@synthesize mapView;
@synthesize posTipsLb;
@synthesize currentPos;
@synthesize popMapView;
@synthesize sendPosBtn;
@synthesize isPreRequestFinished;
@synthesize refreshLb;
@synthesize isToRefresh;

//网页加载相关
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize firstLoadDataStr;
@synthesize selectShopId;
@synthesize topNavi_zeroOne;
@synthesize activityWoodInfo;
@synthesize isWebPageLoaded;
@synthesize locationmanager;
@synthesize cityFromPos;
@synthesize pos;
@synthesize isEnterBakcground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLaunchImageView];
    [self setCache];
    [self jumpToBindShop];
    [self initialization];  //资源的初始化，比如变量的初始化
    [self initView];    //视图的初始化
    [self initPush];    //设定监听
    [self getImageServerIp];    //获取图片服务器的IP地址
}      

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)loadLaunchImageView{
    windows = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    windows.windowLevel = 10.0;
    [windows makeKeyAndVisible];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (iPhone5) {
        
        for (int i = 0; i < 2; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Default-568_%d",i]];
            [arr addObject:image];
        }
//        _launchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    else
    {
        for (int i = 0; i < 2; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Default_%d",i]];
            [arr addObject:image];
        }
//        _launchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    _launchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2-100, MAINSCREEN_HEIGHT-50, 200, 30)];
    [_launchView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:109/255.0 green:3/255.0 blue:4/255.0 alpha:1.0];
    label.font = TEXTFONTSMALL;
    label.text = [NSString stringWithFormat:@"当前版本号:%@",[Tools getAppVersion]];
    label.backgroundColor = [UIColor clearColor];
    
    [windows addSubview:_launchView];
    [windows bringSubviewToFront:_launchView];
    
    [_launchView setAnimationImages:arr];
    [_launchView setAnimationDuration:0.8];
    [_launchView startAnimating];
    
    [self performSelector:@selector(removeLaunchView) withObject:nil afterDelay:3.0];
}

- (void)removeLaunchView{
    windows.alpha = 0.0;
    [_launchView stopAnimating];
    [_launchView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
        else{
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}



- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else{
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)getImageServerIp
{
    NSDictionary *params = @{@"apiid":@"0154"};
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString *url = operation.responseString;
        if (!([url hasPrefix:@"http"] || [url hasPrefix:@"https:"])) {
            url = [NSString stringWithFormat:@"http://%@/",url];
        }
        [HeSingleModel shareHeSingleModel].imageServerUrl = url;
        if (![HeSingleModel shareHeSingleModel].imageServerUrl) {
            [HeSingleModel shareHeSingleModel].imageServerUrl = IMAGESERVER;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    
    }];
}

//检测本地是否有绑定的店铺
- (void)jumpToBindShop
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (userName == nil || [userName isEqualToString:@""]) {
        userName = @"";
    }
    
    NSString *specialKey = @"specialUserKey";
    NSDictionary *dict = [defaults objectForKey:specialKey];
    NSString *specialShopID = [dict objectForKey:@"shopid"];
    if (!(specialShopID == nil || [specialShopID isEqualToString:@""])) {
        //本地有记录
        [self changeRootVCWithShopID:specialShopID];
    }
    else{
        
    }
}

//如果有设置为商家定制版，跳到该商家的详情页
- (void)changeRootVCWithShopID:(NSString *)shopid
{
    [self hideHud];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.agentid = shopid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)setCache
{
    //设置缓存五分钟的有效期
    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                 diskCapacity:200 * 1024 * 1024
                                                                     diskPath:nil
                                                                    cacheTime:300];
    [CustomURLCache setSharedURLCache:urlCache];
}

- (void)initialization
{
    self.view.backgroundColor = [UIColor whiteColor];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    pageStackArr = [[NSMutableArray alloc] init];
    isPreRequestFinished = NO;   //上一次请求是否结束
    isWebPageLoaded = NO;   //网页是否完成加载
    isSpecialShop = NO;   //是特殊店铺
    
    locationObj = [LocationSingleton sharedInstance];
    //执行删除本地不用数据
    [defaults removeObjectForKey:@"favoriteWoodsList"];//1.3.6及之前的版本
    [defaults removeObjectForKey:@"ClientWoodsArray"];//1.3.7及之前的版本
    [defaults removeObjectForKey:@"shopCatWoodsArr"];//1.3.8的版本
    [defaults removeObjectForKey:@"shopCatWoodsCount"];//1.3.8的版本
    [defaults removeObjectForKey:@"portraitImgFilePath"];//1.4.0的版本,删除废弃不用
    
    //每次初始化删除保存的店铺信息
    [defaults removeObjectForKey:@"currentShopInfo"];
    //如果--defaults--没有存放wifiLoadImg,那么添加,并且默认为 true
    if (![defaults objectForKey:@"wifiLoadImg"]) {
        [defaults setObject:@"true" forKey:@"wifiLoadImg"];
    }
}

- (void)initView
{
    addStatusBarHeight = STATUSBAR_HEIGHT;
    
    //0.1元购,头部导航,网页直接跳转,这里添加返回
    topNavi_zeroOne = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight, MAINSCREEN_WIDTH, TOPNAVIHEIGHT)];
    [self.view addSubview:topNavi_zeroOne];
    topNavi_zeroOne.hidden = YES;    //初始时隐藏
    topNavi_zeroOne.userInteractionEnabled = YES;    //这样才可以点击
    topNavi_zeroOne.backgroundColor = TOPNAVIBGCOLOR;
    
    CGFloat buttonX = 10;
    CGFloat buttonY = 2+addStatusBarHeight;
    CGFloat buttonW = 53.5;
    CGFloat buttonH = TOPNAVIHEIGHT - 2 * buttonY;

    UIButton *goBack = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [topNavi_zeroOne addSubview:goBack];
    [goBack setBackgroundImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(onClickBack_web) forControlEvents:UIControlEventTouchUpInside];
    
    //文字
    UILabel *topNaviText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0+addStatusBarHeight, 200, TOPNAVIHEIGHT)];
    topNaviText.text = @"返回首页";
    topNaviText.font = [UIFont systemFontOfSize:18];
    topNaviText.textColor = [UIColor whiteColor];
    topNaviText.tag = 2000;
    topNaviText.userInteractionEnabled = YES;//这样才可以点击
    topNaviText.backgroundColor = [UIColor clearColor];
    [topNavi_zeroOne addSubview:topNaviText];
    
    CGFloat cLbX = 0;
    CGFloat cLbY = 7+addStatusBarHeight;
    CGFloat cLbW = 80;
    CGFloat cLbH = TOPNAVIHEIGHT - 2 * 7;
    cityLb = [[UILabel alloc] initWithFrame:CGRectMake(cLbX, cLbY, cLbW, cLbH)];
    cityLb.backgroundColor = [UIColor clearColor];
    cityLb.font = [UIFont systemFontOfSize:15];
    cityLb.textAlignment = NSTextAlignmentCenter;
    cityLb.textColor = [UIColor whiteColor];
    cityLb.userInteractionEnabled = YES;
    self.navigationController.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightButton)];
    [cityLb addGestureRecognizer:singleTap];//添加大图片点击事件
    [self.view addSubview:cityLb];
    
    //扫描按钮
    CGFloat scanBtnY = 7+addStatusBarHeight;
    CGFloat scanBtnH = TOPNAVIHEIGHT - 2 * 7;
    CGFloat scanBtnW = 60;
    CGFloat scanBtnX = MAINSCREEN_WIDTH - scanBtnW;
    UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(scanBtnX, scanBtnY, scanBtnW, scanBtnH)];
    [self.view addSubview:scanBtn];
    
    //判断是否是业务员版本
    if (isInnerVersion) {
        [scanBtn setTitle:@"坐标" forState:UIControlStateNormal];
        [scanBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
        scanBtn.userInteractionEnabled = YES;
        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(justForInner) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [scanBtn setImage:[UIImage imageNamed:@"newMsg"] forState:UIControlStateNormal];
        [scanBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 18, 7, 18)];
        [scanBtn addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGFloat searchX = cLbX + cLbW;
    CGFloat searchY = 7+addStatusBarHeight;
    CGFloat searchH = TOPNAVIHEIGHT - 2 * 7;
    CGFloat searchW = MAINSCREEN_WIDTH - searchX - scanBtnW;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(searchX, searchY, searchW, searchH)];
    [self.view addSubview:searchView];
    searchView.userInteractionEnabled = YES;
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView.layer setMasksToBounds:YES];
    [searchView.layer setCornerRadius:15.0];  //设置矩形四个圆角半径
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSearchView)];
    [searchView addGestureRecognizer:singleTap1];  //添加点击事件
    //搜索图标
    CGFloat searchIconX = 10;
    CGFloat searchIconY = 5;
    CGFloat searchIconH = searchH - 2 * searchIconY;
    CGFloat searchIconW = searchIconH;
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(searchIconX, searchIconY, searchIconW, searchIconH)];
    [searchView addSubview:searchIcon];
    searchIcon.backgroundColor = [UIColor clearColor];
    searchIcon.image = [UIImage imageNamed:@"magnifying"];
    
    CGFloat searchTextX = searchIconX +  searchIconW + 2;
    CGFloat searchTextY = 2;
    CGFloat searchTextW = searchW - searchIconX - searchIconW - 10;
    CGFloat searchTextH = searchH - 2 * searchTextY;
    
    //索搜文字
    UILabel *searchText = [[UILabel alloc] initWithFrame:CGRectMake(searchTextX, searchTextY, searchTextW, searchTextH)];
    [searchView addSubview:searchText];
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    searchText.text = @"搜索单耳兔商品/店铺";
    searchText.textColor = [UIColor grayColor];
    searchText.textAlignment = NSTextAlignmentLeft;
    
    //城市信息
    //self.kk = self;//
    arrays = [[NSMutableArray alloc] init];//初始化
    self.p = @"1";//当前页
    self.isHaveMore = YES;
    self.isHaveData = YES;
    self.isNetWorkRight = YES;
    self.timerValue = 0;
    isFirstToPostInner = YES;
    isShowActivity = YES;//显示广告
    
    keyWord = @"";
    distanceParameter = @"";//距离范围参数
    classifyType = @"";
    coordinate = @"";
    [Waiting show];
    isShowingActivity = YES;
    
    timerNum = 0;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeTimer) userInfo:nil repeats:YES];
    [myTimer fire];
    
    //取消默认城市,这里初始化
    city = [[NSMutableDictionary alloc]init];
    
    isFirstToLoad = YES;   //第一次加载
    isToGetShopByCity = YES;   //第一次加载城市
    isClickedRefresh = NO;   //是否点击了刷新按钮
    isToDetailByFavoNotify = NO;   //是否跳转到detail ,通过favorite的通知  去跳转
    preCoordinate = @"";
    
    //实例化myTimer,循环间隔执行
    NSTimer* connectionTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    
    webURL = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,INDEXPAGENAME];
    //加载页面
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];
    //清除缓存
    if (CLEARWEBCACHE) {
//        NSURLCache * cache = [NSURLCache sharedURLCache];
//        [cache removeAllCachedResponses];
//        [cache setDiskCapacity:0];
//        [cache setMemoryCapacity:0];
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    
    // Do any additional setup after loading the view, typically from a nib.
    //----loading显示
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;//只能设置中心，不能设置大小
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

- (void)initPush
{
 
    [Tools initPush];
    //----监听消息---
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLocateByGPS) name:@"reLocateByGPS" object:nil];//和 appdelegate  之间的消息传递
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootView) name:@"popToRootView" object:nil];//和 addressView  之间的消息传递
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootDetailView:) name:@"popToRootDetailView" object:nil];//和 favoriteView 收藏商铺 之间的消息传递
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootWoodsDetailView:) name:@"popToRootWoodsDetailView" object:nil];//和 favoriteView 收藏商品 之间的消息传递
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeValue:) name:@"setBadgeValue" object:nil];//和 哪些不能访问到tabbar的view之间的消息传递
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIndexPage:) name:@"showIndexPage" object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showViewTabbarIndex:) name:@"showViewTabbarIndex" object:nil];//
}
/*
 2015-07-03
 弃用--暂时保留
 */
//----显示自定义tabbar---
//-(void)showTabbarView{
//    return;
//    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow .frame.size.height - 49, MAINSCREEN_WIDTH, 49)];
//    //    [self.view addSubview:tabbarView];
//    tabbarView.tag = 1000;//移除时使用tag快速找到-----
//    [[UIApplication sharedApplication].keyWindow  addSubview:tabbarView];
//    //------移除自带的tabbar-----
//    [self.tabBarController.tabBar removeFromSuperview];
//    
//    tabbarView.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
//    
//    NSArray *itemImages = [NSArray arrayWithObjects:@"homeIcon",@"classifyIcon",@"photo",@"shopIcon",@"myIcon",@"homeIcon-B",@"classifyIcon-B",@"photo-B",@"shopIcon-B",@"myIcon-B",@"商城",@"分类",@"",@"购物车",@"我的", nil];
//    NSInteger itemCount = itemImages.count/3;
//    //UIImage *myImage;
//    int itemHeight = 49;
//    double itemWidth = MAINSCREEN_WIDTH/itemCount;
//    int iconImgWidth = 32;
//    for (int i=0; i<itemCount; i++) {
//        UIButton *tabbarItem = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, itemHeight)];
//        [tabbarView addSubview:tabbarItem];
//        //设置为居左居上,这样之后设置edge
//        
//        if (i==2) {
//            iconImgWidth = 40;
//        }else{
//            iconImgWidth = 32;
//        }
//        tabbarItem.contentMode = UIViewContentModeScaleAspectFill;
//        
//        [tabbarItem setImage:[UIImage imageNamed:itemImages[i]] forState:UIControlStateNormal];
//        [tabbarItem setImage:[UIImage imageNamed:itemImages[i+itemCount]] forState:UIControlStateHighlighted];
//        
//        [tabbarItem setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 5, 0)];
//        
//        [tabbarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [tabbarItem setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        //}
//        tabbarItem.tag = 100 + i;
//
//        [tabbarItem setImageEdgeInsets:UIEdgeInsetsMake((itemHeight-iconImgWidth - 30) / 2.0, (itemWidth- iconImgWidth) / 2.0, 0, 0)];
//        [tabbarItem setTitle:itemImages[i+itemCount*2] forState:UIControlStateNormal];
//        tabbarItem.titleLabel.font = TEXTFONTSMALL;
//        [tabbarItem setTitleEdgeInsets:UIEdgeInsetsMake((itemHeight-iconImgWidth - 30) / 2.0 + iconImgWidth, - iconImgWidth + 5, 0, 0)];
//        
//        [tabbarItem addTarget:self action:@selector(tapTabbar:) forControlEvents:UIControlEventTouchUpInside];
//    }
//}

//点击底部tabbar按钮
-(void)tapTabbar:(UIButton *)btn{
    NSInteger tag = btn.tag - 100;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewTabbarIndex" object:nil userInfo:@{@"tabbarIndex":[NSString stringWithFormat:@"%ld",tag]}];//object 和 userInfo都可以传值
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//-------跳到首页,不同tabbar 对应的viewcontroller
-(void)showViewTabbarIndex:(NSNotification*)notification{
    NSInteger tabbarIndex = [[[notification userInfo] objectForKey:@"tabbarIndex"] intValue];
    if (tabbarIndex>=0) {
        [self.tabBarController setSelectedIndex:tabbarIndex];
        [self setBarItemSelectedIndex:tabbarIndex];
    }
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

-(void)showIndexPage:(NSNotification*)notification{
    if ([[[notification userInfo] objectForKey:@"activityName"] isEqualToString:ACTIVITY_ONEYUAN]) {
        topNavi_zeroOne.hidden = YES;
        [webView reload];
    }else{
        topNavi_zeroOne.hidden = NO;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    }
}


//-----网页返回前一页
-(void)onClickBack_web{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //--------默认标题-----"返回首页"----
    UILabel *titleLb = (UILabel *)[topNavi_zeroOne viewWithTag:2000];
    if ([currentURL rangeOfString:@"/mobile01.html"].location||[currentURL rangeOfString:@"/IOSApphdOneForProduct.aspx"].location) {
        topNavi_zeroOne.hidden = YES;
        titleLb.text = @"返回首页";
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    }else{
        if ([currentURL rangeOfString:@"/IOSIndex123.htm"].location!=NSNotFound) {
            topNavi_zeroOne.hidden = NO;
        }else{
            topNavi_zeroOne.hidden = YES;
            titleLb.text = @"返回首页";
        }
        [webView goBack];
    }
}

//扫描
-(void)clickScan
{
    AnnouncementController *annouceV = [[AnnouncementController alloc] init];
    annouceV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:annouceV animated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp
{
    [self checkBindShop];    //检查所绑定的店铺
    isWebPageLoaded = YES;
    [activityIndicator stopAnimating]; // 结束旋转
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentShopInfo"];
}


//跳转商品详情
-(void)goProductDetailByGuid:(NSArray *)inputArray{
    if (inputArray.count > 1) {
        NSString *guid = [inputArray objectAtIndex:1];
        GoodsDetailController *woodsDettail = [[GoodsDetailController alloc] init];
        woodsDettail.danModleGuid = guid;
        woodsDettail.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:woodsDettail animated:YES];
    }
}

//提交店铺码
- (void)commitButtonClick:(NSArray *)inputArray
{
    [self showHudInView:self.view hint:@"提交中..."];
    NSString *sharenumber = [inputArray objectAtIndex:1];
    NSString *deviceCode = [Tools getDeviceUUid];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0143",@"apiid",sharenumber,@"sharenumber",deviceCode,@"deviceCode", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *result = [dic objectForKey:@"result"];
        if ([result compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [self getShopIDWith:sharenumber bindJson:respondStr];
        }
        NSLog(@"%@",respondStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showHint:@"绑定失败"];
    }];
    NSLog(@"%@",inputArray);
}


- (void)getShopIDWith:(NSString *)sharenumber bindJson:(NSString *)bindjson
{
    NSString *deviceCode = [Tools getDeviceUUid];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0144",@"apiid",deviceCode,@"deviceCode", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *shopid = [dic objectForKey:@"shopid"];
        if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil) {
            [self showHint:@"绑定出错"];
        }
        else{
            [self showHudInView:self.view hint:@"正在跳转到绑定店铺首页"];
            [Tools recordBindShopWithShareNumber:sharenumber shopid:shopid];
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"goBindShop('%@')",bindjson]];
            [self performSelector:@selector(changeRootVCWithShopID:) withObject:shopid afterDelay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
        NSLog(@"%@",error);
    }];
}



//跳转到店铺详细页
-(void)goWoodsDetail:(NSArray *) inputArray{
    if (inputArray.count>1) {
        [Waiting show];
        //        [self showHudInView:webView.scrollView hint:@"跳转中..."];
        NSString *guid = inputArray[1];
        NSDictionary * params = @{@"apiid": @"0128",@"productGuid":guid};
        
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            [self hideHud];
            [Waiting dismiss];//隐藏loading
            NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
            //            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            BOOL isDiscountCard;
            if ([[jsonData objectForKey:@"result"] isEqualToString:@"true"]) {
                isDiscountCard = YES;
            }else{
                isDiscountCard = NO;
            }
            //-------
            GoodsDetailController *woodsV = [[GoodsDetailController alloc] init];
            woodsV.danModleGuid = guid;
            woodsV.isDiscountCard = isDiscountCard;//------是否是打折卡------
            //--------图片banner图片-------
//            woodsV.shopImg = [shopInfoDic objectForKey:@"Mobilebanner"];
//            if (!woodsV.shopImg) {
//                woodsV.shopImg = [NSString stringWithFormat:@"%@/Member/%@/%@",IMAGESERVER,[shopInfoDic objectForKey:@"ShopId"],[shopInfoDic objectForKey:@"EntityImage"]];
//            }
            woodsV.hidesBottomBarWhenPushed = NO;
//            woodsV.modle = modle;
            
            [self.navigationController pushViewController:woodsV animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            [self hideHud];
            [Waiting dismiss];//隐藏loading
            [self showHint:REQUESTERRORTIP];
        }];
        [operation start];//-----发起请求------
        
        
        
    }
}

//截获js的调用
- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 说明协议头是ios
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([method isEqualToString:@"getShopDataByCity"]) {
            //加载更多店铺信息
            [self getShopDataByCity];
        }else if([method hasPrefix:@"onClickDanertuItem/"]){
            //跳转到平台  各种酒
            danertuWoodsSegmentNo = [[method stringByReplacingOccurrencesOfString:@"onClickDanertuItem/" withString:@""] intValue];
            [self onClickDanertuItem];
        }else if([method isEqualToString:@"goldCarrot"]){
            //金萝卜签到
            [self goOtherView:@"goldCarrot"];
        }else if([method isEqualToString:@"onClickClassify"]){
            //到分类页面
            self.tabBarController.selectedIndex = 1;
            [self setBarItemSelectedIndex:1];
        }else if([method isEqualToString:@"signIn"]){
            //签到
            [self goOtherView:@"signIn"];
        }else if([method isEqualToString:@"goBackIndex"]){
            //回到首页，春节买赠活动页面的一个点击点
            topNavi_zeroOne.hidden = YES;
            [webView goBack];
        }else if ([method hasPrefix:@"getByClassifWeb/"]){
            //吃住玩购
            NSString  *typeNo= [method stringByReplacingOccurrencesOfString:@"getByClassifWeb/" withString:@""];
            if ([typeNo isEqualToString:@"1"]) {
                //美食页
                GoodFoodController *goodFood = [[GoodFoodController alloc] init];
                goodFood.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodFood animated:YES];
            }else{
                NSArray *array = [method componentsSeparatedByString:@"/"];
                int type = 2;
                @try {
                    type = [[array objectAtIndex:1] intValue];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                styleStr = ZHUWANGOU;
                if (type == 3) {
                    styleStr = YANJIUCHA;
                }
//                [self getByClassifWeb:typeNo];   //zeroOneForProductCheck
                [self getGoodsShopListByClassifWeb:typeNo];
               
            }
        }else if ([method hasPrefix:@"orderSendMeal/"]){
            //----------定餐,送餐------
            NSString  *typeNo= [method stringByReplacingOccurrencesOfString:@"orderSendMeal/" withString:@""];
            styleStr = DINGSONGCAN;
            [self getByClassifWeb:typeNo];//zeroOneForProductCheck
            
        }else if ([method hasPrefix:@"springActivity/"]){
            //----------春节活动------
            NSString  *guid= [method stringByReplacingOccurrencesOfString:@"springActivity/" withString:@""];
            [self goWoodsDetail:guid pageId:@"woodsDetail" activityName:ACTIVITY_SPRING otherParam:@""];//zeroOneForProductCheck
        }else if ([method hasPrefix:@"zeroOneForProduct/"]){
            NSString  *mobile= [method stringByReplacingOccurrencesOfString:@"zeroOneForProduct/" withString:@""];
            NSLog(@"noreiioejgioeiojgero-----%@",mobile);
            topNavi_zeroOne.hidden = NO;//点了提交,隐藏这个返回
            NSString *imageUrl = [NSString stringWithFormat:@"%@/sysProduct/20140819143356515.jpg",IMAGESERVER];
            activityWoodInfo = @{@"activityName":ACTIVITY_ZEROONE,@"shopId":@"chunkang",@"shopName":@"单耳兔商城",@"count":@"1",@"name":@"晓镇香 5陈酿125ml",@"contactTel":@"4009952220",@"Guid":@"6ccaa7c9-d363-45bc-bcac-4f06debb5426",@"img":imageUrl,@"price":@"0.10",@"SupplierLoginID":@""};//------活动商品信息
            [defaults setObject:mobile forKey:@"activityMobile"];//参加活动手机号

            [self performSegueWithIdentifier:@"zeroOnePay" sender:self];
        }else if([method hasPrefix:@"OneYuanArea/&&/"]){
            //1元专区
            NSString  *params= [method stringByReplacingOccurrencesOfString:@"OneYuanArea/&&/" withString:@""];
            params = [params
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *paramsArr = [params componentsSeparatedByString:@"/&&/"];
            if (paramsArr.count >= 7) {
                
                [self goWoodsDetail:paramsArr[0] pageId:@"zeroOnePay" activityName:ACTIVITY_ONEYUAN otherParam:paramsArr[7]];//zeroOneForProductCheck
            }else{
                [self showHint:REQUESTERRORTIP];
            }
        }else if([method isEqualToString:@"GetSpecialData"]){
            [self getSpecialData];
        }else if([method hasPrefix:@"SpecialOfferArea/&&/"]){
            //------------特价区-------
            NSString  *params= [method stringByReplacingOccurrencesOfString:@"SpecialOfferArea/&&/" withString:@""];
            params = [params
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *paramsArr = [params componentsSeparatedByString:@"/&&/"];
            NSString *proName = [paramsArr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            activityWoodInfo = @{@"activityName":ACTIVITY_SPECIAL,@"shopId":paramsArr[3],@"shopName":@"单耳兔商城",@"Name":proName,@"contactTel":@"4009952220",@"Guid":paramsArr[0],@"SmallImage":paramsArr[2],@"AgentId":paramsArr[4],@"SupplierLoginID":paramsArr[5],@"ShopPrice":paramsArr[6]};
            //跳转
            [self performSegueWithIdentifier:@"woodsDetail" sender:self];
         
        }else if([method hasPrefix:@"goSecialShop/"]){
            //跳转到特殊店铺
            NSString *shopNameStr = [method stringByReplacingOccurrencesOfString:@"goSecialShop/" withString:@""];
            
            shopNameStr = [shopNameStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self goToSpecialShop:shopNameStr];
        }else if([method hasPrefix:@"goSecialWoodsList/"]){
            //跳转到特殊商品列表
            [defaults removeObjectForKey:@"currentShopInfo"];//---默认当前店铺
            NSString *woodsListStr = [method stringByReplacingOccurrencesOfString:@"goSecialWoodsList/" withString:@""];
        
            woodsListStr = [woodsListStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            goWoodsListKeyWord = woodsListStr;
            [self performSegueWithIdentifier:@"woodData" sender:self];
        }else if ([method hasPrefix:@"parameter_"]){
            NSInteger location = [method rangeOfString:@"/"].location;
            NSString *funcName = [method substringToIndex:location];
            SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcName]);
            NSArray *parameterArr = [[method substringFromIndex:location+1] componentsSeparatedByString:@"/"];
           
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func withObject:parameterArr];
#pragma clang diagnostic pop
            }
        }else if ([method hasPrefix:@"json_"]){
            NSInteger location = [method rangeOfString:@"/"].location;
            NSString *funcName = [method substringToIndex:location];
            SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcName]);
            NSString *jsonString = [method substringFromIndex:location+1];
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func withObject:jsonString];
#pragma clang diagnostic pop
            }
        }
        
        return NO;
    }else if([request.URL.absoluteString hasSuffix:@"IOSApphdOneForProduct.aspx"]||[request.URL.absoluteString hasSuffix:@"IOSspecialoffermobile.html"]||[request.URL.absoluteString rangeOfString:@"ios_webPage/mobile01.html"].location!=NSNotFound||[request.URL.absoluteString rangeOfString:@"IOSspecialoffermobile.htm"].location!=NSNotFound){
        //参加活动页面
        topNavi_zeroOne.hidden = NO;//跳转页面时显示这个
        //默认标题，"返回首页"
        UILabel *titleLb = (UILabel *)[topNavi_zeroOne viewWithTag:2000];
        titleLb.text = @"返回首页";
    }else if([request.URL.absoluteString rangeOfString:@"IOSspring.html"].location!=NSNotFound){
        //------春节特惠活动----页
        topNavi_zeroOne.hidden = NO;//点了提交,隐藏这个返回
        UILabel *titleLb = (UILabel *)[topNavi_zeroOne viewWithTag:2000];
        titleLb.text = @"喜迎新春送好礼";
    }else if ([request.URL.absoluteString hasSuffix:@"iosZeroOneForProduct.aspx"]){
        //-----0.1元购------
        //-----这里检测是否登录
        [defaults removeObjectForKey:@"currentShopInfo"];//---默认当前店铺
        //[self performSegueWithIdentifier:@"woods" sender:self];//调转到detail页
        if(![defaults objectForKey:@"userLoginInfo"]){
            [self performSegueWithIdentifier:@"login" sender:self];
            return NO;
            isToLoginForActivity = YES;
        }else{
            topNavi_zeroOne.hidden = NO;
            return YES;
        }
    }
    return YES;
}

//统一方法调用
-(void)parameter_iosFunc:(NSArray *) inputArray{
    NSInteger parameterCount = inputArray.count;
    if (parameterCount>0) {
        NSString *funcFlag = [inputArray firstObject];
        SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcFlag]);
        if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:func withObject:inputArray];
#pragma clang diagnostic pop
        }
    }
}

-(void)goShopDetail:(NSArray *)inputArray{
    if (inputArray.count > 1) {
        NSString *shopId = inputArray[1];
        DetailViewController *detailV = [[DetailViewController alloc] init];
        detailV.agentid = shopId;
        //-----跳转----
        detailV.hidesBottomBarWhenPushed = YES;
        
        //在切换界面的过程中禁止滑动手势，避免界面卡死
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
        [self.navigationController pushViewController:detailV animated:YES];
    }
}

//广告图,跳转特殊点铺----店铺关键词
-(void)goToSpecialShop:(NSString*)shopNameKeyWord{
    [self showHudInView:webView.scrollView hint:@"跳转中..."];
    NSDictionary * params = @{@"apiid": @"0044",@"kword":shopNameKeyWord};
    NSString *resultDataKeyPrefix = @"supplierprocuctList";
    NSString *resultDataKeyPrefix1 = @"supplierproductbean";
    
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [Waiting dismiss];
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
        NSMutableArray *temp = [[jsonData objectForKey:resultDataKeyPrefix] objectForKey:resultDataKeyPrefix1];
        
        if(temp.count > 0){
            specialShopModle = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:0]];
            isSpecialShop = YES;
            //保存到页面shopId
            NSString *storeId = [NSString stringWithFormat:@"localStorage.setItem('currentShopId',%@)",specialShopModle.id];
            [webView stringByEvaluatingJavaScriptFromString:storeId];
            
            [self performSegueWithIdentifier:@"shopDetail" sender:self];
        }else{
            [self showHint:@"数据读取错误"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }];
    [operation start];   //发起请求
}

//------跳转到商品详情页，醇康平台的商品---
-(void)goWoodsDetail:(NSString *)guid pageId:(NSString *)pageViewId activityName:(NSString*)name otherParam:(NSString *)clickValid{
    [self showHudInView:webView.scrollView hint:@"跳转中..."];
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0026&proId=%@imei=''&mac=''&deviceid=%@&shopid=%@",guid,[Tools getDeviceUUid],CHUNKANGSHOPID];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    if(!requestOperation.error){
        [self hideHud];
        NSString *temp = [[NSString alloc] initWithData:requestOperation.responseData encoding:NSUTF8StringEncoding];
        temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        NSData *jsonDataTmp = [temp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (jsonData) {
            NSArray *shopInfoArr = [jsonData objectForKey:@"val"] ;
            if (shopInfoArr.count>0) {
                [Waiting dismiss];
                NSDictionary *shopInfoDic = shopInfoArr[0];
                NSString *AgentId = [shopInfoDic objectForKey:@"AgentId"];
                NSString *SupplierLoginID = [shopInfoDic objectForKey:@"SupplierLoginID"];
                NSString *imgUrl = @"";
                if (AgentId.length>1) {
                    imgUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,AgentId,[shopInfoDic objectForKey:@"SmallImage"]];
                }else if (SupplierLoginID.length>1) {
                    AgentId = @"";
                    imgUrl = [NSString stringWithFormat:@"%@%@/%@",SUPPLIERPRODUCT,SupplierLoginID,[shopInfoDic objectForKey:@"SmallImage"]];
                }else{
                    SupplierLoginID = @"";
                    imgUrl = [NSString stringWithFormat:@"%@%@",DANERTUPRODUCT,[shopInfoDic objectForKey:@"SmallImage"]];
                }
                if ([name isEqualToString:ACTIVITY_SPRING]) {
                    //------春节买赠店铺-----
                    activityWoodInfo = @{@"activityName":name,@"shopId":CHUNKANGSHOPID,@"shopName":@"醇康",@"Name":[shopInfoDic objectForKey:@"Name"],@"contactTel":@"4009952220",@"Guid":guid,@"SmallImage":imgUrl,@"AgentId":AgentId,@"SupplierLoginID":SupplierLoginID,@"ShopPrice":[shopInfoDic objectForKey:@"ShopPrice" ],@"mobileProductDetail":[shopInfoDic objectForKey:@"Detail"]};
                }else{
                    //-------一元区--------
                    NSString *contactTel = [shopInfoDic objectForKey:@"contactTel"];
                    if (!contactTel) {
                        contactTel = @"4009952220";
                    }
                    //--------这数据字段与 ZeroOneController页面,OrderFormController保持一致
                    activityWoodInfo = @{@"clickIsValid":clickValid,@"activityName":name,@"shopId":CHUNKANGSHOPID,@"shopName":@"醇康",@"count":@"1",@"name":[shopInfoDic objectForKey:@"Name"],@"contactTel":contactTel,@"Guid":guid,@"img":imgUrl,@"agentId":AgentId,@"price":[shopInfoDic objectForKey:@"ShopPrice" ],@"SupplierLoginID":SupplierLoginID,@"mobileProductDetail":[shopInfoDic objectForKey:@"Detail"]};//------活动商品信息
                    
                }
                //------跳转------
                [self performSegueWithIdentifier:pageViewId sender:self];
            }else{
                [Waiting dismiss];
                [self showHint:REQUESTERRORTIP];
            }
        }else{
            [self hideHud];
            [Waiting dismiss];
            [self showHint:REQUESTERRORTIP];
//            [self.view makeToast:@"数据解析错误:0026" duration:1.2 position:@"center"];
        }
    }else{
        [Waiting dismiss];
    }
}

//住玩购,烟酒茶   classifyType: 0=订餐 ;1=送餐 ;5=烟酒茶 2=住玩购
- (void)getGoodsShopListByClassifWeb:(NSString *)type{
    distanceParameter = @"";
    classifyType = type;
    /*
     由于住玩购,烟酒茶是原生部分,订餐和送餐是web部分,
     所以将原生部分和web部分分开处理,
     方便后期叠代或功能更新
     */
    //住玩购 + 烟酒茶
    GoodsShopListController *goodsShopListVC= [[GoodsShopListController alloc] init];
    goodsShopListVC.classifyType = classifyType;
    goodsShopListVC.keyWord = @"";//分类搜索,关键词置空
    goodsShopListVC.coordinate = coordinate;
    goodsShopListVC.city = city;
    goodsShopListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsShopListVC animated:YES];
}

//网页版订餐,送餐
- (void)getByClassifWeb:(NSString *)typeNo{
    keyWord = @"";   //分类搜索,关键词置空
    distanceParameter = @"";
    classifyType = typeNo;
    
    [self goOtherView:@"ShopData"];
}

//-----跳转到金萝卜
-(void)goOtherView:(NSString *)viewId
{
    [self performSegueWithIdentifier:viewId sender:self];
}


- (void)turnPage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    [adsScrollView scrollRectToVisible:CGRectMake(MAINSCREEN_WIDTH * (page + 1), 0, MAINSCREEN_WIDTH, 460) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

//定时器 绑定的方法
- (void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (slideImages.count-1)? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

//内部使用,业务员版，仅限业务员版，使用了uuid
-(void)justForInner
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    Dao *dao = [Dao sharedDao];
    if (dao.reachbility) {
        if (userLoginInfo) {
            [Waiting show];
            //view区域
            popMapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, self.view.frame.size.height-47-addStatusBarHeight - 20 - 20)];
            popMapView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [[KGModal sharedInstance] showWithContentView:popMapView andAnimated:YES];
            popMapView.userInteractionEnabled = YES;
            CGFloat viewHeight = popMapView.frame.size.height;
            //地图初始化
            mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 260, viewHeight - 110)];
            [popMapView addSubview:mapView];
            mapView.showsUserLocation = YES;
            mapView.delegate = self;
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;//指定需要的精度级别
            locationManager.distanceFilter = 1000.0f;//设置距离筛选器
            [locationManager startUpdatingLocation];//启动位置管理器
            MKCoordinateSpan theSpan;
            //地图的范围 越小越精确
            theSpan.latitudeDelta = 0.01;
            theSpan.longitudeDelta = 0.01;
        
            MKCoordinateRegion theRegion;
            theRegion.center = [[locationManager location] coordinate];
            theRegion.span = theSpan;
            [mapView setRegion:theRegion];
            //posTipsLb
            posTipsLb = [[UILabel alloc]initWithFrame:CGRectMake(20, viewHeight - 110, 220, 35)];
            posTipsLb.font = [UIFont systemFontOfSize:12];
            posTipsLb.text = [NSString stringWithFormat:@"提示:  定位中....(尽可能使用wifi,加速定位,精确定位)"];
            posTipsLb.numberOfLines = 2;
            posTipsLb.backgroundColor = [UIColor clearColor];
            [popMapView addSubview:posTipsLb];//显示坐标
            
            currentPos = [[UILabel alloc]initWithFrame:CGRectMake(20, viewHeight-75, 220, 15)];
            currentPos.font = [UIFont systemFontOfSize:12];
            currentPos.backgroundColor = [UIColor clearColor];
            [popMapView addSubview:currentPos];//显示坐标
            
            //提交坐标
            sendPosBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, viewHeight-55, 220, 40)];
            [sendPosBtn.layer setMasksToBounds:YES];
            [sendPosBtn.layer setCornerRadius:10.0];//设置矩形四个圆角半径
            [sendPosBtn setTitle:@"提交坐标" forState:UIControlStateNormal];
            sendPosBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            sendPosBtn.backgroundColor = [UIColor orangeColor];
            sendPosBtn.enabled = NO;
            [sendPosBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [sendPosBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sendPosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [sendPosBtn addTarget:self action:@selector(sendCoordinate) forControlEvents:UIControlEventTouchUpInside];
            [popMapView addSubview:sendPosBtn];
            [Waiting dismiss];
        }else{
            [self showHint:@"请先登录"];
        }
    }else{
        [self showHint:REQUESTERRORTIP];
    }
}

//当前坐标
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location!=nil)
    {
        posTipsLb.text = [NSString stringWithFormat:@"提示:  位置偏差大时,滑动地图,移动位置或重新打开地图来重定位"];
        sendPosBtn.enabled = YES;//这时可以提交坐标
        [locationObj.pos setValue:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"lat"];
        [locationObj.pos setValue:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"lot"];
       
        currentPos.text = [NSString stringWithFormat:@"当前坐标:  %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
    }else{
        posTipsLb.text = [NSString stringWithFormat:@"提示:  定位中....(尽可能使用wifi,加速定位,精确定位)"];
    }
}


//发送坐标
-(void)sendCoordinate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[KGModal sharedInstance] hide];    //隐藏
    NSString *gpsStr = [NSString stringWithFormat:@"%@,%@",[locationObj.pos valueForKey:@"lot"],[locationObj.pos valueForKey:@"lat"]];
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    NSString *memberId = @"";
    if (userLoginInfo) {
        memberId = [userLoginInfo objectForKey:@"MemLoginID"];//登录手机号
        NSDictionary * params = @{@"apiid": @"0020",@"gps" :gpsStr,@"memberId":memberId ,@"dm": [[UIDevice currentDevice] uniqueDeviceIdentifier]};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [self showHint:@"当前位置信息已发送!"];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [self showHint:REQUESTERRORTIP];
        }];
        [operation start];   //发起请求
    }
}

//菜单分类
//到活动的webview现在是吼分游戏
-(void)gotoWeb{
    [self goMyView];//到---"我的页面"----去操作
}

- (NSString *)getUrlWithArray:(NSArray *)inputArray
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:0];
    int startIndex = 0;
    //寻找网址url的位置
    for (int i = 0; i < [inputArray count]; i++) {
        NSString *str =[inputArray objectAtIndex:i];
        if ([str hasPrefix:@"http"]) {
            startIndex = i;
            break;
        }
    }
    //重新组合url
    for (int i = startIndex; i < [inputArray count]; i++) {
        NSString *str =[inputArray objectAtIndex:i];
        if ([str isEqualToString:@""]) {
            str = @"/";
        }
        else if( i != startIndex){
            str = [NSString stringWithFormat:@"/%@",str];
        }
        
        [mutableString appendString:str];
    }
    return [NSString stringWithFormat:@"%@",mutableString];
}

//跳到原生界面的公共方法
- (void)jumpToPageWithParams:(NSString *)paramString
{
    NSDictionary *paramsDict = [paramString objectFromJSONString];
    if (paramsDict == nil) {
        paramString = [paramString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramsDict = [paramString objectFromJSONString];
    }
    NSString *viewControllerName = [paramsDict objectForKey:@"viewName"];
    
}

- (void)json_gotoClassController:(NSString *)paramString
{
    NSDictionary *paramsDict = [paramString objectFromJSONString];
    if (paramsDict == nil) {
        paramString = [paramString
                       stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramsDict = [paramString objectFromJSONString];
    }
    NSString *shopID = [paramsDict objectForKey:@"shopID"];
    
    ClassifyViewController *classVC = [[ClassifyViewController alloc] init];
    classVC.shopID = shopID;
    classVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classVC animated:YES];
}

//跳到页面的公共方法
- (void)json_gotoNewController:(NSString *)jsonString
{
    NSDictionary *paramsDict = [jsonString objectFromJSONString];
    if (paramsDict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramsDict = [jsonString objectFromJSONString];
    }
    NSString *pagename = [paramsDict objectForKey:@"pagename"];
    NSString *webTypeStr = [paramsDict objectForKey:@"webType"];
    NSString *webTitleStr = [paramsDict objectForKey:@"webTitle"];
    NSString *narBarOffsetYStr = [paramsDict objectForKey:@"narBarOffsetY"];
    NSString *guid = [paramsDict objectForKey:@"guid"];
    NSString *shopid = [paramsDict objectForKey:@"shopid"];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.webURL = pagename;
    webVC.agentid = shopid;
    webVC.webType =  webTypeStr;
    webVC.webTitle = webTitleStr;
    webVC.narBarOffsetY = [narBarOffsetYStr integerValue];
    webVC.infoGuid = guid;
    webVC.jsJsonString = jsonString;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

//公共的网络请求方法
- (void)json_getAgentProduct:(NSString *)jsonString
{
    NSLog(@"%@",jsonString);
    NSDictionary *dict = [jsonString objectFromJSONString];
    if (dict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dict = [jsonString objectFromJSONString];
    }
    [Waiting show];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        NSDictionary *resultDict = [respondString objectFromJSONString];
        NSString *result = [resultDict objectForKey:@"result"];
        
        if ([result isEqualToString:@"false"] || [respondString isEqualToString:@"false"]) {
            [self showHint:@"服务器出错"];
            return;
        }
        if (([respondString compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame) || ([result compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
            NSString *apiid = [dict objectForKey:@"apiid"];
            
            NSString *succeedTips = [dict objectForKey:@"succeedTips"];
            if (succeedTips) {
                [self showHint:succeedTips];
            }
            else{
                if ([apiid isEqualToString:@"0246"]) {
                    [self showHint:@"发布成功"];
                }
                else if ([apiid isEqualToString:@"0249"]){
                    [self showHint:@"修改成功"];
                }
                else if ([apiid isEqualToString:@"0250"]){
                    [self showHint:@"删除成功"];
                }
            }
            
            NSString *callBackMethod = [dict objectForKey:@"callBackMethod"];
            NSString *jsFunc = [NSString stringWithFormat:@"%@('%@')",callBackMethod,respondString];
            [webView stringByEvaluatingJavaScriptFromString:jsFunc];
        }
        else{
            NSString *callBackMethod = [dict objectForKey:@"callBackMethod"];
            NSString *jsFunc = [NSString stringWithFormat:@"%@('%@')",callBackMethod,respondString];
            [webView stringByEvaluatingJavaScriptFromString:jsFunc];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }];
}


-(void)goNewControllerPage:(NSArray *)inputArray{
    
    if (inputArray.count > 3) {
        WebViewController *webViewController = [[WebViewController alloc] init];
        @try {
            webViewController.webURL = inputArray[1];
            webViewController.webType = inputArray[2];
            webViewController.webTitle = inputArray[3];
            webViewController.narBarOffsetY = [inputArray[4] floatValue] + 6;
            if ([inputArray count] > 7) {
                NSString *url = @"";
                NSString *agentid = inputArray[5];
                webViewController.agentid = agentid;
                url = [self getUrlWithArray:inputArray];
                url = [NSString stringWithFormat:@"%@%@&platform=ios",url,agentid];
                webViewController.webURL = url;
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            if (webViewController.agentid == nil) {
                //默认的agentid的值
                webViewController.agentid = CHUNKANGSHOPID;
            }
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

//获取特价区商品数据
-(void)getSpecialData{
    NSDictionary *params = @{@"apiid": @"0090"};
    NSURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                     path:@""
                                               parameters:params];
    AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *jsFunction = [NSString stringWithFormat:@"javaLoadTeJiaQu('%@')",data];
        [webView stringByEvaluatingJavaScriptFromString:jsFunction];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        isShowingActivity = NO;
        [self showHint:REQUESTERRORTIP];
        
    }];
    [operation start];
}

//跳转到  单耳兔商品
-(void)onClickDanertuItem{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentShopInfo"];   //---默认当前店铺
    if(![defaults objectForKey:@"userLoginInfo"]){
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"danertuWoods" sender:self];
    }
}

//我的页面去执行
-(void)goMyView{
    self.tabBarController.selectedIndex = MYINDEX;
}

//修改badge
-(void) setBadgeValue:(NSNotification*) notification{
    NSString *shopCatWoodsCount = [[notification userInfo] objectForKey:SHOPCATWOODSCOUNT];
    [[[[[self tabBarController] viewControllers] objectAtIndex: 1] tabBarItem] setBadgeValue:shopCatWoodsCount];
}

//吃住玩购
-(void) getDataByClassify:(id)sender{
    NSInteger typeNo = [[sender view] tag];
    if (typeNo < 6) {
        keyWord = @"";   //分类搜索,关键词置空
        distanceParameter = @"";
        classifyType = [NSString stringWithFormat:@"%ld",typeNo];
        [self goOtherView:@"ShopData"];
    }
    else if(typeNo == 6 || typeNo == 7) {
        [self goMyView];   //到"我的页面"去操作
    }
    else {
        [self showHint:@"暂未开通"];
    }
}

//跳转到搜索
-(void) toSearchView
{
    [self performSegueWithIdentifier:@"searchView" sender:self];
}

//---弹到第一页
-(void) popToRootView{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];//弹到第一页
}

//---程序重新 成为active状态后,  重新获取城市
-(void) reLocateByGPS{
    isToGetShopByCity = NO;
    coordinate = [NSString stringWithFormat:@"%@,%@",[locationObj.pos valueForKey:@"lat"],[locationObj.pos valueForKey:@"lot"]];//获取  坐标
    [self getCityByGPS];//重新获取城市
}

//重新加载数据
-(void)refreshHttp
{
    Dao *shareDao = [Dao sharedDao];
    if (shareDao.reachbility) {
        keyWord = @"";   //关键字
        distanceParameter = @"";   //距离范围参数
        classifyType = @"";   //分类
        //恢复初始化状态,这里不要初始化,刷新时可能弹出是否切换城市,点击了取消就不能初始化,初始化放在获取城市后的函数里didFinshRequestCitys
        //[self initHttpParameters];
        isClickedRefresh = YES;//点击了刷新
        self.isEnterBakcground = YES;
        [locationObj.locationmanager startUpdatingLocation];//重新获取城市
    }
    else{
        [self showHint:REQUESTERRORTIP];
    }
}

//myTimer调用函数
-(void)timerFired:(NSTimer *)timer{
    self.timerValue++;//计时器
    //根据地理位置 取得城市信息,成功取得城市信息后  读取商铺列表
    if([[locationObj.pos valueForKey:@"lat"] length]>0&&[[locationObj.cityFromPos valueForKey:@"cName"] length]>0){
        coordinate = [NSString stringWithFormat:@"%@,%@",[locationObj.pos valueForKey:@"lat"],[locationObj.pos valueForKey:@"lot"]];//获取  坐标
        [self getCityByGPS];
        if (isFirstToPostInner) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [self justForInner];//-------业务员发送坐标
            });
            isFirstToPostInner = NO;
        }
        
        [timer invalidate];//销毁timer
    }else if(self.timerValue > 1000){
        //gps定位失败,以中山作为  默认地址
        [Waiting dismiss];
        isShowingActivity = NO;
        [self showHint:@"GPS 定位失败!"];
        [self getShopDataByCity];//
        [timer invalidate];//销毁timer
    }
}

//------回到顶部-----
- (void)pageTop{
    CGPoint newOffset = gridView.contentOffset;
    newOffset.y = -40;
    [gridView setContentOffset:newOffset animated:YES];//利用y < -30来判断
}

// webview-----delegate------
- (void)scrollViewDidScroll:(UIScrollView *)scrollViewTmp
{
    if (scrollViewTmp.contentOffset.y < -100 && topNavi_zeroOne.hidden) {
        //加载首页
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    }
}

/*恢复初始化状态
 *数据页数  置1
 *是否更多数据,是否有数据,是否网络正常,都  置 YES
 *arrays  清空,这样会把页面数据消掉
 */
-(void)initHttpParameters{
    self.p = @"1";//如果更换了城市就把page页数变成1
    self.isHaveMore = YES;//是否有更多数据可以加载
    self.isHaveData = YES;//是否有数据
    self.isNetWorkRight = YES;//网络状态是否正常
    [arrays removeAllObjects];//移除所有元素
}

//根据gps  获取当前城市
-(void)getCityByGPS{
    preCoordinate = coordinate;
    if (isToGetShopByCity) {
        city = [locationObj.cityFromPos copy];
        [self initHttpParameters];//初始化
        [self getShopDataByCity];
    }else{
        if ([[locationObj.cityFromPos objectForKey:@"cName"] length]>0&&![[locationObj.cityFromPos objectForKey:@"cName"] isEqualToString:[city objectForKey:@"cName"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"系统定位您在 %@,是否切换?",[locationObj.cityFromPos objectForKey:@"cName"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"切换"];
            [alert setTag:1];
            [alert show];
        }else{
            coordinate = preCoordinate ;
            city = [locationObj.cityFromPos copy];
            /*
             点击了刷新按钮,就会重新获取坐标,城市,商品数据,即使和当前城市一致也要重新加载,可以矫正当前的错误坐标.
             (第一次无法获取坐标时使用的默认坐标)
             */
            if (isClickedRefresh) {
                [self initHttpParameters];//初始化,这样会抹掉原有数据的,如果是程序从后天进入前台的话不能抹掉,
                [self getShopDataByCity];
                isClickedRefresh = NO;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] ==1 ) {
        if (buttonIndex==1){
            city = [locationObj.cityFromPos copy];
            [self initHttpParameters];//初始化,,相关参数,清空现有数据
            firstLoadDataStr = @"";
            [self getShopDataByCity];//城市的 id 做参数,,读取选中城市的数据
            [webView reload];//重新加载页面
        }
    }
}

//点击选择城市
-(void)rightButton{
    [self performSegueWithIdentifier:@"city" sender:self];//点击城市,进入城市列表页面
}

//获取当前城市   店铺数据, 修改标题城市名称 执行--------
-(void)getShopDataByCity
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([city objectForKey:@"cName"]<=0) {
        [defaults setObject:@"中山市" forKey:@"currentCityName"];
        city = @{@"cId":@"",@"cName":@"中山市",@"province":@"广东省"};
    }
    cityLb.text = [city objectForKey:@"cName"];//修改当前城市
    if (self.isHaveMore) {
        /*
         if(!isShowingActivity){
         [Waiting show];
         }*/
        isPreRequestFinished = NO;//-----请求是否完成------
        NSDictionary * params = @{@"apiid": @"0098",@"shoptype" :@"",@"juli":@"0",@"gps": coordinate,@"pageSize": @"30",@"pageIndex": self.p,@"searchtype":@"",@"keyword":@"",@"areaname":[city objectForKey:@"cName"]};
        
        //------切换成不是当前定位的城市,params参数发生变化------
        if ([[locationObj.cityFromPos objectForKey:@"cName"] length] > 0 && ![[city objectForKey:@"cName"] isEqualToString:[locationObj.cityFromPos objectForKey:@"cName"]]) {
            
            params = @{@"apiid": @"0098",@"shoptype" :@"",@"juli":@"0",@"gps": coordinate,@"pageSize": @"30",@"pageIndex": self.p,@"searchtype":@"",@"keyword":@"",@"areaname":[city objectForKey:@"cName"]};
        }
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            isShowingActivity = NO;
            self.isNetWorkRight = YES;
            NSString* data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //这里调用js的方法,传递   数据
            if([self.p isEqualToString:@"1"]){
                //if (isWebPageLoaded) {
                NSString *jsFunction = [NSString stringWithFormat:@"get4Android('%@')",data];
                [webView stringByEvaluatingJavaScriptFromString:jsFunction];
                firstLoadDataStr = data;
               
            }else{
                NSString *jsFunction = [NSString stringWithFormat:@"get4Android('%@')",data];
                [webView stringByEvaluatingJavaScriptFromString:jsFunction];
            }
            DataModle *model = nil;//对象数据模型
            NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
            NSArray *temp = [[jsonData objectForKey:@"shoplist"] objectForKey:@"shopbean"];
            //NSMutableArray *temp = [jsonData objectForKey:@"val"];//多个item数组
            //多个item数组
            
            if(temp.count > 0){
                self.isHaveData = YES;
                self.p = [NSString stringWithFormat:@"%d",[self.p intValue]+1];//得到数据之后,页数才加
                for(int i = 0; i < temp.count; i++){
                    //[model setM:[[temp objectAtIndex:i] objectForKey:@"m"]];
                    model = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                    //[model setE:[[temp objectAtIndex:i] objectForKey:@"e"]];//这里单独设置,图片路径的拼接,http://www.danertu.com + temp objectAtIndex:i
                    [arrays addObject:model];//追加到数组
                }
            }else{
                self.isHaveMore = NO;//没有更多数据
            }
            //[gridView reloadData];//这里没有数据也用执行,因为不执行,就一直显示之前的数据,切换城市时出错
            //如果返回false,可以提交数据
            isPreRequestFinished = YES;//完成一次请求
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
            isPreRequestFinished = YES;//完成一次请求
            isShowingActivity = NO;
            //前一状态的 isNetWorkRight=YES,否则不再执
            if(self.isNetWorkRight){
                self.isNetWorkRight = NO;
            }
            NSString *jsFunction = [NSString stringWithFormat:@"get4Android('')"];
            [webView stringByEvaluatingJavaScriptFromString:jsFunction];
            //[self.view makeToast:@"" duration:1.2 position:@"center"];
            
        }];
        [operation start];//发起请求
    }
}

//-跳转到  城市选择或  detail页
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"city"]){
        CityController *cityController = [segue destinationViewController];
        cityController.hidesBottomBarWhenPushed = YES;
        cityController.delegate = self;
        cityController.city = city;//点击城市按钮进入城市选中列表  ,赋值,当前城市
    }
    else if([segue.identifier isEqualToString:@"ShopData"]){
        
        ShopDataController *shopController = [segue destinationViewController];
        shopController.classifyType = classifyType;
        shopController.city = city;//
        shopController.keyWord = keyWord;
        shopController.distanceParameter = distanceParameter;
        shopController.coordinate = coordinate;
        shopController.hidesBottomBarWhenPushed = YES;
    }
    else if ([segue.identifier isEqualToString:@"zeroOnePay"]){
        ZeroOneController *zero = [segue destinationViewController];
        zero.hidesBottomBarWhenPushed = YES;
        zero.woodInfo = activityWoodInfo;
    }
    else if ([segue.identifier isEqualToString:@"woodsDetail"]){
        GoodsDetailController *woodsController = [segue destinationViewController];
        //-----活动名称
        woodsController.activityWoodName = [activityWoodInfo objectForKey:@"activityName"];
        DanModle *danModle = [[DanModle alloc] initWithDataDic:activityWoodInfo];
        woodsController.danModleGuid = danModle.Guid;
        DataModle *modle = [[DataModle alloc] init];
        modle.s = [activityWoodInfo objectForKey:@"shopName"];
        modle.id = [activityWoodInfo objectForKey:@"shopId"];
        modle.m = [activityWoodInfo objectForKey:@"contactTel"];
        woodsController.hidesBottomBarWhenPushed = NO;
        woodsController.modle = modle;
    }
    else if ([segue.identifier isEqualToString:@"woodData"]){
        WoodDataController *woodController = [segue destinationViewController];
        woodController.hidesBottomBarWhenPushed = YES;
        woodController.searchKeyWord = goWoodsListKeyWord;
    }
    else if ([segue.identifier isEqualToString:@"danertuWoods"]){
        DanertuWoodsController *danController = [segue destinationViewController];
        danController.currentSegmentNo = danertuWoodsSegmentNo;
    }
    else if ([segue.identifier isEqualToString:@"searchView"]){
        SearchViewController *searchView = [segue destinationViewController];
        searchView.hidesBottomBarWhenPushed = YES;
    }
    
}

/*
 城市更换,----代理方法
 self.p----页数至1
 self.isHaveMore--至 YES
 arrays----清空数据
 */
-(void)CityController:(CityController *)controller didSelectCity:(NSDictionary *)cityDic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[cityDic objectForKey:@"cName"] forKey:@"currentCityName"];
    if(![[city objectForKey:@"cName"] isEqualToString:[cityDic objectForKey:@"cName"]]){
        [self initHttpParameters];//回复初始化状态
        [gridView reloadData];//加载一下,上一个城市的数据就不再显示
        city = [cityDic mutableCopy];
        cityLb.text = [city objectForKey:@"cName"];
        self.p = @"1";//---同一个城市,并且当前城市没有读出数据,这里做初始加载
        firstLoadDataStr = @"";
        [self getShopDataByCity];//城市的 id 做参数,,读取选中城市的数据
        [webView reload];//重新加载页面
    }else if (arrays.count==0){
        city = [cityDic mutableCopy];
        cityLb.text = [city objectForKey:@"cName"];
        self.p = @"1";//---同一个城市,并且当前城市没有读出数据,这里做初始加载
        [self getShopDataByCity];//城市的 id 做参数,,读取选中城市的数据
        [webView reload];//重新加载页面
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-----代理方法,点击城市列表选择城市之后执行改方法------
-(NSDictionary *)getGpsCity{
    return city;
}

- (void)showBindShopTip
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (userName == nil || [userName isEqualToString:@""]) {
        userName = @"";
    }
    NSString *specialKey = @"specialUserKey";
    NSDictionary *dict = [defaults objectForKey:specialKey];
    NSString *specialShopID = [dict objectForKey:@"shopid"];
    if (specialShopID == nil || [specialShopID isEqualToString:@""]) {
        [webView stringByEvaluatingJavaScriptFromString:@"showMyTips('yes')"];
    }
    else{
        [webView stringByEvaluatingJavaScriptFromString:@"showMyTips('no')"];
    }
}

//检测是否绑定店铺，绑定店铺的话直接跳转到店铺
-(void)checkBindShop
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceCode = [Tools getDeviceUUid];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0144",@"apiid",deviceCode,@"deviceCode", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *shopid = [dic objectForKey:@"shopid"];
        NSString *sharenumber = [dic objectForKey:@"sharenumber"];
        if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
            sharenumber = @"";
        }
        if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil || [shopid isEqualToString:@""]) {
            //如果服务器没有当前这台设备的绑定店铺，就校正清空
            NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
            if (userName == nil || [userName isEqualToString:@""]) {
                userName = @"";
            }
            NSString *specialKey = @"specialUserKey";
            [defaults removeObjectForKey:specialKey];
            [self showBindShopTip];
        }
        else{
            //如果有，还要判断本地是否有，
            NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
            if (userName == nil || [userName isEqualToString:@""]) {
                userName = @"";
            }
            NSString *specialKey = @"specialUserKey";
            NSDictionary *dict = [defaults objectForKey:specialKey];
            NSString *specialShopID = [dict objectForKey:@"shopid"];
            if (specialShopID == nil || [specialShopID isEqualToString:@""]) {
                //本地没有记录，跳到店铺详情
                [self changeRootVCWithShopID:shopid];
            }
            //最后需要把记录更新到本地
            [Tools recordBindShopWithShareNumber:sharenumber shopid:shopid];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

-(void)closeTimer{
    timerNum++;
    if (timerNum == 6) {
        [myTimer invalidate];
        [Waiting dismiss];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reLocateByGPS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popToRootView" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popToRootDetailView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setBadgeValue" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showViewTabbarIndex" object:nil];
}

@end
