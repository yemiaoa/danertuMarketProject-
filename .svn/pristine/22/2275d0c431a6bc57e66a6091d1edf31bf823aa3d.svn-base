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

#import "CityController.h"
#import "UIView+Toast.h"
#import "DataModle.h"
#import "UIDevice+IdentifierAddition.h"
#import "AHReach.h"
@interface ShopDataController : HeBaseViewController<UIScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *city;
@property (nonatomic, strong) NSString *province;//省份
@property (nonatomic, strong) NSString *coordinate;//"lat,lot"  坐标构成的字符串
@property (nonatomic, strong) NSString *preCoordinate;//"lat,lot"  坐标构成的字符串

@property (nonatomic, strong) NSString *p;
@property (nonatomic, strong) NSString *keyWord;//搜索关键字
@property (nonatomic, strong) NSString *distanceParameter;//范围
@property (nonatomic, strong) NSString *classifyType;//搜索分类,定送餐,----来自首页的
@property (nonatomic) BOOL isHaveMore;//是否有更多数据可以加载
@property (nonatomic) BOOL isNetWorkRight;//网络正常
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) DataModle *modleFromFavoarite;//
@property (atomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *refreshLb;
@property (nonatomic,strong)NSCache *imageCache;

@end

@interface NSString (mamu)
-(void) method;
@end


