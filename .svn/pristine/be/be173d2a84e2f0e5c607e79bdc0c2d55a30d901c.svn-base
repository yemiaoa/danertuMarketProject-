//
//  NSXNGlobalParam.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/3/27.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^callBackBlock)(BOOL isPermenanent);

@interface NTalkerGlobalParam : NSObject
@property(nonatomic,strong)NSString *appKey;//0827 新加
@property(nonatomic,strong)NSString *tchatDownServer;
@property(nonatomic,strong)NSString *tchatUpServer;
@property(nonatomic,strong)NSString *t2dServer;
@property(nonatomic,strong)NSString *fileServer;
@property(nonatomic,strong)NSString *manageserver;//
@property(nonatomic,strong)NSString *coopurl;//加的
@property(nonatomic,strong)NSString *immqttserver;
@property(nonatomic,strong)NSString *tcp;
@property(nonatomic,strong)NSString *tcpPort;//0713
@property(nonatomic,strong)NSString *ws;
@property(nonatomic,strong)NSString *wsPort;//0713
@property(nonatomic,strong)NSString *trailServer;
@property(nonatomic,assign)int gettingServers;
@property(nonatomic,strong)NSString *siteid;

@property(nonatomic,strong)NSMutableDictionary *unreadData;//
//@property(nonatomic,strong)id <NSXNGlobalParamUnreadDelegate> delegate;//

+(instancetype)shareInstance;
- (void)getFlashServer:(NSString *)siteId andAppKey:(NSString *)appKey andCallBackBlock:(callBackBlock)callBackBlock;
//-(void)getUnreadMessageNumWithsiteId:(NSString *)siteId andUserid:(NSString *)userid;//

-(void)getUnreadMessageNumWithSiteid:(NSString *)siteid andUserid:(NSString *)userid andUsername:(NSString *)username;

@end
