//
//  Dao.h
//  huobao
//
//  Created by Tony He on 14-5-13.
//  Copyright (c) 2014年 何 栋明. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Dao : NSObject


@property(assign,nonatomic) BOOL reachbility;
//@property(assign,nonatomic) BOOL isFirstLoadHomePage;//是否首次加载首页数据，app启动首次加载为首次
+(id)sharedDao;


@end
