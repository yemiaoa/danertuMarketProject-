//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//-----商品详细页----
#import "GoodsDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "UIButton+Bootstrap.h"
#import "Waiting.h"
#import "NTalkerChatViewController.h"
#import "NTalkerGlobalParam.h"
#import "NTalkerTrailModel.h"
#import "NTalkerInterface.h"

@interface GoodsDetailController (){
    NSString *arraysStr;
    
    NSArray *hotelGuidArr;
    NSDictionary *bookWood;
    AFHTTPClient * httpClient ;
    DanModle *danModle;
    UIWebView *webView;
    NSString *titleStr;
    BOOL canGoodsBuy;
    BOOL isSpecailGood;
    NSString *memLoginID;          //登录id
    NSDictionary *goodsInfoDic;   //商品信息
    NSDictionary *currentShop;   //当前店铺
    UILabel *woodsStore;         //当前库存数量
    UIButton *shareBtn;          //分享按钮
}
@property(strong,nonatomic) NSString *textStr;
@end

@implementation GoodsDetailController
@synthesize modle;
@synthesize danModleGuid;
@synthesize dataArray;
@synthesize gridView;
@synthesize defaults;
@synthesize favorite;
@synthesize addStatusBarHeight;
@synthesize isShopAddToFavorite;
@synthesize woodsTotal;
@synthesize introduceMore;
@synthesize introduceValue;
@synthesize commentValue;
@synthesize commentMore;
@synthesize stepper;
@synthesize activityWoodName;
@synthesize woodsName,woodsPrice,woodsNum,woodsGoal;
@synthesize availableMaps;
@synthesize shopImg;
@synthesize shopDetailInfoDict;
//@synthesize isQuanYanGoods;
@synthesize textStr;

-(id)initGoodsWithShopDict:(NSDictionary *)shopDict
{
    if ([super init]) {
//        isQuanYanGoods = NO;   //默认值
        shopDetailInfoDict = [[NSMutableDictionary alloc] initWithDictionary:shopDict];
    }
    return self;
}

//修改标题
- (NSString*)getTitle{
    if (self.isDiscountCard) {
        return @"折扣卡";
    }else{
        return @"商品详情";
    }
}

- (void)viewDidLoad
{
    [self initialization];   //初始化
//    [self getContactNumber];  //获取联系方式，因为如果是泉眼旗下的商品，需要单独提取联系方式
    [self getWoodsInfo:danModleGuid];   //完善danModle
    [super viewDidLoad];
    [self initView];
}


- (void)initView{
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-45, addStatusBarHeight+5, 40,34)];
    [self.view addSubview:shareBtn];
    shareBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setHidden:YES];
}

- (void)initialization
{
    defaults =[NSUserDefaults standardUserDefaults];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    //本地存储,用户id
    memLoginID = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    currentShop = [defaults objectForKey:@"currentShopInfo"];
    
    availableMaps = [[NSMutableArray alloc] init];//-----初始化
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    canGoodsBuy = YES;   //商品是否可以购买
    isSpecailGood = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    //温泉酒店的guid
    NSString *path = [[NSBundle mainBundle] pathForResource:@"springHotelGuid" ofType:@"plist"];
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    
    NSDictionary *guidDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    hotelGuidArr = [guidDic objectForKey:@"hotelGuidArr"];
    
    //商品来自活动的名称
    if (!activityWoodName) {
        activityWoodName = @"";
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

//- (void)getContactNumber
//{
//    NSString *shopid = [shopDetailInfoDict objectForKey:@"shopId"];
//    if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil) {
//        return;
//    }
//    NSDictionary *param = @{@"apiid": @"0126",@"shopid" : shopid};
//    [[AFOSCClient sharedClient] postPath:nil parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
//        NSString *respondstring = operation.responseString;
//        id respondObj = [respondstring objectFromJSONString];
//        NSString *resultstr = [respondObj objectForKey:@"result"];
//        if ([resultstr isMemberOfClass:[NSNull class]] || resultstr == nil) {
//            resultstr = @"";
//        }
//        if ([resultstr isEqualToString:@"true"]) {
////            isQuanYanGoods = YES;
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//    
//    }];
//}

-(void)getWoodsInfo:(NSString *)guid {
    if (goodsInfoDic) {
        return;
    }
    [Waiting show];
    NSString *arrivaltime = [Tools getCurrentTime];
    NSString *shopId = shopId = modle.id;
    if (shopId == nil) {
        shopId = [currentShop objectForKey:@"shopId"];
    }

    if (shopId == nil) {
        shopId = CHUNKANGSHOPID;
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0026",@"apiid",guid,@"proId",@"",@"imei",@"",@"mac",[Tools getDeviceUUid],@"deviceid",shopId,@"shopid",arrivaltime,@"arrivaltime", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        
        NSString *temp = [Tools deleteErrorStringInData:operation.responseData];
        NSData *jsonDataTmp = [temp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
        
        if (jsonData) {
            NSArray *shopInfoArr = [jsonData objectForKey:@"val"];
            if (shopInfoArr.count > 0) {
                goodsInfoDic = shopInfoArr[0];
                if ([[goodsInfoDic objectForKey:@"canfirstbuy"] isEqualToString:@"true"]) {
                    isSpecailGood = YES;
                }else{
                    isSpecailGood = NO;
                }
                NSString *AgentId = [goodsInfoDic objectForKey:@"AgentId"];
                NSString *SupplierLoginID = [goodsInfoDic objectForKey:@"SupplierLoginID"];
                NSString *imgUrl = @"";
                NSString *smallImgStr = [goodsInfoDic objectForKey:@"SmallImage"];
                NSString *woodFrom = @"supply";
                if (AgentId.length > 1) {
                    woodFrom = @"agent";
                    if ([smallImgStr hasPrefix:@"/ImgUpload/Agent/"]) {
                        imgUrl = [smallImgStr stringByReplacingOccurrencesOfString:@"/ImgUpload/Agent/" withString:MEMBERPRODUCT];
                    }else{
                        imgUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,AgentId,smallImgStr];
                    }
                }else if (SupplierLoginID.length>1) {
                    AgentId = @"";
                    imgUrl = [NSString stringWithFormat:@"%@%@/%@",SUPPLIERPRODUCT,SupplierLoginID,smallImgStr];
                }else{
                    SupplierLoginID = @"";
                    imgUrl = [NSString stringWithFormat:@"%@%@",DANERTUPRODUCT,smallImgStr];
                    if ([smallImgStr hasPrefix:@"/ImgUpload/"]) {
                        smallImgStr = [smallImgStr stringByReplacingOccurrencesOfString:@"/ImgUpload/" withString:@""];
                        imgUrl = [NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,smallImgStr];
                    }
                }
                
                danModle = [[DanModle alloc] initWithDataDic:goodsInfoDic];
                [danModle setSmallImage:imgUrl];
                [danModle setWoodFrom:woodFrom];
                [danModle setGuid:danModleGuid];
                /*
                 判断商品是否可购买:
                 levelType==2一定可以购买;
                 否则,AgentId==@""可以购买
                 其他均不能购买
                 */
                if ([[currentShop objectForKey:@"levelType"] isEqualToString:@"2"]) {
                    //ok
                }else{
                    if ([danModle.AgentId isEqualToString:@""]) {
                        //ok
                    }else{
                        //no
                        canGoodsBuy = NO;
                        //对导航栏修正
                        self.topNaviView_topClass.backgroundColor = TOPNAVIBGCOLOR_G;
                    }
                }
                
                if (danModle.AgentId&&![danModle.AgentId isEqualToString:@""]&&![[currentShop objectForKey:@"levelType"] isEqualToString:@"2"]) {
                    canGoodsBuy = NO;
                    //对导航栏修正
                    self.topNaviView_topClass.backgroundColor = TOPNAVIBGCOLOR_G;
                }
                
                //判断是否是温泉产品(客房/温泉门票/)
                if ([[goodsInfoDic valueForKey:@"SupplierLoginID"] isEqualToString:SPRINGSUPPLIERID] || self.isDiscountCard || ![[goodsInfoDic objectForKey:@"AgentId"] isEqualToString:@""]) {
                    shareBtn.hidden  = YES;
                    shareBtn.enabled = NO;
                }else{
                    shareBtn.hidden  = NO;
                    shareBtn.enabled = YES;
                }
                [TopNaviViewController load];
                
                if (![danModle.AgentId isEqualToString:@""]) {
                    [self getTelDataFromShopData];
                }else{
                     [self createView];
                }
                
                //记录浏览轨迹
                if ([Tools isUserHaveLogin]) {
                    [self trail];
                }
            }else{
                [self showHint:REQUESTERRORTIP];
            }
        }else{
            [self showHint:REQUESTERRORTIP];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
        [self netWorkError];
    }];
}

- (void)getTelDataFromShopData{
    //代理商
    NSString *laString = [NSString stringWithFormat:@"%.6f",[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lat"] floatValue] * 1];
    NSString *ltString = [NSString stringWithFormat:@"%.6f",[[[[LocationSingleton sharedInstance] pos] objectForKey:@"lot"] floatValue] * 1];
    NSDictionary *paramsDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0041",@"apiid",danModle.AgentId,@"shopid",laString,@"la",ltString,@"lt", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *shopInfoStr = operation.responseString;
        NSData *shopInfoData = [shopInfoStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:shopInfoData options:NSJSONReadingMutableLeaves error:nil];//json解析
        if (![jsonData objectForKey:@"shopdetails"] || ![jsonData objectForKey:@"shopdetails"] || [[[jsonData objectForKey:@"shopdetails"] objectForKey:@"shopbean"] count] == 0 ) {
            [self showHint:@"店铺信息有误,无法查看!"];
            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:2.0];
            return ;
        }else{
            
            NSDictionary *myObj = [[jsonData objectForKey:@"shopdetails"] objectForKey:@"shopbean"][0];
            NSString *phone = [myObj objectForKey:@"Mobile"];
            if (!phone||[phone isEqualToString:@""]) {
                phone = [myObj objectForKey:@"m"] ;
            }
            if (shopDetailInfoDict) {
                [shopDetailInfoDict setObject:phone forKey:@"Mobile"];
            }else{
                NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"Mobile", nil];
                shopDetailInfoDict = [[NSMutableDictionary alloc] initWithDictionary:tempDic];
            }
            [self createView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showHint:REQUESTERRORTIP];
    }];
}
- (void)netWorkError
{
    CGFloat imageScale = 1.66;
    CGFloat imageX = 0;
    CGFloat imageY = TOPNAVIHEIGHT + addStatusBarHeight;
    CGFloat imageW = SCREENWIDTH;
    CGFloat imageH = imageW / imageScale;
    
    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, imageY, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height)];
    errorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgColor"]];
    [self.view addSubview:errorView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"networkError"]];
    imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
    [errorView addSubview:imageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageH + 20, SCREENWIDTH, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"页面加载失败";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor colorWithRed:196.0 / 255.0 green:0 blue:0 alpha:1.0];
    tipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    [errorView addSubview:tipLabel];
    
    UILabel *subTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageH + 60, SCREENWIDTH, 30)];
    subTipLabel.backgroundColor = [UIColor clearColor];
    subTipLabel.text = @"请检查网络后重新加载";
    subTipLabel.textAlignment = NSTextAlignmentCenter;
    subTipLabel.textColor = [UIColor colorWithWhite:144.0 / 255.0 alpha:1.0];
    subTipLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [errorView addSubview:subTipLabel];
}

