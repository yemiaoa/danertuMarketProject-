//
//  KKFirstViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
#import "UIView+Toast.h"
#import "AddressListController.h"
#import "AddressNewController.h"
#import "DetailViewController.h"
@interface BookDetailController : TopNaviViewController
@property (nonatomic, strong) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic,strong) NSDictionary *bookOrderInfo;

- (id)initWithBookDict:(NSDictionary *)dict;

@end
