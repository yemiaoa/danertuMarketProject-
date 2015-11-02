//
//  KKAppDelegate.m
//  Tuan
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
#import "KKAppDelegate.h"
#import "IQKeyboardManager.h"
#import "CustomNavigationController.h"
BMKMapManager* _mapManager;

@implementation KKAppDelegate{
     sqlite3 *database;
}

@synthesize defaults;
@synthesize publicKey;
@synthesize priceScore;
@synthesize window = _window;
@synthesize queue;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    //IOS6.0上面接收到推送的时候执行的方法
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
    [self performSelector:@selector(receiveNotification:) withObject:userInfo afterDelay:0.5];
}


//avoid compile error for sdk under 7.0
#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //IOS7收到推送执行的方法
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    
    [self performSelector:@selector(receiveNotification:) withObject:userInfo afterDelay:0.5];
}
#endif


//当接收到推送通知，并且设备激活后的处理事件
-(void)receiveNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initialization];
    [self launchBaiDuMap];
    [self initAPServiceWithOptions:launchOptions];
    [self umengTrack];
    [self initshareSDK];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(clearImg:) object:nil];
    
    [operation setQueuePriority:NSOperationQueuePriorityNormal];
    [operation setCompletionBlock:^{
        //不上传到iCloud
        [Tools canceliClouldBackup];
    }];
    queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    [queue setMaxConcurrentOperationCount:1];
    
    return YES;
}

//初始化
- (void)initialization
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    //一个单例，初始化之后就开始识别当前网络是否可用
    [Dao sharedDao];
    defaults =[NSUserDefaults standardUserDefaults];
    //检测版本号
    queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:1];
    NSInvocationOperation *check_operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(checkAppVersion) object:nil];
    [check_operation setQueuePriority:NSOperationQueuePriorityLow];
    [queue addOperation:check_operation];
}

-(void)clearImg:(id)sender
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    
    NSString *libraryfolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
    
    NSString *myPath=[libraryfolderPath stringByAppendingPathComponent:@"DanertuDocument"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:myPath]) {
        [fm createDirectoryAtPath:myPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *asynImagePath=[myPath stringByAppendingPathComponent:@"AsynImage"];
    if(![fm fileExistsAtPath:asynImagePath])
    {
        [fm createDirectoryAtPath:asynImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    childFilesEnumerator = [[manager subpathsAtPath:asynImagePath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [asynImagePath stringByAppendingPathComponent:fileName];
        BOOL result = [manager removeItemAtPath:fileAbsolutePath error:nil];
        if (result) {
            NSLog(@"remove asynimage succeed");
        }
        else{
            NSLog(@"remove asynimage faild");
        }
        
        
    }
}

//检测版本更新
- (void)checkAppVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *mark = @""; //标记 空为正常版本 test为测试版本 shopid为定制版本
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"0138",@"apiid",version,@"iosversion",mark,@"mark", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondstring = operation.responseString;
        id respondObj = [respondstring objectFromJSONString];
        if (respondObj) {
            HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
            singleModel.versionDict = respondObj;
            NSString *downloadUrl = [respondObj objectForKey:@"url"];
            if (downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
                //无更新
                return;
            }
            //有更新，但是需要判断是否AppStore上面的版本
            NSString *checkStatus = [respondObj objectForKey:@"checkstatus"];
            if ([checkStatus isMemberOfClass:[NSNull class]]) {
                checkStatus = @"";
            }
            if ([UPDATEMARK isEqualToString:@""] && (checkStatus == nil || [checkStatus isEqualToString:@""] || [checkStatus compare:@"NO" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
                //表明在AppStore上面正在审核的版本，因此把自动更新给屏蔽
                return;
            }
            if ([UPDATEMARK isEqualToString:@""]) {
                //如果是AppStore上面的版本，分享出去的是AppStore上的下载连接地址
                if ([downloadUrl isMemberOfClass:[NSNull class]] || downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
                    downloadUrl = SHAREURL;
                }
            }
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"“单耳兔商城”有新版本，现在更新？" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上更新", nil];
            alertview.accessibilityIdentifier = downloadUrl;
            [alertview show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.accessibilityIdentifier]];
            break;
        }
        default:
            break;
    }
}

//启动百度地图
- (void)launchBaiDuMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BAIDUMAPKEY generalDelegate:self];
    
    if (!ret) {
        NSLog(@"百度地图启动失败");
    }
    else{
        NSLog(@"百度地图启动成功");
    }
}

//初始化极光推送
- (void)initAPServiceWithOptions:(NSDictionary *)launchOptions
{
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [APService setLogOFF];
}

//初始化shareSDK
- (void)initshareSDK
{
    [ShareSDK registerApp:SHARESDKKEY];
    // Override point for customization after application launch.
    [ShareSDK connectSMS];//
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:TencentWeiboKey
                                  appSecret:TencentWeiboAppSecret
                                redirectUri:APPSTOREDOWNLOADURL
                                   wbApiCls:[WeiboApi class]];
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:TencentWeiboKey
                           appSecret:TencentWeiboAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:QZoneAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:WeChatAppId
                           wechatCls:[WXApi class]];
}

