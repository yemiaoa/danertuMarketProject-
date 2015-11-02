//
//  HeWebRequestModel.m
//  单耳兔
//
//  Created by Tony on 15/7/17.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeWebRequestModel.h"
#import "AFOSCClient.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation HeWebRequestModel

/*
 *brief js调用原生的时候访问的post公共方法
 *params paramsJson 请求的json
 *params jsMethod 回调js的时候的方法
 */
+ (void)requestWithPostJson:(NSString *)paramsJson callBackMethod:(NSString *)jsMethod withBlock:(jsCallBackBlock)callBackBlock
{
    NSDictionary *params = [paramsJson objectFromJSONString];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondString = operation.responseString;
        callBackBlock(respondString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *respondString = operation.responseString;
        callBackBlock(respondString);
    }];
}

/*
 *brief js调用原生的时候访问的get公共方法
 *params getUrl get请求的url
 *params jsMethod 回调js的时候的方法
 */
+ (void)requestWithGetUrl:(NSString *)getUrl callBackMethod:(NSString *)jsMethod withBlock:(jsCallBackBlock)callBackBlock
{
    [[AFOSCClient sharedClient] getPath:getUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondString = operation.responseString;
        callBackBlock(respondString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *respondString = operation.responseString;
        callBackBlock(respondString);
    }];
}

@end
