//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "TopNaviViewController.h"


#import "AddressListController.h"
#import "AddressNewController.h"


#import "AlipayPostInfo.h"
#import "UPPayPlugin.h"

#import "WXApi.h"
#import "TenpayUtil.h"
#import "payRequsestHandler.h"
#import "DanertupayPostInfo.h"
#import "UIDevice+IdentifierAddition.h"
#import "OrderListController.h"
#import "MyKeyChainHelper.h"

@interface OrderFormController : TopNaviViewController<UPPayPluginDelegate,UIAlertViewDelegate>
{
    NSString *lastSelectDataString;
}
@property (nonatomic, strong) NSUserDefaults *defaults;//本地存储
@property (nonatomic, strong)UILabel *totalLbPart;
@property (nonatomic, strong)UIScrollView *contentView;

@property (nonatomic, strong)UILabel *clickAdd;
@property (nonatomic, strong)UIView *itemSelect;
@property (nonatomic, strong)UILabel *userNameLb;
@property (nonatomic, strong)UILabel *mobileLb;
@property (nonatomic, strong)UILabel *adrLb;

@property (nonatomic, strong)NSMutableArray *productInfo;
@property (nonatomic,strong) NSString *productInfoStr;
@property (nonatomic, strong)UIImageView *backHomeIcon;
@property (nonatomic) int addStatusBarHeight;
@property (assign,nonatomic)NSInteger giveNumber;



@property (nonatomic,strong) NSMutableDictionary *orderInfoDic;
@property (nonatomic) BOOL isAddAddress;//是否添加了地址
@property (nonatomic,strong) UIButton *payBtn;

@property (nonatomic) BOOL isFromActivity;
@property (nonatomic, strong) NSDictionary *activityWood;
@property (nonatomic, strong) NSDictionary *addressInfo;

@property (nonatomic) BOOL canGoAddressView;
@property (nonatomic) BOOL isFromDirectlyPay;//是否来自商品详情页,不是来自购物车

@property (nonatomic, strong)UILabel *shouldPayTextLb;

@property (nonatomic, strong)NSMutableDictionary *subViewDict; //存放与价格有关的视图，可以方便寻址修改价格
@end

@interface NSMutableArray (convertToDic)

-(NSMutableArray *)convertToDic:(NSString *)keyName;

@end
