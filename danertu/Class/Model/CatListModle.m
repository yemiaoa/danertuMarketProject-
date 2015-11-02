//
//  DataModle.m
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "CatListModle.h"

@implementation CatListModle
@synthesize name,images,market,price,SupplierLoginID,shopId,Guid,woodsCount,img,shopName,woodFrom,AgentId,arriveTime,leaveTime;

-(NSString *)description{
    NSLog(@"name = %@, img = %@, market = %@, price = %@, SupplierGuid = %@, shopId = %@, woodsCount = %@, shopName = %@",name, img, market, price, SupplierLoginID, shopId,woodsCount,shopName);
    return [NSString stringWithFormat:@"name = %@, img = %@, market = %@, price = %@, SupplierGuid = %@, shopId = %@, woodsCount = %@, shopName = %@",name, img, market, price, SupplierLoginID, shopId,woodsCount,shopName];
}

@end
