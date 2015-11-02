//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "ShopIntroduceController.h"
@implementation ShopIntroduceController
@synthesize addStatusBarHeight;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webTitle;
@synthesize shopInfoDic;
@synthesize shopInfoStr;
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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, self.view.frame.size.height-addStatusBarHeight-TOPNAVIHEIGHT)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    //-----------加载内容------------
//    NSString *url = [[NSBundle mainBundle] pathForResource:@"shop_info" ofType:@"html" inDirectory:@"www"];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:url]]];
    
    NSString *webURL = [NSString stringWithFormat:@"%@/shop_info.html",PAGEURLADDRESS];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    
    //----loading显示
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色； iOS5引入
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return [shopInfoDic objectForKey:@"ShopName"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
    
    /*
    NSDictionary *dic = @{@"shopdetails":@{@"shopbean":shopInfoStr}};
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *source = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    */
    
    NSString *jsFunction = [NSString stringWithFormat:@"javaLoadShopIntroduce('%@')",shopInfoStr];
    [webView stringByEvaluatingJavaScriptFromString:jsFunction];
    
    NSLog(@"fpwoekfpjgrith-----%@--%@",shopInfoStr,shopInfoDic);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 404) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (BOOL)webView:(UIWebView*)localWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
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
            
            [localWebView stopLoading];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，目前页面有点问题，请稍后再试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 404;
            [alert show];
            return NO;
        }
        
        [localWebView loadData:data MIMEType:@"text/html" textEncodingName:nil baseURL:[request URL]];
        
        isRequestWeb = NO;
        return NO;
    }
    return YES;
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