//拦截跳转路径
- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
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
    
    // 说明协议头是ios
    
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"jfoepierbhiohgoireghre----%@",method);
        if ([method hasPrefix:@"parameter_"]){
            NSInteger location = [method rangeOfString:@"/"].location;
            NSString *funcName = [method substringToIndex:location];
            SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcName]);
            NSArray *parameterArr = [[method substringFromIndex:location+1] componentsSeparatedByString:@"/"];
            NSLog(@"jfioewjigoreg------%@--%@",funcName,parameterArr);
            
            if ( [self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:func withObject:parameterArr];
#pragma clang diagnostic pop
            }
        }
        return NO;
    }
    return YES;
}
//-----同意方法调用-------
-(void)parameter_iosFunc:(NSArray *) inputArray{
    NSInteger parameterCount = inputArray.count;
    if (parameterCount>0) {
        NSString *funcFlag = [inputArray firstObject];
        SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",funcFlag]);
        if([self respondsToSelector:func]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:func withObject:inputArray];
#pragma clang diagnostic pop
        }
    }
}

//显示提示信息-----
-(void)showMsg:(NSArray *) inputArray{
    if (inputArray.count>1) {
        [self.view makeToast:inputArray[1] duration:1.2 position:@"center"];
    }
}
//-----点击返回
-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"----backLogin---图片被点击!------");
}
//-------检测登录状态-------
-(void)checkLogin:(NSArray *) inputArray{
    if (!memLoginID) {
        [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.2];
    }
}
//---------调接口加载数据,并且把数据返回-------
-(void)jsGetData:(NSArray *) inputArray{
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
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];
                NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
//                
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

//获取需要的参数
-(void)getParamters:(NSArray *)inputArray{
    [Waiting show];
    NSString *guid = [goodsInfoDic objectForKey:@"Guid"];
    NSDictionary *params = @{@"apiid":@"0130",@"memberid":memLoginID,@"productguid":guid};
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        /*
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//json解析
         NSArray* temp = [jsonData objectForKey:@"val"];//数组
         */
        NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
        NSString *result = [dicData objectForKey:@"result"];
        NSLog(@"fewojgreoigrkopkoejfiogjrigio-------%@\n%@",source,dicData);
        if (!result) {
            result = @"false";
        }
        //
        NSString *funcName = [NSString stringWithFormat:@"getParamters_callBack('%@','%@','%@','%@','%@','%@')",guid,[goodsInfoDic objectForKey:@"Name"],[currentShop objectForKey:@"shopName"],memLoginID,shopImg,result];
        [webView stringByEvaluatingJavaScriptFromString:funcName];
        NSLog(@"gkrekgopopth-----%@",funcName);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        NSLog(@"gregjoeijorth-----%@",error);
        [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
    }];
    [operation start];
}

//领取
-(void)takeDiscount:(NSArray *)inputArray{
    if (inputArray.count>1) {
        NSString *paramStr = [inputArray objectAtIndex:1];
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
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            /*
             NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//json解析
             NSArray* temp = [jsonData objectForKey:@"val"];//数组
             */
            NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
            NSLog(@"fewojgreoigrkopkoejfiogjrigio-------%@\n%@",source,dicData);
            NSString *funcName = [NSString stringWithFormat:@"takeDiscount_callBack('%@')",source];;
            [webView stringByEvaluatingJavaScriptFromString:funcName];
            NSLog(@"gkrekgopopth-----%@",funcName);
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
        }];
        [operation start];
            
        }
    }
}

//webview加载完毕,执行
-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    NSLog(@"kgphoptrkhoptfjwfpwogrkop--------%@",danModle);
    NSString *shopName = [[defaults objectForKey:@"currentShopInfo"] objectForKey:@"shopName"];
    if (!shopName) {
        shopName = @"";
    }
    NSString *funcName = [NSString stringWithFormat:@"localStorage.setItem('discount_memberid','%@');localStorage.setItem('discount_productGuid','%@');localStorage.setItem('discount_prouductName','%@');localStorage.setItem('discount_shopName','%@');localStorage.setItem('discount_shopImg','%@');",memLoginID,danModle.Guid,danModle.Name,shopName,danModle.SmallImage];
    [webView stringByEvaluatingJavaScriptFromString:funcName];
}

//创建视图
-(void)createView{
    if (self.isDiscountCard) {
        CGRect frame = CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT+49);
        webView = [[UIWebView alloc] initWithFrame:frame];//上半部分
        [self.view addSubview:webView];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;

        if (CLEARWEBCACHE) {
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            [cache setDiskCapacity:0];
            [cache setMemoryCapacity:0];
        }
        NSString *pageName = @"discount_take.html?893qwe";
        NSString *webURL = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,pageName];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    }else{
        //原生开发
        [self createView_ios];
    }
}

