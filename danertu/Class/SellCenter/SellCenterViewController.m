//
//  SellCenterViewController.m
//  单耳兔
//
//  Created by yang on 15/6/30.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//
//卖家中心

#import "SellCenterViewController.h"
#import "LoginViewController.h"
#import "WineActiveInfoViewController.h"
#import "WebViewController.h"
#import "SellOrderManageViewController.h"
#import "SellWoodsManageViewController.h"
#import "SellShopManageViewController.h"
#import "SellSettingViewController.h"
#import "Waiting.h"
#import "AsynImageView.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import "HeModifySellerVC.h"

#define MinLocationSucceedNum 1   //要求最少成功定位的次数

@interface SellCenterViewController ()<BMKLocationServiceDelegate>
{
    int addStatusBarHeight;
    AsynImageView *headImageView;
    UILabel *shopNameLable;
    NSMutableDictionary *myShopDic;
    UIImageView *shareBG;
    CGFloat distanceOffset; //分享界面移动的偏移值
    UIView *dismissShareBG;
    NSArray *sellArr;
    UIScrollView *scrollView;
    BMKLocationService *_locService;
    BOOL isShowSetting;
    BOOL isShowStat;
}

@property (nonatomic,strong)NSString *shareNumber;
@property (nonatomic,assign)NSInteger locationSucceedNum; //定位成功的次数
@property (nonatomic,strong)NSMutableDictionary *userLocationDict;
@property (nonatomic,strong)NSMutableArray *shareImageArray;
@property (nonatomic,assign)BOOL haveLoadShareImage;

@end

@implementation SellCenterViewController
@synthesize myShopDataInfo;
@synthesize locationSucceedNum;
@synthesize userLocationDict;
@synthesize shareImageArray;
@synthesize haveLoadShareImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self getShopNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_locService stopUserLocationService];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
     
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadShareImage];
}

-(NSString*)getTitle
{
    return @"卖家中心";
}

-(void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadShareImage
{
    if (!self.haveLoadShareImage) {
        self.haveLoadShareImage = YES;
        NSArray *array = @[@"shareSpringIcon",@"shareWineIcon",@"shareShopIcon"];
        for (int i = 0; i < [shareImageArray count];i++) {
            @try {
                AsynImageView *image = [shareImageArray objectAtIndex:i];
                NSString *imagename = [array objectAtIndex:i];
                NSString *preurl = [NSString stringWithFormat:@"%@/pptImage/",IMAGESERVER];
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@.png",preurl,imagename];
                image.imageURL = imageUrl;
                
                image.layer.borderWidth = 0;
                image.layer.backgroundColor = [UIColor clearColor].CGColor;
                image.layer.borderColor = [UIColor clearColor].CGColor;
                image.layer.masksToBounds = YES;
                image.contentMode = UIViewContentModeScaleAspectFill;
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
    }
}

-(void)initView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyShopDetailSucceed:) name:@"modifyShopDetailSucceed" object:nil];
    
    self.haveLoadShareImage = NO;
    shareImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:5.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    
    userLocationDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    locationSucceedNum = 0;
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight] + TOPNAVIHEIGHT;
    
    UIButton *shopDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-75, addStatusBarHeight+5-TOPNAVIHEIGHT, 80,34)];
    [self.view addSubview:shopDetailBtn];
    shopDetailBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [shopDetailBtn setTitle:@"进入店铺" forState:UIControlStateNormal];
    [shopDetailBtn addTarget:self action:@selector(goToShopDetailTap) forControlEvents:UIControlEventTouchUpInside];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - addStatusBarHeight)];//上半部分
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, 100 + MAINSCREEN_WIDTH - 30 + 70);
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
  
    myShopDic = [[NSMutableDictionary alloc] init];
    [myShopDic setObject:[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] forKey:@"shopDataKey"];
    
    //资料信息

    UIImage *giveWineImage = [UIImage imageNamed:@"sellcenter_giveWine.jpg"];
    UIImageView *giveWineImageView = [[UIImageView alloc] initWithImage:giveWineImage];
    giveWineImageView.userInteractionEnabled = YES;
    CGFloat giveWineImageW = MAINSCREEN_WIDTH;
    CGFloat giveWineImageH = 0;
    @try {
        giveWineImageH = giveWineImageW * (giveWineImage.size.height / giveWineImage.size.width );
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    giveWineImageView.frame = CGRectMake(0, 0, giveWineImageW, giveWineImageH);
    UITapGestureRecognizer *giveWineTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giveWine:)];
    giveWineTap.numberOfTapsRequired = 1;
    giveWineTap.numberOfTouchesRequired = 1;
    [giveWineImageView addGestureRecognizer:giveWineTap];
    
    UIView *sellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 90 + giveWineImageH)];
    [scrollView addSubview:sellBackgroundView];
    [sellBackgroundView setBackgroundColor:[UIColor whiteColor]];
    
    sellBackgroundView.userInteractionEnabled = YES;
    [sellBackgroundView addSubview:giveWineImageView];
    
    //左侧点击区域
    UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 10 + giveWineImageH, 70, 70)];
    [sellBackgroundView addSubview:leftBgView];
    
    //暂时不可设置
