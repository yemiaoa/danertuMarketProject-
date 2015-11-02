//
//  HeMerchantDetailVC.h
//  单耳兔
//
//  Created by iMac on 15/6/24.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "CityController.h"
#import "UIView+Toast.h"
#import "DataModle.h"
#import "WebViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import "ShopDataController.h"
#import <MapKit/MapKit.h>
#import "CJSONDeserializer.h"
#import "KGModal.h"
#import "AHReach.h"
#import "ZeroOneController.h"
#import "GoodFoodController.h"
#import "Dao.h"

#import "LocationSingleton.h"

#import "AnnouncementController.h"
#import "CustomURLCache.h"
#import "MyKeyChainHelper.h"

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

#import "AES128Util.h"
#import "NSData+ASE128.h"
@interface HeMerchantDetailVC : TopNaviViewController<UIActionSheetDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate,UIAlertViewDelegate>



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

@property (nonatomic, strong) NSString *shopIdFrom;//---联系电话
@end
