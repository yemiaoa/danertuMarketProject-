//
//  DetailViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Crypto.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIView+Toast.h"
@interface PayMMSingleton : NSObject<UIAlertViewDelegate,UITextFieldDelegate>


@property (nonatomic, strong)UIView *alertV;
@property (nonatomic, strong)UIView *maskV;
+(PayMMSingleton*) sharedInstance ;
-(void)showPayMMUi:(UIView *)parentView result:(void (^)(BOOL isRight))result cancle:(void (^)(BOOL isCancle))cancle;
@end
