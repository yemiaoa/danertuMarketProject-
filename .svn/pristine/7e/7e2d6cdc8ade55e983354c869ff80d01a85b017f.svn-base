//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "GoodFoodController.h"
@implementation GoodFoodController{
    AFHTTPClient *httpClient;
    NSString *commentDataStr;
    NSMutableArray *pageStackArr;//记录页面加载顺序
    NSString *titleName;//标题栏
    NSString *classifyJsonStr;//二级分类json数据字符串
    NSString *shopJsonStr;//店铺json数据字符串
    NSString *shoptype;
    NSString *juli;
    NSArray *arrays;
    NSString *pageIndex;
    bool isLoadCommentData;
}
@synthesize addStatusBarHeight;
@synthesize webView;
@synthesize activityIndicator;
@synthesize defaults;
@synthesize shopGps;
@synthesize loadPageName;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    titleName = @"美食";
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    pageStackArr = [[NSMutableArray alloc] init];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    
    
    shoptype = @"";
    juli = @"";
    pageIndex = @"1";
    //-------loading显示-------
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色； iOS5引入
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
}
//-----点击返回
-(void)onClickBack{
    if (pageStackArr.count>0) {
        [pageStackArr removeLastObject];
        if (pageStackArr.count>0) {
            titleName = [[pageStackArr lastObject] objectAtIndex:1];
        }else{
            titleName = @"美食";
        }
        [super viewDidLoad];
        //----页面返回----
        [webView goBack];
    }else{
        //----viewcontroller的返回---
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//-----页面显示时--------
-(void)viewWillAppear:(BOOL)animated{
    isLoadCommentData = NO;
    //-----------加载内容------------
    /*
     NSString *filePath = [[NSBundle mainBundle]pathForResource:@"principle" ofType:@"html"];
     NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
     [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
     */
    if (pageStackArr.count<=0) {
        NSString *pageName = @"menu.html";
        if (shopGps.length>0) {
            pageName = @"nearbyShop.html";
            pageIndex = @"1";
            [self getShopTypeData];
        }
        /*
        NSString *filePath = [[NSBundle mainBundle]pathForResource: pageName ofType:nil inDirectory:@"www"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        */
        
        NSString *webURL = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,pageName];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
        NSLog(@"fjaeowjfowjfowjof------%@",webURL);
        // Do any additional setup after loading the view, typically from a nib.
        //[webView loadHTMLString:@"qwe" baseURL:[NSURL URLWithString:@"http://baidu.com"]];
    }
    NSLog(@"eoqueoqueioquequoe----------%@",pageStackArr);
}
//-----修改标题,重写父类方法----
-(NSString *)getTitle{
    return titleName;
}
//-----停止loading-----------
-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (BOOL)webView:(UIWebView *)webViewTmp shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"fjeoijwoifjejfoepierbhiohgoireghre----%@---%@",request,request.URL.scheme);
    //window.location.href="ios:normalPage/"+page+"/"+name+"/"+id+"/"+tagFlag;
    // 说明协议头是ios
    
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
            [activityIndicator stopAnimating]; // 结束旋转
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
    
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"jfoepierbhiohgoireghre----%@",method);
        if ([method hasPrefix:@"normalPage"]) {
            NSRange range1 = [method rangeOfString:@"normalPage/"];
            NSString *paramsStr = [method substringFromIndex:range1.location + range1.length];
            NSArray *paramArr = [paramsStr componentsSeparatedByString:@"/"];
            NSLog(@"fwjfioewjfoiwij-----%@---%lu---%lu",paramArr,(unsigned long)range1.location,(unsigned long)range1.length);
            if (paramArr.count==4) {
                NSString *webURL = [NSString stringWithFormat:@"%@/%@",PAGEURLADDRESS,paramArr[0]];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
                [pageStackArr addObject:paramArr];
                if([paramArr[3] isEqualToString:@"1"]) {
                    titleName = paramArr[1];//---修改标题---
                    [self getSecondTypeData:paramArr[2]];//
                }else if([paramArr[3] isEqualToString:@"2"]){
                    shoptype = paramArr[2];
                    juli = @"1000";//-----这里初次加载页面,默认距离----
                    //-----二级分类的----标题使用之前的,这里不必更换------
                    
                    NSLog(@"kfewkofwpfwkopf-----1");
                }else if([paramArr[3] isEqualToString:@"3"]){
                    titleName = paramArr[1];//---修改标题---
                    //----默认第一个-----11,21
                    shoptype = [NSString stringWithFormat:@"%@",paramArr[2]];
                    juli = @"1000";//-----这里初次加载页面,默认距离----
                    if ([shoptype isEqualToString:@"1"]) {
                        shoptype = [NSString stringWithFormat:@"%@1",paramArr[2]];
                        [self getSecondTypeData:paramArr[2]];//
                    }else if([shoptype isEqualToString:@"-1"]) {
                        shoptype = @"";
                        [self getSecondTypeData:paramArr[2]];//
                    }
                }else{
                    [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                }
                //-----修改标题,,重新load-----
                [super viewDidLoad];
            }else{
                [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
            }
        }else if ([method hasPrefix:@"jsGetSecTypeJson/"]){
            NSRange range1 = [method rangeOfString:@"jsGetSecTypeJson/"];
            NSString *paramsStr = [method substringFromIndex:range1.location + range1.length];
            if (paramsStr.length>0) {
                NSArray *paramArr = [paramsStr componentsSeparatedByString:@"/"];
                if (paramArr.count==2) {
                    shoptype = paramArr[0];
                    juli = paramArr[1];
                    NSLog(@"kfewkofwpfwkopf-----3");
                }else{
                    [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
                }
            }else{
                NSString *jsFuncStr = [NSString stringWithFormat:@"javaLoadSecCate(%@,'%@')",shoptype,classifyJsonStr];
                [webView stringByEvaluatingJavaScriptFromString:jsFuncStr];
                NSLog(@"jfowjfeowjfeooiw-----%@",jsFuncStr);
            }
            pageIndex = @"1";
            [self getShopTypeData];
        }else if ([method hasPrefix:@"goShopDetail/"]){
            //-----店铺详情页
            NSString *selectShopId = [method stringByReplacingOccurrencesOfString:@"goShopDetail/" withString:@""];
            //-----跳转shopDetail
            
            DetailViewController *detaiV = [[DetailViewController alloc] init];
            for (NSDictionary *modle in arrays) {
                if ([[modle objectForKey:@"id"] isEqualToString:selectShopId]) {
                    detaiV.modle = [[DataModle alloc] initWithDataDic:modle];
                    break;
                }
            }
            if (detaiV.modle == nil) {
                detaiV.agentid = selectShopId;
            }
            detaiV.hidesBottomBarWhenPushed = YES;//隐藏
            [self.navigationController pushViewController:detaiV animated:YES];
        }else if ([method isEqualToString:@"getShopTypeData"]){
            //加载更多,这里不用修改页数
            [self getShopTypeData];
            
        }
        return  NO;
    }
    return YES;
}
//----根据一级分类--读取二级分类----
-(void)getSecondTypeData:(NSString *)firstTypeId{
    NSDictionary * params = @{@"apiid": @"0099",@"firstTypeId" :firstTypeId};
    NSLog(@"urdsadadadfdfewioutolocationString---------:%@--",params);
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //--------当前的二级分类数据------
        classifyJsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"------------weqqfasdfeawf-----%@",classifyJsonStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [self.view makeToast:@"提交数据错误" duration:1.2 position:@"center"];
        [Waiting dismiss];
    }];
    [operation start];//-----发起请求------
}

