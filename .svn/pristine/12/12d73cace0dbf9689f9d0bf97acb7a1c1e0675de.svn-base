//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIView+Toast.h"

@interface AddressNewController : TopNaviViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UIButton *setDefaultBtn;
@property (nonatomic) BOOL isDefaultAddress;
@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *telphone;
@property (nonatomic, strong) UILabel *preAddress;
@property (nonatomic, strong) UITextField *address;
@property (nonatomic) BOOL isFromOrderForm;//是否来自订单,
@end
