//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatListModle.h"
#import "CatListViewCell.h"
#import "KKFirstViewController.h"
#import "TabBarController.h"

#import "WoodDataController.h"
enum searchType{
    SEARCHSHOP,
    SEARCHWOOD
};
#define HOT_ITEM_COUNT 6 //热门搜索 条目 数
#define SCROLL_CONTENT_GAP 20 //热门搜索 条目 数

@interface SearchViewController : HeBaseViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary *cachedImage;

@property (nonatomic, strong) NSString *keyWord;//搜索关键字
@property (nonatomic, strong) NSString *distanceParameter;//搜索关键字
@property (nonatomic, strong) UIScrollView *scrollView;// 滑动区域
@property (nonatomic, strong) NSUserDefaults *defaults;//本地化存储
@property (nonatomic, strong)UILabel *segment1;
@property (nonatomic, strong)UILabel *segment2;
@property (nonatomic, strong)UILabel *segment3;
@property (nonatomic, strong) UILabel *item2AreaLb;//范围搜索


@property (nonatomic, strong) UIButton *item3Area_delete;//搜索记录

@property (nonatomic, strong)UILabel *segmentBlock1;
@property (nonatomic, strong)UILabel *segmentBlock2;


@property (nonatomic) int scrollViewStartY;//滑动区域开始Y坐标
@property (nonatomic) int hotItemIndex,distanceItemIndex,historyItemIndex;//记录下表用于改变显示状态
@property (nonatomic, strong) UIView *item3AreaLb;//搜索记录
@property (nonatomic, strong) UIView *item3Area_list;//搜索记录

@property (nonatomic, strong)UILabel *topNaviClassifyText;
@property (nonatomic, strong)UIView *classifyView;
@property (nonatomic, strong)NSArray *classifyArr;
@property (nonatomic, strong)UITextField *searchText;
@end
