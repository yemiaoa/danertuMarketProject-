//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "AnnounceDetailController.h"
#import <ShareSDK/ShareSDK.h>

@implementation AnnounceDetailController
@synthesize addStatusBarHeight;
@synthesize scrollView;
@synthesize messageArr;
@synthesize msgInfo;
@synthesize webView;
@synthesize activityIndicator;
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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    webView.userInteractionEnabled = YES;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 10 - (TOPNAVIHEIGHT - 20), 10+addStatusBarHeight, TOPNAVIHEIGHT - 20, TOPNAVIHEIGHT - 20)];
    [self.topNaviView_topClass addSubview:shareButton];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"an_shareIcon"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----------加载内容------------
    /*
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"AnnouncementDetail" ofType:@"htm"inDirectory:@"www"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    */
     
    NSString *webURL = [NSString stringWithFormat:@"%@/AnnouncementDetail.htm",PAGEURLADDRESS];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    /*
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"AnnouncementDetail" ofType:@"htm" inDirectory:@"www"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    */

    //     http://192.168.1.129:778/AnnouncementDetail.htm
    
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.129:778/AnnouncementDetail.htm"]]];
    
	// Do any additional setup after loading the view, typically from a nib.
    //[webView loadHTMLString:@"qwe" baseURL:[NSURL URLWithString:@"http://baidu.com"]];
    
    //----loading显示
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;//只能设置中心，不能设置大小
    [self.view addSubview:activityIndicator];
    activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色； iOS5引入
    [activityIndicator startAnimating]; // 开始旋转
    [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

- (void)shareMethod:(id)sender
{
    //构造分享内容
    NSString *content = [msgInfo objectForKey:@"messageTitle"];
    if ([content isMemberOfClass:[NSNull class]] || content == nil) {
        content = @"";
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x"  ofType:@"png"];
    NSString *titleStr = @"单耳兔资讯";
    
    NSString *msgID = [msgInfo objectForKey:@"id"];
    if ([msgID isMemberOfClass:[NSNull class]] || msgID == nil) {
        msgID = @"";
    }
    
    NSString *webURL = @"http://www.danertu.com/mobile/announcement/AnnouncementDetail.htm";
    NSString *url = [NSString stringWithFormat:@"%@?guid=%@&platform=ios",webURL,msgID];
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:titleStr
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

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"资讯详情";
}
//-----获取消息信息
-(void)getMessageData{
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0095",@"msgid": [msgInfo objectForKey:@"id"]};
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        
        NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"bioejgoijgosdsafsfrejoge-----%@---%@",source,msgInfo);
        
        source = [source stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //javaLoadAnnouncementDetail
        NSString *jsFunction = [NSString stringWithFormat:@"javaLoadAnnouncementDetail('%@','%@','%@')",[msgInfo objectForKey:@"messageTitle"],[msgInfo objectForKey:@"ModiflyTime"],source];
        [webView stringByEvaluatingJavaScriptFromString:jsFunction];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}
-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
    
    //[webView stringByEvaluatingJavaScriptFromString:@"testFunction()"];
    
    [self getMessageData];
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
