
///
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//-----商品详细页----
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI/BMapKit.h>
@interface DetailViewController ()
{
    
    NSString *shopInfoStr;
    AFHTTPClient * httpClient;
    NSArray *classifyDataArr;
    NSDictionary *selectTypeDic;
    UIView *noDataView;
    NSTimer *myTimer ;
    UIScrollView *bannerProductV;
    UICollectionView *gridView;
    UIView *tabbarView ;
    UIWebView *webView;
    BOOL hideTabbarDisappearView;//退出后隐藏tabbar
    NSString *shopLevelType;
    NSString *titleStr;//标题,店铺名称
}
@property(strong,nonatomic)NSString *fileModel;
@property(strong,nonatomic)NSMutableArray *arrays;
@property(strong,nonatomic)NSMutableDictionary *shopInfoDic;

@end

@implementation DetailViewController

@synthesize modle;
@synthesize defaults;
@synthesize addStatusBarHeight;
@synthesize isShopAddToFavorite;
@synthesize favoriteShopList;
@synthesize selectedM;
@synthesize favorite;
@synthesize availableMaps;

@synthesize urls_queue;
@synthesize isPreRequestFinished;
@synthesize contactTel;
@synthesize clientGoodsView;
@synthesize agentid;
@synthesize jsJsonString;
@synthesize fileModel;

@synthesize arrays;
@synthesize shopInfoDic;

