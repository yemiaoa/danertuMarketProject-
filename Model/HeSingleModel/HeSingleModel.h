//
//  HeSingleModel.h
//  单耳兔
//
//  Created by iMac on 15/6/12.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeSingleModel : NSObject

@property(strong,nonatomic) NSString *imageServerUrl;
@property(strong,nonatomic) NSDictionary *versionDict;

+ (HeSingleModel *)shareHeSingleModel;

@end
