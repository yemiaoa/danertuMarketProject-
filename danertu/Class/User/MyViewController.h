//
//  DetailViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import <ShareSDK/ShareSDK.h>
//#import "MyKeyChainHelper.h"
#import "OrderListController.h"
#import "BookOrderController.h"
//#import "GameBlareController.h"
#import "TopNaviViewController.h"
#import "HeWineCheckVC.h"

#import "AccountSecurityController.h"
#import "SettingsViewController.h"
#import "SignInController.h"
#import "FavoriteViewController.h"
#import "AddressListController.h"
#import "AnnouncementController.h"
#import "WebViewController.h"
#import "GoldCarrotController.h"
#import "WalletViewController.h"
#import "WineActiveInfoViewController.h"

@interface MyViewController : TopNaviViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, strong) UILabel *showTextLabel;
@property (nonatomic, strong) UILabel *scoreLb;
@property (nonatomic, strong) UILabel *refreshLb;
@property (nonatomic) BOOL isToRefresh;//是否下拉刷新

@property (nonatomic, strong) NSUserDefaults *defaults;//本地化存储
//@property (nonatomic, strong)UIImageView *backHomeIcon;
//@property (nonatomic) int addStatusBarHeight;



@property (nonatomic, strong) UIButton *loginBtn;//退出按钮
@property (nonatomic, strong) UIView *userInfoView;//个人账户积分,
@property (nonatomic, strong) UIImageView *portrait;//个人账户积分,
@end