- (id)initWithFileName:(NSString *)myfileModel
{
    if (self = [super init]) {
        self.fileModel = [[NSString alloc] initWithString:myfileModel];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializaiton];
    [Tools initPush];
    [self requestShopInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)initializaiton
{
    if (self.navigationController.view) {
        [Waiting show];
//        [self showHudInView:self.navigationController.view hint:@"努力加载中..."];
    }
    
    [self performSelector:@selector(dismissTip) withObject:nil afterDelay:15.0];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    defaults =[NSUserDefaults standardUserDefaults];
    arrays = [[NSMutableArray alloc] init];//初始化
    availableMaps = [[NSMutableArray alloc] init];//初始化
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
}

- (void)dismissTip
{
//    [self hideHud];
    [Waiting dismiss];
}

- (void)getShopName
{
    NSString *shopId = modle.id;
    if (!shopId || [shopId isEqualToString:@""]) {
        
        shopId = agentid;//没有modle,只传来了shopId
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0141",@"apiid",shopId,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        id respondObj = [respondStr objectFromJSONString];
        id valObj = [respondObj objectForKey:@"val"];
        @try {
            id respondDic = [valObj firstObject];
            self.shopName = [respondDic objectForKey:@"ShopName"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        if ([self.shopName isMemberOfClass:[NSNull class]] || self.shopName == nil) {
            self.shopName = @"单耳兔美食网";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (void)requestShopInfo
{
    NSString *shopId = modle.id;
    if (!shopId || [shopId isEqualToString:@""]) {

        shopId = agentid;//没有modle,只传来了shopId
    }
    else{
        if (!agentid) {
            agentid = shopId;
        }
    }
    if ([shopId isMemberOfClass:[NSNull class]] || !shopId || [shopId isEqualToString:@""]) {
        titleStr = modle.s;
        NSString *levelType = modle.leveltype;
        [self createViewWithData:levelType];
        return;
    }
    NSString *laString = [NSString stringWithFormat:@"%.6f",[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lat"] floatValue] * 1];
    NSString *ltString = [NSString stringWithFormat:@"%.6f",[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lot"] floatValue] * 1];
    NSDictionary *paramsDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0041",@"apiid",shopId,@"shopid",laString,@"la",ltString,@"lt", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        shopInfoStr = operation.responseString;
        if (!shopInfoStr) {
            shopInfoStr = @"";
        }
        NSData *shopInfoData = [shopInfoStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:shopInfoData options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (![jsonData objectForKey:@"shopdetails"] || ![jsonData objectForKey:@"shopdetails"] || [[[jsonData objectForKey:@"shopdetails"] objectForKey:@"shopbean"] count] == 0 ) {
            [self showHint:@"店铺信息有误,无法查看!"];
            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:2.0];
            return ;
        }else{
            NSDictionary *myObj = [[jsonData objectForKey:@"shopdetails"] objectForKey:@"shopbean"][0];
            
             self.shopInfoDic = [[NSMutableDictionary alloc] initWithDictionary:myObj];
        }
        //初始化model
        [self initModleData];
        [shopInfoDic setObject:agentid forKey:@"shopId"];
//        if (!modle) {
//            [shopInfoDic setObject:agentid forKey:@"shopId"];
//            [self initModleData];
//        }else{
//            [self initModleData];
//            [shopInfoDic setObject:agentid forKey:@"shopId"];
//        }
        if (![shopInfoDic objectForKey:@"Mobile"]||[[shopInfoDic objectForKey:@"Mobile"]isEqualToString:@""]) {
            NSString *phone = [shopInfoDic objectForKey:@"shopId"] ;
            [shopInfoDic setObject:phone forKey:@"Mobile"];
        }
        NSString *imgUrl = [shopInfoDic objectForKey:@"Mobilebanner"];
        if (imgUrl.length > 3) {
            imgUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[shopInfoDic objectForKey:@"m"],imgUrl];
            [shopInfoDic setObject:imgUrl forKey:@"Mobilebanner"];
        }
        [shopInfoDic setObject:modle.id forKey:@"ShopId"];
        
        NSString *levelType = modle.leveltype;
        if (!levelType) {
            levelType = [shopInfoDic objectForKey:@"leveltype"];
        }
        NSDictionary *currentShopInfo = [NSDictionary dictionaryWithObjectsAndKeys:modle.id,@"shopId",[shopInfoDic objectForKey:@"ShopName"],@"shopName",levelType,@"levelType", nil];
        [defaults setObject:currentShopInfo forKey:@"currentShopInfo"];
        titleStr = [shopInfoDic objectForKey:@"ShopName"];
        [self createViewWithData:levelType];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showHint:REQUESTERRORTIP];
    }];
    
}

//初始化modle数据
-(void)initModleData
{
    modle = [[DataModle alloc] init];
    modle.id = agentid;
    modle.e = [shopInfoDic objectForKey:@"EntityImage"];
    modle.jyfw = [shopInfoDic objectForKey:@"ShopJYFW"];
    modle.w = [shopInfoDic objectForKey:@"TYAddress"];
    modle.shopshowproduct = [shopInfoDic objectForKey:@"shopshowproduct"];
    modle.s = [shopInfoDic objectForKey:@"ShopName"];
    modle.la = [shopInfoDic objectForKey:@"la"];
    modle.lt = [shopInfoDic objectForKey:@"lt"];
}

//跳转商品详情
-(void)goProductDetailByGuid:(NSArray *)inputArray
{
    if (inputArray.count > 1) {
        NSString *guid = [inputArray objectAtIndex:1];
        GoodsDetailController *woodsDettail = [[GoodsDetailController alloc] init];
        woodsDettail.danModleGuid = guid;
        woodsDettail.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:woodsDettail animated:YES];
    }
}

//修改标题
-(NSString*)getTitle
{
    return titleStr;
}

//重新父类方法,显示搜索框
-(BOOL)isShowSearchView
{
    return NO;
}

-(void)onClickBack
{
    [defaults removeObjectForKey:@"currentShopInfo"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goBack{
    [defaults removeObjectForKey:@"currentShopInfo"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)htmlTabbar:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSInteger tag = [[inputArray objectAtIndex:1] integerValue];
        if (tag>=0&&tag<=5) {
            switch (tag) {
                case 0:{
                    GoodFoodController *goodV = [[GoodFoodController alloc] init];
                    goodV.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goodV animated:YES];
                    break;
                }
                case SHOPCATINDEX:;
                case MYINDEX:;
                case SHAREINDEX:{
                    [tabbarView removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewTabbarIndex" object:nil userInfo:@{@"tabbarIndex":[NSString stringWithFormat:@"%ld",tag]}];//object 和 userInfo都可以传值
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //            [self.tabBarController setSelectedIndex:tag];//----这里不可以控制----需要
                    break;
                }
                default:
                    break;
            }
        }else{
            [self.view makeToast:@"1.2" duration:1.2 position:@"center"];
        }
    }else{
        [self.view makeToast:@"1.2" duration:1.2 position:@"center"];
    }
}

//点击底部tabbar按钮
-(void)tapTabbar:(UIButton *)btn{
    NSInteger tag = btn.tag - 100;
    hideTabbarDisappearView = NO;
    switch (tag) {
        case 0:{
            GoodFoodController *goodV = [[GoodFoodController alloc] init];
            [self.navigationController pushViewController:goodV animated:YES];
            break;
        }
        case 3:;
        case 4:{
            [tabbarView removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showViewTabbarIndex" object:nil userInfo:@{@"tabbarIndex":[NSString stringWithFormat:@"%ld",(long)tag]}];//object 和 userInfo都可以传值
            [self.navigationController popToRootViewControllerAnimated:NO];
//            [self.tabBarController setSelectedIndex:tag];//----这里不可以控制----需要
            break;
        }
        case 5:{
            hideTabbarDisappearView = YES;
            NSDictionary *shareInfo = [NSDictionary dictionaryWithObjectsAndKeys:modle.s,@"shareTitle",agentid,@"shareId",@"s",@"shareType",nil];
            
            ShareViewController *shareV = [[ShareViewController alloc] init];
            shareV.shareInfo = shareInfo;
            [self.navigationController pushViewController:shareV animated:YES];
            break;
        }
        default:
            break;
    }
}

//跳转到搜索
-(void) toSearchView{
    
    SearchViewController *searchV = [[SearchViewController alloc] init];
    searchV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchV animated:YES];
}


//------请求数据,店铺详细信息数据
-(void) getDetailDataFormHttp{
    //-----这里得到数据---shopInfoDic,开始绘制view--------
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadShopDetail('%@')",shopInfoStr]];
}
//------读取线下产品
-(void)getClientWoodDataFormHttp{
//    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0042",@"shopId":modle.id};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation start];//发起请求
    [requestOperation waitUntilFinished];
    if(!requestOperation.error){
        
        DanModle *model = [[DanModle alloc] init];//初始化
        NSString *jsonDataStr = [[NSString alloc] initWithData:requestOperation.responseData encoding:NSUTF8StringEncoding];
        jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"•	" withString:@""];
        NSData *jsonDataTmp = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
    
        if (jsonData) {
            NSArray* temp = [[jsonData objectForKey:@"shopprocuctList"] objectForKey:@"shopproductbean"];//数组
            if(temp.count>0){
                NSString *firstGuid = @"";
                if (arrays.count>0) {
                    DanModle *tmpM = arrays[0];
                    firstGuid = tmpM.Guid;
                }
                for(int i=0;i<temp.count;i++){
                    model = [[DanModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                    if (![model.Guid isEqualToString:firstGuid]) {
                        [model setWoodFrom:@"agent"];
                        [model setContactTel:model.AgentId];//自营店电话
                        if ([model.SmallImage hasPrefix:@"/ImgUpload/Agent/"]) {
                            model.SmallImage = [model.SmallImage stringByReplacingOccurrencesOfString:@"/ImgUpload/Agent/" withString:@""];
                            [model setSmallImage:[NSString stringWithFormat:@"%@%@" ,MEMBERPRODUCT, model.SmallImage]];
                        }
                        else if ([model.AgentId hasPrefix:@"z"]) {
                            NSString *agentIdTmp = [model.AgentId stringByReplacingOccurrencesOfString:@"z" withString:@"0"];
                            [model setSmallImage:[NSString stringWithFormat:@"%@%@/%@" ,MEMBERPRODUCT,agentIdTmp, model.SmallImage]];//单独修改  图片路径属性,
                        }
                        else{
                            [model setSmallImage:[NSString stringWithFormat:@"%@%@/%@" ,MEMBERPRODUCT,model.AgentId, model.SmallImage]];//单独修改  图片路径属性,
                        }
                        [arrays addObject:model];//追加到数组
                    }
                }
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadOffline('%@')",jsonDataStr]];
            }
            else{
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadOffline('%@')",jsonDataStr]];
            }
        }
    }
}

//跳到分类页面
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
            GoodsDetailController *woodsV = [[GoodsDetailController alloc] initGoodsWithShopDict:shopInfoDic];
            woodsV.danModleGuid = guid;
            woodsV.isDiscountCard = isDiscountCard;//------是否是打折卡------
            //--------图片banner图片-------
            woodsV.shopImg = [shopInfoDic objectForKey:@"Mobilebanner"];
            if (!woodsV.shopImg) {
                woodsV.shopImg = [NSString stringWithFormat:@"%@/Member/%@/%@",IMAGESERVER,[shopInfoDic objectForKey:@"ShopId"],[shopInfoDic objectForKey:@"EntityImage"]];
            }
            woodsV.hidesBottomBarWhenPushed = NO;
            woodsV.modle = modle;
           
            [self.navigationController pushViewController:woodsV animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self hideHud];
            [Waiting dismiss];//隐藏loading
            [self showHint:REQUESTERRORTIP];
        }];
        [operation start];//-----发起请求------
        
        
        
    }
}

//跳转到woodDetail
-(void)goDetailView:(id)sender{
    NSInteger tag = [[sender view] tag] - 100;
    //获取当前所选的对象
    selectedM = arrays[tag];
    GoodsDetailController *woodsV = [[GoodsDetailController alloc] init];
    woodsV.danModleGuid =  selectedM.Guid;
    woodsV.modle = modle;
    woodsV.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:woodsV animated:YES];
}

//创建view 创建线下产品view
-(void)createClientWoodView{
    double woodCount = arrays.count;
    
    CGFloat width = MAINSCREEN_WIDTH/2.0;
    int height = 200;
    if (woodCount==1) {
        width = 80;//设定最小值,
    }
    for (int i=0; i<woodCount; i++) {
        int line = i/2;
        int colum = 0;
        if (i%2!=0) {
            colum = 1;
        }
        DanModle *woodModle = arrays[i];
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(width*colum, height*line, width, height)];
        [clientGoodsView addSubview:cellView];
        cellView.tag = 100+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDetailView:)];
        [cellView addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, width-10, height-10)];
        [cellView addSubview:contentView];
        //图片
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 140, 140)];
        [contentView addSubview:imgV];
        [imgV sd_setImageWithURL:[NSURL URLWithString:woodModle.SmallImage] placeholderImage:[UIImage imageNamed:@"noData"]];
        imgV.layer.borderColor = [UIColor grayColor].CGColor;
        imgV.layer.borderWidth = 0.5;
        //名称
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 145, 140, 30)];
        [contentView addSubview:nameLb];
        nameLb.font = TEXTFONT;
        nameLb.text = woodModle.Name;
        
        
        //价格
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 175, 60, 15)];
        [contentView addSubview:priceLb];
        priceLb.font = TEXTFONT;
        priceLb.text = [NSString stringWithFormat:@"¥ %@",woodModle.ShopPrice];
        priceLb.textColor = [UIColor redColor];
        
        //市场价
        UILabel *marketPrceLb = [[UILabel alloc] initWithFrame:CGRectMake(65, 175, 80, 15)];
        [contentView addSubview:marketPrceLb];
        marketPrceLb.font = TEXTFONTSMALL;
        marketPrceLb.textColor = [UIColor grayColor];
        marketPrceLb.text = [NSString stringWithFormat:@"原价:¥ %@",woodModle.MarketPrice];
        [marketPrceLb sizeToFit];
        
        //划线---
        UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, marketPrceLb.frame.size.height/2, marketPrceLb.frame.size.width, 1)];
        [marketPrceLb addSubview:lineLb];
        lineLb.backgroundColor = [UIColor grayColor];
        
    }
    //-----没有数据----
    noDataView = nil;
    int lineNum = ceil(woodCount/2);
    CGRect frame1 = CGRectMake(0, 25, MAINSCREEN_WIDTH, lineNum*height);
    clientGoodsView.frame = frame1;
    
}

