//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "WebViewController.h"
#import "CustomNavigationController.h"
#import "NoItemView.h"

@implementation WebViewController{
    AFHTTPClient * httpClient ;
    NSString *memLoginID;
    NoItemView *noDataView;
}

@synthesize addStatusBarHeight;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize webType;
@synthesize defaults;
@synthesize narBarOffsetY;
@synthesize agentid;
@synthesize shopDetailInfoDict;
@synthesize shopNumber;
@synthesize infoGuid;
@synthesize jsJsonString;

-(id)initWebViewWithShopDict:(NSDictionary *)shopDict
{
    if ([super init]) {
        shopDetailInfoDict = [[NSDictionary alloc] initWithDictionary:shopDict];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    memLoginID = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT - narBarOffsetY, MAINSCREEN_WIDTH, CONTENTHEIGHT + 49 + narBarOffsetY)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    webView.scrollView.bounces = NO;
    
    //清除缓存
    if (CLEARWEBCACHE) {
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    }

    //加载内容
    NSString *platform = @"ios";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceid = [Tools getDeviceUUid];
    if ([webType isEqualToString:@"localPage"]) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:webURL ofType:@"html"inDirectory:@"www"];
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    }else if ([webType isEqualToString:@"webUrl"]) {
        NSString *webURL_full  = @"";
        if ([self.webURL hasPrefix:@"http"]) {
            webURL_full = self.webURL;
        }
        else{
            
            webURL_full = [NSString stringWithFormat:@"%@/%@?platform=%@&version=%@&deviceid=%@&agenid=%@",PAGEURLADDRESS,self.webURL,platform,version,deviceid,self.agentid];
            if (self.isPublicPage) {
                //如果是独立界面
                webURL_full = [NSString stringWithFormat:@"%@/%@?platform=%@&version=%@&deviceid=%@&agenid=%@",PUBLICURLADDRESS,self.webURL,platform,version,deviceid,self.agentid];
            }
        }
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL_full]]];
    }
    if (self.isCheckJiu) {
        activityIndicator.hidden = YES;
//        [self showHudInView:webView.scrollView hint:@"加载中..."];
        
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectShopModel:) name:@"selectShopModel" object:nil];
    
    //获取店铺名
    [self getShopName];
    //获取店铺码
    [self getShopNumber];
    
    //没有数据显示的view,下方按钮高70
    noDataView = [[NoItemView alloc] initWithY:TOPNAVIHEIGHT+addStatusBarHeight+(CONTENTHEIGHT-150)/2+30 Image:[UIImage imageNamed:@"noData"] mes:@"暂无相关记录"];
    [self.view addSubview:noDataView];
    //默认隐藏
    noDataView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.webURL rangeOfString:@"shop_info_list"].length != 0 || [self.webURL rangeOfString:@"shop_info_detail"].length != 0 || [self.webURL rangeOfString:@"my_supply_lsit"].length != 0 || [self.webURL rangeOfString:@"my_supply_detail"].length != 0) {
        [webView reload];
    }
    
}

//修改标题,重写父类方法
-(NSString*)getTitle{
    return webTitle;
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
    if (self.isCheckJiu) {
        //如果是送酒审核
        [self getOrderList:nil];
    }
    webViewTmp.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)func_getCurrentLocation
{
    UIViewController *vc = ((CustomNavigationController *)[self.tabBarController.viewControllers objectAtIndex:0]).topViewController;
    if ([vc isMemberOfClass:[KKFirstViewController class]]) {
        NSDictionary *dic = ((KKFirstViewController *)vc).city;
        NSString *cityName = [dic objectForKey:@"cName"];
        if ([cityName isMemberOfClass:[NSNull class]] || cityName == nil) {
            //默认是珠海市
            cityName = @"珠海市";
        }
        NSString *jsFunction = [NSString stringWithFormat:@"getCurrentLocation('%@')",cityName];
        [webView stringByEvaluatingJavaScriptFromString:jsFunction];
    }
}

- (void)getShopName
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0141",@"apiid",agentid,@"shopid", nil];
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
            self.shopName = @"单耳兔商城";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    
    }];
}

