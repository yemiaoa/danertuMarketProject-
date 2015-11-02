//
//  alipayPostInfo.h
//  单耳兔
//
//  Created by administrator on 14-8-12.
//  Copyright (c) 2014年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AlipayPostInfo : NSObject

-(void)doPayByAlipay:(NSMutableDictionary*)orderInfoDic resultBlock:(void (^)(BOOL isFinish))resultBlock;

@property (nonatomic,retain) NSOperationQueue *aliPayQueue;
@property (nonatomic,assign) SEL result;
@property (nonatomic,retain) NSString *PartnerID;
@property (nonatomic,retain) NSString *SellerID;
@property (nonatomic,retain) NSString *PartnerPrivKey;
@property (nonatomic,retain) NSString *AlipayPubKey;
@property (nonatomic,retain) NSMutableDictionary *orderInfoDic;
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@end