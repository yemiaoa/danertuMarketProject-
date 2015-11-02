//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "TopNaviViewController.h"
#import "VRGCalendarView.h"
#import "UIView+Toast.h"
#import "SDBManager.h"
#import "LoginViewController.h"
@interface SignInController : TopNaviViewController<VRGCalendarViewDelegate>
@property (nonatomic, strong) NSUserDefaults *defaults;//本地化存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UILabel *signText;
@property (nonatomic, strong) NSDateComponents *currentDate;
@property (nonatomic, strong) FMDatabase * dataBase;
@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) VRGCalendarView *calendar;
@property (nonatomic) BOOL isSignInToday;
@end