//跳到店铺介绍页面
-(void)goIntroduce
{
    ShopIntroduceController *shopV = [[ShopIntroduceController alloc] init];
    shopV.shopInfoDic = shopInfoDic;
    shopV.shopInfoStr = shopInfoStr;
    shopV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopV animated:YES];
}

//创建view 添加数据
/*
 *  这里的数据  大部分在 modle 里,就是之前的view请求得到的
 *  ban属性,就是店铺自己的图片  是在dataArray[0]里 ,当然dataArray[0] 包含所有值
 */
#pragma mark method 绑定店铺模板
- (void) createViewWithData:(NSString *)levelTypeStr{
    NSInteger levelType = [levelTypeStr integerValue];
    
    NSString *filename = @"";
    switch (levelType) {
        case 0:
        {
            //旧模板
            filename = @"Android_shop1.html";
//            [self createPageView:@"Android_shop1.html?900" showHeader:NO];
            break;
        }
        case 1:
        {
            //简装
            filename = @"shop_new.html";
//            [self createPageView:@"shop_new.html" showHeader:NO];
            break;
        }
        case 2:
        {
            //新新模板
            filename = @"food_shop.html";
//            [self createPageView:@"food_shop.html?9090" showHeader:NO];
            break;
        }
        case 3:
        {
            //新新模板
            filename = @"food_shop3Modle.html";
//            [self createPageView:@"food_shop3Modle.html" showHeader:NO];
            break;
        }
        case 4:
        {
            //新新模板
            filename = @"food_shop4Modle.html";
//            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 11:{
            //新新模板
            filename = @"shop_template_1.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 12:{
            //新新模板
            filename = @"shop_template_2.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 13:{
            //新新模板
            filename = @"shop_template_3.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 14:{
            //新新模板
            filename = @"shop_template_4.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 15:{
            //新新模板
            filename = @"shop_template_5.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 16:{
            //新新模板
            filename = @"shop_template_6.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        case 17:{
            //新新模板
            filename = @"shop_template_7.html";
            //            [self createPageView:@"food_shop4Modle.html?9090" showHeader:NO];
            break;
        }
        default:
        {
            NSInteger templevelType = levelType - 10;
            filename = [NSString stringWithFormat:@"shop_template_%ld.html",templevelType];
            break;
        }
    }
//    if (fileModel) {
//        
//        filename = fileModel;
//    }
    [self createPageView:filename showHeader:NO];
}

//创建页面
-(void)createPageView:(NSString *)pageName showHeader:(BOOL) isShow{
    //新模板,页面构造,头部使用html页面
    CGRect frame = CGRectMake(0, addStatusBarHeight - 6, self.view.frame.size.width, self.view.frame.size.height-addStatusBarHeight+6);
    if (isShow) {
        frame = CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT -6, self.view.frame.size.width, CONTENTHEIGHT + 49 +6);
    }
    webView = [[UIWebView alloc] initWithFrame:frame];//上半部分
    webView.scrollView.bounces = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    
    //清除缓存
    if (CLEARWEBCACHE) {
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    }

    NSString *webURL = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,pageName];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    
}

