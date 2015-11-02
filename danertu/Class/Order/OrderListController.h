//
//  KKFirstViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlipayPostInfo.h"
#import "TopNaviViewController.h"
#import "RealPayController.h"
#import "OrderFormController.h"
#import "AsynImageView.h"

@interface OrderListController : TopNaviViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic) int addStatusBarHeight;
//------------新增---------------
@property (nonatomic, strong) UIView *topSegmentView; //分类,待支付,待评价
@property (nonatomic, strong) UILabel *flagLb; //编辑,取消lb
@property (nonatomic) NSInteger currentItemTag; //当前选择的类别,0,1,2,3
@property (nonatomic, strong) UICollectionView *gridView;
@property (atomic, strong) NSMutableArray *orderArrays; //订单数组,有编号,支付状态.....
@property (atomic, strong) UIView *noOrderView; //没有订单的视图
@property (nonatomic,strong)NSCache *imageCache;

@end
