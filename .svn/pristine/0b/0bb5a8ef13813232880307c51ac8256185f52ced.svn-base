//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "WalletViewController.h"
#import "HeGetCashVC.h"
#import "KKAppDelegate.h"

enum payType{
    DANERTUPAY,
    ALIPAY,
    WEBCHATPAY,
    UNIONPAY,
};
@implementation WalletViewController{
    BOOL showFinishButton;
    BOOL moreAvailable;//更多按钮是否可以点击
    AFHTTPClient * httpClient ;
    NSString *loginId;
    enum payType payOffType;
    UITextField *_userPwd ;
    UIView *alertV;
    UIView *maskV;
    NSString *finishBtntitle;
    double borderGap;
    CGFloat narBarOffsetY;
}

@synthesize addStatusBarHeight;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize webType;
@synthesize defaults;
@synthesize jsJsonString;

- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (id)init
{
    if (self = [super init]) {
        showFinishButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [((KKAppDelegate *)[UIApplication sharedApplication].delegate).window makeKeyAndVisible];
}

#pragma mark - method initialization
- (void)initialization
{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    narBarOffsetY = 50;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT + 49)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    payOffType = ALIPAY;///默认支付宝支付
    defaults = [NSUserDefaults standardUserDefaults];
    loginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    
    if ([webType isEqualToString:@"localPage"]) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:webURL ofType:nil inDirectory:@"www"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    }else if ([webType isEqualToString:@"webUrl"]) {
        NSString *appVersion = [Tools getAppVersion];
        NSString *webURL_full = [NSString stringWithFormat:@"%@/%@?version=%@",SELLERURLADDRESS,webURL,appVersion];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL_full]]];
    }
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor];
    [activityIndicator startAnimating];
    [activityIndicator setHidesWhenStopped:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realRecharge:) name:@"realRecharge" object:nil];//和 appdelegate  之间的消息传递
}

//修改标题,重写父类方法
-(NSString*)getTitle{
    return webTitle;
}

//搜索按钮
-(BOOL)isShowFinishButton{
    return showFinishButton;
}

//完成按钮标题
-(NSString*)getFinishBtnTitle{
    return finishBtntitle;
}

#pragma mark - method 点击更多或者完成
-(void) clickFinish{
    if ([finishBtntitle isEqualToString:@"更多"]) {
        if (moreAvailable) {
            NSString *webURL_full = [NSString stringWithFormat:@"%@/wallet_set.html",PAGEURLADDRESS];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL_full]]];
            webTitle = @"钱包设置";
            showFinishButton = NO;
            [super viewDidLoad];
        }
        else{
            [self.view makeToast:@"请设置支付密码" duration:1.2 position:@"center"];
        }
    }
    else if ([finishBtntitle isEqualToString:@"完成"]) {
        NSLog(@"完成");
    }
    
}


