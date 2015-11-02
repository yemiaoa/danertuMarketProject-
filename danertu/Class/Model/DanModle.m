//
//  DataModle.m
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "DanModle.h"
@implementation DanModle
@synthesize Detail,Name,SupplierLoginID,mobileProductDetail,ShopPrice,OriginalImge,MarketPrice,woodFrom,ContactTel,SmallImage,Guid,Mobile,
AgentId;

-(NSString *)description{
    NSLog(@"Name = %@, SupplierLoginID = %@, mobileProductDetail = %@, ShopPrice = %@, MarketPrice = %@,AgentId = %@, Guid = %@, woodFrom = %@, OriginalImge = %@, SmallImage = %@, ContactTel = %@",Name, SupplierLoginID,mobileProductDetail,ShopPrice,MarketPrice,AgentId,Guid, woodFrom,OriginalImge,SmallImage,ContactTel);
    return [NSString stringWithFormat:@"Name = %@, SupplierLoginID = %@, mobileProductDetail = %@, ShopPrice = %@, MarketPrice = %@,AgentId = %@, Guid = %@, woodFrom = %@, OriginalImge = %@, SmallImage = %@, ContactTel = %@",Name, SupplierLoginID,mobileProductDetail,ShopPrice,MarketPrice,AgentId,Guid, woodFrom,OriginalImge,SmallImage,ContactTel];
}
@end
