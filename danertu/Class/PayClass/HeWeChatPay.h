//
//  HeWeChatPay.h
//  单耳兔
//
//  Created by Tony on 15/10/16.
//  Copyright © 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeWeChatPay : NSObject

-(void)doPayByWeChatpay:(NSMutableDictionary*)orderInfoDic resultBlock:(void (^)(BOOL isFinish))resultBlock;

@end