-(void)createView_ios
{
    CGFloat scrollH = 625;//可滑动区域
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT + addStatusBarHeight, self.view.frame.size.width, CONTENTHEIGHT + 49)];//上半部分
    scrollView.backgroundColor = VIEWBGCOLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollH);//staticPart高度
    
    [self.view addSubview:scrollView];
    //上半部分
    UIView *staticPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, scrollH)];
    staticPart.backgroundColor = [UIColor whiteColor];
    staticPart.userInteractionEnabled = YES;
    [scrollView addSubview:staticPart];

    //单耳兔商城 产品danertuItem
    UIImageView *danertuItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 200)];
    [staticPart addSubview:danertuItem];
    danertuItem.userInteractionEnabled = YES;
    danertuItem.backgroundColor = [UIColor orangeColor];
    
    AsynImageView *imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 200)];
    imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
    imageView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.imageURL = danModle.SmallImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.masksToBounds = YES;

    [danertuItem addSubview:imageView];//---添加大图片点击事件
    //----收藏按钮
    
    UIButton *favoriteBtn =[[UIButton alloc] initWithFrame:CGRectMake(250, 250, 60, 25)];
    [staticPart addSubview:favoriteBtn];
    favoriteBtn.layer.cornerRadius = 3;
    favoriteBtn.backgroundColor = TOPNAVIBGCOLOR;
    favoriteBtn.titleLabel.font = TEXTFONT;
    [favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [favoriteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [favoriteBtn addTarget:self action:@selector(addToFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 199, MAINSCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor grayColor];
    [staticPart addSubview:line];
    
    //-----商品名称
    UILabel *nameText = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 50)];
    [nameText setBackgroundColor:[UIColor clearColor]];
    nameText.textAlignment = NSTextAlignmentRight;
    nameText.font = [UIFont systemFontOfSize:16];
    nameText.textColor = [UIColor grayColor];
    [staticPart addSubview:nameText];
    nameText.text = @"商品名称:";

    woodsName = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, MAINSCREEN_WIDTH - 105, 50)];
    [woodsName setBackgroundColor:[UIColor clearColor]];
    [staticPart addSubview:woodsName];
    woodsName.textAlignment = NSTextAlignmentLeft;
    woodsName.font = [UIFont fontWithName:@"Helvetica" size:16];
    woodsName.numberOfLines = 2;
    woodsName.text = danModle.Name;
    
    
    //-----商品售价---marketprice------原价
    UILabel *priceText_market = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 80, 25)];
    [staticPart addSubview:priceText_market];
    priceText_market.textAlignment = NSTextAlignmentRight;
    priceText_market.font = [UIFont systemFontOfSize:16];
    priceText_market.textColor = [UIColor grayColor];
    priceText_market.text = @"原       价:";
    
    UILabel *priceSign_market = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, 114, 25)];
    [staticPart addSubview:priceSign_market];
    priceSign_market.textAlignment = NSTextAlignmentLeft;
    priceSign_market.font = [UIFont systemFontOfSize:16];
    double marketPrice = [danModle.MarketPrice doubleValue];
    if (marketPrice<=[danModle.ShopPrice doubleValue]) {
        marketPrice = [danModle.ShopPrice doubleValue];
    }
    priceSign_market.text = [NSString stringWithFormat:@"¥ %0.2f",marketPrice];
    [priceSign_market sizeToFit];
    
    UIView *borderline_market = [[UIView alloc] initWithFrame:CGRectMake(0, 10, priceSign_market.frame.size.width, 1)];
    [priceSign_market addSubview:borderline_market];
    borderline_market.backgroundColor = [UIColor grayColor];

    
    //-----商品售价
    UILabel *priceText = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, 80, 25)];
    [staticPart addSubview:priceText];
    priceText.textAlignment = NSTextAlignmentRight;
    priceText.font = [UIFont systemFontOfSize:16];
    priceText.textColor = [UIColor grayColor];
    priceText.text = @"单       价:";
    
    UILabel *priceSign = [[UILabel alloc] initWithFrame:CGRectMake(100, 275, 10, 25)];
    [staticPart addSubview:priceSign];
    priceSign.textAlignment = NSTextAlignmentLeft;
    priceSign.font = [UIFont systemFontOfSize:16];
    priceSign.text = @"¥";
    
    woodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(114, 275, 100, 25)];
    [staticPart addSubview:woodsPrice];
    woodsPrice.textAlignment = NSTextAlignmentLeft;
    woodsPrice.font = [UIFont systemFontOfSize:16];
    woodsPrice.text = danModle.ShopPrice;
    
    //-------立即预订-------
    if (!canGoodsBuy) {
        favoriteBtn.frame = CGRectMake(250, 240, 60, 25);
        UIButton *bookProduct = [[UIButton alloc]initWithFrame:CGRectMake(230, 270, 80, 25)];
        [bookProduct.layer setMasksToBounds:YES];
        [bookProduct.layer setCornerRadius:3];//设置矩形四个圆角半径
        bookProduct.backgroundColor = TOPNAVIBGCOLOR_G;
        [bookProduct setTitle:@"下单预订" forState:UIControlStateNormal];
        bookProduct.titleLabel.font = TEXTFONT;
        [bookProduct setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bookProduct setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [bookProduct addTarget:self action:@selector(addToBook) forControlEvents:UIControlEventTouchUpInside];
        [staticPart addSubview:bookProduct];
        //对导航栏修正
        self.topNaviView_topClass.backgroundColor = TOPNAVIBGCOLOR_G;
    }
    
    
    //-----商品数量
    UILabel *numTmp = [[UILabel alloc] initWithFrame:CGRectMake(0, 250+25*2, MAINSCREEN_WIDTH, 25)];
    numTmp.userInteractionEnabled = YES;//暂时不能使用输入数字
    [staticPart addSubview:numTmp];
    UILabel *numText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    numText.textAlignment = NSTextAlignmentRight;
    numText.font = [UIFont systemFontOfSize:16];
    numText.textColor = [UIColor grayColor];
    [numTmp addSubview:numText];
    numText.text = @"数       量:";
    
    //商品数量的输入框
    woodsNum = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 60, 25)];//高度--44
    [numTmp addSubview:woodsNum];
    woodsNum.text = @"1";
    woodsNum.keyboardType = UIKeyboardTypeNumberPad;
    woodsNum.borderStyle = UITextBorderStyleNone;
    woodsNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    woodsNum.textAlignment = NSTextAlignmentCenter;
    woodsNum.delegate = self;
    
    //圆角边框
    UIColor *lineColor = [UIColor grayColor];
    woodsNum.backgroundColor = [UIColor whiteColor];
    woodsNum.layer.cornerRadius = 3;
    woodsNum.clipsToBounds = YES;
    woodsNum.layer.borderWidth = 0.6;
    woodsNum.layer.borderColor = [lineColor CGColor];
    
    //-----总价
    UIView *totalTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 250 + 25 * 3, MAINSCREEN_WIDTH, 25)];
    [staticPart addSubview:totalTmp];
    UILabel *totalText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    totalText.textAlignment = NSTextAlignmentRight;
    totalText.font = [UIFont systemFontOfSize:16];
    totalText.textColor = [UIColor grayColor];
    [totalTmp addSubview:totalText];
    totalText.text = @"总       价:";
    
    woodsTotal = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 230, 25)];
    [totalTmp addSubview:woodsTotal];
    woodsTotal.textAlignment = NSTextAlignmentLeft;
    woodsTotal.font = [UIFont systemFontOfSize:16];
    woodsTotal.textColor = [UIColor redColor];
    woodsTotal.text = [NSString stringWithFormat:@"¥ %@",danModle.ShopPrice];
    
    //商品评分
    UIView *goalTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 250 + 25 * 5, MAINSCREEN_WIDTH, 24)];
    [staticPart addSubview:goalTmp];
    UILabel *goalText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    goalText.textAlignment = NSTextAlignmentRight;
    goalText.font = [UIFont systemFontOfSize:16];
    goalText.textColor = [UIColor grayColor];
    [goalTmp addSubview:goalText];
    goalText.text = @"商品评分:";
    
    woodsGoal = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 230, 25)];
    [goalTmp addSubview:woodsGoal];
    woodsGoal.textAlignment = NSTextAlignmentLeft;
    [woodsGoal setText:@"--"];
    //----不是首特可以修改数量----
    if (isSpecailGood) {
        UILabel *addtionLb = [[UILabel alloc]initWithFrame:CGRectMake(180, 248 + 25 * 2, 110, 30)];
        addtionLb.backgroundColor = [UIColor clearColor];
        addtionLb.textColor = [UIColor redColor];
        addtionLb.text = @"首特(数量仅限1)";
        addtionLb.font = TEXTFONT;
        [staticPart addSubview:addtionLb];
    }else{
        // + - 按钮
        stepper = [[UIStepper alloc]initWithFrame:CGRectMake(180, 248 + 25 * 2, 90, 29)];
        stepper.transform = CGAffineTransformMakeScale(0.8, woodsNum.frame.size.height / stepper.frame.size.height);
//        [stepper sizeToFit];
        [staticPart addSubview:stepper];
        [stepper addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
        stepper.maximumValue = 100000.0; //[woodsStore.text intValue]
        stepper.minimumValue = 1;
    }
    
    //-----库存
    UIView *storeTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 250 + 25*4, MAINSCREEN_WIDTH, 25)];
    [staticPart addSubview:storeTmp];
    UILabel *storeText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
    storeText.textAlignment = NSTextAlignmentRight;
    storeText.font = [UIFont systemFontOfSize:16];
    storeText.textColor = [UIColor grayColor];
    [storeTmp addSubview:storeText];
    storeText.text = @"库       存:";
    //库存数量
    woodsStore = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 230, 25)];
    [storeTmp addSubview:woodsStore];
    woodsStore.textAlignment = NSTextAlignmentLeft;
    woodsStore.font = [UIFont systemFontOfSize:16];
    woodsStore.text = @"0";
    NSString *proguid = danModleGuid;
    NSString *arriveTime = [Tools getCurrentTime];
    NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0086",@"apiid",arriveTime,@"daoDate",proguid,@"proguid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        if ([respondStr isMemberOfClass:[NSNull class]] || respondStr == nil) {
            respondStr = @"0";
        }
        woodsStore.text = respondStr;
        stepper.maximumValue = [respondStr intValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"faild");
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.2];
        [self.view makeToast:@"数据加载错误!" duration:1.2 position:@"center"];
    }];
    
    
    //----border
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 250 + 25 * 6 - 1, MAINSCREEN_WIDTH, 0.8)];
    border.backgroundColor = [UIColor grayColor];
    [staticPart addSubview: border];
    
    
    //-----商品描述
    UIView *woodsIntroduce = [[UIView alloc] initWithFrame:CGRectMake(20, 400, 300, 40)];
    woodsIntroduce.userInteractionEnabled = YES;
    
    
    [staticPart addSubview:woodsIntroduce];
    UILabel *introduceText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 39)];
    introduceText.textAlignment = NSTextAlignmentLeft;
    introduceText.textColor = [UIColor grayColor];
    introduceText.text = @"商品描述:";
    [woodsIntroduce addSubview:introduceText];//text
    
    introduceValue = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 39)];
    introduceValue.textAlignment = NSTextAlignmentLeft;
    [woodsIntroduce addSubview:introduceValue];
    
    introduceMore = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 60, 39)];
    introduceMore.textColor = [UIColor orangeColor];
    introduceMore.userInteractionEnabled = YES;
    introduceMore.hidden = NO;
    introduceMore.text = @"更多";
    [woodsIntroduce addSubview:introduceMore];
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showIntroduce)];
    [introduceMore addGestureRecognizer:singleTap1];//---添加点击事件
    if (danModle.mobileProductDetail.length>0&&[danModle.mobileProductDetail rangeOfString:@"http://img"].location==NSNotFound) {
        introduceValue.text = danModle.mobileProductDetail;
        introduceMore.hidden = NO;
    }else{
        introduceValue.text = @"--";
        introduceMore.hidden = YES;
    }
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, 300, 0.6)];
    border1.backgroundColor = [UIColor grayColor];
    [woodsIntroduce addSubview: border1];

    //-----购买评论
    UIView *woodsComment = [[UIView alloc] initWithFrame:CGRectMake(20, 400 + 40 * 1, 300, 40)];
    woodsComment.userInteractionEnabled = YES;

    
    [staticPart addSubview:woodsComment];
    UILabel *commentText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 39)];
    commentText.textAlignment = NSTextAlignmentLeft;
    commentText.textColor = [UIColor grayColor];
    commentText.text = @"购买评论:";
    [woodsComment addSubview:commentText];//text
    
    commentValue = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 39)];
    commentValue.textAlignment = NSTextAlignmentLeft;
    commentValue.text = @"--";
    [woodsComment addSubview:commentValue];
    
    commentMore = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 60, 39)];
    commentMore.textColor = [UIColor orangeColor];
    commentMore.userInteractionEnabled = YES;
    commentMore.hidden = YES;
    commentMore.text = @"详情";
    [woodsComment addSubview:commentMore];
    UITapGestureRecognizer *singleTap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showComment)];
    [commentMore addGestureRecognizer:singleTap3];//---添加点击事件
    
    UILabel *border3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 480, MAINSCREEN_WIDTH, 0.8)];
    border3.backgroundColor = [UIColor grayColor];
    [staticPart addSubview: border3];
    
    //联系客服
    UIButton *customerSerBtn =[[UIButton alloc] initWithFrame:CGRectMake(220, 350, 90, 25)];
    [staticPart addSubview:customerSerBtn];
    customerSerBtn.layer.cornerRadius = 3;
    customerSerBtn.backgroundColor = TOPNAVIBGCOLOR;
    customerSerBtn.titleLabel.font = TEXTFONT;
    [customerSerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [customerSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [customerSerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [customerSerBtn addTarget:self action:@selector(goToCustomerServiceView) forControlEvents:UIControlEventTouchUpInside];
    
    if (!canGoodsBuy) {
        //---------导航-------
        UIView *navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 490, 160, 35)];
        [staticPart addSubview:navigation];
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
        navText.text = @"导航";
        //中间分割线
        UILabel *cuttingLine = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 1, 25)];
        [navigation addSubview:cuttingLine];
        cuttingLine.backgroundColor = VIEWBGCOLOR;
        //---------电话-------
        UIView *telPhone = [[UIView alloc] initWithFrame:CGRectMake(160, 490, 160, 35)];
        [staticPart addSubview:telPhone];
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
        phoneText.text = @"去购买";
        //对导航栏修正
        self.topNaviView_topClass.backgroundColor = TOPNAVIBGCOLOR_G;
    }else{
        //商家联系电话------图文详情-------
        UIButton *telPhoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 490, 280, 30)];
        [telPhoneBtn.layer setMasksToBounds:YES];
        [telPhoneBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
        telPhoneBtn.layer.borderColor = [UIColor blackColor].CGColor;
        telPhoneBtn.layer.borderWidth = 0.6;
        [telPhoneBtn setTitle:@"商家联系电话" forState:UIControlStateNormal];
        telPhoneBtn.titleLabel.font = TEXTFONT;
        [telPhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [telPhoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [telPhoneBtn addTarget:self action:@selector(dialPhone) forControlEvents:UIControlEventTouchUpInside];
        [staticPart addSubview:telPhoneBtn];
    }
    //添加评论
    UIButton *detailImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 530, 280, 30)];
    [detailImgBtn.layer setMasksToBounds:YES];
    [detailImgBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    detailImgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    detailImgBtn.layer.borderWidth = 0.6;
    [detailImgBtn setTitle:@"图文详情" forState:UIControlStateNormal];
    detailImgBtn.titleLabel.font = TEXTFONT;
    [detailImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailImgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [detailImgBtn addTarget:self action:@selector(goTextImgView) forControlEvents:UIControlEventTouchUpInside];
    [staticPart addSubview:detailImgBtn];
    
    if (!canGoodsBuy) {
        
        UIView *agentTextView = [[UIView alloc]initWithFrame:CGRectMake(0, 575, MAINSCREEN_WIDTH, 50)];
        [staticPart addSubview:agentTextView];
        agentTextView.backgroundColor = TOPNAVIBGCOLOR_G;
        UILabel *totalTextLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
        [agentTextView addSubview:totalTextLb];
        totalTextLb.textColor = [UIColor whiteColor];
        totalTextLb.font = TEXTFONT;
        totalTextLb.backgroundColor = [UIColor clearColor];
        totalTextLb.text = @"温馨提示";
        
        UILabel *detailTextLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 30)];
        [agentTextView addSubview:detailTextLb];
        detailTextLb.textColor = [UIColor whiteColor];
        detailTextLb.numberOfLines = 2;
        detailTextLb.font = TEXTFONTSMALL;
        detailTextLb.backgroundColor = [UIColor clearColor];
        detailTextLb.text = @"(线下产品可通过'去购买'联系商家及导航到店消费,也可下单预订后消费)";
    }else{
        //-----按钮-----
        //加入购物车
        CGFloat buttonX = 20;
        CGFloat buttonY = 575;
        CGFloat buttonH = 35;
        CGFloat buttonDistance = 10;   //按钮的水平间距
        CGFloat numberCount = 2.0;    //按钮的个数
        CGFloat buttonW = ([UIScreen mainScreen].bounds.size.width - 2 * buttonX - (numberCount - 1) * buttonDistance) / numberCount;
        UIButton *addToShopList = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [addToShopList.layer setMasksToBounds:YES];
        [addToShopList.layer setCornerRadius:5];//设置矩形四个圆角半径
        [addToShopList setTitle:@"加入购物车" forState:UIControlStateNormal];
        addToShopList.titleLabel.font = TEXTFONT;
        //----首特不让加入购物车-------
        if (isSpecailGood) {
            addToShopList.enabled = NO;
            addToShopList.backgroundColor = [UIColor grayColor];;
        }else{
            addToShopList.enabled = YES;
            addToShopList.backgroundColor = BUTTONCOLOR_Y;
        }
         
        [addToShopList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addToShopList setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [addToShopList addTarget:self action:@selector(addToShopList) forControlEvents:UIControlEventTouchUpInside];
        [staticPart addSubview:addToShopList];
        
//        buttonX = buttonX + buttonW + buttonDistance;
//        UIButton *goToShopList = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
//        [goToShopList.layer setMasksToBounds:YES];
//        [goToShopList.layer setCornerRadius:5];//设置矩形四个圆角半径
//        [goToShopList setTitle:@"前往购物车" forState:UIControlStateNormal];
//        goToShopList.titleLabel.font = TEXTFONT;
//        goToShopList.enabled = YES;
//        goToShopList.backgroundColor = BUTTONCOLOR_Y;
//        [goToShopList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [goToShopList setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//        [goToShopList addTarget:self action:@selector(goToShopList) forControlEvents:UIControlEventTouchUpInside];
//        [staticPart addSubview:goToShopList];
        
        buttonX = buttonX + buttonW + buttonDistance;
        //添加评论
        UIButton *comment = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [comment.layer setMasksToBounds:YES];
        [comment.layer setCornerRadius:5];//设置矩形四个圆角半径
        [comment setTitle:@"立即购买" forState:UIControlStateNormal];
        comment.titleLabel.font = TEXTFONT;
        comment.backgroundColor = BUTTONCOLOR;
        [comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [comment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [comment addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
        [staticPart addSubview:comment];
    
        //---获取评论条数---
        //[self getCommentNum];
    }
    NSString *mobileProductDetail = danModle.Detail;
    if (mobileProductDetail.length > 0) {
        NSString *componentsStr = @"quot;";
        if ([mobileProductDetail rangeOfString:componentsStr].length == 0) {
            componentsStr = @"&quot;";
        }
        NSArray *tmp = [mobileProductDetail componentsSeparatedByString:componentsStr];
        arraysStr = @"";
        if (tmp.count > 0) {
            for (NSString *item in tmp) {
                if ([item hasPrefix:IMAGESERVER]) {
                    arraysStr = [NSString stringWithFormat:@"%@;,;%@",arraysStr,item];
                }else if ([item hasPrefix:@"http://115.28.77.246/"]) {
                    NSString *itemReplace = [item stringByReplacingOccurrencesOfString:@"http://115.28.77.246/" withString:IMAGESERVER];
                    arraysStr = [NSString stringWithFormat:@"%@;,;%@",arraysStr,itemReplace];
                }
            }
            //----截取第一个  逗号------
            if (arraysStr.length > 5) {
                arraysStr = [arraysStr substringFromIndex:3];
            }
        }
        
    }
    
    //自营产品图文信息
    if ([goodsInfoDic valueForKey:@"Detail"] && ![[goodsInfoDic objectForKey:@"AgentId"] isEqualToString:@""]) {
         self.textStr = [NSString stringWithFormat:@"%@",[goodsInfoDic valueForKey:@"Detail"]];
    }
    if (self.textStr == nil) {
        self.textStr = @"";
    }
    if (![[goodsInfoDic valueForKey:@"mobileDetailsImgList"] isEqualToString:@""]) {
        
        NSString *namestr = [goodsInfoDic valueForKey:@"mobileDetailsImgList"];
        NSArray *tempArr = [namestr componentsSeparatedByString:@","];
        
        for (NSString *str in tempArr) {
            NSString *tempUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],str];
             arraysStr = [NSString stringWithFormat:@"%@;,;%@",arraysStr,tempUrl];
        }
    }
    NSLog(@"arrystr:%@",arraysStr);
}

- (void) clickFinish{
    NSString *imgUrl = danModle.SmallImage;
    NSString *shareId;
    if (modle.id) {
        shareId = modle.id;
    }else if(currentShop){
        shareId = [currentShop objectForKey:@"shopId"];
    }
    if (!shareId) {
        shareId = CHUNKANGSHOPID;
    }
    NSString *shopid = shareId;
    NSString *guid = danModleGuid;
    NSDictionary *shareInfo = [NSDictionary dictionaryWithObjectsAndKeys:danModle.Name,@"shareTitle",shareId,@"shareId",@"product",@"shareType",imgUrl,@"shareImg",shopid,@"shopid",guid,@"guid",nil];
    [self shareGoodsWithDict:shareInfo];
//    ShareViewController *sView = [[ShareViewController alloc] init];
//    sView.shareInfo = shareInfo;
//    sView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sView animated:YES];
}

//分享商品详情页 
- (void)shareGoodsWithDict:(NSDictionary *)shareInfo{
    
    NSString   *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [WXUtil md5:time_stamp];
    
    NSString *shareTitle = [shareInfo objectForKey:@"shareTitle"];
    NSString *imagePath = [shareInfo objectForKey:@"shareImg"] ; //图片的链接地址
    NSString *shopid = [shareInfo objectForKey:@"shopid"];
    NSString *guid = [shareInfo objectForKey:@"guid"];
    NSString *url = [NSString stringWithFormat:@"%@?shopid=%@&guid=%@&random=%@",GOODSDETAILSHAREURL,shopid,guid,nonce_str];
    NSString *content = [NSString stringWithFormat:@"您身边的商城-单耳兔O2O商城。"];
    //构造分享内容
    imagePath = [NSString stringWithFormat:@"%@",imagePath];
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithUrl:imagePath]
                                                title:shareTitle
                                                  url:url
                                          description:content
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
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

//修改标题栏背景颜色,如果是线下产品使用浅绿色,否则使用默认红色
-(UIColor *)getTopNaviColor{
    if (!canGoodsBuy) {
        return TOPNAVIBGCOLOR_G;
    }else{
        return TOPNAVIBGCOLOR;
    }
}

- (void)goToShopList
{
    if ([self.view viewWithTag:200]) {
        [self dismissPopView:nil];
    }
    [self.tabBarController setSelectedIndex:2];
    [self setBarItemSelectedIndex:2];
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

//去支付
-(void)gotoPay{
    if ([hotelGuidArr indexOfObject:danModle.Guid] != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尊敬的客户您好:在您购买此产品前请您必须咨询 0760-85883115,查询实时房态,否则订单失效!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"电话咨询"];
        [alert setTag:23];
        [alert show];
    }else{
        //库存数量不足
        if ([woodsNum.text intValue] > [woodsStore.text intValue]) {
            [self.view makeToast:@"抱歉,库存数量不足!" duration:1.2 position:@"center"];
            return;
        }
        
        //---------立即购买-----
        NSString *shopId = CHUNKANGSHOPID,*shopName = @"单耳兔商城";
        if (modle.s) {
            shopId = modle.id;
            shopName = modle.s;
        }else if(currentShop){
            shopId = [currentShop objectForKey:@"shopId"];
            shopName = [currentShop objectForKey:@"shopName"];
        }
        NSString *agentId = @"", *supplierLoginID = @"";
        if (danModle.AgentId) {
            agentId = danModle.AgentId;
        }
        if (danModle.SupplierLoginID) {
            supplierLoginID = danModle.SupplierLoginID;
        }
        
        NSDictionary *wood = @{@"Guid":danModle.Guid,@"SupplierLoginID":supplierLoginID,@"activityName":@"",@"agentID":agentId,@"count":woodsNum.text,@"img":danModle.SmallImage,@"name":danModle.Name,@"price":danModle.ShopPrice,@"shopId":shopId,@"shopName":shopName};
        //------保存到支付商品-----跳转到支付------
        [defaults setObject:@[wood] forKey:PAYOFFWOODSARR];
        
        OrderFormController *orderForm = [[OrderFormController alloc] init];
        orderForm.hidesBottomBarWhenPushed = YES;
        orderForm.isFromDirectlyPay = YES;
        [self.navigationController pushViewController:orderForm animated:YES];
        
    }
}

//到图文详情页
-(void)goTextImgView{
    if (arraysStr.length>0 || self.textStr.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"浏览图文详情需要大量流量"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"确定"];
        [alert setTag:15];
        [alert show];
    }else{
        [self showHint:@"暂无图文详细信息"];
    }
}

