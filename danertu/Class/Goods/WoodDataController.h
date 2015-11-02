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

#import "UIView+Toast.h"
#import "DanModle.h"
#import "UIDevice+IdentifierAddition.h"
#import "AHReach.h"
#import "GoodsDetailController.h"

#import "TopNaviViewController.h"
@interface WoodDataController : TopNaviViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *gridView;

@property (nonatomic, strong) UIImageView *additionIcon;
@property (nonatomic, strong) UILabel *classifyLb;
@property (nonatomic, strong) UILabel *activity;
@property (nonatomic, strong) UIButton *arrow ;

@property (nonatomic) BOOL isNetWorkRight;//网络正常
@property (nonatomic) int timerValue;//是否有数据
@property (nonatomic) int addStatusBarHeight;

@property (nonatomic) BOOL isShowingActivity;//loading 是否显示

@property (nonatomic) BOOL isToGetShopByCity;//是否第一次加载城市
@property (nonatomic) BOOL isFirstToLoad;//是否第一次加载城市
@property (nonatomic) BOOL isClickedRefresh;//是否点击了刷新按钮
@property (nonatomic) BOOL isToDetailByFavoNotify;//是否点击了刷新按钮
@property (nonatomic) BOOL isFirstToPostInner;//是否点击了刷新按钮
@property (nonatomic) BOOL isShowActivity;//---是否显示广告

@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic, strong) DanModle *modleFromFavoarite;//
@property (atomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UIButton *reachTop;//---返回顶部----
@property (nonatomic) BOOL isDataByClassifyType;//---是否分类--

@property (nonatomic) BOOL isToRefresh;//---是否下拉刷新
@property (nonatomic, strong) UILabel *refreshLb;
@property (nonatomic, strong) NSCache *imageCache;

//------新增
@property (nonatomic, strong) NSDictionary *selectTypeDic;
@property (nonatomic, strong) NSString *searchKeyWord;//搜索关键字

@property (nonatomic, strong)NSString *shopID; //该分类商品所在的店铺的ID

@end