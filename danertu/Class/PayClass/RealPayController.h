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
#import "AlipayPostInfo.h"
#import "UPPayPlugin.h"

#import "WXApi.h"
#import "TenpayUtil.h"
#import "payRequsestHandler.h"

#import "DanertupayPostInfo.h"

@interface RealPayController : TopNaviViewController<UPPayPluginDelegate>
@property (nonatomic, strong) NSUserDefaults *defaults;//本地化存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UILabel *totalPayLb;
@property (nonatomic, strong) NSDictionary *payMoneyDic;
@property (nonatomic, strong) NSDictionary *addressInfo;
@property (nonatomic, strong) UIView *selectGoldPayView;

@property (nonatomic) BOOL isGoldCarrotPay;//是否使用金萝卜支付
@property (nonatomic,strong) NSMutableDictionary *orderInfoDic;
@property (nonatomic, strong)NSMutableArray *productInfo;
@property (nonatomic,strong) NSString *productInfoStr;
@property (nonatomic, strong) NSDictionary *activityWood;
@property (nonatomic, strong)NSArray *productsArr;

@property (nonatomic) BOOL isFromPayOff;//是否来自直接付款(不是订单中心)
@end
