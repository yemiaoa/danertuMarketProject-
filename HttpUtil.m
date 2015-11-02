//
//  HttpUtil.m
//  OnlineExam
//
//  Created by Goven on 13-10-18.
//  Copyright (c) 2013年 Goven. All rights reserved.
//

#import "HttpUtil.h"
#import "AFNetworking.h"
#import "JSONKit.h"

@implementation HttpUtil

+ (void)doGetWithUrl:(NSString *)url path:(NSString *)path params:(NSDictionary *)params callback:(BKHttpCallback) callback
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    [httpClient getPath:path
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                    NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    if (responseJson)
                    {
                        NSDictionary *result = [responseJson objectFromJSONString];
                        callback(YES, result);
                    }
                    else
                    {
                        callback(NO, nil);
                    }
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    callback(NO, nil);
                }];
}

+ (void)doPostWithUrl:(NSString *)url path:(NSString *)path params:(NSDictionary *)params callback:(BKHttpCallback)callback
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient postPath:path
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                     NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                     if (responseJson)
                     {
                         NSDictionary *result = [responseJson objectFromJSONString];
                         callback(YES, result);
                     }
                     else
                     {
                         callback(NO, nil);
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    callback(NO, nil);
                }];
}

+ (void)getImageWithUrl:(NSString *)url callback:(BKHttpCallback)callback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:request];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *image = responseObject;
        NSDictionary *result = @{@"image":image};
        callback(YES, result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO, nil);
    }];
    [requestOperation start];
}

@end
