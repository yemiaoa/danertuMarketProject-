//
//  NTalkerChatMessage.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/3/16.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTalkerMainParam.h"



@interface NTalkerChatMessage : NSObject

@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *usericon;
@property(nonatomic,strong)NSString *siteid;
@property(nonatomic,strong)NSString *settingid;

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *messageid;
@property(nonatomic,strong)NSString *msgStatus;//sending/send/failed  //

@property(nonatomic,assign)int type;
@property(nonatomic,assign)int subtype;
@property(nonatomic,strong)id messageBody;


+(NTalkerChatMessage *)shareInstance;

@end

@interface NTalkerTextChatMessage : NSObject

@property(nonatomic,strong)NSString *text_content;

@property(nonatomic,strong)NSString *text_add;

@property(nonatomic,strong)NSString *text_extension;

@end

@interface NTalkerImageChatMessage : NSObject

@property(nonatomic,strong)NSString *img_path;
@property(nonatomic,strong)NSString *img_sourcepath;
@property(nonatomic,strong)NSString *img_oldfile;
@property(nonatomic,strong)NSString *img_size;
@property(nonatomic,strong)NSString *img_type;

@property(nonatomic,assign)int emotion;

@property(nonatomic,strong)NSString *img_extension;

@end

@interface NTalkerVoiceChatMessage : NSObject

@property(nonatomic,strong)NSString *sound_length;
@property(nonatomic,strong)NSString *sound_format;
@property(nonatomic,strong)NSString *sound_amrpath;
@property(nonatomic,strong)NSString *sound_mp3path;
@property(nonatomic,strong)NSString *sound_extension;
@end
//商品详情？
@interface NTalkerProductionChatMessage : NSObject

@property(nonatomic,strong)NSString *productinfourl;
@property(nonatomic,strong)NSString *itemidurl;//0608 商品ID拼成的URL


@end
//发起页
@interface NTalkerHomeSystemChatMessage : NSObject

@property(nonatomic,strong)NSString *parentpagetitle;
@property(nonatomic,strong)NSString *parentpageurl;

@end
//ERP+语言消息
@interface NTalkerERPSystemChatMessage : NSObject

@property(nonatomic,strong)NSString *erpparam;

@end
//评价
@interface NTalkerEvaluationSystemChatMessage : NSObject

@property(nonatomic,strong)NSString *appraise;

@end

//订单
@interface NTalkerGoodsMessage : NSObject

@property(nonatomic,strong)NSString *siteid;
@property(nonatomic,strong)NSString *sellerid;
@property(nonatomic,strong)NSString *groupid;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *userlevel;
@property(nonatomic,strong)NSString *pagestyle;
@property(nonatomic,strong)NSString *orderid;
@property(nonatomic,strong)NSString *orderprice;
@property(nonatomic,strong)NSString *param;

@end

//客服信息
@interface NTalkerCustomerService : NSObject

@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *externalname;
@property(nonatomic,strong)NSString *signature;
@property(nonatomic,strong)NSString *sessionid;//会话
@property(nonatomic,assign)int age;
@property(nonatomic,assign)int sex;
@property(nonatomic,assign)int level;
@property(nonatomic,assign)int status;//0:离线；1:在线；2:隐身；3:忙碌；4:离开
@property(nonatomic,strong)NSString *usericon;
@property(nonatomic,strong)NSString *unreadnum;
@property(nonatomic,strong)NSString *lasttime; 

+(NTalkerCustomerService *)shareInstance;

//添加以后可能会用到
//@property(nonatomic,strong)NSString *lastMessage;

@end
//工具类
@interface NTalkerToolsMethod : NSObject
+(NSString *)getFormatTimeString:(NSString *)timeStr;
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+(NSString *)getConfigFile:(NSString *)fileName;
+(NSString *)getNowTimeWithLongType;
+(NSString *)valiMobile:(NSString *)mobile;


@end