//原生旧模板
-(void)createIosView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, CONTENTHEIGHT)];   //上半部分
    [self.view addSubview:scrollView];
    scrollView.directionalLockEnabled = YES;
    scrollView.backgroundColor = VIEWBGCOLOR;
    
    //加盟商自己产品
    UIView *clientItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 160)];
    clientItem.backgroundColor = [UIColor whiteColor];
    clientItem.userInteractionEnabled = YES;
    [scrollView addSubview:clientItem];
    
    bannerProductV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 120)];
    [clientItem addSubview:bannerProductV];
    bannerProductV.backgroundColor = [UIColor whiteColor];
    
    //图片
    UIImageView *clientImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 120)];
    if ([[shopInfoDic objectForKey:@"Mobilebanner"] length] > 3) {
        [clientImg sd_setImageWithURL:[shopInfoDic objectForKey:@"Mobilebanner"]];
    }else{
        [clientImg setImage:[UIImage imageNamed:@"onesui.jpg"]];
    }
    clientImg.userInteractionEnabled = YES;
    [bannerProductV addSubview:clientImg];
    if ([[shopInfoDic objectForKey:@"shopshowproduct"] length] > 5) {
        NSArray *productInfoArr = [[shopInfoDic objectForKey:@"shopshowproduct"] componentsSeparatedByString:@","];
        if (productInfoArr.count > 4) {
            //特价商品图片
            UIImageView *productImg = [[UIImageView alloc] initWithFrame:CGRectMake(420, 0, 120, 120)];
            //找到一个model,,线下产品的,获取agentId
            //DanModle *modelTmp = arrays[0];
            NSString *imgUrl = productInfoArr[2];
            if ([imgUrl hasPrefix:@"/ImgUpload/Agent/"]) {
                imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@"/ImgUpload/Agent/" withString:@""];
                imgUrl = [NSString stringWithFormat:@"%@%@" ,MEMBERPRODUCT, imgUrl];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@%@/%@" ,MEMBERPRODUCT,modle.id, productInfoArr[2]];
            }
            [productImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"noData"]];
            productImg.userInteractionEnabled = YES;
            
            [bannerProductV addSubview:productImg];
            
            //-----
            bannerProductV.contentSize = CGSizeMake(640, 120);
            
            //-----mask蒙版-----上边一个名词,一个按钮
            UIView *maskView_ = [[UIView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH, 0, MAINSCREEN_WIDTH, 120)];
            [bannerProductV addSubview:maskView_];
            maskView_.tag = 100;
            maskView_.backgroundColor = [UIColor clearColor];
            
            UITapGestureRecognizer *tapProduct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDetailView:)];
            [maskView_ addGestureRecognizer:tapProduct];
            
            //----商品名称
            UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 180, 40)];
            [maskView_ addSubview:shopName];
            shopName.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
            shopName.text = productInfoArr[1];
            shopName.backgroundColor = [UIColor clearColor];
            
            UILabel *priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(220, 80, 90, 25)];
            [maskView_ addSubview:priceLabel];
            priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            priceLabel.text = [NSString stringWithFormat:@"¥ %@",productInfoArr[4]];
            priceLabel.textColor = [UIColor redColor];
            priceLabel.backgroundColor = [UIColor clearColor];
            
            UILabel *border =[[UILabel alloc] initWithFrame:CGRectMake(0, 119, MAINSCREEN_WIDTH, 1)];
            [maskView_ addSubview:border];
            border.backgroundColor = BORDERCOLOR;
            
            //-------设置动态切换banner图和  特价商品------
            myTimer = [NSTimer  timerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
            [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
            
        }else{
            [self.view makeToast:@"店铺特价商品读取错误" duration:2.5 position:@"center"];
        }
    }
    //-----mask蒙版-----上边一个名词,一个按钮
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 120)];
    [bannerProductV addSubview:maskView];
    maskView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    
    UITapGestureRecognizer *tap123 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goIntroduce)];
    [maskView addGestureRecognizer:tap123];
    
    //----商品名称
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 230, 40)];
    [maskView addSubview:shopName];
    shopName.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    shopName.text = [shopInfoDic objectForKey:@"ShopName"];
    shopName.textColor = [UIColor whiteColor];
    shopName.backgroundColor = [UIColor clearColor];
    
    //----店铺简介按钮
    UIButton *introduceBtn =[[UIButton alloc] initWithFrame:CGRectMake(250, 5, 60, 25)];
    [maskView addSubview:introduceBtn];
    introduceBtn.layer.cornerRadius = 3;
    introduceBtn.backgroundColor = TOPNAVIBGCOLOR;
    introduceBtn.titleLabel.font = TEXTFONT;
    [introduceBtn setTitle:@"简介" forState:UIControlStateNormal];
    [introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [introduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [introduceBtn addTarget:self action:@selector(goIntroduce) forControlEvents:UIControlEventTouchUpInside];
    //----推广按钮
    UIButton *codeBtn =[[UIButton alloc] initWithFrame:CGRectMake(250, 40, 60, 25)];
    [maskView addSubview:codeBtn];
    codeBtn.layer.cornerRadius = 3;
    codeBtn.backgroundColor = TOPNAVIBGCOLOR;
    codeBtn.titleLabel.font = TEXTFONT;
    [codeBtn setTitle:@"推广" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [codeBtn addTarget:self action:@selector(onClickQR) forControlEvents:UIControlEventTouchUpInside];
    
    //----收藏按钮
    UIButton *favoriteBtn =[[UIButton alloc] initWithFrame:CGRectMake(250, 80, 60, 25)];
    [maskView addSubview:favoriteBtn];
    favoriteBtn.layer.cornerRadius = 3;
    favoriteBtn.backgroundColor = TOPNAVIBGCOLOR;
    favoriteBtn.titleLabel.font = TEXTFONT;
    [favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [favoriteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [favoriteBtn addTarget:self action:@selector(addToFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *addressDistanceView = [[UILabel alloc] initWithFrame:CGRectMake(0, bannerProductV.frame.size.height, MAINSCREEN_WIDTH, 40)];
    [clientItem addSubview:addressDistanceView];
    
    //详细地址
    UILabel *clientAdd = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
    [addressDistanceView addSubview:clientAdd];
    clientAdd.font = TEXTFONT;
    clientAdd.numberOfLines = 2;
    clientAdd.text = [shopInfoDic objectForKey:@"TYAddress"];
    
    //距离
    UILabel *distanceLb = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, 40)];
    [addressDistanceView addSubview:distanceLb];
    distanceLb.textAlignment = NSTextAlignmentCenter;
    distanceLb.font = TEXTFONT;
    NSLog(@"ajjogprejopwfjeo------%@",modle);
    if (modle.juli.length>0) {
        distanceLb.text = [NSString stringWithFormat:@"%@ km",modle.juli];
    }else{
        //-------这里只有  la=22371117  lt=113449599------需要计算距离----
        
        float distance = [self getDistanceOfPoints:[modle.la floatValue] y1:[modle.lt floatValue] x2:[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lat"] floatValue] y2:[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lot"] floatValue]]/1000;
        distanceLb.text = [NSString stringWithFormat:@"%.2f km",distance];
        
    }
    //-----------名酒世界-----吼一吼---------
    UIView *adsView = [[UIView alloc] initWithFrame:CGRectMake(0,clientItem.frame.size.height,MAINSCREEN_WIDTH,130)];
    [scrollView addSubview:adsView];
    NSArray *adsImgs = @[@"adsImg_wine.jpg",@"qcyy.jpg"];
    for (int i=0;i<adsImgs.count;i++) {
        UIButton *adsItem = [[UIButton alloc] initWithFrame:CGRectMake(10+(145+10)*i,5,145,84)];
        [adsView addSubview:adsItem];
        [adsItem setImage:[UIImage imageNamed:[adsImgs objectAtIndex:i]] forState:UIControlStateNormal];
        adsItem.tag = 100+i;
        [adsItem addTarget:self action:@selector(adsClickTo:) forControlEvents:UIControlEventTouchUpInside];
    }
    //---------白色------
    UIView *shopCommentView = [[UIView alloc] initWithFrame:CGRectMake(10,94,300,30)];
    [adsView addSubview:shopCommentView];
    shopCommentView.backgroundColor = [UIColor whiteColor];
    //
    UILabel *textInfoLb = [[UILabel alloc] initWithFrame:CGRectMake(10,5,200,20)];
    [shopCommentView addSubview:textInfoLb];
    textInfoLb.text = [NSString stringWithFormat:@"店铺评价  (%@)",[shopInfoDic objectForKey:@"plscore"] ];
    [textInfoLb sizeToFit];
    double avgScore = [[shopInfoDic objectForKey:@"avgscore"] doubleValue];
    
    //星星----
    UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(textInfoLb.frame.size.width+20, 7, 80, 16)];
    [shopCommentView addSubview:starView];
    starView.image = [UIImage imageNamed:@"star5Gray"];
    
    UIView *starViewYellowBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80*avgScore/5, 16)];
    [starView addSubview:starViewYellowBg];
    starViewYellowBg.clipsToBounds = YES;
    
    UIImageView *starViewYellow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 16)];
    [starViewYellowBg addSubview:starViewYellow];
    starViewYellow.image = [UIImage imageNamed:@"star5Yellow"];
    
    
    
    //评分----
    UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(textInfoLb.frame.size.width+20+starView.frame.size.width+5,0,30,30)];
    [shopCommentView addSubview:scoreLb];
    scoreLb.text = [NSString stringWithFormat:@"%0.1f",avgScore];
    scoreLb.textColor = [UIColor grayColor];
    
    //向右箭头----
    UIButton *goCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(260,0,40,30)];
    [shopCommentView addSubview:goCommentBtn];
    goCommentBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [goCommentBtn setTitleColor:BORDERCOLOR forState:UIControlStateNormal];
    [goCommentBtn setTitle:@">" forState:UIControlStateNormal];
    [goCommentBtn addTarget:self action:@selector(goCommentView) forControlEvents:UIControlEventTouchUpInside];
    
    
    //-------本店先下产品-----
    UIView * clientAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, clientItem.frame.size.height+adsView.frame.size.height, MAINSCREEN_WIDTH, 225)];
    [scrollView addSubview:clientAreaView];
    clientAreaView.backgroundColor = [UIColor whiteColor];
    
    //-----title---
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 25)];
    [clientAreaView addSubview: titleLb];
    titleLb.userInteractionEnabled = YES;
    titleLb.backgroundColor = BUTTONCOLOR;
    titleLb.font = TEXTFONT;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.text = @"    本超市线下产品";
   
    
    //-----线下产品展示-----创建view-----
    clientGoodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, MAINSCREEN_WIDTH, 200)];
    [clientAreaView addSubview:clientGoodsView];
    [self createClientWoodView];
    clientAreaView.frame = CGRectMake(0, clientItem.frame.size.height+adsView.frame.size.height, MAINSCREEN_WIDTH, 25+clientGoodsView.frame.size.height);
    
    //
    UIView *navigationTelView = [[UIView alloc] initWithFrame:CGRectMake(0, clientItem.frame.size.height+adsView.frame.size.height+clientAreaView.frame.size.height, MAINSCREEN_WIDTH, 35)];
    [scrollView addSubview:navigationTelView];
    navigationTelView.backgroundColor = [UIColor whiteColor];
    //---------导航-------
    UIView *navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
    [navigationTelView addSubview:navigation];
    navigation.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNavigation)];
    [navigation addGestureRecognizer:tap];
    //-图片
    UIImageView *navImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 25, 25)];
    [navigation addSubview:navImg];
    navImg.image = [UIImage imageNamed:@"location"];
    //-文字
    UILabel *navText = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 65, 25)];
    [navigation addSubview:navText];
    navText.backgroundColor = [UIColor clearColor];
    navText.font = TEXTFONT;
    navText.textAlignment = NSTextAlignmentCenter;
    navText.text = @"到这里去";
    //中间分割线
    UILabel *cuttingLine = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 1, 25)];
    [navigation addSubview:cuttingLine];
    cuttingLine.backgroundColor = VIEWBGCOLOR;
    //---------电话-------
    UIView *telPhone = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 35)];
    [navigationTelView addSubview:telPhone];
    telPhone.userInteractionEnabled = YES;
    UITapGestureRecognizer *tasp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialPhone)];
    [telPhone addGestureRecognizer:tasp];
    //-图片
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 25, 25)];
    [telPhone addSubview:phoneImg];
    phoneImg.image = [UIImage imageNamed:@"telPhone"];
    //-文字
    UILabel *phoneText = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 65, 25)];
    [telPhone addSubview:phoneText];
    phoneText.backgroundColor = [UIColor clearColor];
    phoneText.font = TEXTFONT;
    phoneText.textAlignment = NSTextAlignmentCenter;
    if ([[shopInfoDic objectForKey:@"isfood"] isEqualToString:@"yes"]) {
        phoneText.text = @"订餐咨询";
    }else{
        phoneText.text = @"咨询商家";
    }
    
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    [navigationTelView addSubview:border];
    border.backgroundColor = VIEWBGCOLOR;
    
    //------所有view加载完毕,可以计算总高度--------
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, clientItem.frame.size.height+navigationTelView.frame.size.height+clientAreaView.frame.size.height+adsView.frame.size.height);//----滑动区域----
}
//------展示评论页评论页-----
-(void)goCommentView{
    ShowCommentController *commentController = [[ShowCommentController alloc] init];
    commentController.shopInfoDic = shopInfoDic;
    commentController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentController animated:YES];
    
}
//-----同意方法调用-------
-(void)parameter_iosFunc:(NSArray *) inputArray{
    NSInteger parameterCount = inputArray.count;
    if (parameterCount > 0) {
        NSString *funcFlag = [inputArray firstObject];
        SEL func = NSSelectorFromString(funcFlag);
        if (parameterCount > 1) {
            //---------带参数的方法-----
            func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcFlag]);
        }
        if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:func withObject:inputArray];
