//
//  WineActiveInfoViewController.h
//  单耳兔
//
//  Created by administrator on 15-5-21.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "HeWineActivityCell.h"

@interface WineActiveInfoViewController : TopNaviViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong) UILabel *infoLb;

@property (nonatomic,strong)UITableView *tableView;

@end