//获取评论总条数
-(void)getCommentNum{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0068",@"productguid":danModle.Guid};
    NSLog(@"---locationString---------:%@",params);
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"ewqewqewq------%@-----",temp);
        if ([temp isEqualToString:@"0"]) {
            commentValue.text = @"暂无评论";
            commentMore.hidden = YES;
        }else{
            commentMore.hidden = NO;
            commentValue.text = [NSString stringWithFormat:@"总共评论数(%@)",temp];
            NSString *agentId = @"";
            if (modle.m) {
                agentId = modle.m;
            }else if(danModle.AgentId){
                agentId = danModle.AgentId;
            }
            NSDictionary *wood = @{@"productguid":danModle.Guid,@"agentID":agentId,@"commentNum":temp};
            [defaults setObject:wood forKey:@"currentWoodsInfo"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
    }];
    [operation start];//-----发起请求------
}

//stepper的按钮
- (void)stepperAction:(id)sender
{
    UIStepper *st = (UIStepper *)sender;
    NSLog(@"st.value:%f",st.value);
    int selfCount = [[NSString stringWithFormat:@"%0.0f",st.value] intValue];
//    if (selfCount > [woodsStore.text intValue]) {
//        [self.view makeToast:@"抱歉,库存数量不足!" duration:1.2 position:@"center"];
//        return;
//    }
    woodsNum.text   = [NSString stringWithFormat:@"%d",selfCount];
    float total     = [woodsPrice.text floatValue] * selfCount;
    woodsTotal.text = [NSString stringWithFormat:@"¥ %0.2f",total];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [woodsNum resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    int selfCount = [woodsNum.text intValue];
    woodsNum.text = [NSString stringWithFormat:@"%d",selfCount];
    //-----首特数量仅限1-----
    if (selfCount<=0||isSpecailGood) {
        selfCount = 1;
        woodsNum.text = @"1";
    }else if (selfCount > [woodsStore.text intValue]){
        woodsNum.text = woodsStore.text;
        [self.view makeToast:@"抱歉,库存数量不足!" duration:1.2 position:@"center"];
    }
//    else if(selfCount>9999){
//        selfCount = 9999;
//        woodsNum.text = @"9999";
//        [self.view makeToast:@"最大数量:9999" duration:1.2 position:@"center"];
//    }
    stepper.value = [woodsNum.text floatValue];
    float total = [woodsPrice.text floatValue] * selfCount;
    woodsTotal.text = [NSString stringWithFormat:@"¥ %0.2f",total];
    return YES;
}

//商品描述
- (void)showIntroduce
{
    UIScrollView *introduceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH - 40, self.view.frame.size.height - 47 - addStatusBarHeight - 20 - 20)];
    introduceView.contentSize = CGSizeMake(MAINSCREEN_WIDTH - 40, self.view.frame.size.height - 47 - addStatusBarHeight + 100);
    introduceView.backgroundColor = VIEWBGCOLOR;
    [[KGModal sharedInstance] showWithContentView:introduceView andAnimated:YES];
    introduceView.userInteractionEnabled = YES;
    
    UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, introduceView.frame.size.width - 40, introduceView.frame.size.height - 40)];
    tmp.text = introduceValue.text;
    CGSize textSize = [introduceValue.text sizeWithFont:tmp.font constrainedToSize:CGSizeMake(tmp.frame.size.width, 2000)];
    tmp.frame = CGRectMake(20, 20, introduceView.frame.size.width - 40, textSize.height);
    introduceView.contentSize = CGSizeMake(280, textSize.height + 2 * tmp.frame.origin.y);
    tmp.backgroundColor = [UIColor clearColor];  //背景色
    tmp.numberOfLines = 0;
    [introduceView addSubview:tmp];
}