//----根据二级分类--读取分类店铺信息----
-(void)getShopTypeData{
    [Waiting show];
    NSString *gpsParameter;
    NSString *cityName = [defaults objectForKey:@"currentCityName"];
    if (self.shopGps) {
        juli = @"1000";
        gpsParameter = self.shopGps;
    }else{
        gpsParameter = [NSString stringWithFormat:@"%@,%@",[[[LocationSingleton sharedInstance] pos] objectForKey:@"lat"],[[[LocationSingleton sharedInstance] pos] objectForKey:@"lot"]];
    }
    //----没获取到城市---
    if (!cityName) {
        cityName = @"";
    }
    NSDictionary * params = @{@"apiid": @"0098",@"shoptype" :shoptype,@"juli":juli,@"gps": gpsParameter,@"pageSize": @"10",@"pageIndex": pageIndex,@"searchtype":@"",@"keyword":@"",@"areaname":cityName};
    NSLog(@"kfopwfkoewpqwedadadfdfewioutolocationString---------:%@--",params);
    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        shopJsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
        if (jsonData) {
            arrays = [[jsonData objectForKey:@"shoplist"] objectForKey:@"shopbean"];
        }else if(![shopJsonStr isEqualToString:@""]){
            [self.view makeToast:@"数据错误" duration:1.2 position:@"center"];
        }
        //---------------页数加加---------
        pageIndex = [NSString stringWithFormat:@"%d",[pageIndex intValue] +1];
        NSLog(@"-------qw-----weqqfasdfeawf----%@",shopJsonStr);
        
        NSString *jsFuncStr_1 = [NSString stringWithFormat:@"javaLoadData('%@')",shopJsonStr];
        [webView stringByEvaluatingJavaScriptFromString:jsFuncStr_1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"faild , error == %@ ", error);
        [self.view makeToast:@"提交数据错误:0098" duration:1.2 position:@"center"];
        [Waiting dismiss];
    }];
    [operation start];//-----发起请求------
}



@end