#pragma mark - method 点击回退或者返回
-(void)onClickBack
{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *lastURL = [webView stringByEvaluatingJavaScriptFromString:@"document.referrer"];
    
    
    if ([currentURL rangeOfString:webURL].location == NSNotFound) {
        
        if ([currentURL rangeOfString:@"wallet_index_second.html"].location != NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [webView goBack];
        if ([currentURL rangeOfString:@"wallet_set.html"].location!=NSNotFound) {
            webTitle = @"我的钱包";
            finishBtntitle = @"更多";
            showFinishButton = YES;
            [super viewDidLoad];
        }else if ([currentURL rangeOfString:@"wallet_withdraw_1.html"].location!=NSNotFound) {
            [webView goBack];
            webTitle = @"我的钱包";
            finishBtntitle = @"更多";
            showFinishButton = YES;
            [super viewDidLoad];
        }else if([currentURL rangeOfString:@"Android_wallet_pay_success.html"].location!=NSNotFound){
            [webView goBack];
            webTitle = @"我的钱包";
            finishBtntitle = @"更多";
            showFinishButton = YES;
            [super viewDidLoad];
        }
        if ([lastURL rangeOfString:@"wallet_index_second"].location != NSNotFound || [lastURL isEqualToString:@""]) {
            finishBtntitle = @"更多";
            showFinishButton = YES;
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - method 展示信息
-(void)parameter_jsShowMsg:(NSArray *)inputArray{
    if(inputArray.count>0){
        [self.view makeToast:inputArray[0] duration:1.2 position:@"center"];
    }
}

#pragma mark - method 获取登录的ID
-(void)func_getMemberId{
    if (loginId) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getMemberId_callBack('%@')",loginId]];
    }else{
        [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.2];
    }
}

#pragma mark - method 弹出窗口验证支付密码
-(void)parameter_inShopPay:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *paramStr = [inputArray firstObject];
        [[PayMMSingleton sharedInstance] showPayMMUi:self.view result:^(BOOL isRight){
            if (isRight) {
                NSMutableArray *paramArr = [[paramStr componentsSeparatedByString:@",;"] mutableCopy];
                if (paramArr.count>0) {
                    [Waiting show];
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    NSString *apiid;
                    NSInteger i = 0;
                    for (NSString *item in paramArr) {
                        if (item ) {
                            NSArray *temArr = [item componentsSeparatedByString:@"|"];
                            if (temArr.count==2) {
                                if (i) {
                                    apiid = temArr[1];
                                }
                                i++;
                                [params setObject:temArr[1] forKey:temArr[0]];
                            }else{
                                //                        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                            }
                        }
                    }
                    
                    NSLog(@"jfewogjrrtihohirjfeoiwjiow----%@-----%@",paramArr,params);
                    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
                    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                                  path:@""
                                                            parameters:params];
                    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loading
                        NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
                        NSLog(@"fewojgkopfiogjrigio-------%@\n%@",source,dicData);
                        if (!source) {
                            source = @"false";
                        }
                        NSString *jsFuncName = [NSString stringWithFormat:@"javaLoad('%@')",source];
                        [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
                        webTitle = @"付款";
                        showFinishButton = NO;
                        [super viewDidLoad];
                        
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"gregjoeijorth-----%@",error);
                        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                    }];
                    [operation start];
                }
            }
        } cancle:^(BOOL isCancle){
        }];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 调接口加载数据,并且把数据返回
//调接口加载数据,并且把数据返回
-(void)parameter_jsGetData:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = inputArray[0];
        NSString *callback = inputArray[1];
        //var paramVcode = 'apiid|0078,;mobile|' + mobileNum + ',;vcode|' + vCode + ',;';
        NSMutableArray *paramArr = [[paramStr componentsSeparatedByString:@",;"] mutableCopy];
        if (paramArr.count>0) {
            [Waiting show];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            NSString *apiid;
            NSInteger i = 0;
            for (NSString *item in paramArr) {
                if (item ) {
                    NSArray *temArr = [item componentsSeparatedByString:@"|"];
                    if (temArr.count==2) {
                        if (i) {
                            apiid = temArr[1];
                        }
                        i++;
                        [params setObject:temArr[1] forKey:temArr[0]];
                        if ([temArr[0] isEqualToString:@"pwd"]) {
                            NSString *enStr  = Crypto.MD5Encode([temArr[1] dataUsingEncoding:NSUTF8StringEncoding]);
                            [params setObject:enStr forKey:temArr[0]];
                        }
                    }else{
                        //                        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                    }
                }
            }
            
            
            NSLog(@"jfewojfeoiwjiow----%@-----%@",paramArr,params);
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    NSString *jsFuncName = [NSString stringWithFormat:@"javaLoadData('%@')",source];
                    [webView stringByEvaluatingJavaScriptFromString:jsFuncName];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"gregjoeijorth-----%@",error);
                [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
            }];
            [operation start];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404 || alertView.tag == 403) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)getCashSucceed
{
    [webView reload];
}

#pragma mark - method 跳转到提现界面
- (void)func_getCash
{
    HeGetCashVC *getCashVC = [[HeGetCashVC alloc] init];
    getCashVC.getCashDelegate = self;
    getCashVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:getCashVC animated:YES];
}