#pragma clang diagnostic pop
        }
    }
}

#pragma hkrphport

//---------调接口加载数据,并且把数据返回-------
-(void)jsGetData:(NSArray *) inputArray{
    if (inputArray.count>2) {
        NSString *paramStr = inputArray[1];
        NSString *callback = inputArray[2];
        NSMutableArray *paramArr = [[paramStr componentsSeparatedByString:@",;"] mutableCopy];
        if (paramArr.count>0) {
//            [Waiting show];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *item in paramArr) {
                if (item ) {
                    NSMutableArray *temArr = [[item componentsSeparatedByString:@"|"] mutableCopy];
                    if (temArr.count==2) {
                        [params setObject:temArr[1] forKey:temArr[0]];
                    }else{
                        if ([temArr[0] isEqualToString:@"shopid"]) {
                            [params setObject:[shopInfoDic objectForKey:@"ShopId"] forKey:temArr[0]];
                        }
//                        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                    }
                }
            }
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                
                NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dicSource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if (!source||[[dicSource objectForKey:@"result"] isEqualToString:@"false"]) {
                    source = @"false";
                }
                if ([dicSource objectForKey:@"Guid"]) {
                    NSMutableDictionary *tmpDic = [dicSource mutableCopy];
                    [tmpDic setObject:[shopInfoDic objectForKey:@"ShopId"] forKey:@"ShopId"];
                    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:tmpDic options:NSJSONWritingPrettyPrinted error:nil];
                    source = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                
                /*
                 source:  true
                 source:  该用户名已注册
                 */
                if ([callback isEqualToString:@"YES"]) {
                    NSString *jsFuncName = [NSString stringWithFormat:@"javaLoadData(%@)",source];
                    [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
                }
//                NSString *pa = @"2";
//                NSString *typeNum = [NSString stringWithFormat:@"loadPlatFormProduct(%@)",pa];
//                [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
                
            }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                [Waiting dismiss];
                [self showHint:REQUESTERRORTIP];
            }];
            [operation start];
        }
    }
}
//请求服务
-(void)getService:(NSArray *) inputArray{
    NSInteger parameterCount = inputArray.count;
    if (parameterCount>1) {
        NSString *memLoginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
        if (memLoginId) {
            //餐桌号,服务号
            [Waiting show];
            NSString *tableNo = [inputArray firstObject];
            NSString *serviceNo = [inputArray objectAtIndex:1];
            NSString *sourceStr = [NSString stringWithFormat:@"%@|%@|%@|%@",memLoginId, [shopInfoDic objectForKey:@"ShopId"], tableNo,serviceNo];
            NSString *encryptPostStr = [AES128Util AES128Encrypt:sourceStr key:AESKEY];
            NSDictionary *params = @{@"apiid":@"0117",@"alias":@"9",@"ctype":@"3",@"md5str":encryptPostStr};
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params];
            AFHTTPRequestOperation * operationItem = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationItem, id responseObject) {
                [Waiting dismiss];
//                NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                //------成功或失败-----true/false
                if ([jsonData objectForKey:@"result"]) {
                    [self.view makeToast:[jsonData objectForKey:@"info"] duration:1.2 position:@"center"];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"faild , error == %@ ", error);
                [Waiting dismiss];
                [self showHint:REQUESTERRORTIP];
            }];
            [operationItem start];
        }else{
            [self showHint:@"请先登录"];
        }
    }
}

//本超市线下产品
-(void)goClientWoods
{
    ClientWoodsController *clientV = [[ClientWoodsController alloc] init];
    clientV.hidesBottomBarWhenPushed = YES;
    clientV.arrays = [arrays copy];
    [self.navigationController pushViewController:clientV animated:YES];
    
}

//计算距离
-(float)getDistanceOfPoints:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2
{
    float distance = 1.0;
    float wuce = 100000;
    float poA = fabs(x2 * wuce - x1 );
    float poB = fabs(y2 * wuce  - y1 );
    float wwc = 0.9296;//换算百度精准倍率
    //return parseInt(Math.sqrt((poA * poA) + (poB * poB))/10/ wwc);
    distance = sqrt((poA * poA) + (poB * poB))/10/ wwc;
    return distance;
}

