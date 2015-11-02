//
//  KKAppDelegate.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "OpenUDID.h"
#import "KKFirstViewController.h"
#import "Dao.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>
#import "SDBManager.h"
#import "APService.h"
#import "HeSingleModel.h"
//#import <TestinAgent/TestinAgent.h>
#import <BaiduMapAPI/BMapKit.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface KKAppDelegate : UIResponder<UIAlertViewDelegate,BMKGeneralDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *publicKey;
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int priceScore;
@property (strong, nonatomic)NSOperationQueue *queue;
@end
