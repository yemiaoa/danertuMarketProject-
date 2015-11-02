//
//  HeSingleModel.m
//  单耳兔
//
//  Created by iMac on 15/6/12.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "HeSingleModel.h"

@implementation HeSingleModel
@synthesize versionDict;
@synthesize imageServerUrl;

+ (HeSingleModel *)shareHeSingleModel {
    static HeSingleModel *_singleModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleModel = [[HeSingleModel alloc] init];
        
    });
    return _singleModel;
}

- (id)init
{
    if (self = [super init]) {
        self.imageServerUrl = IMAGESERVER;
    }
    return self;
}

@end