//----动态展示banner图
-(void)timerFired{
    //滑动
    if(bannerProductV.contentOffset.x == MAINSCREEN_WIDTH){
        [UIView animateWithDuration:2.0 animations:^(void){
            [bannerProductV setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
        
    }else{
        [UIView animateWithDuration:2.0 animations:^(void){
            [bannerProductV setContentOffset:CGPointMake(MAINSCREEN_WIDTH, 0) animated:YES];
        }];
    }
}
//------广告点击跳转----
-(void)adsClickTo:(UIButton *)sender{
    NSInteger tag = [sender tag] - 100;
    
    if (tag==0) {
        DanertuWoodsController *danV = [[DanertuWoodsController alloc] init];
        danV.hidesBottomBarWhenPushed = YES;
        danV.modle = modle;
        [self.navigationController pushViewController:danV animated:YES];
    }else if (tag==1) {
        hideTabbarDisappearView = YES;
        WebViewController *web = [[WebViewController alloc] init];
        web.hidesBottomBarWhenPushed = YES;
        web.webTitle = @"全场一元";
        web.webURL = @"http://115.28.55.222:8017/IOSApphdOneForProduct.aspx";
        web.webType =  @"webUrl";
        [self.navigationController pushViewController:web animated:YES];
    }
}

//检查是否已经加入  收藏列表
-(BOOL)isHaveAddToFavorite
{
    BOOL result = NO;
    favoriteShopList = [[defaults objectForKey:@"favoriteShopList"] copy];
    if (favoriteShopList) {
        for (id temp in favoriteShopList ) {
            if ([[temp objectForKey:@"id"] isEqualToString:modle.id]) {
                result = YES;
                break;
            }
        }
    }else{
        result = NO;
    }
    return result;
}

//获取一级分类
-(void)getClassifyData{
    [Waiting show];
    NSString *gps = [NSString stringWithFormat:@"%@,%@",[[[LocationSingleton sharedInstance] pos] valueForKey:@"lat"] ,[[[LocationSingleton sharedInstance] pos] valueForKey:@"lot"]];
    NSDictionary *params = @{@"apiid":@"0098",@"pageSize":@"9",@"pageIndex":@"1",@"gps":gps,@"keyword":@"",@"juli":@"8000",@"shoptype":@"1",@"searchtype":@""};
    
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operationItem = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationItem, id responseObject) {
        [Waiting dismiss];
//        NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        classifyDataArr = [[jsonData objectForKey:@"firstCategoryList"] objectForKey:@"firstCategorybean"];
        if (classifyDataArr.count==0) {
            [self showHint:REQUESTERRORTIP];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }];
    [operationItem start];
}

- (void)setToHomePage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设置该店铺为应用首页？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    alertView.delegate = self;
    [alertView show];
}

//点击添加到收藏
-(void)addToFavorite
{
    //检测是否登录
    if (![Tools isUserHaveLogin]) {
        [self showHint:@"亲，您尚未登录，不能收藏该商品"];
        return;
    }
    isShopAddToFavorite = [self isHaveAddToFavorite];//检测是否加入收藏
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (favoriteShopList) {
        temp = [favoriteShopList mutableCopy];
    }
    if (isShopAddToFavorite) {
        [self showHint:@"已收藏"];
    }else{
        NSDictionary *shop = [NSDictionary dictionaryWithObjectsAndKeys:modle.id,@"id",modle.s,@"s",modle.e,@"e",modle.w,@"w",modle.jyfw,@"jyfw",modle.m,@"m",modle.c,@"c",modle.z,@"z",modle.sc,@"sc", modle.om,@"om",modle.num,@"num",modle.Rank,@"Rank",modle.i,@"i",modle.ot,@"ot",modle.la,@"la",modle.lt,@"lt", nil];
        
        [temp addObject:shop];
        [defaults setObject:temp forKey:@"favoriteShopList"];
        isShopAddToFavorite = YES;
        [favorite setImage:[UIImage imageNamed:@"star-orange"] forState:UIControlStateNormal];
        [self showHint:@"收藏成功"];
    }
}


//-----这里应该是分享的方法
-(void)onClickQR{
    //测试之用，记得删除
//    HeTestShopVC *testVC = [[HeTestShopVC alloc] init];
//    testVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testVC animated:YES];
//    return;
    NSString *shareId = modle.id;
    if (!shareId) {
        shareId = agentid;
        
    }
    if (!shareId) {
        shareId = @"";
    }
    NSString *levelType = modle.leveltype;
    if (!levelType) {
        levelType = [shopInfoDic objectForKey:@"leveltype"];
    }
    if ([levelType isMemberOfClass:[NSNull class]] || levelType == nil) {
        levelType = @"";
    }
    
    NSString *Mobilebanner = [shopInfoDic objectForKey:@"Mobilebanner"];
    if ([Mobilebanner isMemberOfClass:[NSNull class]] || Mobilebanner == nil) {
        Mobilebanner = @"";
    }
    NSString *EntityImage = [shopInfoDic objectForKey:@"EntityImage"];
    if ([EntityImage isMemberOfClass:[NSNull class]] || EntityImage == nil) {
        EntityImage = @"";
    }
    
    
    NSArray *imageURLArray = [Mobilebanner componentsSeparatedByString:@"/"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:imageURLArray];
    if (!([EntityImage isEqualToString:@"png"] || [EntityImage isEqualToString:@"jpg"] | [EntityImage isEqualToString:@"jpeg"])) {
        @try {
            [array removeLastObject];
            [array addObject:EntityImage];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    
    
    Mobilebanner = [self getUrlWithArray:array];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,self.agentid,EntityImage];
    if (EntityImage.length <= 3) {
        imageUrl = DEFAULTIMAGEURL;
    }
    
    NSDictionary *shareInfo = [NSDictionary dictionaryWithObjectsAndKeys:modle.s,@"shareTitle",shareId,@"shareId",@"s",@"shareType",levelType,@"levelType",levelType,@"leveltype",imageUrl,@"Mobilebanner",nil];
    ShareViewController *sView = [[ShareViewController alloc] init];
    sView.shareInfo = shareInfo;
    sView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sView animated:YES];
    
    return;
    //店铺的ID
    NSString *shopID = [shopInfoDic objectForKey:@"shopId"];
    if ([shopID isMemberOfClass:[NSNull class]] || shopID == nil) {
        shopID = @"";
    }
    
    //分享出去的链接地址
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.danertu.com/mobile/chenniang/chenniang.htm?agentid=%@",shopID];
    NSString *shareContent = @"加我即送\n198元茅台晓镇香\n免费名酒2瓶";  //分享的内容
    NSString *shareTitleStr = [NSString stringWithFormat:@"(%@) 新店开张",self.shopName];    //分享的主标题
    NSString *imagePath = @"http://115.28.77.246/pptImage/giveaway.jpg";
    if ([imagePath isMemberOfClass:[NSNull class]] || imagePath == nil) {
        imagePath = @"";
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
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}
/*
 线下产品的展示
 */
#pragma mark-(BD-09)----UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int cellCount = arrays.count;
    return cellCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.item;//小标
    
    DanModle *woodModle = arrays[index];
    //NSArray *lalt = [coordinate componentsSeparatedByString:@","];
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //@autoreleasepool {
    //---------最大整个view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 150, 190)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    contentView.layer.borderColor = [UIColor grayColor].CGColor;
    contentView.layer.borderWidth = 2;
    //图片
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 140, 140)];
    [contentView addSubview:imgV];
    [imgV sd_setImageWithURL:[NSURL URLWithString:woodModle.SmallImage] placeholderImage:[UIImage imageNamed:@"noData"]];
    imgV.layer.borderColor = [UIColor grayColor].CGColor;
    imgV.layer.borderWidth = 0.5;
    //名称
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 145, 140, 30)];
    [contentView addSubview:nameLb];
    nameLb.font = TEXTFONT;
    nameLb.text = woodModle.Name;
    

    //价格
    UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 175, 60, 15)];
    [contentView addSubview:priceLb];
    priceLb.font = TEXTFONT;
    priceLb.text = [NSString stringWithFormat:@"¥ %@",woodModle.ShopPrice];
    priceLb.textColor = [UIColor redColor];
    NSLog(@"jgropebjrjihtyj------%@",woodModle);
    //市场价
    UILabel *marketPrceLb = [[UILabel alloc] initWithFrame:CGRectMake(65, 175, 80, 15)];
    [contentView addSubview:marketPrceLb];
    marketPrceLb.font = TEXTFONTSMALL;
    marketPrceLb.textColor = [UIColor grayColor];
    marketPrceLb.text = [NSString stringWithFormat:@"原价:¥ %@",woodModle.MarketPrice];
    [marketPrceLb sizeToFit];
    NSLog(@"jiaojorigjoirg-----%@",marketPrceLb);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(160,200);
    return size;
}

/*
 *导航---------
 */
