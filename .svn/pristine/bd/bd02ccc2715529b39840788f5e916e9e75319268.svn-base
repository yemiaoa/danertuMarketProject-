//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "ShowCommentController.h"
@implementation ShowCommentController{
    AFHTTPClient *httpClient;
    NSString *commentDataStr;
    bool isLoadCommentData;
}
@synthesize addStatusBarHeight;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize shopInfoDic;
@synthesize defaults;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];

    //-------loading显示-------
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色； iOS5引入
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

//获取评论
-(void)getCommentData{
    if (!isLoadCommentData) {
        NSDictionary * params = @{@"apiid": @"0100",@"shopid" :[shopInfoDic objectForKey:@"ShopId"]};
        NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
        AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            commentDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (commentDataStr) {
                isLoadCommentData = YES;
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadShopComment('%@', '%@', '%@')",[shopInfoDic objectForKey:@"ShopName"],[shopInfoDic objectForKey:@"avgscore"],commentDataStr]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
        }];
        [operation start];//-----发起请求------
    }else{
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javaLoadShopComment('%@', '%@', '%@')",[shopInfoDic objectForKey:@"ShopName"],[shopInfoDic objectForKey:@"avgscore"],@""]];
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
    webURL = [NSString stringWithFormat:@"%@/Overall_evaluation.html",PAGEURLADDRESS];
    //------------//网络网络---------------
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    
	// Do any additional setup after loading the view, typically from a nib.
    //[webView loadHTMLString:@"qwe" baseURL:[NSURL URLWithString:@"http://baidu.com"]];
    
}
//-----修改标题,重写父类方法----
-(NSString *)getTitle{
    return @"评价";
}
//-----完成按钮标题
-(NSString*)getFinishBtnTitle{
    return @"去评价";
}

//完成按钮
-(BOOL)isShowFinishButton{
    return YES;
}

//点击发布评论
-(void) clickFinish{
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userLoginInfo) {
        ShopCommentController *commentController = [[ShopCommentController alloc] init];
        commentController.shopInfoDic = shopInfoDic;
        commentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentController animated:YES];
    }else{
        [self.view makeToast:@"登录后才能发布评论" duration:1.2 position:@"center"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
}

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
    
    // 说明协议头是ios
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [request.URL.absoluteString substringFromIndex:range.location + 1];
        method = [method
                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([method isEqualToString:@"loadCommentData"]) {
            [self getCommentData];
        }
        return  NO;
    }
    return YES;
}
@end
