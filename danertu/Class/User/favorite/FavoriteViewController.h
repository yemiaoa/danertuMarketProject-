//
//  KKFirstViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModle.h"
#import "FavoriteWoodsModle.h"
#import "TopNaviViewController.h"
@interface FavoriteViewController : TopNaviViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong)UILabel *segment1;
@property (nonatomic, strong)UILabel *segment2;
@property (nonatomic, strong) FavoriteWoodsModle *selectedM;

@end
