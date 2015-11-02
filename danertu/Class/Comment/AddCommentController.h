//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTapRateView.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIView+Toast.h"

@interface AddCommentController : HeBaseViewController<RSTapRateViewDelegate,UITextViewDelegate>

@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic, strong)UIImageView *backHomeIcon;
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UIImageView *refreshIcon;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, retain) RSTapRateView *tapRateView;
@property (nonatomic, retain) UILabel *labeltext;
@end