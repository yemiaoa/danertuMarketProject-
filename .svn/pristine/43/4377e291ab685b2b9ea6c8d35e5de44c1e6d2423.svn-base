//
//  DetailViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "DataModle.h"
#import "UIView+Toast.h"
#import "GoodsDetailController.h"
#import "DanertuWoodsController.h"
#import "AHReach.h"
#import <MapKit/MapKit.h>

#import "ClassifyDetailController.h"
#import "TopNaviViewController.h"
#import "ShareViewController.h"
#import "ShopIntroduceController.h"
#import "CJSONDeserializer.h"
#import "GameBlareController.h"
#import "ClientWoodsController.h"

#import "ShopCommentController.h"
#import "ShowCommentController.h"


#import "SearchViewController.h"
#import "GoodFoodController.h"
#import "MyViewController.h"
#import "ShareViewController.h"
#import "HeTestShopVC.h"
#import "AES128Util.h"
#import "NSData+ASE128.h"
@interface DetailViewController : TopNaviViewController<UIActionSheetDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>


- (id)initWithFileName:(NSString *)fileModel;

@property (nonatomic, strong)DataModle *modle;//来自首页,本店相关数据
@property (nonatomic, strong)DanModle *selectedM;//点击选中的hotelModle


@property (nonatomic) int woodsCount;//购物车物品数量,
@property (nonatomic) NSUserDefaults *defaults;//本地存储

@property (nonatomic) UIButton *favorite;//收藏

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic) BOOL isShopAddToFavorite;//是否本店加入收藏
@property (nonatomic) NSMutableArray *favoriteShopList;//收藏店铺列表

@property (nonatomic) dispatch_queue_t urls_queue;

@property (nonatomic, strong) NSMutableArray *availableMaps;


@property (nonatomic) BOOL isPreRequestFinished;//---前一次数据请求是否完成----

@property (nonatomic, strong) NSString *contactTel;//---联系电话

@property (nonatomic, strong) UIView *clientGoodsView;

@property (nonatomic, strong) NSString *agentid;//店铺ID
@property (nonatomic, strong) NSString *shopName;

@property(strong,nonatomic)NSString *jsJsonString;

@end
