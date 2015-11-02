//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "TextImgController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataModle.h"
#import "UIImageView+WebCache.h"

@interface TextImgController() {
    NSMutableData *receivedData;
    UIWebView *webView;
    NSArray *arrays;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation TextImgController

@synthesize arraysStr;
@synthesize addStatusBarHeight;
@synthesize textStr;
@synthesize isCanBuy;
- (void)viewDidLoad
{
    [super viewDidLoad];//没有词句,会执行多次
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    

    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = VIEWBGCOLOR;
    if(arraysStr.length > 0 || self.textStr > 0){
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
        webView.userInteractionEnabled = YES;
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        NSString *webURL = [NSString stringWithFormat:@"%@/textImg.html",PAGEURLADDRESS];
        //------------//网络网络---------------
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
        
        //----loading显示
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = self.view.center;
        [self.view addSubview:activityIndicator];
        activityIndicator.color = [UIColor orangeColor]; // 改变圈圈的颜色为红色； iOS5引入
        [activityIndicator startAnimating]; // 开始旋转
        [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIColor *)getTopNaviColor{
    if (!isCanBuy) {
        return TOPNAVIBGCOLOR_G;
    }else{
        return TOPNAVIBGCOLOR;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewTmp{
    [activityIndicator stopAnimating]; // 结束旋转
    NSString *funcStr = [NSString stringWithFormat:@"showImgsAndText('%@','%@')",arraysStr,textStr];
    NSLog(@"fkewokfeowpfkewp-----%@",funcStr);
    [webView stringByEvaluatingJavaScriptFromString:funcStr];
}
//-----修改标题
-(NSString*)getTitle{
    return @"图文详情";
}
//----下载图片
- (void)downloadPngImage:(NSString *)imgUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imgUrl]];
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"get some data");
    [receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *results = [[NSString alloc]
                         initWithBytes:[receivedData bytes]
                         length:[receivedData length]
                         encoding:NSUTF8StringEncoding];
    
    CGSize imgSize = [self jpgImageSizeWithHeaderData:receivedData];
    
    
    NSLog(@"connectionDidFinishLoading: %@--%@",results,NSStringFromCGSize(imgSize));
}
//-----获取图片大小
- (CGSize)jpgImageSizeWithHeaderData:(NSData *)data
{
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