- (void)jsGetShopValue:(NSArray *)inputArray
{
    NSString *jsFunc = [NSString stringWithFormat:@"javaAssignValue('%@')",self.agentid];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

- (void)getOrderList:(NSArray *)inputArray
{
    [Waiting show];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0226",@"apiid",self.agentid,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
//        [self hideHud];
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        NSString *correctString = [Tools deleteErrorStringInString:respondString];
        NSString *jsFunc = [NSString stringWithFormat:@"getOrderList('%@','%@')",self.agentid,correctString];
        [webView stringByEvaluatingJavaScriptFromString:jsFunc];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
    }];
}

- (void)prepareToUpdate:(NSArray *)inputArray
{
    NSString *idstr = @"";
    NSString *statestr = @"";
    NSString *type = @"";
    @try {
        idstr = inputArray[1];
        statestr = inputArray[2];
        type = inputArray[3];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if ([type isMemberOfClass:[NSNull class]] || type == nil || [type isEqualToString:@""]) {
        type = @"1";
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0227",@"apiid",idstr,@"id",statestr ,@"state",type,@"type",nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondString = operation.responseString;
        NSString *correctString = [Tools deleteErrorStringInString:respondString];
        NSString *jsFunc = [NSString stringWithFormat:@"updateOrderList('%@')",correctString];
        [webView stringByEvaluatingJavaScriptFromString:jsFunc];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}


- (NSString *)getUrlAfterAddParamWithUrl:(NSString *)url
{
    NSString *platform = @"ios";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceid = [Tools getDeviceUUid];
    NSString *webURL_full = [NSString stringWithFormat:@"%@?platform=%@&version=%@&deviceid=%@&agenid=%@",url,platform,version,deviceid,self.agentid];
    return webURL_full;
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
        NSDictionary *paramsDict = [self.jsJsonString objectFromJSONString];
        if (paramsDict == nil) {
            self.jsJsonString = [self.jsJsonString
                          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict = [self.jsJsonString objectFromJSONString];
        }
        propertyValue = [paramsDict objectForKey:propertyKey];
        if (!propertyValue) {
            Class cls = NSClassFromString(propertyClass);
            if(cls && [cls respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                propertyValue = [cls performSelector:func withObject:nil];
#pragma clang diagnostic pop
            }
        }
        
    }
    if (propertyValue == nil) {
        propertyValue = @"";
    }
    NSString *jsFunc = [NSString stringWithFormat:@"getProperty('%@','%@')",propertyKey,propertyValue];
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

- (void)gotoBook:(NSArray *)inputArray
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
    NSString *url = [NSString stringWithString:mutableString];
    NSString *bookurl = [self getUrlAfterAddParamWithUrl:url];
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    webViewController.webURL = bookurl;
    webViewController.webType = @"webUrl";
    webViewController.webTitle = @"";
    webViewController.narBarOffsetY = 50;
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

//跳到登录界面
- (void)goLogin:(NSArray *)inputArray
{
    //跳转到个人中心
    NSString *alertTitle = @"温馨提示";
    NSString *alertContent = @"";
    if ([Tools isUserHaveLogin]) {
        alertContent = @"亲，目前你已有账号登录，请先注销当前登录账号!";
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:alertTitle message:alertContent delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
        [alertview show];
    }
    else{
        [self.tabBarController setSelectedIndex:3];
        [self setBarItemSelectedIndex:3];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

//重置密码
- (void)goOtherViewController:(NSArray *)inputArray
{
    NSString *alertTitle = @"温馨提示";
    NSString *alertContent = @"";
    if ([Tools isUserHaveLogin]) {
        alertContent = @"亲，目前你已有账号登录，请先注销当前登录账号!";
    }
    else{
        alertContent = @"亲，目前你还没登录，请先登录然后修改密码!";
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:alertTitle message:alertContent delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看", nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    switch (buttonIndex) {
        case 1:
        {
            //跳转到个人中心
            [self.tabBarController setSelectedIndex:3];
            [self setBarItemSelectedIndex:3];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

//获取店铺码
- (void)getShopNumber
{
    NSString *shareId = self.agentid;
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0142",@"apiid",shareId,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *sharenumber = [dic objectForKey:@"sharenumber"];
        if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
            
        }
        else{
            self.shopNumber = sharenumber;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (void)share:(NSArray *)inputArray
{
    //分享出去的链接地址
    //agentid  店铺的ID
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.danertu.com/mobile/chenniang/chenniang.htm?agentid=%@",agentid];
    
    NSString *shareContent = @"加我即送\n198元茅台晓镇香\n免费名酒2瓶";  //分享的内容
    NSString *shareTitleStr = [NSString stringWithFormat:@"(%@) 新店开张",self.shopName];    //分享的主标题
    NSString *imagePath = @"http://115.28.77.246/pptImage/giveaway.jpg";
    if ([self.webTitle isEqualToString:@"免费开店"]) {
        shareUrl = [NSString stringWithFormat:@"http://www.danertu.com/mobile/agentRegester/open_shop_link.htm?leadid=%@",agentid];
        imagePath = [NSString stringWithFormat:@"%@/pptImage/openshop.jpg",IMAGESERVER];
        shareTitleStr = @"完全免费";    //分享的主标题
        if (self.shopName) {
            shareTitleStr = [NSString stringWithFormat:@"完全免费--%@",self.shopName];    //分享的主标题
        }
        
        if ([self.shopNumber isMemberOfClass:[NSNull class]] || [self.shopNumber isEqualToString:@""] || self.shopNumber == nil) {
            shareContent = @"您身边的商城-单耳兔O2O商城。";
        }
        else{
            shareContent = [NSString stringWithFormat:@"您身边的商城-单耳兔O2O商城。\n店铺码:%@",self.shopNumber];
        }
    }
    else if ([self.webTitle isEqualToString:@"泉眼预定"]){
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
        NSString *url = [NSString stringWithString:mutableString];
        
        shareUrl = url;
        imagePath = [NSString stringWithFormat:@"%@/pptImage/quanyan.jpg",IMAGESERVER];
        shareTitleStr = @"中山泉眼温泉";    //分享的主标题
        shareContent = @"吃住玩泡一站式享受";
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

- (void)parameter_gotoInfoDetail:(NSArray *)inputArray
{

}

- (void)cellOnClick:(NSArray *)inputArray
{
    [Waiting show];
//    [self showHudInView:webView.scrollView hint:@"加载中..."];
    NSString *shopprice = @"";
    NSString *proid = @"";
    NSString *mid = @"";
    @try {
        shopprice = [NSString stringWithFormat:@"%@",inputArray[2]];
        proid = [NSString stringWithFormat:@"%@",inputArray[1]];
        mid = [NSString stringWithFormat:@"%@",inputArray[3]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    //加载产品销售详细数据
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0139",@"apiid",shopprice,@"shopprice",proid,@"proid", mid,@"mid",nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
//        [self hideHud];
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        NSString *jsFuncName = [NSString stringWithFormat:@"loadOrderDetail('%@')",respondString];
        [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        [self hideHud];
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }];
}

//送酒提交成功以后
- (void)commitSucceed:(NSArray *)inputArray
{
    WebViewController *webViewController = [[WebViewController alloc] init];
    @try {
        
        webViewController.webURL = @"";
        webViewController.webType =  @"webUrl";
        webViewController.webTitle = @"提交成功";
        webViewController.narBarOffsetY = 50;
        NSString *url = @"";
        for (int i = 1; i < [inputArray count]; i++) {
            NSString *str = inputArray[i];
            if ([str hasPrefix:@"http"]) {
                url = [NSString stringWithFormat:@"%@%@//",url,str];
            }
            else if(![str isEqualToString:@""] && i != [inputArray count] - 1){
                url = [NSString stringWithFormat:@"%@%@/",url,str];
            }
            else if(![str isEqualToString:@""] && i == [inputArray count] - 1){
                url = [NSString stringWithFormat:@"%@%@",url,str];
            }
        }
        webViewController.webURL = url;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        webViewController.agentid = self.agentid;   //默认agentid 15017339307
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (void)jsGetParam
{
    if (jsJsonString == nil) {
        jsJsonString = @"";
    }
    NSString *jsFunc = [NSString stringWithFormat:@"jsGetParam('%@')",self.jsJsonString];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response.statusCode == 404 || response.statusCode == 403 || error) {
            // code for 404 or 403
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
            imageView.frame = CGRectMake((MAINSCREEN_WIDTH - 100)/2.0, 200, 100, 100);
            imageView.center = self.view.center;
            [self.view addSubview:imageView];
            activityIndicator.hidden = YES;
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
    //说明协议头是ios
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        if ([method rangeOfString:@"commitSucceed"].length == 0) {
            //送酒提交成功之后不要进行UTF8转换，中文名称会出现乱码
            method = [method
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        if([method isEqualToString:@"goldCarrot"]){
            //金萝卜签到
            [self goViewController:@"GoldCarrotController"];
        }else if([method isEqualToString:@"signIn"]){
            //签到
            [self goViewController:@"SignInController"];
        }else if ([method hasPrefix:@"zeroOneForProduct/"]){
            //0.1元购
            NSString  *mobile= [method stringByReplacingOccurrencesOfString:@"zeroOneForProduct/" withString:@""];
            
            [defaults setObject:mobile forKey:@"activityMobile"];//参加活动手机号
            
            ZeroOneController *zero = [[ZeroOneController alloc] init];
            NSString *imageUrl = [NSString stringWithFormat:@"%@/sysProduct/20140819143356515.jpg",IMAGESERVER];
            zero.woodInfo = @{@"activityName":ACTIVITY_ZEROONE,@"shopId":@"chunkang",@"shopName":@"活动特惠店铺",@"count":@"1",@"name":@"晓镇香 5陈酿125ml",@"contactTel":@"4009952220",@"Guid":@"6ccaa7c9-d363-45bc-bcac-4f06debb5426",@"img":imageUrl,@"price":@"0.10",@"SupplierLoginID":@""};//------活动商品信息
            ;
            zero.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zero animated:YES];
            
        }else if([method hasPrefix:@"OneYuanArea/&&/"]){
            //1元专区
            NSString  *params= [method stringByReplacingOccurrencesOfString:@"OneYuanArea/&&/" withString:@""];
            params = [params
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *paramsArr = [params componentsSeparatedByString:@"/&&/"];
            if (paramsArr.count >= 7) {
                /*
                 activityWoodInfo = @{@"activityName":ACTIVITY_ONEYUAN,@"shopId":paramsArr[3],@"shopName":@"活动特惠店铺",@"count":@"1",@"name":proName,@"contactTel":@"4009952220",@"Guid":paramsArr[0],@"img":paramsArr[2],@"agentID":paramsArr[4],@"SupplierLoginID":paramsArr[5],@"price":paramsArr[6],@"clickIsValid":paramsArr[7]};
                 topNavi_zeroOne.hidden = NO;
                 
                 NSLog(@"jfaiojfiogjrthpokopwd------%@",paramsArr);
                 //跳转
                 [self performSegueWithIdentifier:@"zeroOnePay" sender:self];
                 */
                [self goWoodsDetail:paramsArr[0] pageId:@"zeroOnePay" activityName:ACTIVITY_ONEYUAN otherParam:paramsArr[7]];//zeroOneForProductCheck
            }else{
                [self showHint:REQUESTERRORTIP];
            }
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

//同意方法调用
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

//到首页
-(void)goHomeViewController:(NSArray *) inputArray{
    if (inputArray.count > 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.tabBarController setSelectedIndex:0];
    [self setBarItemSelectedIndex:0];
}

//跳转商品详情
-(void)goProductDetailByGuid:(NSArray *)inputArray{
    NSString *otherMethod = nil;
    @try {
        otherMethod = inputArray[2];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (otherMethod) {
        SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",otherMethod]);
        if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:func withObject:inputArray];
#pragma clang diagnostic pop
        }
        return;
    }
    if (inputArray.count > 1) {
        NSString *guid = [inputArray objectAtIndex:1];
        
        GoodsDetailController *woodsDettail = [[GoodsDetailController alloc] initGoodsWithShopDict:shopDetailInfoDict];
        woodsDettail.hidesBottomBarWhenPushed = NO;
        
        woodsDettail.danModleGuid = guid;
        [self.navigationController pushViewController:woodsDettail animated:YES];
        
    }
}

- (void)gotoClassDetailWithClassID:(NSString *)classid
{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0073"};
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *jsonData = operation.responseString;
        NSDictionary *jsonDict = [jsonData objectFromJSONString];
        NSArray *classifyDataArr = [[jsonDict objectForKey:@"firstCategoryList"] objectForKey:@"firstCategorybean"];
        for (int i = 0; i < [classifyDataArr count]; i++) {
            NSString *tmpID = [classifyDataArr[i] objectForKey:@"ID"];
            if ([tmpID integerValue] == [classid integerValue]) {
                 NSDictionary *selectTypeDic = @{@"ID":[classifyDataArr[i] objectForKey:@"ID"],@"Name":[classifyDataArr[i] objectForKey:@"Name"],@"indexTag":[NSNumber numberWithInt:i]};
                ClassifyDetailController *classDetailVC = [[ClassifyDetailController alloc] init];
                classDetailVC.selectTypeDic = selectTypeDic;
                classDetailVC.classifyDataArr = classifyDataArr;
                classDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:classDetailVC animated:YES];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
        [self.view makeToast:@"网络错误请重试" duration:1.5 position:@"center"];
    }];
}

-(void)json_goClassView:(NSString *)jsonString
{
    NSDictionary *dict = [jsonString objectFromJSONString];
    NSString *vcValue = [dict objectForKey:@"classKey"];
    if ([vcValue isMemberOfClass:[NSNull class]] || vcValue == nil) {
        vcValue = @"";
    }
    Class myclass = NSClassFromString(vcValue);
    id object = [[myclass alloc] init];
    if ([object isKindOfClass:[UIViewController class]]) {
        if ([vcValue isEqualToString:@"ClassifyDetailController"]) {
            NSString *classID = [dict objectForKey:@"classID"];
            if ([classID isMemberOfClass:[NSNull class]] || classID == nil) {
                classID = @"";
            }
            //跳转到分类详情的页面
            [self gotoClassDetailWithClassID:classID];
            return;
        }
        UIViewController *myVC = (UIViewController *)object;
        myVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
}

- (void)parameter_postNotification:(NSArray *)inputArray
{
    
    NSString *notificationName = @"";
    NSString *jsValue = @"";
    @try {
        notificationName = inputArray[0];
        jsValue = inputArray[1];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (jsValue == nil) {
        jsValue = @"";
    }
    NSNotification *notification = [[NSNotification alloc] initWithName:notificationName object:nil userInfo:@{@"jsKey":jsValue}];
    if (notificationName) {
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)updateLastPage
{
    
}

- (void)selectShopModel:(NSNotification *)notification
{
    NSString *jsValue = [notification.userInfo objectForKey:@"jsKey"];
    NSDictionary *myDict = [jsValue objectFromJSONString];
    NSString *levelType = [myDict objectForKey:@"levelType"];
    NSString *jsFunction = [NSString stringWithFormat:@"InitShopTemplate('%@')",levelType];
    [webView stringByEvaluatingJavaScriptFromString:jsFunction];
}

//返回
-(void)onClickBack:(NSArray *)inputArray
{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回首页
-(void)goIndexPage:(NSArray *)inputArray{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//跳转到其他页面
-(void)goViewController:(NSString *)viewId{
    id myObj = [[NSClassFromString(viewId) alloc] init];
    if (myObj) {
        ((UIViewController *)myObj).hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:(UIViewController *)myObj animated:YES];
    }else{
        [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
    }
}

-(void)jsGetValue:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        if ([paramStr isEqualToString:@"memLoginID"]) {
            NSString *jsFuncName = [NSString stringWithFormat:@"javaAssignValue('%@')",memLoginID];
            [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
        }
    }
}

//-----单耳兔酒-------
-(void)goDanertuGoods:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        DanertuWoodsController *danController = [[DanertuWoodsController alloc] init];
        danController.currentSegmentNo = [paramStr integerValue];
        danController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:danController animated:YES];
    }
}
//---------调接口加载数据,并且把数据返回-------
-(void)jsGetData:(NSArray *) inputArray{
    if (inputArray.count>2) {
        NSString *paramStr = inputArray[1];
        NSString *callback = inputArray[2];
        BOOL canPostParam = YES;
        //var paramVcode = 'apiid|0078,;mobile|' + mobileNum + ',;vcode|' + vCode + ',;';
        NSMutableArray *paramArr = [[paramStr componentsSeparatedByString:@",;"] mutableCopy];
        if (paramArr.count>0) {
            [Waiting show];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *item in paramArr) {
                if (item ) {
                    NSArray *temArr = [item componentsSeparatedByString:@"|"];
                    if (temArr.count==2) {
                        NSString *valueStr = temArr[1];
                        if (!valueStr||[valueStr isEqualToString:@""]) {
                            if ([temArr[0] isEqualToString:@"memLoginID"]||[temArr[0] isEqualToString:@"memberid"]) {
                                valueStr = memLoginID;
                                NSLog(@"hugrgiehgiege-----%@",memLoginID);
                                if (!memLoginID||[memLoginID isEqualToString:@""]) {
                                    NSLog(@"hugrgiehgiege-----%@",memLoginID);
                                    canPostParam = NO;
                                    [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
                                    [self performSelector:@selector(onClickBack:) withObject:nil afterDelay:1.2];
                                }
                            }else if ([temArr[0] isEqualToString:@"shopid"]) {
                                valueStr = [[defaults objectForKey:@"currentShopInfo"] objectForKey:@"shopId"];//本地存储
                                if (!valueStr||[valueStr isEqualToString:@""]) {
                                    valueStr = CHUNKANGSHOPID;
                                }
                            }
                        }
                        if (valueStr) {
                            [params setObject:valueStr forKey:temArr[0]];
                        }
                    }else{
                        
                    }
                }
            }
            //可以提交----
            if (canPostParam) {
                NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                  path:@""
                                                            parameters:params];
                AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [Waiting dismiss];//隐藏loading
                    /*
                     NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//json解析
                     NSArray* temp = [jsonData objectForKey:@"val"];//数组
                     */
                    NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
                    NSLog(@"fewojfiogjrigio-------%@\n%@",source,dicData);
                    if (!source) {
                        source = @"false";
                    }
                    /*
                     source:  true
                     source:  该用户名已注册
                     */
                    if ([callback isEqualToString:@"YES"]) {
                        
                        if ([[[dicData valueForKey:@"mydazheList"] valueForKey:@"mydazhebean"] count] > 0) {
                            noDataView.hidden = YES;
                            NSString *jsFuncName = [NSString stringWithFormat:@"javaLoadData('%@')",source];
                            [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
                        }else{
                            //无数据
                            noDataView.hidden = NO;
                        }
                    }
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"gjoriejgioejoihtrh-----%@",error);
                    [Waiting dismiss];
                    [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                }];
                [operation start];
            }
        }
    }
}
-(void)jsShowMsg:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[1];
        [self.view makeToast:paramStr duration:1.2 position:@"center"];
    }
}
-(void)goShopDetail:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSString *shopId = inputArray[1];
        DetailViewController *detailV = [[DetailViewController alloc] init];
        detailV.agentid = shopId;
        //-----跳转----
        detailV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailV animated:YES];
    }
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

-(void)goNewControllerPage:(NSArray *)inputArray{
    if (inputArray.count > 3) {
        webURL = inputArray[1];
        webType =  inputArray[2];
        webTitle = inputArray[3];
        [self viewDidLoad];
    }
}

-(void)goToNewControllerPage:(NSArray *)inputArray{
    if (inputArray.count > 3) {
        WebViewController *webViewController = [[WebViewController alloc] init];
        @try {
            webViewController.webURL = inputArray[1];
            webViewController.webType = inputArray[2];
            webViewController.webTitle = inputArray[3];
            webViewController.narBarOffsetY = [inputArray[4] floatValue];
            if ([inputArray count] > 7) {
                NSString *url = @"";
                NSString *tmpAgentid = inputArray[5];
                webViewController.agentid = tmpAgentid;
                url = [self getUrlWithArray:inputArray];
                url = [NSString stringWithFormat:@"%@%@&platform=ios",url,tmpAgentid];
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

//搜索商品
- (void)json_SearchGoodsWithParams:(NSString *)jsonString
{
    NSDictionary *paramsDict = [jsonString objectFromJSONString];
    if (paramsDict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.jsJsonString = jsonString;
        paramsDict = [jsonString objectFromJSONString];
    }
    NSString *keyword = [paramsDict objectForKey:@"keyword"];
    NSInteger searchType = [[paramsDict objectForKey:@"searchType"] integerValue];
    if (searchType == 0) {
        //搜索商品
        WoodDataController *woodController = [[WoodDataController alloc] init];
        woodController.searchKeyWord = keyword;
        woodController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:woodController animated:YES];
    }
    else{
        //搜索店铺
        SearchShopViewController *searchShopVC = [[SearchShopViewController alloc] init];
        searchShopVC.keyWord = keyword;
        searchShopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchShopVC animated:YES];
    }
}

- (void)json_gotoNewController:(NSString *)jsonString
{
    NSDictionary *paramsDict = [jsonString objectFromJSONString];
    if (paramsDict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.jsJsonString = jsonString;
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

- (void)json_gotoInfoDetail:(NSString *)jsonString
{
    NSDictionary *paramsDict = [jsonString objectFromJSONString];
    if (paramsDict == nil) {
        jsonString = [jsonString
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.jsJsonString = jsonString;
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
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)addShopInfo:(NSArray *)inputArray
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.webURL = inputArray[1];
    webVC.webType =  inputArray[2];
    webVC.webTitle = inputArray[3];
    webVC.narBarOffsetY = 50;
    webVC.agentid = self.agentid;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)editShopInfo:(NSArray *)inputArray
{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.webURL = inputArray[1];
    webVC.webType =  inputArray[2];
    webVC.webTitle = inputArray[3];
    webVC.narBarOffsetY = 50;
    webVC.agentid = self.agentid;
    webVC.infoGuid = self.infoGuid;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

//------跳转到商品详情页-----
-(void)goWoodsDetail:(NSString *)guid pageId:(NSString *)pageViewId activityName:(NSString*)name otherParam:(NSString *)clickValid{
    [Waiting show];//-----loading-----
//    [self showHudInView:webView.scrollView hint:@"跳转中..."];
    //这里修改为异步的请求方式，同步会出现界面跳转的卡顿
    NSDictionary *params = @{@"apiid":@"0026",@"proId":guid};
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
//        [self hideHud];
        [Waiting dismiss];
        NSString *temp = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        NSData *jsonDataTmp = [temp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (jsonData) {
            NSArray *shopInfoArr = [jsonData objectForKey:@"val"] ;
            if (shopInfoArr.count>0) {
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
                //-------一元区--------
                NSString *contactTel = [shopInfoDic objectForKey:@"contactTel"];
                if (!contactTel) {
                    contactTel = @"4009952220";
                }
                
                //------跳转------
                
                ZeroOneController *zero = [[ZeroOneController alloc] init];
                zero.woodInfo = @{@"clickIsValid":clickValid,@"activityName":name,@"shopId":CHUNKANGSHOPID,@"shopName":@"醇康",@"count":@"1",@"name":[shopInfoDic objectForKey:@"Name"],@"contactTel":contactTel,@"Guid":guid,@"img":imgUrl,@"agentId":AgentId,@"price":[shopInfoDic objectForKey:@"ShopPrice" ],@"SupplierLoginID":SupplierLoginID,@"mobileProductDetail":[shopInfoDic objectForKey:@"Detail"]};//------活动商品信息
                ;
                zero.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:zero animated:YES];
                
            }else{
                [self showHint:REQUESTERRORTIP];
            }
        }else{
            [self showHint:REQUESTERRORTIP];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
//        [self hideHud];
        [self showHint:REQUESTERRORTIP];
        
    }];
    
    return;
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0026&proId=%@",guid];
    
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    if(!requestOperation.error){
//        [self hideHud];
        [Waiting dismiss];
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
                //-------一元区--------
                NSString *contactTel = [shopInfoDic objectForKey:@"contactTel"];
                if (!contactTel) {
                    contactTel = @"4009952220";
                }
                
                //------跳转------
                
                ZeroOneController *zero = [[ZeroOneController alloc] init];
                zero.woodInfo = @{@"clickIsValid":clickValid,@"activityName":name,@"shopId":CHUNKANGSHOPID,@"shopName":@"醇康",@"count":@"1",@"name":[shopInfoDic objectForKey:@"Name"],@"contactTel":contactTel,@"Guid":guid,@"img":imgUrl,@"agentId":AgentId,@"price":[shopInfoDic objectForKey:@"ShopPrice" ],@"SupplierLoginID":SupplierLoginID,@"mobileProductDetail":[shopInfoDic objectForKey:@"Detail"]};//------活动商品信息
                ;
                zero.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:zero animated:YES];
                
            }else{
                [self showHint:REQUESTERRORTIP];
            }
        }else{
            [self showHint:REQUESTERRORTIP];
        }
    }else{
//        [self hideHud];
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectShopModel" object:nil];
}

@end