//初始化友盟的SDK
- (void)umengTrack
{
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:UMANALYSISKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setBackgroundTaskEnabled:YES];
    [MobClick setLogSendInterval:3600];//每隔两小时上传一次
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
}



- (void)serviceError:(NSNotification *)notification {
    //    NSDictionary *userInfo = [notification userInfo];
    //    NSString *error = [userInfo valueForKey:@"error"];
    //    NSLog(@"%@", error);
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    //    NSDictionary * userInfo = [notification userInfo];
    //    NSString *title = [userInfo valueForKey:@"title"];
    //    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //如果在线的情况下所需要执行的方法
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[defaults setObject:arrays forKey:@"storeCurrentData"];//-----保存数据,用于恢复
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [[LocationSingleton sharedInstance] startLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//支付
//独立客户端回调函数,支付宝支付回调,分享回调,
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//	[self parse:url application:application];
	return YES;
    /*
     return [ShareSDK handleOpenURL:url wxDelegate:self];
     return [ShareSDK handleOpenURL:url
     wxDelegate:self];
     */
}

//------分享使用------这个严重影响了支付宝支付结果的回调------
/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
*/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    /*
     此处必须执行,不然的话在设备安装支付宝app的情况下,
     使用支付宝支付时,获取不到支付结果的回调
     */
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
    
    }];
    
//    NSString *urlStr  = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"jgoreigoiejgioe--%@---%@--%@",urlStr,url,url.host);
//    if ([url.host isEqualToString:@"safepay"]) {
//        if ([urlStr rangeOfString:@"\"ResultStatus\":\"9000\""].location!=NSNotFound) {
//            //------发送通知-------
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"realRecharge" object:nil userInfo:@{@"result":@"true"}];//发送通知,重新加载未支付订单
//            NSLog(@"gjireojgieorg-----");
//            
//            //----未支付订单支付完成------发送通知--------
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"initOrderList" object:nil userInfo:nil];//发送通知,重新加载未支付订单
//        }
//
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
//            NSLog(@"resultDic:%@",resultDic);
//        }];
//        
//        [[AlipaySDK defaultService] processAuth_V2Result:url
//                                         standbyCallback:^(NSDictionary *resultDic) {
//                                             
//                                             NSString *resultStr = resultDic[@"result"];
//                                             NSLog(@"hfeufhe = %@,%@",resultDic,resultStr);
//                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"realRecharge" object:nil userInfo:@{@"result":@"true"}];//发送通知,重新加载未支付订单
//                                         }];
//    }
    
    return YES;
}