/*
la = 22330635;
lt = 113472422;
m = 18022005702;
 2014-07-29 09:17:13.623 danertu[421:907] ------------navigation--
 startLat:22.319945,
 startLot:113.459392,startText:start--
 endLat:22.324935,
 endLot:113.465907,endText:end
*/
#pragma mark-(BD-09) 百度坐标系转火星坐标系 (GCJ-02) 的转换算法
-(CLLocationCoordinate2D)returnGCJPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = PoiLocation.longitude - 0.0065, y = PoiLocation.latitude - 0.006;
    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D GCJpoi=
    CLLocationCoordinate2DMake( z * sin(theta),z * cos(theta));
    return GCJpoi;
}
//--导航至本店
-(void)goNavigation{
    [self availableMapsApps];
    
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *defaultLocateAction = [UIAlertAction actionWithTitle:@"使用系统自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //取消
            double endLat = [modle.la doubleValue] /100000.0;
            if (endLat > 90) {
                endLat = endLat / 10.0;
            }
            double endLot = [modle.lt doubleValue] /100000.0;
            if (endLot > 180) {
                endLot = endLot / 10.0;
            }
            CLLocationCoordinate2D endCoor = [self returnGCJPoi:CLLocationCoordinate2DMake(endLat, endLot)];
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            toLocation.name = modle.s;//-----目的地
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];
        [alertController addAction:defaultLocateAction];
        
        for (int i = 0;i < [availableMaps count]; i++) {
            NSDictionary *dic = availableMaps[i];
            NSString *titleString = [NSString stringWithFormat:@"使用%@导航", dic[@"name"]];
            UIAlertAction *locateAction = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSDictionary *mapDic = self.availableMaps[i];
                NSString *urlString = mapDic[@"url"];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alertController addAction:locateAction];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIActionSheet *action = [[UIActionSheet alloc] init];
        
        [action addButtonWithTitle:@"使用系统自带地图导航"];
        for (NSDictionary *dic in self.availableMaps) {
            [action addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", dic[@"name"]]];
        }
        [action addButtonWithTitle:@"取消"];
        action.cancelButtonIndex = self.availableMaps.count + 1;
        action.delegate = self;
        [action showInView:[UIApplication sharedApplication].keyWindow];//----取消按钮遮挡bug-----
    }

    
}
//---------可以使用第三方地图配置
- (void)availableMapsApps {
    [self.availableMaps removeAllObjects];//-----清空
    double startLat = [[[[LocationSingleton sharedInstance] pos] valueForKey:@"lat"] doubleValue] ;
    double startLot = [[[[LocationSingleton sharedInstance] pos] valueForKey:@"lot"] doubleValue] ;
    if (startLat > 90) {
        startLat = startLot / 10.0;
    }
    if (startLot > 180) {
        startLot = startLot / 10.0;
    }
    
    NSString* startText = @"start";
    double endLat = [modle.la doubleValue] /100000.0;
    double endLot = [modle.lt doubleValue] /100000.0;
    if (endLat > 90) {
        endLat = endLat / 10.0;
    }
    if (endLot > 180) {
        endLot = endLot / 10.0;
    }
    NSString* endText = modle.s;
    
    NSLog(@"------------navigation-------origin_endLat:%@--origin_endLot:%@----startLat:%f,startLot:%f,startText:%@--endLat:%f,endLot:%f,endText:%@",modle.la,modle.lt,startLat,startLot,startText,endLat,endLot,endText);
    CLLocationCoordinate2D startCoor = CLLocationCoordinate2DMake(startLat, startLot);
    //-----------百度坐标系转---火星
    CLLocationCoordinate2D endCoor = [self returnGCJPoi:CLLocationCoordinate2DMake(endLat, endLot)];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=GaodeScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",endCoor.latitude,endCoor.longitude];
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%.6f,%.6f|name:我的位置&destination=latlng:%.6f,%.6f|name:%@&mode=driving&coord_type=bd09ll",
                               startLat, startLot, endLat, endLot, endText];
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=transit",endCoor.latitude, endCoor.longitude];
        NSDictionary *dic = @{@"name": @"Google Maps",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
        NSLog(@"qopwoqpwopq-------coordinate----%f,%f-----%f,%f----",startCoor.latitude, startCoor.longitude,endCoor.latitude, endCoor.longitude);
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    AHReach *hostReach = [AHReach reachForHost:@"https://www.baidu.com/"];
    if ([hostReach isReachable]) {
    //if (1) {
        if (buttonIndex == 0) {
            double endLat = [modle.la doubleValue] /100000.0;
            double endLot = [modle.lt doubleValue] /100000.0;
            CLLocationCoordinate2D endCoor = [self returnGCJPoi:CLLocationCoordinate2DMake(endLat, endLot)];
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            toLocation.name = modle.s;//-----目的地
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            //NSLog(@"fhewhfewhgwo----------");
        }else if (buttonIndex < self.availableMaps.count+1) {
            NSDictionary *mapDic = self.availableMaps[buttonIndex-1];
            NSString *urlString = mapDic[@"url"];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        [self.view makeToast:@"网络未连接" duration:1.2 position:@"center"];
    }
}
//拨打电话
-(void)dialPhone{
    /*
    NSString* tel = modle.id;
    if(modle.id.length>11){
        tel = [modle.id substringFromIndex:(modle.id.length-11)];//有的电话前含有字母  z13549920715
    }
     */
    NSString *telPhone = [shopInfoDic objectForKey:@"Mobile"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"店铺电话:%@",telPhone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"拨打"];
    [alert setTag:12];
    [alert show];
    
}
//对应 弹出窗按钮的处理-------多个弹窗以tag区分
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] ==12 ) {    // it's the Error alert
        NSString *telPhone = [shopInfoDic objectForKey:@"Mobile"];
        if ([telPhone isMemberOfClass:[NSNull class]] || telPhone == nil) {
            telPhone = @"";
            [self showHint:@"商家暂没提供联系方式!"];
            return;
        }
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",telPhone];
        if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        }
    }else if ([alertView tag] ==22 ) {    // it's the Error alert
        if(buttonIndex==1){
            //这里的电话号码  0760-85883115   之间不能有  -  或其他非数字
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://076085883115"]];
        }
    }else if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}
//----广告跳转------
-(void)goAdsViewController:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        
        if ([paramStr isEqualToString:@"0"]) {
            DanertuWoodsController *danV = [[DanertuWoodsController alloc] init];
            danV.hidesBottomBarWhenPushed = YES;
            danV.modle = modle;
            [self.navigationController pushViewController:danV animated:YES];
        }else if ([paramStr isEqualToString:@"1"]) {
            hideTabbarDisappearView = YES;
            WebViewController *web = [[WebViewController alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            web.webTitle = @"全场一元";
            web.webURL = @"http://115.28.55.222:8017/IOSApphdOneForProduct.aspx";
            web.webType =  @"webUrl";
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}
//------跳转到其他viewcontroller--------
-(void)goOtherViewController:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        
        id Controller =  [[NSClassFromString(paramStr) alloc] init];
        if (Controller) {
            ((UIViewController *)Controller).hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Controller animated:YES];
        }
        
        
    }
}


