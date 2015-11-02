//
//  HeWeChatPay.m
//  单耳兔
//
//  Created by Tony on 15/10/16.
//  Copyright © 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeWeChatPay.h"
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"

@implementation HeWeChatPay

-(void)doPayByWeChatpay:(NSMutableDictionary*)orderInfoTmp resultBlock:(void (^)(BOOL isFinish))resultBlock
{
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:WXAPP_ID mch_id:WXMCH_ID];
    //设置密钥
    [req setKey:WXPARTNER_ID];
    
    NSMutableDictionary *orderInfoDic = [orderInfoTmp mutableCopy];//参数
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithDict:orderInfoDic];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        //发起微信呢支付
        BOOL paySucceed = [WXApi sendReq:req];
        resultBlock(paySucceed);
    }
}

@end
