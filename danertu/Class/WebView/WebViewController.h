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
#import "ZeroOneController.h"
#import "GoodsDetailController.h"
#import "ClassifyViewController.h"
#import "SearchShopViewController.h"

@interface WebViewController : TopNaviViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong)NSUserDefaults *defaults;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *webType;

@property (nonatomic, strong) NSString *agentid;  //店铺的ID

@property (nonatomic, assign) CGFloat narBarOffsetY;  //导航条的Y坐标的偏移量

@property (nonatomic, strong) NSString *showTopBar;

@property (nonatomic, strong) NSDictionary *shopDetailInfoDict;  //店铺详情信息
@property (nonatomic, assign) BOOL isCheckJiu;  //判断是否送酒审核的页面，由于送酒的页面需要加载数据，然而在页面那边还没加载完成不能直接调用js，因此等待加载完成判断是否送酒，如果是送酒审核的页面然后再调用js

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopNumber; //店铺码

@property (nonatomic, strong) NSString *infoGuid;  //店铺咨询某一条咨询的ID

@property(strong,nonatomic)NSString *jsJsonString;

@property(assign,nonatomic)BOOL isPublicPage; //是否公共页面
/*!
 @method
 @brief 把店铺的信息传递过来
 @discussion
 @param shopDict 店铺的信息
 @result 返回WebViewController的一个实例
 */
-(id)initWebViewWithShopDict:(NSDictionary *)shopDict;

@end