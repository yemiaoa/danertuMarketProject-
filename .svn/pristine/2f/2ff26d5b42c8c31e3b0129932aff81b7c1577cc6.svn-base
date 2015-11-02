//
//  bigMa.h
//  MJExtensionExample
//
//  Created by NTalker on 15/6/8.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTalkerGoodsModel : NSObject
/**
 *  appgoodsinfo_type
 */
@property (copy, nonatomic) NSString *appgoodsinfo_type;

/**
 *  clientgoodsinfo_type
 */
@property (copy, nonatomic) NSString *clientgoodsinfo_type;
/**
 *  商品ID
 */
@property (copy, nonatomic) NSString *goods_id;
/**
 *  商品名称
 */
@property (copy, nonatomic) NSString *goods_name;
/**
 *  商品价格
 */
@property (copy, nonatomic) NSString *goods_price;
/**
 *  商品图片地址
 */
@property (copy, nonatomic) NSString *goods_image;
/**
 *  该商品在网站上的实际页面地址
 */
@property (copy, nonatomic) NSString *goods_url;
/**
 *  客服端显示的商品页面地
 */
@property (copy, nonatomic) NSString *goods_showurl;


/**
 *  将json转化为模型
 *
 *  @param jsonString 传入的json字符串
 *
 *  @return 初始化好的对象
 */
+ (NTalkerGoodsModel *)dictionaryWithJsonString:(NSString *)jsonString;

@end
