//
//  HeWebRequestModel.h
//  单耳兔
//
//  Created by Tony on 15/7/17.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//  JS调用原生的时候的一些公共访问方法

#import <Foundation/Foundation.h>

typedef void(^jsCallBackBlock)(NSString *callBackJson);

@interface HeWebRequestModel : NSObject

/*
 *brief js调用原生的时候访问的post公共方法
 *params paramsJson 请求的json
 *params jsMethod 回调js的时候的方法
 */
+ (void)requestWithPostJson:(NSString *)paramsJson callBackMethod:(NSString *)jsMethod withBlock:(jsCallBackBlock)callBackBlock;

/*
 *brief js调用原生的时候访问的get公共方法
 *params getUrl get请求的url
 *params jsMethod 回调js的时候的方法
 */
+ (void)requestWithGetUrl:(NSString *)getUrl callBackMethod:(NSString *)jsMethod withBlock:(jsCallBackBlock)callBackBlock;

@end
