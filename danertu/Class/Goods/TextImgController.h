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
@interface TextImgController : TopNaviViewController<UIWebViewDelegate>

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic,strong) NSString *arraysStr;
@property (nonatomic,strong) NSString *textStr;
@property (nonatomic,assign) BOOL isCanBuy;
@end