//购买评论
- (void)showComment
{
    [self performSegueWithIdentifier:@"commentView" sender:self];
}

//点击添加到预定
-(void)addToBook{
    NSDictionary *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    //登录是否才能下单
    if([userLoginInfo objectForKey:@"MemLoginID"]){
    
        NSString *shopId = CHUNKANGSHOPID,*shopName = @"单耳兔商城";
        if (modle.s) {
            shopId = modle.id;
            shopName = modle.s;
        }
        NSString *agentId = @"", *marketPrice = @"", *supplierLoginID = @"",*mobileProductDetail = @"";
        if (danModle.AgentId) {
            agentId = danModle.AgentId;
        }
        if (danModle.MarketPrice) {
            marketPrice = danModle.MarketPrice;
        }
        if (danModle.SupplierLoginID) {
            supplierLoginID = danModle.SupplierLoginID;
        }
        if (danModle.mobileProductDetail) {
            mobileProductDetail = danModle.mobileProductDetail;
        }
        bookWood = @{@"shopId":shopId,@"shopName":shopName,@"Guid":danModle.Guid,@"img":danModle.SmallImage,@"name":danModle.Name,@"market":marketPrice,@"price":danModle.ShopPrice,@"woodFrom":danModle.woodFrom,@"mobileProductDetail":mobileProductDetail,@"SupplierLoginID":supplierLoginID,@"AgentId":agentId,@"count":woodsNum.text};
        
        BookProductController *controller = [[BookProductController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.bookWood = [bookWood mutableCopy];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self.view makeToast:@"预订前请登录" duration:1.2 position:@"center"];
    }
}

//点击添加到收藏商品
-(void)addToFavorite{
    //先判断是否已经登录
    if (![Tools isUserHaveLogin]) {
        [self showHint:@"亲，您尚未登录，不能收藏该商品"];
        
        return;
    }
    NSString *shopId = CHUNKANGSHOPID,*shopName = @"单耳兔商城";
    if (modle.s) {
        shopId = modle.id;
        shopName = modle.s;
    }else if(currentShop){
        shopId = [currentShop objectForKey:@"shopId"];
        shopName = [currentShop objectForKey:@"shopName"];
    }

    NSString *agentId = @"", *marketPrice = @"", *supplierLoginID = @"", *mobileProductDetail = @"";
    if (danModle.AgentId) {
        agentId = danModle.AgentId;
    }
    if (danModle.MarketPrice) {
        marketPrice = danModle.MarketPrice;
    }
    if (danModle.SupplierLoginID) {
        supplierLoginID = danModle.SupplierLoginID;
    }
    if (danModle.mobileProductDetail) {
        mobileProductDetail = danModle.mobileProductDetail;
    }
    NSDictionary *woods = @{@"id":shopId,@"s":shopName,@"Guid":danModle.Guid,@"img":danModle.SmallImage,@"name":danModle.Name,@"market":marketPrice,@"price":danModle.ShopPrice,@"woodFrom":danModle.woodFrom,@"mobileProductDetail":mobileProductDetail,@"SupplierLoginID":supplierLoginID,@"AgentId":agentId};
    
    NSMutableArray *temp = [[defaults objectForKey:FAVORITEWOODSARR] mutableCopy];
    NSString *info = @"收藏成功";
    if (temp) {
        BOOL isHaveAdded = NO;
        for (id item in temp ) {
            if ([[item objectForKey:@"Guid"] isEqualToString:danModle.Guid]) {
                isHaveAdded = YES;
                break;
            }
        }
        if (!isHaveAdded) {
            [temp addObject:woods];
        }else{
            info = @"已收藏";
        }
    }else{
        temp = [[NSMutableArray alloc] init];
        [temp addObject:woods];

    }
    
    [defaults setObject:temp forKey:FAVORITEWOODSARR];
    isShopAddToFavorite = YES;
    favorite.image = [UIImage imageNamed:@"star-black"];
    [self showHint:info];
}


#pragma mark - method addToShopList

//添加到购物车
-(void)addToShopList{
//    if ([hotelGuidArr indexOfObject:danModle.Guid] != NSNotFound) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尊敬的客户您好:在您购买此产品前请您必须咨询 0760-85883115,查询实时房态,否则订单失效!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        // optional - add more buttons:
//        [alert addButtonWithTitle:@"电话咨询"];
//        [alert setTag:22];
//        [alert show];
//    }
//    //库存数量不足
//    if ([woodsNum.text intValue] > [woodsStore.text intValue]) {
//        [self.view makeToast:@"抱歉,库存数量不足!" duration:1.2 position:@"center"];
//        return;
//    }
    //由于泉眼的商品有些是动态判断库存的，因此在加入购物车的时暂不需要判断库存是否足够
    NSString *shopId = CHUNKANGSHOPID,*shopName = @"单耳兔商城";
    if (modle.s) {
        shopId = modle.id;
        shopName = modle.s;
    }else if(currentShop){
        shopId = [currentShop objectForKey:@"shopId"];
        shopName = [currentShop objectForKey:@"shopName"];
    }
    NSString *agentId, *marketPrice, *supplierLoginID;
    if (danModle.AgentId) {
        agentId = danModle.AgentId;
    }else{
        agentId = @"";
    }
    if (danModle.MarketPrice) {
        marketPrice = danModle.MarketPrice;
    }else{
        marketPrice = @"";
    }
    if (danModle.SupplierLoginID) {
        supplierLoginID = danModle.SupplierLoginID;
    }else{
        supplierLoginID = @"";
    }
    
    NSDictionary *wood = @{@"Guid":danModle.Guid,@"SupplierLoginID":supplierLoginID,@"activityName":@"",@"agentID":agentId,@"count":woodsNum.text,@"img":danModle.SmallImage,@"name":danModle.Name,@"price":danModle.ShopPrice,@"shopId":shopId,@"shopName":shopName};
    //如果是泉眼的商品，必须先登录才能加到购物车那里去
    if ([Tools isSpringGoodsWithDic:wood]) {
        if (![Tools isUserHaveLogin]) {
            [self showHint:@"亲，您尚未登录哦"];
            return;
        }
    }
    //----动画
    UIImageView* test = [[UIImageView alloc] initWithFrame:CGRectMake(97, 100, 120, 126)];//起点
    NSString *urlStr = danModle.SmallImage;
    NSURL *imageUrl = [NSURL URLWithString:urlStr];
    [test sd_setImageWithURL:imageUrl];
    test.layer.borderWidth = 1;
    test.layer.borderColor = BUTTONCOLOR.CGColor;
    [self.view addSubview: test];
    [UIView beginAnimations:@"xcodeImageViewAnimation" context:nil];
    //设置动画时间为5s
    [UIView setAnimationDelay:0.5f];
    [UIView setAnimationDuration:1.0f];
    //[UIView setAnimationCurve:UIAnimat]
    //接受动画代理
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(imageViewDidStop:finished:context:)];
    /* 设置Frame在右下角 */
    [test setFrame:CGRectMake(13.0f,650.0f,80.0f,84.0f)];//终点
    //提交动画
    [UIView commitAnimations];
    //-----修改  当前物品数量
    int shopCatWoodsCount =  [[[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] badgeValue] intValue];
    shopCatWoodsCount = shopCatWoodsCount+[woodsNum.text intValue];
    [defaults setObject:[NSString stringWithFormat:@"%d",shopCatWoodsCount] forKey:SHOPCATWOODSCOUNT];
    [[[[[self tabBarController] viewControllers] objectAtIndex: SHOPCATINDEX] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d",shopCatWoodsCount]];
    //----读取存在本地的数据,修改之后再次存入
    NSArray *tempArray = [defaults objectForKey:SHOPCATWOODSARR];
    NSMutableArray *tempArray1  = [[NSMutableArray alloc] init];
    if(tempArray){
        [tempArray1 addObjectsFromArray:tempArray];
    }
    int woodsCount = [woodsNum.text intValue];//初始值
    NSDictionary *currentShopInfo ;
    //如果没有保存当前商城
    if (modle.id&&modle.s) {
        currentShopInfo = @{@"shopId":modle.id,@"shopName":modle.s};
    }else{
        currentShopInfo = [defaults objectForKey:@"currentShopInfo"];
    }
    if (!currentShopInfo) {
        currentShopInfo = @{@"shopId":CHUNKANGSHOPID,@"shopName":@"单耳兔商城"};
    }
    
    for(int i = 0; i < tempArray1.count; i++){
        //如果,tempArray有值,并且当前的oId在数组tempArray1中,改变数量 count,,,,,如果来自活动,那么活动名称也要一致
        if(tempArray&&![danModle.SupplierLoginID isEqualToString:SPRINGSUPPLIERID]&&[[[tempArray1 objectAtIndex:i] objectForKey:@"shopId"] isEqualToString:[currentShopInfo objectForKey:@"shopId"]]&&[[[tempArray1 objectAtIndex:i] objectForKey:@"Guid"] isEqualToString:danModle.Guid]){
            //---如果是活动商品
            if (activityWoodName.length>0) {
                if ([[[tempArray1 objectAtIndex:i] objectForKey:@"activityWoodName"] isEqualToString:activityWoodName]) {
                    woodsCount =  [[[tempArray1 objectAtIndex:i] objectForKey:@"count"] intValue]+[woodsNum.text intValue];//累加已经加到购物车的数量----
                    [tempArray1 removeObjectAtIndex:i];//remove  旧的
                    break;
                }
            }else{
                woodsCount =  [[[tempArray1 objectAtIndex:i] objectForKey:@"count"] intValue]+[woodsNum.text intValue];//累加已经加到购物车的数量----
                [tempArray1 removeObjectAtIndex:i];//remove  旧的
                break;
            }
        }
    }
    
    NSDictionary *obj = @{@"shopId":[currentShopInfo objectForKey:@"shopId"],@"shopName":[currentShopInfo objectForKey:@"shopName"],@"name":danModle.Name,@"img":urlStr,@"woodFrom":danModle.woodFrom,@"price":danModle.ShopPrice,@"count":[NSString stringWithFormat:@"%d",woodsCount],@"Guid":danModle.Guid,@"SupplierLoginID":supplierLoginID,@"AgentId":agentId,@"activityWoodName":activityWoodName,@"woodsLeftNums":woodsStore.text};
    [tempArray1 addObject:obj];//ClienWoodsArray没值 或 数组中不存在oId,//添加  新的
    
    NSArray *tempArray2 = [tempArray1  mutableCopy];
    
    [defaults setObject:tempArray2 forKey:SHOPCATWOODSARR];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShopCat" object:nil];//object 和 userInfo都可以传值
    
    //加入购物车成功之后，弹窗提示
    [self showPopView];
    
}

- (void)showPopView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, MAINSCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 200;
    bgView.alpha = 0.7;
    bgView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *dismissGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopView:)];
    dismissGes.numberOfTapsRequired = 1;
    dismissGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:dismissGes];
    
    [self performSelector:@selector(dismissPopView:) withObject:dismissGes afterDelay:5.0];
