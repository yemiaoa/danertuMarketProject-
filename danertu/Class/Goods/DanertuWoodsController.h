//
//  KKFirstViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "DanModle.h"
#import "DataModle.h"
#import "DanertuWoodsViewCell.h"
#import "ShopCatController.h"
#import "GoodsDetailController.h"
#import "AHReach.h"
#import "AsynImageView.h"
#import "TopNaviViewController.h"
@interface DanertuWoodsController : TopNaviViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) DataModle *modle;//来自首页,本店相关数据
@property (nonatomic, strong) NSMutableDictionary *cachedImage;
@property (nonatomic, strong) UITableView *gridView;
@property (nonatomic, strong) DanModle *selectedM;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;

@property (nonatomic) int woodsCount;//购物车物品数量,
@property (nonatomic) NSUserDefaults *defaults;//本地存储

@property (nonatomic) BOOL isShowingActivity;
@property (nonatomic) int addStatusBarHeight;
@property(nonatomic, strong)NSCache *imageCache;


@property (nonatomic) int currentSegmentNo;//当前的segment编号------
@end
