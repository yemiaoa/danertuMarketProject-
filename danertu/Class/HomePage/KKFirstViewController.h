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
#import "KKAppDelegate.h"
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

@interface KKFirstViewController : HeBaseViewController< CityControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
}
@property (nonatomic, strong) UITableView *gridView;
@property (nonatomic, strong) NSDictionary *city;
@property (nonatomic, strong) NSString *coordinate;//"lat,lot"  坐标构成的字符串
@property (nonatomic, strong) NSString *preCoordinate;//"lat,lot"  坐标构成的字符串

@property (nonatomic, strong) UILabel *cityLb;
@property (nonatomic, strong) UIImageView *refreshIcon;
@property (nonatomic, strong) UIImageView *additionIcon;
@property (nonatomic, strong) UIView *classifyLb;
@property (nonatomic, strong) UIView *activity;
@property (nonatomic, strong) UIButton *arrow ;

@property (nonatomic, strong) NSString *p;
@property (nonatomic, strong) NSString *keyWord;//搜索关键字
@property (nonatomic, strong) NSString *distanceParameter;//范围
@property (nonatomic, strong) NSString *classifyType;//搜索关键字
@property (nonatomic) BOOL isHaveMore;//是否有更多数据可以加载
@property (nonatomic) BOOL isHaveData;//是否有数据
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
@property (nonatomic) BOOL isToRefresh;//---是否下拉刷新
@property (nonatomic, strong) DataModle *modleFromFavoarite;//
@property (atomic, strong) NSMutableArray *arrays;//-----------源原子访问,遍历时不可增删改------
@property (nonatomic, strong) UIScrollView *adsScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *slideImages;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *reachTop;

@property (nonatomic, strong) UIView *popMapView;//----弹出层------
@property (nonatomic, strong) MKMapView *mapView;//----弹出层地图----业务员使用
@property (nonatomic, strong) UILabel *posTipsLb;
@property (nonatomic, strong) UILabel *currentPos;
@property (nonatomic, strong) UIButton *sendPosBtn;
@property (nonatomic, strong) UILabel *refreshLb;

@property (nonatomic) BOOL isPreRequestFinished;//---前一次数据请求是否完成----

//webview-------
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *firstLoadDataStr;
@property (nonatomic, strong) NSString *selectShopId;

@property (nonatomic, strong) UIView *topNavi_zeroOne;//0.1元购

@property (nonatomic, strong) NSDictionary *activityWoodInfo;

@property (nonatomic) BOOL isWebPageLoaded;

@property (strong, nonatomic) CLLocationManager* locationmanager;
@property (strong, nonatomic) NSMutableDictionary *pos;
@property (strong, nonatomic) NSDictionary *cityFromPos;
@property (nonatomic) BOOL isEnterBakcground;

@end
