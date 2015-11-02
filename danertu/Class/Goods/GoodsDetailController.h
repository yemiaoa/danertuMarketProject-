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
#import "CommentViewController.h"

#import "DataModle.h"
#import "DanModle.h"
#import "UIView+Toast.h"
#import "AHReach.h"
#import "KGModal.h"

#import "TopNaviViewController.h"
#import "TextImgController.h"
#import "BookProductController.h"
#import "OrderFormController.h"


#import "MyKeyChainHelper.h"

@interface GoodsDetailController : TopNaviViewController<UITextFieldDelegate,UIActionSheetDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)DataModle *modle;//来自首页,本店相关数据
@property (nonatomic, strong)NSString *danModleGuid;//来自首页,本店相关数据

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UITableView *gridView;

@property (nonatomic) NSUserDefaults *defaults;//本地存储

@property (nonatomic) UIImageView *favorite;//收藏

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic) BOOL isShopAddToFavorite;//是否本店加入收藏



@property (nonatomic) UILabel *woodsName;
@property (nonatomic) UILabel *woodsPrice;
@property (nonatomic) UITextField *woodsNum;
@property (nonatomic) UILabel *woodsTotal;
@property (nonatomic) UILabel *woodsGoal;

@property (nonatomic) UILabel *introduceValue;
@property (nonatomic) UILabel *introduceMore;
@property (nonatomic) UILabel *commentValue;
@property (nonatomic) UILabel *commentMore;

@property (nonatomic) UIStepper *stepper;


@property (nonatomic, strong) NSString *activityWoodName;

@property (nonatomic, strong) NSMutableArray *availableMaps;


@property (nonatomic) BOOL isDiscountCard;//是否是打折卡(这里可能是打折卡,可能是正常商品)
@property (nonatomic, strong) NSString *shopImg;//------shopbanner图----需要显示---
@property (nonatomic, strong) NSMutableDictionary *shopDetailInfoDict;  //店铺详情信息
//@property (nonatomic, assign) BOOL isQuanYanGoods;  //判断是否泉眼店铺以及泉眼商品

/*!
 @method
 @brief 把店铺的信息传递过来
 @discussion
 @param shopDict 店铺的信息
 @result 返回商品的一个实例
 */
-(id)initGoodsWithShopDict:(NSDictionary *)shopDict;

@end
