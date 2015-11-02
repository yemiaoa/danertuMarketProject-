//
//  Tools.h
//  单耳兔
//
//  Created by 何栋明 on 15/5/25.
//  Copyright (c) 2015年 danertu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//判断当前用户是否已经登录
+ (BOOL)isUserHaveLogin;

//判断用户是否切换账号
+ (BOOL)isUserAccountChanged;

//判断是否泉眼的商品
+ (BOOL)isSpringGoodsWithDic:(NSDictionary *)woodDic;

//获取openUUID
+ (NSString *)getDeviceUUid;

//获取平台信息
+ (NSString *)getPlatformInfo;

//获取当前时间
+ (NSString *)getCurrentTime;

//取消iCloud上的备份
+ (void)canceliClouldBackup;

//设置table没数据的cell为空白
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

//删除错误的字符串
+ (NSString *)deleteErrorStringInString:(NSString *)inputString;

//删除错误的字符串
+ (NSString *)deleteErrorStringInData:(NSData *)inputData;

//Unicode转化为汉字
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//初始化推送服务
+ (void)initPush;

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

//泉眼产品是否为酒店产品
+ (BOOL)isSpringHotelWithGuid:(NSString *)guid;

//记录用户绑定的店铺
+ (BOOL)recordBindShopWithShareNumber:(NSString *)sharenumber shopid:(NSString *)shopid;

//删除Guid后缀异常的字符
+ (NSString *)deleStringWithGuid:(NSString *)guid;

//获取当前用户的登录账号
+ (NSString *)getUserLoginNumber;

//获取图片的商品url
+ (NSString *)getGoodsImageUrlWithData:(NSDictionary *)tempDic;

//获取app的版本号
+ (NSString *)getAppVersion;

//判断是否是温泉客房
+ (BOOL)isSpringHotelTicketWithInfo:(NSDictionary *)goodInfo;

//判断是否是温泉门票
+ (BOOL)isSpringTicketWithGuid:(NSString *)guid;
@end