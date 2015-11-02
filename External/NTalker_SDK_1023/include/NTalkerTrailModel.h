//
//  trailModel.h
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/7/14.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTalkerTrailModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *otherParam;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *siteID;
@property (nonatomic,copy) NSString *sellerID;
@property (nonatomic,copy) NSString *userLevel;
@property (nonatomic,copy) NSString *orderID;
@property (nonatomic,copy) NSString *orderPrice;
@property (nonatomic,copy) NSString *userid;

+(NTalkerTrailModel *)sharedInstence;

@end
