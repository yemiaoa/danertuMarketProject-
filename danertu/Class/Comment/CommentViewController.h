//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "CommentModle.h"
#import "UIView+Toast.h"
#import "SBJSON.h"
#import "CommentViewCell.h"
#import "UIImageView+WebCache.h"
#import "AHReach.h"
@interface CommentViewController : HeBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSUserDefaults *defaults;//本地存储
@property (nonatomic, strong)UIImageView *backHomeIcon;
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UITableView *gridView;
@property (nonatomic, strong) CommentModle *commendModle;
@property (nonatomic, strong) NSString *p;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (nonatomic) BOOL isHaveMore;//是否有更多数据可以加载
@property (nonatomic) BOOL isHaveData;//是否有数据
@property (nonatomic) BOOL isNetWorkRight;//网络正常
@property (nonatomic, strong) UIButton *reachTop;
@property (nonatomic, strong) UIImageView *addCommentIcon;

@end
