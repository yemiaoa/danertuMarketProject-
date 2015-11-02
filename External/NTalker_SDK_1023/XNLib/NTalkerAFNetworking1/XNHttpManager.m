//
//  XNHttpManager.m
//  TestiOS6
//
//  Created by  on 15/10/13.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "XNHttpManager.h"
#import "AFNetworking.h"

@interface XNHttpManager ()

@property (strong, nonatomic) AFHTTPClient *client;

@end

static XNHttpManager *httpManager = nil;
@implementation XNHttpManager

+ (XNHttpManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!httpManager) {
            httpManager = [[XNHttpManager alloc] init];
        }
    });
    return httpManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}

- (void)getHttpService:(NSString *)URLStr andParmas:(NSDictionary *)dict andSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSError *))failure
{
    [_client getPath:URLStr
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if ([responseObject isKindOfClass:[NSData class]]) {
                     if (success) {
                         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                         success(result);
                     }
                 } else {
                     if (failure) {
                         NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"error":@"回调失败"}];
                         failure(error);
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
}

- (void)postHttpService:(NSString *)URLStr andParams:(NSDictionary *)dict andSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSError *))failure
{
    [_client postPath:URLStr
           parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([responseObject isKindOfClass:[NSData class]]) {
                      if (success) {
                          NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                          success(result);
                      }
                  } else {
                      if (failure) {
                          NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"error":@"回调失败"}];
                          failure(error);
                      }
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (failure) {
                      failure(error);
                  }
              }];
}

- (void)uploadFile:(NSString *)URLStr andParams:(NSDictionary *)dict andType:(NSString *)type andFilePath:(NSString *)path andSuccess:(void (^)(NSString *response))success andFailure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [_client multipartFormRequestWithMethod:@"POST"
                                                                     path:URLStr
                                                               parameters:dict
                                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                    NSData *data = [NSData dataWithContentsOfFile:path];
                                                    [formData appendPartWithFileData:data name:@"userfile" fileName:[path lastPathComponent] mimeType:type];
                                                }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:(NSURLRequest *)request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            if (success) {
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(result);
            }
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"error" code:0 userInfo:@{@"error":@"回调失败"}];
                failure(error);
            }
        }
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failure) {
                                             failure(error);
                                         }
                                     }];
    [_client enqueueHTTPRequestOperation:operation];
}

- (void)cancelAllRequest

{
//    NSLog(@"内部关闭网络请求");
    [_client.operationQueue cancelAllOperations];
}

@end
