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
#import "HeGetCashVC.h"

#import "AES128Util.h"
#import "NSData+ASE128.h"
#import "Crypto.h"
#import "AlipayPostInfo.h"

#import "PayMMSingleton.h"

#import "MyKeyChainHelper.h"
@interface WalletViewController : TopNaviViewController<UIWebViewDelegate,UIAlertViewDelegate,getCashProtol>

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong)NSUserDefaults *defaults;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *webType;

@property(strong,nonatomic)NSString *jsJsonString;

@end
