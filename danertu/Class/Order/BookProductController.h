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
#import "BookFinishController.h"

@interface BookProductController : TopNaviViewController
@property (nonatomic, strong) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic,strong) NSMutableArray *arrays;
@property (nonatomic,strong) NSMutableDictionary *bookWood;


@property (nonatomic, strong)UILabel *clickAdd;
@property (nonatomic, strong)UIView *itemSelect;
@property (nonatomic, strong)UILabel *userNameLb;
@property (nonatomic, strong)UILabel *mobileLb;
@property (nonatomic, strong)UILabel *adrLb;

@property (nonatomic) BOOL isAddAddress;//是否添加了地址
@property (nonatomic,strong) UIButton *payBtn;

@property (nonatomic,strong) NSMutableDictionary *orderInfoDic;

@property (nonatomic, strong) NSDictionary *addressInfo;

@property (nonatomic) BOOL canGoAddressView;

@property (nonatomic, strong)UIScrollView *contentView;
@property (nonatomic, strong)UILabel *shouldPayTextLb;
@end
