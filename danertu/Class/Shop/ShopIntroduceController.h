//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIView+Toast.h"

@interface ShopIntroduceController : TopNaviViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSDictionary *shopInfoDic;
@property (nonatomic, strong) NSString *shopInfoStr;
@end