-(void)invokeOhterApi{
    
    //验证签名成功，交易结果无篡改
    NSString *ordernumber = [defaults objectForKey:@"tradeNO"];//--刚刚进行的交易号
    
    NSMutableArray *tempArray = [defaults objectForKey:@"NotPayedOrderList"];//订单--------本地存储
    NSMutableArray *tempArray1  = [[NSMutableArray alloc] init];
    NSMutableArray *_tempArray = [defaults objectForKey:@"PayedOrderList"];//订单--------本地存储
    NSMutableArray *_tempArray1  = [[NSMutableArray alloc] init];
    if(tempArray){
        tempArray1 = [tempArray mutableCopy];
    }
    if(_tempArray){
        _tempArray1 = [_tempArray mutableCopy];
    }
    for (NSDictionary *item in tempArray1) {
        if ([[item objectForKey:@"tradeNO"] isEqualToString:ordernumber]) {
            [_tempArray1 addObject:item];
            [tempArray1 removeObject:item];
            priceScore = [[item objectForKey:@"price"] intValue];
            [defaults setObject:tempArray1 forKey:@"NotPayedOrderList"];
            [defaults setObject:_tempArray1 forKey:@"PayedOrderList"];
            break;
        }
    }
    
    
    NSMutableArray *orderWoodsArray = [defaults objectForKey:@"NotPayedOrderWoodsArray"];//订单--------本地存储
    NSMutableArray *orderWoodsArray1  = [[NSMutableArray alloc] init];
    NSMutableArray *_orderWoodsArray = [defaults objectForKey:@"PayedOrderWoodsArray"];//订单--------本地存储
    NSMutableArray *_orderWoodsArray1  = [[NSMutableArray alloc] init];
    if(orderWoodsArray){
        orderWoodsArray1 = [orderWoodsArray mutableCopy];
    }
    if(_orderWoodsArray){
        _orderWoodsArray1 = [_orderWoodsArray mutableCopy];
    }
   
    for (NSDictionary *itemWood in orderWoodsArray1) {
        if ([[itemWood objectForKey:@"tradeNO"] isEqualToString:ordernumber]) {
            [orderWoodsArray1 removeObject:itemWood];//--移除旧的---
            [_orderWoodsArray1 addObject:itemWood];//--添加到已支付
            [defaults setObject:orderWoodsArray1 forKey:@"NotPayedOrderWoodsArray"];//
            [defaults setObject:_orderWoodsArray1 forKey:@"PayedOrderWoodsArray"];//
            break;
        }
    }
    
    NSDictionary * params1 = @{@"apiid": @"0061",@"score" :[NSString stringWithFormat:@"%d",priceScore],@"mid": [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"]};
    NSLog(@"locationString---------:%@",params1);
    NSURLRequest * request1 = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                   path:@""
                                             parameters:params1];
    AFHTTPRequestOperation * operation1 = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request1 success:^(AFHTTPRequestOperation *operation1, id responseObject) {
        NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([source isEqualToString:@"true"]) {
            priceScore = priceScore + [[[defaults objectForKey:@"userLoginInfo"] objectForKey:@"Score"] intValue];
            NSDictionary *nb = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:priceScore],@"Score", nil];
            NSMutableDictionary *tmp = [[defaults objectForKey:@"userLoginInfo"] mutableCopy] ;
            [tmp setObject:[NSString stringWithFormat:@"%d",priceScore] forKey:@"Score"];//----修改分数---
            [defaults setObject:tmp forKey:@"userLoginInfo"];//----保存登录信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlareScore" object:nil userInfo:nb];//刷新Myview上显示的-------分数
        }
        
    } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
        
        //[Waiting dismiss];//----隐藏loading----
    }];
    [operation1 start];//-----发起请求------
    
    //发送通知,传递参数:订单号
    NSDictionary *userInfoDic = @{@"orderNo":ordernumber};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPayment" object:nil userInfo:userInfoDic];//发送通知,重新加载未支付订单

    [[NSNotificationCenter defaultCenter] postNotificationName:@"realRecharge" object:nil userInfo:@{@"result":@"true"}];//发送通知,重新加载未支付订单
    
}

//-------创建数据库----
/**
 * @brief 创建数据库
 */
- (void) createDataBase {
    FMDatabase * _db = [SDBManager defaultDBManager].dataBase;
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = 'signInRecord'"]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE signInRecord (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, memLoginId VARCHAR(20), signDate CHAR(10),comment VARCHAR(30))";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            
        } else {
            
        }
    }
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    NSLog(@"memory warning,kkappdelegate---");
}
@end
