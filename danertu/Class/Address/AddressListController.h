//
//  KKFirstViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
#import "AddressManagerController.h"
#import "AddressNewController.h"
#define ADDRESSLIST_ITEMHEIGHT 70

@interface AddressListController : TopNaviViewController

@property (nonatomic, strong) UIView *deleteBtnView;
@property (nonatomic, strong) UIButton *deletePart;
@property (nonatomic, strong) UIButton *deleteAll;

@property (nonatomic, strong) NSMutableArray *selectAddressTagArray;
@property (nonatomic, strong) UILabel *editLb;//编辑,取消lb

@property (nonatomic) BOOL isEditMode;//是否是编辑模式

@property (nonatomic, strong) UIView *bottomNavi;
@property (nonatomic, strong) UIView *maskView;



@property (nonatomic, strong) UIScrollView *addressView;
@property (nonatomic, strong) UIScrollView *payedView;
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) NSDictionary *selectedAddress;//选择管理的地址
@property (nonatomic) BOOL isFromOrderForm;
@property (nonatomic, strong) NSString *prevAddressGuid;//之前收货地址的guid;
@end