#pragma mark - method 跳转到绑定的界面
- (void)parameter_goBindCard:(NSArray *)inputArray
{
    NSString *jsonString = [inputArray firstObject];
    NSDictionary *dict = [jsonString objectFromJSONString];
    NSString *filename = [dict objectForKey:@"filename"];
    NSString *bindTitle = [dict objectForKey:@"bindTitle"];
//    NSInteger bindType = [[dict objectForKey:@"bindType"] integerValue]; //绑定的类型 1：支付宝 0：银行卡
    
    NSString *webURL_full = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,filename];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL_full]]];
    webTitle = bindTitle;
    showFinishButton = NO;
    [super viewDidLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webViewTmp
{
    webViewTmp.scrollView.showsVerticalScrollIndicator = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp
{
    [activityIndicator stopAnimating]; // 结束旋转
    NSString *currentTitle = [webViewTmp stringByEvaluatingJavaScriptFromString:@"document.title"];
    webTitle = currentTitle;
    self.topNaviText.text = currentTitle;
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //不带参数的直接方法名
        if([method hasPrefix:@"func_"]){
            SEL func = NSSelectorFromString(method);
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func];
#pragma clang diagnostic pop
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

#pragma mark - method 跳转到其他页面
-(void)goViewController:(NSString *)viewId{
    id myObj = [[NSClassFromString(viewId) alloc] init];
    if (myObj) {
        ((UIViewController *)myObj).hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:(UIViewController *)myObj animated:YES];
    }else{
        [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 初始化加载，获取绑定银行卡,账户余额
-(void)func_loadAccountInfo{
    [Waiting show];
    NSString *payMM = [self getPayMM];
    NSString *bindMobile = [self getBindMobile];
    if (payMM.length>5&&bindMobile.length>5&&![payMM isEqualToString:@"e10adc3949ba59abbe56e057f20f883e"]) {
        //完成过初始化的,才去显示余额
        [self func_getBalance];
        NSString *funcStr = [NSString stringWithFormat:@"bindCard('%@')",[self func_getBindCard]];
        [webView stringByEvaluatingJavaScriptFromString:funcStr];
        moreAvailable = YES;
        finishBtntitle = @"更多";
        [self getCashInfo];
        [super viewDidLoad];
    }else{
        finishBtntitle = @"";
        moreAvailable = NO;
        [webView stringByEvaluatingJavaScriptFromString:@"notInit()"];
        [super viewDidLoad];
    }
    [Waiting dismiss];
}

#pragma mark - method 获取取提现信息
- (void)getCashInfo
{
    NSDictionary * params = @{@"apiid": @"0244",@"shopid" : loginId};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *funcStr = [NSString stringWithFormat:@"GetTxInfo('%@')",result];
        [webView stringByEvaluatingJavaScriptFromString:funcStr];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
        //        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

#pragma mark - method 获取绑定的银行卡或者支付宝账号信息
-(NSString *)func_getBindCard{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0150&memloginid=%@",loginId];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSString *result;
    if (![requestOperation error]) {
        result = requestOperation.responseString;
    }else{
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
    }
    return result;
}

#pragma mark - method 读取余额
-(void)func_getBalance{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0108",@"memloginid" : loginId}; //原先使用0224接口
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *funcStr = [NSString stringWithFormat:@"showBalance('%@')",result];
        [webView stringByEvaluatingJavaScriptFromString:funcStr];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

#pragma mark - method 获取验证码
- (void)getVerCodeWith:(NSString *)bindMobile
{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0077",@"mobile" : bindMobile};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([temp isEqualToString:@"true"]) {
            [self.view makeToast:@"验证码已发送,请注意查收" duration:1.2 position:@"center"];
        }else{
            [self.view makeToast:@"发送失败,请稍后重试" duration:1.2 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

#pragma mark - method 判断输入的手机号是否当前账号的绑定手机号
//获取验证码，获取验证码之前应当首先判断输入的手机号是否当前账号的绑定手机号
-(void)parameter_getVerifyCode:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *bindMobile = [inputArray firstObject];
        [Waiting show];
        NSString *loginid = [Tools getUserLoginNumber];
        NSDictionary *params = @{@"apiid":@"0114",@"memloginid":loginid};
        [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            [Waiting dismiss];
            NSString *respondPhone = operation.responseString;
            respondPhone = [respondPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([respondPhone isMemberOfClass:[NSNull class]] || respondPhone == nil) {
                //尚未绑定手机号
                respondPhone = @"";
            }
            
            if ([respondPhone isEqualToString:bindMobile] || [respondPhone isEqualToString:@""]) {
                [self getVerCodeWith:bindMobile];
            }
            else{
                [self showHint:@"此手机号非本账号绑定手机号"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [Waiting dismiss];
            [self showHint:REQUESTERRORTIP];
        }];
        
        
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
    
}

#pragma mark - method 验证验证码，手机号
-(void)parameter_checkVerifyCode:(NSArray *) inputArray{
    if (inputArray.count>2) {
        NSString *funcFlag = [inputArray firstObject];
        NSString *vcode = [inputArray objectAtIndex:1];
        NSString *bindMobile = [inputArray objectAtIndex:2];
        [Waiting show];
        NSDictionary * params = @{@"apiid": @"0078",@"mobile" : bindMobile,@"vcode" : vcode};
        NSLog(@"rewrwgjiroejgoreoigeroi------%@",params);
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([temp isEqualToString:@"true"]) {
                if ([funcFlag isEqualToString:@"check"]) {
                    if ([bindMobile isEqualToString:[self getBindMobile]]) {
                        [self loadOtherPage:@"wallet_forgetpassword1.html"];
                    }else{
                        [self.view makeToast:@"绑定手机号错误" duration:1.2 position:@"center"];
                    }
                }else if ([funcFlag isEqualToString:@"bind"]) {
                    [self parameter_bindMobile:@[bindMobile]];
                }
            }else{
                [self.view makeToast:@"验证码错误,请重新输入" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jgrioejgirejoige-----%@",error);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 提取现金
//校验绑定手机
//提现
-(void)parameter_withdraw:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *chargeMoney = @"";//----提现金额----
        NSString *payPwd = @"";
        NSString *type = @"";
        @try {
            chargeMoney = [inputArray firstObject];//----提现金额----
            payPwd = [inputArray objectAtIndex:1];
            type = inputArray[2];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        if (chargeMoney == nil) {
            chargeMoney = @"";
        }
        if (payPwd == nil) {
            payPwd = @"";
        }
        if (type == nil) {
            type = @"";
        }
        payPwd = Crypto.MD5Encode([payPwd dataUsingEncoding:NSUTF8StringEncoding]);
        if ([payPwd isEqualToString:[self getPayMM]]) {
            [Waiting show];
            NSDictionary * params = @{@"apiid": @"0108",@"memloginid" : loginId};
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params];
            AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([result doubleValue]>=[chargeMoney doubleValue]) {
                    NSString *key = [NSString stringWithCString:"abcdef1234567890" encoding:NSUTF8StringEncoding];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyyMMddHHmm"];
//                    NSString *theDate = [dateFormat stringFromDate:[[NSDate alloc] init]];
//                    NSString *RechargeCode = [NSString stringWithFormat:@"%@%d",theDate,arc4random()/1000];
                    //----版本号-----
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                    NSString *remark = [NSString stringWithFormat:@"Ios(%@)提现",appVersion];
                    NSString *sourcePostStr = [NSString stringWithFormat:@"%@|%@|%@|0",loginId,chargeMoney,remark];
                    NSString *encryptPostStr = [AES128Util AES128Encrypt:sourcePostStr key:key];
                    [Waiting show];
                    NSDictionary * params = @{@"apiid": @"0105",@"strDetinfo" : encryptPostStr};
                    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
                    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loading
                        
                        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
                            [self loadOtherPage:@"wallet_withdraw_1.html"];
                            webTitle = @"提现";
                            showFinishButton = NO;
                            [super viewDidLoad];
                            
                        }else{
                            [self.view makeToast:[resultDic objectForKey:@"info"] duration:1.2 position:@"center"];
                        }
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
                        [Waiting dismiss];//隐藏loading
                    }];
                    [operation start];
                }else{
                    [self.view makeToast:@"余额不足" duration:1.2 position:@"center"];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
                [Waiting dismiss];//隐藏loading
            }];
            [operation start];
        }else{
            [self.view makeToast:@"支付密码错误" duration:1.2 position:@"center"];
        }
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 验证支付密码
-(void)parameter_checkPayMM:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *pageName = [inputArray firstObject];
        NSString *payPwd = [inputArray objectAtIndex:1];
        payPwd = Crypto.MD5Encode([payPwd dataUsingEncoding:NSUTF8StringEncoding]);
        if ([payPwd isEqualToString:[self getPayMM]]) {
            [self loadOtherPage:pageName];
        }else{
            [self.view makeToast:@"支付密码错误" duration:1.2 position:@"center"];
        }
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 绑定银行卡或者支付宝
-(void)parameter_bindCard:(NSArray *) inputArray{
    if (inputArray.count>1) {
        [Waiting show];
        NSString *otherPageFlag = @"";
        NSString *cardNo = @"";
        NSString *realName = @"";
        NSString *bankDetailName = @"";
        NSString *type = @"";  //0:银行卡  //1：支付宝
        
        @try {
            otherPageFlag = [inputArray firstObject];
            cardNo = [inputArray objectAtIndex:1];
            
            realName = [inputArray objectAtIndex:3];
            bankDetailName = [inputArray objectAtIndex:2];
            type = [inputArray objectAtIndex:4];  //0:银行卡  //1：支付宝
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        if (otherPageFlag == nil) {
            otherPageFlag = @"";
        }
        if (cardNo == nil) {
            cardNo = @"";
        }
        if (realName == nil) {
            realName = @"";
        }
        if (bankDetailName == nil) {
            bankDetailName = @"";
        }
        if (type == nil) {
            type = @"0";
        }
        NSString *cardNoKey = @"cardnumber";
        if ([type integerValue] == 1) {
            cardNoKey = @"alipayAccount";
        }
        NSDictionary * params = @{@"apiid": @"0109",@"memloginid":loginId,cardNoKey: cardNo,@"type":type,@"realName":realName,@"bankDetailName":bankDetailName};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
            [self.view makeToast:[tempDic objectForKey:@"info"] duration:2.0 position:@"center"];
            if ([[tempDic objectForKey:@"result"] isEqualToString:@"true"]) {
                //银行卡绑定成功
                if (otherPageFlag.length>1) {
                    //----加载新页面
                    showFinishButton = YES;
                    [self loadOtherPage:otherPageFlag];
                }else if(otherPageFlag.length==1){
                    //----后退
                    int times = (int)[otherPageFlag integerValue];
                    for (int i=0; i<times; i++) {
                        [webView goBack];
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jgrioejgirejoige-----%@",error);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 加载其他页面
-(void)loadOtherPage:(NSString *)pageName
{
    NSString *webURL_full = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,pageName];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL_full]]];
}

#pragma mark - method 绑定手机号
-(void)parameter_bindMobile:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *mobile = [inputArray firstObject];
        [Waiting show];
        NSDictionary * params = @{@"apiid": @"0113",@"memloginid":loginId,@"mobile": mobile};
        NSLog(@"jijijiferewrwgjiroejgoreoigeroi------%@",params);
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
            NSLog(@"fkoeopewopk09gjrioejgrieojfeoiwbnutqwoprejiogejoig-----%@",tempDic);
            [self.view makeToast:[tempDic objectForKey:@"info"] duration:2.0 position:@"center"];
            if ([[tempDic objectForKey:@"result"] isEqualToString:@"true"]) {
                //-----支付密码设置成功------
                [self loadOtherPage:@"wallet_index_second.html"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jgrioejgirejoige-----%@",error);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
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

- (void)json_getAgentProduct:(NSString *)jsonString
{
    self.jsJsonString = jsonString;
    NSDictionary *dict = [jsonString objectFromJSONString];
    [Waiting show];
    [[AFOSCClient sharedClient] postPath:nil parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *respondString = operation.responseString;
        if ([respondString compare:@"true" options:NSCaseInsensitiveSearch]) {
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

//js获取上级js所传的js参数
- (void)jsGetParam
{
    if (jsJsonString == nil) {
        jsJsonString = @"";
    }
    NSString *jsFunc = [NSString stringWithFormat:@"jsGetParam('%@')",self.jsJsonString];
    [webView stringByEvaluatingJavaScriptFromString:jsFunc];
}

#pragma mark - method 钱包设置方法

#pragma mark - method 更换付款的方式
-(void)parameter_checkPayMMChangeCard:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *pageName = nil;
        NSInteger changeType = 0;  //更改的类型 1:更改支付宝 2:更换银行卡
        @try {
            pageName = [inputArray firstObject];
            changeType = [[inputArray objectAtIndex:1] integerValue];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        NSString *bindCard = [self func_getBindCard];
        NSDictionary *bindInfoDict = [bindCard objectFromJSONString];
        NSString *bindInfo = nil;
        NSString *errorBindTip = @"";
        if (changeType == 1) {
            bindInfo = [bindInfoDict objectForKey:@"CK_ZhiFuBaoNumber"];
            errorBindTip = @"请先绑定支付宝";
        }
        else if (changeType == 2){
            bindInfo = [bindInfoDict objectForKey:@"WW"];
            errorBindTip = @"请先绑定银行卡";
        }
        bindInfo = [bindInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([bindInfo isMemberOfClass:[NSNull class]] || bindInfo == nil || [bindInfo isEqualToString:@""]) {
            [self showHint:errorBindTip];
            return;
        }
        [self parameter_alertCheckPayMM:@[pageName]];
    }
    else{
        [self showHint:REQUESTERRORTIP];
    }
}

#pragma mark - method 弹窗验证支付密码
-(void)parameter_alertCheckPayMM:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *pageName = [inputArray firstObject];
        [[PayMMSingleton sharedInstance] showPayMMUi:self.view result:^(BOOL isRight){
            if (isRight) {
                [self loadOtherPage:pageName];
            }
        } cancle:^(BOOL isCancle){
        }];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 显示已绑定的手机号
-(void)func_showBindCardNo{
    NSString *funcStr = [NSString stringWithFormat:@"showBindCardNo('%@')",[self func_getBindCard]];
    [webView stringByEvaluatingJavaScriptFromString:funcStr];
    
}

#pragma mark - method 设置支付密码
-(void)parameter_setPayPwd:(NSArray *) inputArray{
    if (inputArray.count>1) {
        [Waiting show];
        NSString *otherPageFlag = [inputArray firstObject];
        NSString *paypwd = [inputArray objectAtIndex:1];
        paypwd = Crypto.MD5Encode([paypwd dataUsingEncoding:NSUTF8StringEncoding]);
        [Waiting show];
        NSDictionary * params = @{@"apiid": @"0112",@"memloginid":loginId,@"paypwd": paypwd};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
            [self.view makeToast:[tempDic objectForKey:@"info"] duration:2.0 position:@"center"];
            if ([[tempDic objectForKey:@"result"] isEqualToString:@"true"]) {
                //-----支付密码设置成功------
                //[self loadOtherPage:otherPage];
                if (otherPageFlag.length>1) {
                    //----加载新页面
                    [self loadOtherPage:otherPageFlag];
                }else if(otherPageFlag.length==1){
                    //----后退
                    int times = (int)[otherPageFlag integerValue];
                    for (int i=0; i<times; i++) {
                        [webView goBack];
                    }
                }
                moreAvailable = YES;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 获取消费记录
-(void)func_getRecords{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0106",@"memloginid" : loginId};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.length<5) {
            result = @"{\"rechargeList\": {\"rechargebean\": []}}";
        }
        //获取提现记录一并输出
        [self showRecords:result];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

#pragma mark - method 提现记录
-(void)showRecords:(NSString *)recordsResult{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0107",@"memloginid" : loginId};
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (result.length<5) {
            result           = @"{\"cashList\": {\"cashbean\": []}}";
        }
        NSString *funcStr = [NSString stringWithFormat:@"showRecords('%@','%@')",recordsResult,result];
        [webView stringByEvaluatingJavaScriptFromString:funcStr];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

#pragma mark - method 获取绑定的手机号
-(NSString *)getBindMobile{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0114&memloginid=%@",loginId];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSString *result;
    if (![requestOperation error]) {
        result = requestOperation.responseString;
    }else{
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
    }
    return result;
}

#pragma mark - method 获取支付密码
-(NSString *)getPayMM{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0111&memloginid=%@",loginId];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSString *result;
    if (![requestOperation error]) {
        result = requestOperation.responseString;
    }else{
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
    }
    return result;
}

#pragma mark - method 验证绑定手机号的是否正确
-(void)parameter_checkChangeCard:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSString *bindMobile = [inputArray firstObject];
        NSString *vcode = [inputArray objectAtIndex:1];
        [Waiting show];
        NSDictionary * params = @{@"apiid": @"0078",@"mobile" : bindMobile,@"vcode" : vcode};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([temp isEqualToString:@"true"]) {
                if ([bindMobile isEqualToString:[self getBindMobile]]) {
                    [self loadOtherPage:@"wallet_changebindcard1.html"];
                }else{
                    [self.view makeToast:@"绑定手机号错误" duration:1.2 position:@"center"];
                }
            }else{
                [self.view makeToast:@"验证码错误,请重新输入" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jgrioejgirejoige-----%@",error);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 账户充值支付

#pragma mark - method 根据选择方式支付
-(void)realRecharge:(NSNotification*)notification{
    NSString *result = [[notification userInfo] objectForKey:@"result"];
    if ([result isEqualToString:@"true"]) {
        [self loadOtherPage:@"wallet_index_second.html"];
    }
}

#pragma mark - method 实际的账户充值
-(void)parameter_recharge:(NSArray *) inputArray{
    if (inputArray.count>0) {
        NSString *rechargeMoney = [inputArray firstObject];//----充值金额----
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMddHHmm"];
        NSString *theDate = [dateFormat stringFromDate:[[NSDate alloc] init]];
        NSString *rechargeCode = [NSString stringWithFormat:@"%@%d",theDate,arc4random()/1000];
        NSLog(@"ghrehigoedjjw-----%@",rechargeCode);
        [defaults setObject:@{@"rechargeMoney":rechargeMoney,@"rechargeCode":rechargeCode} forKey:@"rechargeInfo"];
        NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] initWithDictionary:@{@"body":@"单耳兔账户充值",@"price":rechargeMoney,@"subject":@"单耳兔账户充值",@"tradeNO":rechargeCode}];
        [self onClickPay:orderInfo];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

#pragma mark - method 充值
-(void)onClickPay:(NSMutableDictionary *)orderInfo{
    NSString *key = [NSString stringWithCString:"abcdef1234567890" encoding:NSUTF8StringEncoding];
    NSDictionary *rechargeInfo = [defaults objectForKey:@"rechargeInfo"];
    [defaults removeObjectForKey:@"rechargeInfo"];//使用过立即移除----
    NSString *rechargeMoney = [rechargeInfo objectForKey:@"rechargeMoney"];
    NSString *rechargeCode = [rechargeInfo objectForKey:@"rechargeCode"];
    if (rechargeMoney&&rechargeCode) {
        //----版本号-----
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *inoutFlag = @"0";
        NSString *remark = @"预充款记录";
        NSString *RechargeWay = [NSString stringWithFormat:@"Ios(%@)支付宝",appVersion];
        NSString *sourcePostStr = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",loginId,inoutFlag,rechargeMoney,remark,RechargeWay,rechargeCode];
        NSString *encryptPostStr = [AES128Util AES128Encrypt:sourcePostStr key:key];
        NSLog(@"foewghrhrueihuehgrei: %@\n %@", sourcePostStr,encryptPostStr);
        [Waiting show];
        NSDictionary * params = @{@"apiid": @"0225",@"strDetinfo" : encryptPostStr};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
//            NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
                //充值成功
                if (payOffType==ALIPAY) {
                    //支付宝支付
                    AlipayPostInfo *aliPayObj = [[AlipayPostInfo alloc]init];//初始化
                    [aliPayObj doPayByAlipay:orderInfo resultBlock:^(BOOL isFinish){
                    }];//调用支付
                }else if (payOffType==WEBCHATPAY){
                    //微信支付
                    [self.view makeToast:@"微信支付暂未开通,请使用其他支付方式" duration:1.2 position:@"center"];
                    //[self sendPay2];
                }else if (payOffType==UNIONPAY){
                    //银联卡支付-------
                    /*
                     [Waiting show];
                     //NSString *proname =
                     NSString *price = [orderInfoDic objectForKey:@"price"];
                     price = [NSString stringWithFormat:@"%d",(int)[[orderInfoDic objectForKey:@"price"] doubleValue] *100];
                     //如果是测试支付的话,金额改成1分
                     if (isTestPayMoney) {
                     price = @"1";
                     }
                     NSDictionary * params = @{@"apiid": @"0089",@"ordernumber" : [orderInfoDic objectForKey:@"tradeNO"],@"proname":[orderInfoDic objectForKey:@"body"],@"orderAmount":price};
                     NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                     path:@""
                     parameters:params];
                     AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [Waiting dismiss];//隐藏loadin
                     NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                     NSLog(@"hotrjnonrjiewiocheuevihuiqw----%@",score);
                     if(score.length>0){
                     [UPPayPlugin startPay:score mode:@"00" viewController:self delegate:self];
                     }else{
                     [self.view makeToast:@"系统错误,请稍后重试" duration:2.0 position:@"center"];
                     }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"jtorijhirojoief---%@--%@",error,params);
                     [Waiting dismiss];//隐藏loading
                     [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
                     }];
                     [operation start];
                     */
                }
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
            [Waiting dismiss];//隐藏loading
        }];
        [operation start];
    }else{
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"realRecharge" object:nil];
}

@end

