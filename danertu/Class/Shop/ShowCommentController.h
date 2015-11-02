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
#import "ShopCommentController.h"

@interface ShowCommentController : TopNaviViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSDictionary *shopInfoDic;//来自首页,本店相关数据
@end
