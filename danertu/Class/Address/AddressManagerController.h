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
@interface AddressManagerController : TopNaviViewController
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) NSDictionary *address;
@property (nonatomic, strong) UIButton *setDefaultBtn;
@property (nonatomic) BOOL isDefaultAddress;
@property (nonatomic, strong) UIView *addressView;//显示地址的文本区域
@end
