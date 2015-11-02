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

#import "ClassifyDetailController.h"
#import "DanertuWoodsController.h"
#import "LoginViewController.h"
#import "WoodDataController.h"
#import "WebViewController.h"


@interface GoldCarrotController : TopNaviViewController<UIScrollViewDelegate>
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) UIView *userInfoView;
@end
