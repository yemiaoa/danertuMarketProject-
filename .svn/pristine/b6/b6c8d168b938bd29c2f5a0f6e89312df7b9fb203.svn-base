//
//  NSXNCometConnection.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/3/27.
//  Copyright (c) 2015年 NTalker. All rights reserved.


#import <Foundation/Foundation.h>
#import "NTalkerChatMessage.h"



@interface NTalkerCometConnection : NSObject
-(void)requestChatSiteid:(NSString *)siteid settingid:(NSString *)settingid uids:(NSString *)uids uid:(NSString *)uid issingle:(int)issingle cid:(NSString *)cid success:(void (^)(id response))success failed:(void (^)(NSError *error))failed;




-(void)requestLoginUserid:(NSString *)userid Sessionid:(NSString *)Sessionid Destid:(NSString *)Destid machineID:(NSString *)machineID username:(NSString *)username userlevel:(int)userlevel settingid:(NSString *)settingid success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;





- (void)requestAliveUserid:(NSString *)userid Sessionid:(NSString *)Sessionid Destid:(NSString *)Destid machineID:(NSString *)machineID username:(NSString *)username userlevel:(int)userlevel settingid:(NSString *)settingid clientid:(NSString *)clientid httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;



- (void)sendMsgMyuid:(NSString *)myuid clientid:(NSString *)clientid sessionid:(NSString *)sessionid msgid:(NSString *)msgid msg:(NSString *)msg httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;



-(void)uploadFileSiteid:(NSString *)siteid fileType:(NSString *)type filepath:(NSString *)path success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;



-(void)sendPredictMsgmyuid:(NSString *)myuid clientid:(NSString *)clientid sessionid:(NSString *)sessionid msg:(NSString *)msg httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;




-(void)sendRemarkMyuid:(NSString *)myuid clientid:(NSString *)clientid sessionid:(NSString *)sessionid proposal:(NSString *)proposal value:(int)value httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;




-(void)shutDownTchatcid:(NSString*)cid siteid:(NSString *)siteid uid:(NSString *)uid httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;



#pragma mark - 发送离线消息对接接口方法声明


- (void)sendLeaveMsgMyuid:(NSString *)myuid msg_name:(NSString *)msg_name settingid:(NSString *)settingid sellerid:(NSString *)sellerid sessionid:(NSString *)sessionid destuid:(NSString *)destuid source:(NSString *)source leaveMsg:(NSString *)leaveMsg leaveTelPhone:(NSString *)leaveTelPhone leaveEmail:(NSString *)leaveEmail httpIndex:(int)index success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;

//msgid:(NSString *)msgid
- (void)sendproductionMsgMyuid:(NSString *)myuid clientid:(NSString *)clientid sessionid:(NSString *)sessionid msgid:(NSString *)msgid msg:(NSString *)msg httpIndex:(int)index  type:(int)type success:(void(^)(id response))success failed:(void(^)(NSError *error))failed;

/*
 *  中止当前所有网络请求
 */
//-(void)cancelAllRequest;
- (void)postMessageForUserTrail:(NSDictionary *)params;
@end
