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
#import "CJSONDeserializer.h"
#import "AnnounceDetailController.h"

@interface AnnouncementController : TopNaviViewController<UIScrollViewDelegate>

@property (nonatomic,assign) int addStatusBarHeight;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *messageArr;
@property (nonatomic,strong) NSString *shopID;    //商家的ID，如果有值，那么消息就只会显示专属该商家的消息

@end