//    UITapGestureRecognizer *changeHeadImageTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToChangeHeadImage)];
//    [leftBgView addGestureRecognizer:changeHeadImageTap];
    
    //头像
    headImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [leftBgView addSubview:headImageView];
    headImageView.layer.borderWidth = 3.0;
    UIColor *borderColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.1];
    headImageView.layer.borderColor = [borderColor CGColor];
    headImageView.layer.cornerRadius = 70 / 2.0;
    headImageView.layer.masksToBounds = YES;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],[[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"]];
    if ([[[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"] isEqualToString:@""]) {
        imageUrl = @"";
        headImageView.placeholderImage = [UIImage imageNamed:@"shop_sell_default"];
    }else{
        //已存在商品图片
        headImageView.placeholderImage = [UIImage imageNamed:@"noData2"];
        headImageView.imageURL         = imageUrl;
    }
    //如果存在本地图片,从本地加载
//    [self resetHeadImageView];
    
    //店铺名称
    shopNameLable = [[UILabel alloc] initWithFrame:CGRectMake(95, 30-10 + giveWineImageH, 110, 30+20)];
    [sellBackgroundView addSubview:shopNameLable];
    [shopNameLable setFont:TEXTFONT];
    shopNameLable.numberOfLines = 2;
    shopNameLable.text = [[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"ShopName"];
    
    //右侧点击区域
    UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 90,  giveWineImageH, 80, 90)];
    [sellBackgroundView addSubview:rightBgView];
    UITapGestureRecognizer *shopDetailTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingClick)];
    [rightBgView addGestureRecognizer:shopDetailTap];
    
    //查看卖家
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 35, 50, 20)];
    [rightBgView addSubview:tipLabel];
    [tipLabel setText:@"编辑"];
    [tipLabel setTextAlignment:NSTextAlignmentRight];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    [tipLabel setTextColor:[UIColor grayColor]];
    [tipLabel setFont:TEXTFONTSMALL];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 41, 10, 10)];
    [rightBgView addSubview:tipImageView];
    [tipImageView setImage:[UIImage imageNamed:@"icon_sell_jiantou"]];
    
    //判断是否显示"送酒分成设置",总代时显示,不是总代时不显示
    isShowStat = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"Rank"] intValue] == 0 ? YES : NO;
    BOOL isVip = [[[NSUserDefaults standardUserDefaults] valueForKey:@"IsVipUser"] boolValue];
    
    if (isShowStat) {
        //开启"送酒分成设置"功能
        //功能信息
        if (isShowSetting) {
            if (isVip) {
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒分成设置",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"泉眼产品销售统计",@"店铺动态",@"代理产品",@"供求管理",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_set",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"ico_HS_sta",@"icon_shopDynamic",@"icon_agentProduct",@"icon_gongqiu"];
            }else{
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒分成设置",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"泉眼产品销售统计",@"店铺动态",@"代理产品",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_set",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"ico_HS_sta",@"icon_shopDynamic",@"icon_agentProduct"];
            }
        }else{
            if (isVip) {
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒分成设置",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"店铺动态",@"代理产品",@"供求管理",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_set",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"icon_shopDynamic",@"icon_agentProduct",@"icon_gongqiu"];
            }else{
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒分成设置",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"店铺动态",@"代理产品",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_set",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"icon_shopDynamic",@"icon_agentProduct"];
            }
        }
    }else{
        if (isShowSetting) {
            if (isVip) {
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"泉眼产品销售统计",@"店铺动态",@"代理产品",@"供求管理",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"ico_HS_sta",@"icon_shopDynamic",@"icon_agentProduct",@"icon_gongqiu"];
            }else{
                sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"泉眼产品销售统计",@"店铺动态",@"代理产品",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"ico_HS_sta",@"icon_shopDynamic",@"icon_agentProduct"];
            }
        }else{
            if (isVip) {
                 sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"店铺动态",@"代理产品",@"供求管理",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"icon_shopDynamic",@"icon_agentProduct",@"icon_gongqiu"];
            }else{
                 sellArr = @[@"订单管理",@"商品管理",@"店铺管理",@"送酒活动统计",@"送酒活动审核",@"提交店铺坐标",@"店铺动态",@"代理产品",@"ico_order",@"ico_pro",@"ico_distribution",@"ico_wine_sta",@"ico_wine_appr",@"sell_location",@"icon_shopDynamic",@"icon_agentProduct"];
            }
        }
    }
    
    int itemCount = (int)sellArr.count / 2;
    int itemWidth = MAINSCREEN_WIDTH / 3;
    int itemHeight = MAINSCREEN_WIDTH / 3 -10;
    for (int i = 0; i < itemCount; i++) {
        int lineNum = i / 3; //每行三个
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*(i%3),itemHeight*lineNum+100 + giveWineImageH, itemWidth, itemHeight)];
        [scrollView addSubview:itemView];
        
        //tag值校正
        //当店铺是总代时,rank = 0;不是总代时,"送酒分成设置"之后的功能tag需+1,
        if (!isShowStat && i > 2) {
            itemView.tag = 101 + i;
            if (!isShowSetting && i > 5) {
                itemView.tag = 101 + 1 +i;
            }
        }else{
            itemView.tag = 100 + i;
            if (!isShowSetting && i > 6) {
                itemView.tag = 100 + 1 +i;
            }
        }
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSellItemDetail:)];
        [itemView addGestureRecognizer:singleTap];
        
        //图片
        UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(23, 15, 60, 60)];
        [itemView addSubview:itemImage];
        [itemImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[sellArr objectAtIndex:i+itemCount]]]];
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 106, 25)];
        [itemView addSubview:itemLabel];
        [itemLabel setText:[NSString stringWithFormat:@"%@",[sellArr objectAtIndex:i]]];
        [itemLabel setFont:TEXTFONTSMALL];
        [itemLabel setBackgroundColor:[UIColor clearColor]];
        [itemLabel setTextColor:[UIColor grayColor]];
        [itemLabel setTextAlignment:NSTextAlignmentCenter];
    }
    //纠正contentSize的大小
    if (itemCount%3 > 0) {
        scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, sellBackgroundView.frame.size.height + itemHeight*(itemCount/3 + 2) - 20);
    }else{
        scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, sellBackgroundView.frame.size.height + itemHeight*(itemCount/3 + 1) - 20);
    }
    
    CGFloat statusBarHeight = 20;
    dismissShareBG = [[UIView alloc] init];
    dismissShareBG.frame = self.view.frame;
    if (!iOS7) {
        CGRect frame = dismissShareBG.frame;
        frame.origin.y = frame.origin.y - statusBarHeight;
        dismissShareBG.frame = frame;
    }
    dismissShareBG.backgroundColor = [UIColor blackColor];
    dismissShareBG.alpha = 0.7;
    [self.view addSubview:dismissShareBG];
    dismissShareBG.hidden = YES;
    
    UITapGestureRecognizer *disGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    disGes.numberOfTapsRequired = 1;
    disGes.numberOfTouchesRequired = 1;
    [dismissShareBG addGestureRecognizer:disGes];
    
    //分享的部分
    UIImage *shareImage = [UIImage imageNamed:@"shareBG"];
    CGFloat imageW = SCREENWIDTH;
    CGFloat imageH = imageW * shareImage.size.height / shareImage.size.width;
    CGFloat imageX = 0;
    
    shareBG = [[UIImageView alloc] initWithImage:shareImage];
    shareBG.userInteractionEnabled = YES;
    shareBG.tag = 1;
    
    UITapGestureRecognizer *showTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShare:)];
    showTap.numberOfTapsRequired = 1;
    showTap.numberOfTouchesRequired = 1;
    [shareBG addGestureRecognizer:showTap];
    
    UIImage *shareShopIcon = [UIImage imageNamed:@"shareShopIcon"];
    CGFloat imageScale = shareShopIcon.size.width / shareShopIcon.size.height;
    CGFloat buttonX = 10;
    CGFloat hDistance = 5;
    CGFloat buttonW = (SCREENWIDTH - 2 * buttonX - 2 * hDistance) / 3.0;
    CGFloat buttonH = buttonW / imageScale;
    CGFloat buttonY = imageH - 10 - buttonH;
    
    CGFloat imageY = [UIScreen mainScreen].bounds.size.height - (imageH - buttonY - 30);
    if (!iOS7) {
        imageY = imageY - statusBarHeight;
    }
    shareBG.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [self.view addSubview:shareBG];
    
    distanceOffset = imageY - ([UIScreen mainScreen].bounds.size.height - imageH);
    if (!iOS7) {
        distanceOffset = distanceOffset + statusBarHeight;
    }
    
    NSArray *array = @[@"shareSpringIcon",@"shareWineIcon",@"shareShopIcon"];

    CGFloat tag = 0;
    for (NSString *imagename in array) {
        AsynImageView *shareButton = [[AsynImageView alloc] init];
        shareButton.backgroundColor = [UIColor clearColor];
        shareButton.placeholderImage = [UIImage imageNamed:imagename];
        
        shareButton.layer.borderWidth = 0;
        shareButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        shareButton.layer.borderColor = [UIColor clearColor].CGColor;
        shareButton.layer.masksToBounds = YES;
        shareButton.contentMode = UIViewContentModeScaleAspectFill;
        shareButton.userInteractionEnabled = YES;
        shareButton.tag = tag;
        shareButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [shareBG addSubview:shareButton];
        
        buttonX = buttonX + buttonW + hDistance;
        tag = tag + 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapGes:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [shareButton addGestureRecognizer:tap];
        [shareImageArray addObject:shareButton];
    }
}

