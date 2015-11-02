//
//  AFOSCClient.h
//  哲信
//
//  Created by 何栋明 on 12-8-14.
//  Copyright (c) 2012年 哲信信息科技有限公司. All rights reserved.
//  网络请求的单例


#import "AFHTTPClient.h"

@interface AFOSCClient : AFHTTPClient

+ (AFOSCClient *)sharedClient;

@end
