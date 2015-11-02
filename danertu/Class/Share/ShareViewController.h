//
//  WebViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "QRCodeGenerator.h"
#import <ShareSDK/ShareSDK.h>
#import "HeSingleModel.h"
#import "TopNaviViewController.h"

@interface ShareViewController : TopNaviViewController

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)NSString *shareId ;
@property (nonatomic, strong)NSString *shareType ;
@property (nonatomic, strong)NSDictionary *shareInfo ;
@property (nonatomic, strong)NSString *shareNumber;
@property (nonatomic, strong)UILabel *infoLb;
@property (nonatomic, strong)NSString *myshopName;

@end