- (void)giveWine:(UITapGestureRecognizer *)ges
{
    NSString *pagename = @"send_wine_talent.html";
    NSString *webTypeStr = @"webUrl";
    NSString *webTitleStr = @"送酒达人赛";
    NSString *narBarOffsetYStr = @"44";
    NSString *guid = nil;
    NSString *shopid = [Tools getUserLoginNumber];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.isPublicPage = YES;
    webVC.webURL = pagename;
    webVC.agentid = shopid;
    webVC.webType =  webTypeStr;
    webVC.webTitle = webTitleStr;
    webVC.narBarOffsetY = [narBarOffsetYStr integerValue];
    webVC.infoGuid = guid;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

//修改完成商户的个人资料，刷新视图
- (void)modifyShopDetailSucceed:(id)object
{
    NSLog(@"modifyShopDetailSucceed");
    
//    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0141",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        
        
        if ([[tempDic valueForKey:@"val"] count] > 0) {
            self.myShopDataInfo = tempDic;
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],[[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"]];
            if ([[[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"] isEqualToString:@""]) {
                imageUrl = @"";
                headImageView.placeholderImage = [UIImage imageNamed:@"shop_sell_default"];
            }else{
                //已存在商品图片
                headImageView.placeholderImage = [UIImage imageNamed:@"noData2"];
                headImageView.imageURL         = imageUrl;
            }
            //如果存在本地图片,从本地加载
            //    [self resetHeadImageView];
            
            //店铺名称
            shopNameLable.text = [[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"ShopName"];
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
    
    
}

- (void)dismiss:(UITapGestureRecognizer *)tap
{
    dismissShareBG.hidden = YES;
    shareBG.tag = -1;
    [self showShare:nil];
}

- (void)showShare:(UITapGestureRecognizer *)tap
{
    UIView *tapView = shareBG;
    CGRect oldFrame = tapView.frame;
    CGRect newFrame = oldFrame;
    if (tapView.tag == 1) {
        //点击向上弹出
        dismissShareBG.hidden = NO;
        tapView.tag = -1;
        newFrame.origin.y = oldFrame.origin.y - distanceOffset;
    }
    else{
        //点击回弹
        dismissShareBG.hidden = YES;
        tapView.tag = 1;
        newFrame.origin.y = oldFrame.origin.y + distanceOffset;
    }
    [UIView animateWithDuration:.3 animations:^{
        tapView.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)shareTapGes:(UITapGestureRecognizer *)tap
{
    shareBG.tag = -1;
    [self showShare:nil];
    
    UIView *tapView = tap.view;
    switch (tapView.tag) {
        case 0:
        {
            //泉眼
            [self shareWithTitle:@"泉眼预定"];
            break;
        }
        case 1:
        {
            //送酒
            [self shareWithTitle:@"免费送酒"];
            break;
        }
        case 2:
        {
            //一键开店
            [self shareWithTitle:@"免费开店"];
            break;
        }
        default:
            break;
    }
}

- (void)getShopNumber
{
    NSString *agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0142",@"apiid",agentid,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *sharenumber = [dic objectForKey:@"sharenumber"];
        if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
            self.shareNumber = nil;
        }
        else{
            
            self.shareNumber = sharenumber;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (void)shareWithTitle:(NSString *)title
{
    //分享出去的链接地址
    //agentid  店铺的ID
    NSString *agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    NSString *shopName = [[myShopDic objectForKey:@"shopDataKey"] objectForKey:@"ShopName"];
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.danertu.com/mobile/chenniang/chenniang.htm?agentid=%@",agentid];
    
    NSString *shareContent = @"加我即送\n198元茅台晓镇香\n免费名酒2瓶";  //分享的内容
    if (self.shareNumber) {
        shareContent = [NSString stringWithFormat:@"加我即送\n198元茅台晓镇香\n免费名酒2瓶。\n店铺码:%@",self.shareNumber];
    }
    NSString *shareTitleStr = [NSString stringWithFormat:@"(%@) 新店开张",shopName];    //分享的主标题
    NSString *imagePath = @"http://115.28.77.246/pptImage/giveaway.jpg";
    if ([title isEqualToString:@"免费开店"]) {
        shareUrl = [NSString stringWithFormat:@"http://www.danertu.com/mobile/agentRegester/open_shop_link.htm?leadid=%@",agentid];
        imagePath = [NSString stringWithFormat:@"%@/pptImage/openshop.jpg",IMAGESERVER];
        shareTitleStr = @"完全免费";    //分享的主标题
        if (shopName) {
            shareTitleStr = [NSString stringWithFormat:@"完全免费--%@",shopName];    //分享的主标题
        }
        if ([self.shareNumber isMemberOfClass:[NSNull class]] || [self.shareNumber isEqualToString:@""] || self.shareNumber == nil) {
            shareContent = @"您身边的商城-单耳兔O2O商城。";
        }
        else{
            shareContent = [NSString stringWithFormat:@"您身边的商城-单耳兔O2O商城。\n店铺码:%@",self.shareNumber];
        }
    }
    else if ([title isEqualToString:@"泉眼预定"]){
        
        NSString *url = [NSString stringWithFormat:@"http://www.danertu.com/mobile/qyyd/quanyan_index.htm?agentid=%@",agentid];
        
        shareUrl = url;
        imagePath = [NSString stringWithFormat:@"%@/pptImage/quanyan.jpg",IMAGESERVER];
        shareTitleStr = @"中山泉眼温泉";    //分享的主标题
        if (self.shareNumber) {
            shareContent = [NSString stringWithFormat:@"吃住玩泡一站式享受。\n店铺码:%@",self.shareNumber];
        }
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithUrl:imagePath]
                                                title:shareTitleStr
                                                  url:shareUrl
                                          description:shareContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                    [alertview show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self showHint:@"分享失败"];
                                }
                            }];
}

//判断是否显示"泉眼产品销售统计"
-(void)loadData{
    [Waiting show];
    NSDictionary *param = @{@"apiid": @"0126",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *respondstring = operation.responseString;
        id respondObj = [respondstring objectFromJSONString];
        NSString *resultstr = [respondObj objectForKey:@"result"];
        if ([resultstr isMemberOfClass:[NSNull class]] || resultstr == nil) {
            resultstr = @"";
        }
        isShowSetting = [resultstr isEqualToString:@"true"] ? YES : NO;
        [self initView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:2.0];
    }];
}

-(void)goSellItemDetail:(id)sender{
    int itemTag = (int)[[sender view] tag] - 100;
    switch (itemTag) {
        case 0:
            {
                //订单管理
                SellOrderManageViewController *sellOrderManageVC = [[SellOrderManageViewController alloc] init];
                sellOrderManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sellOrderManageVC animated:YES];
            }
            break;
        case 1:
            {
                //商品管理
                SellWoodsManageViewController *sellWoodsManageVC = [[SellWoodsManageViewController alloc] init];
                sellWoodsManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sellWoodsManageVC animated:YES];
            }
            break;
        case 2:
            {
                //店铺管理
                SellShopManageViewController *sellShopManageVC = [[SellShopManageViewController alloc] init];
                sellShopManageVC.shopKeeperDic = myShopDic;
                sellShopManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sellShopManageVC animated:YES];
            }
            break;
        case 3:
            {
                //送酒分成设置
                SellSettingViewController *sellSettingVC = [[SellSettingViewController alloc] init];
                sellSettingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sellSettingVC animated:YES];
            }
            break;
        case 4:
            {
                //送酒统计
                WineActiveInfoViewController *wineActiveInfoVC = [[WineActiveInfoViewController alloc] init];
                wineActiveInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wineActiveInfoVC animated:YES];

            }
            break;
        case 5:
            {
                //送酒审核
                WebViewController *webViewController = [[WebViewController alloc] init];
                webViewController.agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
                webViewController.isCheckJiu = YES;
                webViewController.narBarOffsetY = 50;
                
                webViewController.webTitle = @"送酒活动审核";
                webViewController.webURL = @"check_jiu.html";
                webViewController.webType = @"webUrl";
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            break;
        case 6:
        {
            //出现提示框时开始定位
            [self goToChangeLocation];
        }
            break;
        case 7:
            {
                //泉眼产品销售统计
                WebViewController *webViewController = [[WebViewController alloc] init];
                webViewController.webTitle = @"泉眼产品销售";
                webViewController.webURL = @"sell_detail.html";
                webViewController.webType = @"webUrl";
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            break;
        case 8:
        {
            //店铺动态
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.narBarOffsetY = 50;
            webViewController.webTitle = @"店铺动态";
            webViewController.webURL = @"shop_info_list.html";
            webViewController.webType = @"webUrl";
            webViewController.agentid = [Tools getUserLoginNumber];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        case 9:
        {
            //代理产品
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.narBarOffsetY = 50;
            webViewController.webTitle = @"代理产品";
            webViewController.webURL = @"agent_product.html";
            webViewController.webType = @"webUrl";
            webViewController.agentid = [Tools getUserLoginNumber];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        case 10:
        {
            //供求管理
//            [self showHint:@"敬请期待"];
//            return;
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.narBarOffsetY = 50;
            webViewController.webTitle = @"供求管理";
            webViewController.webURL = @"my_supply_lsit.html";
            webViewController.webType = @"webUrl";
            webViewController.agentid = [Tools getUserLoginNumber];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

//-(void)resetHeadImageView{
//    //头像文件
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/sell_headImage.png"];
//    //头像文件存在
//    if ([fileManager fileExistsAtPath:filePath]) {
//        headImageView.image = [UIImage imageWithContentsOfFile:filePath];
//    }
//}

//我的店铺详情
-(void)goToShopDetailTap{
    DataModle *clickModle = [[DataModle alloc] init];
    clickModle.id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    clickModle.s = [[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"ShopName"];
    
    DetailViewController *detailController = [[DetailViewController alloc] init];
    detailController.modle = clickModle;
    detailController.agentid = clickModle.id;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}


//编辑
- (void)settingClick{
    //送酒审核
    HeModifySellerVC *webViewController = [[HeModifySellerVC alloc] init];
    webViewController.agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    webViewController.narBarOffsetY = 50;
    webViewController.myShopDataInfo = self.myShopDataInfo;
    webViewController.webTitle = @"店铺设置";
    webViewController.webURL = @"set_shop_base.html";
    webViewController.webType = @"webUrl";
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    
//    HeModifySellerVC *modifySellerVC = [[HeModifySellerVC alloc] init];
//    modifySellerVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:modifySellerVC animated:YES];
}

//更换店铺坐标
-(void)goToChangeLocation{
    NSLog(@"开始定位");
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务设置->隐私->定位服务" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self showHudInView:self.view hint:@"定位中..."];
        [_locService startUserLocationService];
    }
}

//登录
-(void)onClickLogin{
    LoginViewController *loginV = [[LoginViewController alloc] init];
    loginV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginV animated:YES];
}

-(void)sendLocationToSever{
    NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
    if (latitudeStr == nil) {
        latitudeStr = @"";
    }
    NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
    if (longitudeStr == nil) {
        longitudeStr = @"";
    }
    //修改店铺坐标
    NSDictionary * params  = @{@"apiid": @"0242",
                               @"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],
                               @"la" : latitudeStr,
                               @"lt" : longitudeStr};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        if ([[tempDic valueForKey:@"result"] isEqualToString:@"true"]){
            [self.view makeToast:@"已成功设置店铺坐标" duration:2.0 position:@"center"];
        }else{
            [self.view makeToast:@"设置店铺坐标失败,请重新设置" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [_locService stopUserLocationService];
                return;
                break;
            case 1:
                [self sendLocationToSever];
                break;
            default:
                break;
        }
    }
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    
    if (newLocation) {
        locationSucceedNum = locationSucceedNum + 1;
        if (locationSucceedNum >= MinLocationSucceedNum) {
            [self hideHud];
            locationSucceedNum = 0;
            [userLocationDict setObject:latitudeStr forKey:@"latitude"];
            [userLocationDict setObject:longitudeStr forKey:@"longitude"];
            [_locService stopUserLocationService];
            //
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否将当前定位坐标作为您店铺的地址？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag = 100;
            [alertView show];
        }
    }
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

#pragma mark CLLocationManagerDelegate
//iOS6.0以后定位更新使用的代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    CLLocationCoordinate2D coordinate1 = newLocation.coordinate;
    
    CLLocationCoordinate2D coordinate = [self returnBDPoi:coordinate1];
    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    
    if (newLocation) {
        locationSucceedNum = locationSucceedNum + 1;
        if (locationSucceedNum >= MinLocationSucceedNum) {
            [self hideHud];
            locationSucceedNum = 0;
            [userLocationDict setObject:latitudeStr forKey:@"latitude"];
            [userLocationDict setObject:longitudeStr forKey:@"longitude"];
            [_locService stopUserLocationService];
            //
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否将当前定位坐标作为您店铺的地址？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag = 100;
            [alertView show];
        }
    }
    
    
//    if(coordinate.latitude){
//        [locationManager stopUpdatingLocation];//停止gps
//        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
//            //得到的数组placemarks就是CLPlacemark对象数组，这里只取第一个就行
//            CLPlacemark *mark = nil;
//            if([placemarks count] > 0){
//                id tempMark = [placemarks objectAtIndex:0];
//                if([tempMark isKindOfClass:[CLPlacemark class]])
//                {
//                    mark = tempMark;
//                }
//                //具体业务逻辑，CLPlacemark的属性有很多，包括了街道名等相关属性
//                NSDictionary *addressDict = mark.addressDictionary;
//                NSString *address = [addressDict  objectForKey:@"Street"];
//                address = address == nil ? @"" : address;
//                NSString *state = [addressDict objectForKey:@"State"];
//                state = state == nil ? @"" : state;
//                NSString *city = [addressDict objectForKey:@"City"];
//                city = city == nil ? @"" : city;
//                [pos setObject:city forKey:@"cityName"];
//                
//                cityFromPos = @{@"cId":@"",@"cName":city,@"province":state};
//            }
//        }];
//    }
}

#pragma 火星坐标系 (GCJ-02) 转 mark-(BD-09) 百度坐标系 的转换算法
-(CLLocationCoordinate2D)returnBDPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = PoiLocation.longitude + 0.0065, y = PoiLocation.latitude + 0.006;
    float z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D GCJpoi=
    CLLocationCoordinate2DMake( z * sin(theta),z * cos(theta));
    return GCJpoi;
}

//定位失误时触发
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
//    [self.view makeToast:@"定位失败,请重新定位" duration:2.0 position:@"center"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyShopDetailSucceed" object:nil];
}

@end
