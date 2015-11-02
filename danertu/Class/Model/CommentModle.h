//
//  DataModle.h
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYBaseModel.h"
@interface CommentModle : BYBaseModel
@property(nonatomic, retain) NSString *AgentId;//-----单耳兔,自营店
@property(nonatomic, retain) NSString *Content;//评论内容
@property(nonatomic, retain) NSString *Guid;//--------评论--id
@property(nonatomic, retain) NSString *MemLoginID;//----评论用户ID
@property(nonatomic, retain) NSString *ProductGuid;//---商品ID
@property(nonatomic, retain) NSString *Rank;//---评星
@property(nonatomic, retain) NSString *SendTime;//---发送时间
@end