//---------加载完毕-----
-(void)getShop_newPageData{
    if (modle.id) {
        //----获取评论-----------------
        NSDictionary * params = @{@"apiid": @"0100",@"shopid" :modle.id};
        NSLog(@"urdfdfewioutolocationString---------:%@--",params);
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            NSString *commentDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"123sewqewrjg-fasdfeawf--------%@--%@",shopInfoStr,commentDataStr);
            /*
            NSString *imgName = [shopInfoDic objectForKey:@"EntityImage"];
            NSString *imgFileUrl;
            if ([imgName length]>3) {
                imgFileUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[shopInfoDic objectForKey:@"m"],imgName];
            }else{
                
            }
             */
            if (commentDataStr) {
                NSLog(@"q---------q");
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadPageData('%@', '%@')",shopInfoStr,commentDataStr]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
            [Waiting dismiss];
        }];
        [operation start];//-----发起请求------
    }else{
        [self.view makeToast:@"数据错误:0100" duration:1.2 position:@"center"];
    }
}
//新店铺模板加载数据
-(void)loadNewShopData
{
    
}
//---------提交点菜订单--------
-(void)submitBook:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        NSString *memLoginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
        if (memLoginId) {
            //-----餐桌号,服务号------
            [Waiting show];
            //--------mobile联系电话|adress地址|Remark ------传空--------
            NSString *sourceStr = [NSString stringWithFormat:@"%@|%@|%@",memLoginId, [shopInfoDic objectForKey:@"ShopId"], paramStr];
            NSString *encryptPostStr = [AES128Util AES128Encrypt:sourceStr key:AESKEY];
            NSDictionary *params = @{@"apiid":@"0117",@"alias":@"9",@"ctype":@"2",@"md5str":encryptPostStr};
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params];
            AFHTTPRequestOperation * operationItem = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationItem, id responseObject) {
                [Waiting dismiss];
//                NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                //------成功或失败-----true/false
                if ([jsonData objectForKey:@"result"]) {
                    [self.view makeToast:[jsonData objectForKey:@"info"] duration:1.2 position:@"center"];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"faild , error == %@ ", error);
                [Waiting dismiss];
                [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
            }];
            [operationItem start];
        }else{
            [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
        }
    }
}
//---------提交点菜订单--------
-(void)submitOrder:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        NSString *memLoginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
        if (memLoginId) {
            //-----餐桌号,服务号------
            [Waiting show];
            //--------mobile联系电话|adress地址|Remark ------传空--------
            NSString *sourceStr = [NSString stringWithFormat:@"%@|%@|%@|''|''|''",memLoginId, [shopInfoDic objectForKey:@"ShopId"], paramStr];
            NSString *encryptPostStr = [AES128Util AES128Encrypt:sourceStr key:AESKEY];
            NSDictionary *params = @{@"apiid":@"0117",@"alias":@"9",@"ctype":@"1",@"md5str":encryptPostStr};
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params];
            AFHTTPRequestOperation * operationItem = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operationItem, id responseObject) {
                [Waiting dismiss];
                NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"jgjfiofjiowforejggjieogjieooj----%@\n%@\n%@",sourceStr,source,params);
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                //------成功或失败-----true/false
                if ([jsonData objectForKey:@"result"]) {
                    [self.view makeToast:[jsonData objectForKey:@"info"] duration:1.2 position:@"center"];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"faild , error == %@ ", error);
                [Waiting dismiss];
                [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
            }];
            [operationItem start];
        }else{
            [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
        }
    }
}
//-----加载所有数据----
-(void)getAllData{
    
    [self getClientWoodDataFormHttp];
    [self getDetailDataFormHttp];
    NSString *param = [NSString stringWithFormat:@"apiid|0123,;shopid|%@",modle.id];
    [self parameter_iosFunc:@[@"jsGetData",param,@"YES"]];
}

/*!
 @method 加载旧版店铺的商品数据
 @discussion
 @property typeNum 商品的类别
 */
- (void)loadOldShopDataWithType:(int)typeNum
{
    NSString *typestr = [NSString stringWithFormat:@"%d",typeNum];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0040",@"apiid",@"",@"kword",typestr,@"type", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondString = operation.responseString;
        NSString *correctString = [Tools deleteErrorStringInString:respondString];
        //原生调用js加载数据
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadPlatFormProduct('%@',%d)",correctString,typeNum]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

/*!
 @method 子类别的点击事件
 @discussion
 @property inputArray 参数值
 */
- (void)subClassButtonClick:(NSArray *)inputArray
{
    int typeNum = 0;
    @try {
        typeNum = [inputArray[1] intValue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    //加载商品数据
    [self loadOldShopDataWithType:typeNum];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if (alertView.tag == 100 && buttonIndex == 1){
        defaults = [NSUserDefaults standardUserDefaults];
        NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
        if (userName == nil || [userName isEqualToString:@""]) {
            userName = @"";
        }
        NSString *specialKey = [NSString stringWithFormat:@"specialKey_%@",userName];
        NSString *specialShopID = [defaults objectForKey:specialKey];
        specialShopID = [NSString stringWithFormat:@"%@",modle.id];
        [defaults setObject:specialShopID forKey:specialKey];
        [defaults synchronize];
        [self showHint:@"设置成功，下次启动应用即可生效"];
    }
}

- (void)parameter_getProperty:(NSArray *)inputArray
{
    NSString *propertyKey = nil;
    NSString *propertyClass = nil;
    NSString *propertyValue = nil;
    @try {
        propertyKey = inputArray[0];
        propertyClass = inputArray[1];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    SEL func = NSSelectorFromString(propertyKey);
    if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        propertyValue = [self performSelector:func withObject:nil];
#pragma clang diagnostic pop
    }
    else{
        Class cls = NSClassFromString(propertyClass);
        if(cls && [cls respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            propertyValue = [cls performSelector:func withObject:nil];
#pragma clang diagnostic pop
        }
    }
    if (propertyValue == nil) {
        propertyValue = @"";
    }
    NSString *jsFunc = [NSString stringWithFormat:@"getProperty('%@','%@')",propertyKey,propertyValue];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

- (void)jsGetParam
{
    if (jsJsonString == nil) {
        jsJsonString = @"";
    }
    NSString *jsFunc = [NSString stringWithFormat:@"jsGetParam('%@')",self.jsJsonString];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

- (void)json_showTips:(NSString *)tipString
{
    NSDictionary *dict = [tipString objectFromJSONString];
    NSString *tip = [dict objectForKey:@"tip"];
    if ([tip isMemberOfClass:[NSNull class]] || tip == nil) {
        tip = @"";
    }
    [self showHint:tipString];
}

- (void)json_getAgentProduct:(NSString *)jsonString
{
    self.jsJsonString = jsonString;
    NSLog(@"%@",jsonString);
    NSDictionary *dict = [jsonString objectFromJSONString];
    if (dict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.jsJsonString = jsonString;
        dict = [jsonString objectFromJSONString];
    }
    [Waiting show];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        if ([respondString compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
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

- (void)webViewDidStartLoad:(UIWebView *)mywebView
{
    
    [self performSelector:@selector(dismissTip) withObject:nil afterDelay:5.0];
}

- (void)webViewDidFinishLoad:(UIWebView *)mywebView
{
//    [self hideHud];
    [Waiting dismiss];
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    static BOOL isRequestWeb = YES;
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response.statusCode == 404 || response.statusCode == 403) {
            // code for 404 or 403
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
            imageView.frame = CGRectMake((MAINSCREEN_WIDTH - 100)/2.0, 200, 100, 100);
            imageView.center = self.view.center;
            [self.view addSubview:imageView];
            
            [webView stopLoading];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，目前页面有点问题，请稍后再试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 404;
            [alert show];
            return NO;
        }
        [webView loadData:data MIMEType:@"text/html" textEncodingName:nil baseURL:[request URL]];
        isRequestWeb = NO;
        return NO;
    }
    //window.location.href="ios:normalPage/"+page+"/"+name+"/"+id+"/"+tagFlag;
    // 说明协议头是ios
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //--------不带参数的直接方法名------
        if ([method hasPrefix:@"parameter_"]){
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
        }
        else if ([method hasPrefix:@"json_"]){
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
        else if ([method hasPrefix:@"func_"]){
            SEL func = NSSelectorFromString(method);
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func withObject:nil];
#pragma clang diagnostic pop
            }
        }
        return NO;
    }
    return YES;
}


//-------与其他页面统一-----
-(void)goNewControllerPage:(NSArray *)inputArray{
    if (inputArray.count > 3) {
        WebViewController *webViewController = [[WebViewController alloc] init];
        @try {
            webViewController.webURL = inputArray[1];
            webViewController.webType = inputArray[2];
            webViewController.webTitle = inputArray[3];
            webViewController.narBarOffsetY = [inputArray[4] floatValue];
            if ([inputArray count] > 7) {
                NSString *url = @"";
                NSString *agentid = inputArray[5];
                if (modle.id) {
                    agentid = modle.id;
                }
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

- (void)json_gotoNewController:(NSString *)jsonString
{
    NSDictionary *paramsDict = [jsonString objectFromJSONString];
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
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
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

//-----附近店铺-----
-(void)nearbyShop{
    GoodFoodController *goodV = [[GoodFoodController alloc] init];
    goodV.shopGps = [NSString stringWithFormat:@"%f,%f",[modle.la doubleValue] / 100000,[modle.lt doubleValue] / 100000];
    goodV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodV animated:YES];
}

//-----------内存不足报警------
-(void)dealloc
{
    
}
@end
