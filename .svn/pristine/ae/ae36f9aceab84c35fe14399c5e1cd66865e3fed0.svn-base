/*****************************************************************
 * 版权所有： 江西倍康信息技术有限公司 (2014)
 * 文件名称： HttpUtil.h
 * 内容摘要： http远程访问的工具类
 * 其它说明：
 * 编辑作者： 李华光
 * 版本编号： 1.0
 * Copyright (c) 2014年 bitcare. All rights reserved.
 ****************************************************************/

#import <Foundation/Foundation.h>

typedef void (^BKHttpCallback)(BOOL isSuccessed, NSDictionary *result);

@interface HttpUtil : NSObject

/**
 *  GET方法请求数据
 *
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param (BOOL isSuccessed, Result *result))callback  回调方法
 */
+ (void)doGetWithUrl:(NSString *)url path:(NSString *)path params:(NSDictionary *)params callback:(BKHttpCallback) callback;

/**
 *  请求WebService数据
 *
 *  @param baseUrl  请求的基础URL
 *  @param params   请求参数
 *  @param (BOOL isSuccessed, Result *result))callback  回调方法
 */
+ (void)doPostWithUrl:(NSString *)url path:(NSString *)path params:(NSDictionary *)params callback:(BKHttpCallback)callback;

/**
 *  Get方法请求图片
 *
 *  @param url      图片URL
 *  @param (BOOL isSuccessed, Result *result))callback  回调方法
 */
+ (void)getImageWithUrl:(NSString *)url callback:(BKHttpCallback)callback;

@end