//    [self.view addSubview:bgView];
    
    UIImage *bgImage = [UIImage imageNamed:@"popViewBG_B"];
    CGFloat imageScale = bgImage.size.width / bgImage.size.height;
    CGFloat imageH = 80;
    CGFloat imageW = imageScale * imageH;
    UIImageView *popView = [[UIImageView alloc] initWithImage:bgImage];
    int tempHeight = iOS7 ? 0 : 20;
    popView.frame = CGRectMake((SCREENWIDTH - imageW) / 2.0, MAINSCREEN_HEIGHT - imageH - 50 - tempHeight, imageW, imageH);
    popView.tag = 210;
    popView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageW, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    titleLabel.text = @"商品已经成功加入";
    [popView addSubview:titleLabel];
    
    CGFloat buttonW = 2 * imageW / 3.0;
    CGFloat buttonH = 30;
    CGFloat buttonX = (imageW - buttonW) / 2.0;
    CGFloat buttonY = titleLabel.frame.origin.y + titleLabel.frame.size.height;
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [payButton setTitle:@"去付款" forState:UIControlStateNormal];
    [payButton stytleWithColor:[UIColor colorWithRed:255.0 / 255.0 green:96.0 / 255.0 blue:18.0 / 255.0 alpha:1.0] borderColor:[UIColor clearColor] hightColor:[UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1]];
    [payButton addTarget:self action:@selector(goToShopList) forControlEvents:UIControlEventTouchUpInside];
    payButton.layer.borderWidth = 0;
    payButton.layer.borderColor = [UIColor clearColor].CGColor;
    [payButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [popView addSubview:payButton];
    
   
    [self.view addSubview:popView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [popView.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)dismissPopView:(UITapGestureRecognizer *)tap
{
    UIView *popBGView = [self.view viewWithTag:200];
    [popBGView removeFromSuperview];
    
    UIView *popBView = [self.view viewWithTag:210];
    [popBView removeFromSuperview];
    
    [self.view removeGestureRecognizer:tap];
    
}

-(NSString *)getTelNumber{
    NSLog(@"goodsInfoDic%@",goodsInfoDic);
    NSString *tel = danModle.ContactTel;
//    if ([Tools isSpringHotelWithGuid:danModleGuid]) {
//        return @"076085883115";
//    }
    if (shopDetailInfoDict != nil && [shopDetailInfoDict allKeys].count > 0) {
        //如果是泉眼店铺以及泉眼商品
        tel = [shopDetailInfoDict objectForKey:@"Mobile"];
    }
//    if (isQuanYanGoods) {
//        //如果是泉眼店铺以及泉眼商品
//        tel = [shopDetailInfoDict objectForKey:@"m"];
//    }
    if ([tel isMemberOfClass:[NSNull class]] || tel == nil || [tel isEqualToString:@""]) {
        tel = @"4009952220";
    }
    return tel;
}

- (void)callShopTelphone{
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@",[self getTelNumber]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)callBookTelphone{
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@",@"076085883115"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//--拨打电话
-(void)dialPhone
{
    NSString *shopPhone = [NSString stringWithFormat:@"店铺电话:%@",[self getTelNumber]];
    if (shopDetailInfoDict != nil && [shopDetailInfoDict allKeys].count > 0) {
        //自营产品
        if (iOS8) {
            __block typeof(self) bself = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //取消
            }];
            
            UIAlertAction *shopPhoneAction = [UIAlertAction actionWithTitle:shopPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [bself callShopTelphone];
            }];
            // Add the actions.
            [alertController addAction:shopPhoneAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"温馨提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:shopPhone, nil];
            actionsheet.tag = 99;
            [actionsheet showInView:self.view];
        }
    }else{
         NSString *bookPhone = @"预订部:076085883115";
        //泉眼产品
        if (iOS8) {
            
            __block typeof(self) bself = self;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //取消
            }];
           
            UIAlertAction *shopPhoneAction = [UIAlertAction actionWithTitle:shopPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [bself callShopTelphone];
            }];
            
            UIAlertAction *bookPhoneAction = [UIAlertAction actionWithTitle:bookPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [bself callBookTelphone];
            }];
            
            // Add the actions.
            [alertController addAction:shopPhoneAction];
            [alertController addAction:bookPhoneAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"温馨提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:shopPhone,bookPhone, nil];
            actionsheet.tag = 100;
            [actionsheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [self callShopTelphone];
                break;
            case 1:
                [self callBookTelphone];
                break;
            default:
                break;
        }
        return;
    }else if (actionSheet.tag == 99){
        switch (buttonIndex) {
            case 0:
                [self callShopTelphone];
        }
        return;
    }
    
    AHReach *hostReach = [AHReach reachForHost:@"https://www.baidu.com/"];
    if ([hostReach isReachable]) {
        //if (1) {
        if (buttonIndex == 0) {
            double endLat = [modle.la doubleValue] / 100000.0;
            double endLot = [modle.lt doubleValue] / 100000.0;
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
            NSLog(@"\n%@\n%@\n%@", mapDic[@"name"], mapDic[@"url"], urlString);
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        [self.view makeToast:@"网络未连接" duration:1.2 position:@"center"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12 ) {    // it's the Error alert
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",[self getTelNumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
    }
    else if ([alertView tag] ==15){
        if (buttonIndex==1) {
            
            TextImgController *detailController = [[TextImgController alloc] init];
            detailController.hidesBottomBarWhenPushed = YES;
            detailController.arraysStr = arraysStr;
            detailController.textStr = self.textStr;
            detailController.isCanBuy = canGoodsBuy;
            [self.navigationController pushViewController:detailController animated:YES];
        }
    }
    else if ([alertView tag] == 22 ||[alertView tag] == 23) {    // it's the Error alert
        
        if(buttonIndex==1){
            //这里的电话号码  0760-85883115   之间不能有  -  或其他非数字
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://076085883115"]];
        }else if([alertView tag] ==23){
            //立即购买
            NSString *shopId = CHUNKANGSHOPID,*shopName = @"单耳兔商城";
            if (modle.s) {
                shopId = modle.id;
                shopName = modle.s;
            }
            NSString *agentId = @"", *supplierLoginID = @"";
            if (danModle.AgentId) {
                agentId = danModle.AgentId;
            }
            if (danModle.SupplierLoginID) {
                supplierLoginID = danModle.SupplierLoginID;
            }
            
            NSDictionary *wood = @{@"Guid":danModle.Guid,@"SupplierLoginID":supplierLoginID,@"activityName":@"",@"agentID":agentId,@"count":woodsNum.text,@"img":danModle.SmallImage,@"name":danModle.Name,@"price":danModle.ShopPrice,@"shopId":shopId,@"shopName":shopName};
            //------保存到支付商品-----跳转到支付------
            [defaults setObject:@[wood] forKey:PAYOFFWOODSARR];
            
            OrderFormController *orderForm = [[OrderFormController alloc] init];
            orderForm.hidesBottomBarWhenPushed = YES;
            orderForm.isFromDirectlyPay = YES;
            [self.navigationController pushViewController:orderForm animated:YES];
        }
    }
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
            double endLot = [modle.lt doubleValue] /100000.0;
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

- (void)goToCustomerServiceView{
    
    if (![Tools isUserHaveLogin]) {
        [self showHint:@"亲，您尚未登录，不能联系客服"];
        return;
    }

    NTalkerChatViewController *chatViewController=[[NTalkerChatViewController alloc] init];
    
    chatViewController.appKey = @"2E15B6D9-FEC6-4B06-8B19-8E80D7CD7AF7";//[必填]  请联系小能技术人员获取该值
    chatViewController.siteid = @"dr_1000";//平台ID:企业唯一标识  [必填]   如惠买为：@"kf_9715"；
    chatViewController.settingid = @"dr_1000_1444459107870";//客服组ID:客服组唯一标识 [必填] 详细获取方式请参考文档
    chatViewController.sellerID = @"dr_1001";//商户ID :同一平台下区分不能商户，一个平台下有多个商户时需要传值  [必填] 有则传，没有则传空字符@""； 如：@“dd_1001”
    chatViewController.pushOrPresent = NO;//扩展参数:用于以后功能扩展，目前固定传"NO" [必填] 统一传NO；
    
    chatViewController.userid = memLoginID;//访客ID:用户唯一标识  [必填] 登陆用户则传值，未登录访客则传空字符@""；注意：不可传nil!
    chatViewController.username = memLoginID;//访客名称 [必填] 可传空字符@""（不推荐）
    chatViewController.userlevel = 0;//是否是vip用户  [必填]    0:非VIP  1:是VIP
    chatViewController.issingle =-1;//是否请求独立用户，明确指定咨询某客服时值为1；不确定咨询客服组里那个客服时值为0；指定的客服如果不存在时，允许分配置其它客服时为-1（默认为—1） [必填]
    chatViewController.titleName = @"在线客服";//自定义聊窗title [必填]
    chatViewController.erpparam = @"";//erp参数  [必填] 如果没有此参数，直接传空字符串@""
    
    //商品信息展示：
    //    chatViewController.jsonString = nil;//商品信息json数据  [必填]  SDK端需要展示商品信息时传json数据,详细json格式参考文档。 不需要展示时可以传nil;
    
    //商品ID和商品URL中传一个即可在客服端展示商品
    chatViewController.goodsID = @"";//@"商品信息";//商品ID：客服端显示商品信息用 [必填] 有则传，没有则传空字符串@""；@"50094233"
    //    chatViewController.goodsURL =@"http://pic.shopex.cn/pictures/goodsdetail/29b.jpg?rnd=111111";//商品URL：客服端显示商品信息用 [必填] 有则传 ，没有则传空字符串@""；
    chatViewController.goodsURL = @"";
    //注意：客服端显示商品信息
    //1、商品信息json数据传nil时， goodsID和goodsURL中选择其中一个传值，另一个传空字符@""；
    //2、商品信息json数据有传值（非nil且非空字符）时，goodsID和goodsURL可以都传空字符@""；
    NSString *AgentId = [goodsInfoDic objectForKey:@"AgentId"];
    if (AgentId.length > 1) {
    }else{
        AgentId = CHUNKANGSHOPID;
    }
        
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@.danertu.com/ProductDetail/%@.html",AgentId,danModleGuid];
    NSString *jsonStr = [NSString stringWithFormat:@"{\"appgoodsinfo_type\":\"3\",\"clientgoodsinfo_type\":\"2\",\"goods_id\":\"%@\",\"goods_name\":\"%@\",\"goods_price\":\"%@\",\"goods_image\":\"%@\",\"goods_url\":\"%@\",\"goods_showurl\":\"%@\"}",danModleGuid,danModle.Name,danModle.ShopPrice,danModle.SmallImage,goodsUrl,goodsUrl];
    chatViewController.jsonString = jsonStr;
    //appgoodsinfo_type 0:不展示 1:传商品id展示 2:传url展示 3:传json展示
    chatViewController.hidesBottomBarWhenPushed = YES;
    //客服端展示商品信息 (字典型 ，键值固定) url goods_id:商品ID   goods_showurl：商品url  [选填]
    UINavigationController *navgationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [self presentViewController:navgationController animated:YES completion:^{
        
    }];
}

- (void)trail{
    /**
     *title         当前页标题【必填】
     *ntalkerparam  页面特定参数【根据移动端sdk文档传值（json字符串）】
     *username
     *siteid        平台id
     *sellerid      商户id
     *userlevel     用户级别
     *orderid       订单ID
     *orderprice    订单价格
     */
    
    NTalkerTrailModel *trailmodel =[NTalkerTrailModel sharedInstence];
    trailmodel.siteID = @"dr_1000";// 平台ID
    trailmodel.title = [self getTitle];// app传参 当前页的标题
    trailmodel.otherParam = @"";// app传参
    trailmodel.userName = memLoginID;// app传参
    trailmodel.userid = memLoginID;//有则传没有则传空////后来加的
    trailmodel.sellerID = @"dr_1001";// 商户ID
    trailmodel.userLevel = @"0";//用户级别 app传参
    trailmodel.orderID = @"";//订单号  app传参
    trailmodel.orderPrice = danModle.ShopPrice;//订单价格  app传参
    
    [NTalkerInterface trajectory:trailmodel];
}

@end
