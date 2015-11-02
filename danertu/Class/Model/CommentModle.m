//
//  DataModle.m
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "CommentModle.h"
@implementation CommentModle
@synthesize AgentId,Content,Guid,MemLoginID,ProductGuid,Rank,SendTime;
-(NSString *)description{
    NSLog(@"AgentId = %@, Content = %@, Guid = %@, MemLoginID = %@, ProductGuid = %@,Rank = %@,SendTime = %@",AgentId,Content,Guid,MemLoginID,ProductGuid,Rank,SendTime);
    return [NSString stringWithFormat:@"AgentId = %@, Content = %@, Guid = %@, MemLoginID = %@, ProductGuid = %@,Rank = %@,SendTime = %@",AgentId,Content,Guid,MemLoginID,ProductGuid,Rank,SendTime];
}
@end
