//
//  XNHttpManager.h
//  TestiOS6
//
//  Created by Ntalker on 15/10/13.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNHttpManager : NSObject

+ (XNHttpManager *)sharedManager;

//get请求
- (void)getHttpService:(NSString *)URLStr
             andParmas:(NSDictionary *)dict
            andSuccess:(void (^)(NSString *response))success
            andFailure:(void(^)(NSError *error))failure;

//post请求
- (void)postHttpService:(NSString *)URLStr
              andParams:(NSDictionary *)dict
             andSuccess:(void (^)(NSString *response))success
             andFailure:(void(^)(NSError *error))failure;

//上传文件
- (void)uploadFile:(NSString *)URLStr
         andParams:(NSDictionary *)dict
           andType:(NSString *)type
       andFilePath:(NSString *)path
        andSuccess:(void (^)(NSString *response))success
        andFailure:(void (^)(NSError *error))failure;

//取消网络请求
- (void)cancelAllRequest;

@end
