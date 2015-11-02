//
//  NSXNInterface.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/3/16.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NTalkerChatMessage.h"
//#import "NTalkerCometConnection.h"
//#import "NTalkerMainParam.h"
#import "NTalkerTrailModel.h"

//@protocol NSXNInterfaceDelegate;
@protocol NTalkerInterfaceDelegate <NSObject>

- (void)xnGetMessage:(NTalkerChatMessage *)msg;
- (void)xnSendMessageResult:(id)result;
//- (void)xnNetworkError:(NSString *)handler;
- (void)xnCustomerSeverStatus:(int)status;
- (void)xnShowCommentView;
- (void)xnPostUnreadMessageRequestDelegate;

- (void)xnCommentStatue:(BOOL)success;
@end

@interface NTalkerInterface : NSObject


@property(nonatomic,strong)NSString *siteid;
@property(nonatomic,strong)NSString *settingid;
@property(nonatomic,strong)NSString *clientid;
@property(nonatomic,strong)NSString *sessionid;
//@property(nonatomic,strong)NSString *uids;
@property(nonatomic,strong)NSString *userid;//（为空 则传机器码）
@property(nonatomic,strong)NSString *pcid;
@property(nonatomic,strong)NSString *username;
//0529 zhoujia
@property(nonatomic,strong)NSString *erpparam;//erp参数
@property(nonatomic,strong)NSDictionary *itemDic;//商品详情


@property(nonatomic,strong)NTalkerChatMessage *chatMessage;//zjia
@property (nonatomic,weak)id<NTalkerInterfaceDelegate> delegate;//


/**
 *
 *  登录IM
 */
//-(void)loginToIM;

-(void)loginToIMWithSiteid:(NSString*)siteid userid:(NSString *)userid andusername :(NSString*)name clientid:(NSString *)clientid hostServer:(NSString *)hostServer topic:(NSString *)topic port:(NSString *)port  username:(NSString *)username password:(NSString *)password;

- (void)keepLiveIM;

- (void)disconnectIM;


-(void)startChatingSiteid:(NSString *)siteid settingid:(NSString *)settingid uids:(NSString *)uids  userid:(NSString *)userid username:(NSString *)username userlevel:(int)userlevel issingle:(int)single  pcid:(NSString *)pcid erpparam:(NSString *)erpparam itemDic:(NSDictionary *)itemDic;
-(void)loginToTChat;//0610jia

- (void)addChatMessage:(NTalkerChatMessage *)chatMessage;//将新消息添加到消息队列



-(void)trajectory:(NTalkerGoodsMessage *)goodsMessage title:(NSString *)title ntalkerparam:(NSString *)ntalkerparam username:(NSString *)username userid:(NSString *)userid siteid:(NSString *)siteid sellerid:(NSString *)sellerid levelStr:(NSString *)levelStr orderid:(NSString *)orderid orderprice:(NSString *)orderprice result:(void(^)(NSString *result))block;//商品轨迹

+(void)trajectory:(NTalkerTrailModel *)trailModel;

-(void)endChating;//结束会话
-(void)predictMsg:(NSString *)msg;//发送消息预知
-(void)remarkMsgValue:(int)value proposal:(NSString *)proposal;//提交评价
#pragma mark - 提交留言方法声明
- (void)submitLeaveMsg:(NSMutableArray *)leavemassage siteid:(NSString *)siteid msg_name:(NSString *)msg_name andDelegate:(id)delegate;//离线留言
@end

