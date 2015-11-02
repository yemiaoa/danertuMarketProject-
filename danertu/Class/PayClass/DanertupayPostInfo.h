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
#import "PayMMSingleton.h"
#import "AES128Util.h"
#import "NSData+ASE128.h"


@interface DanertupayPostInfo : NSObject

-(void)doPayByDanertu:(NSMutableDictionary*)orderInfoDic priceData:(NSString *)priceData parentV:(UIView *)parentView canclable:(BOOL)canclable resultBlock:(void (^)(BOOL isFinish))resultBlock ;
@property (nonatomic) NSUserDefaults *defaults;//本地存储
@end