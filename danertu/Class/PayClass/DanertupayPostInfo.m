//
//  alipayPostInfo.m
//  单耳兔
//
//  Created by administrator on 14-8-12.
//  Copyright (c) 2014年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "DanertupayPostInfo.h"
#import "Waiting.h"
@interface DanertupayPostInfo (){
    AFHTTPClient *httpClient;
    NSString *loginId;
    void (^resultBlockCallBack)(BOOL isFinish);
}
@end
@implementation DanertupayPostInfo
@synthesize defaults;

-(DanertupayPostInfo *)init{
    defaults = [NSUserDefaults standardUserDefaults];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    loginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    return self;
}
//--------------支付宝---------------
//-----调用支付宝
-(void)doPayByDanertu:(NSMutableDictionary*)orderInfoDic priceData:(NSString *)priceData   parentV:(UIView *)parentView canclable:(BOOL)canclable resultBlock:(void (^)(BOOL isFinish))resultBlock {
    double balance = [[self func_getBalance:parentView] doubleValue];
    resultBlockCallBack = resultBlock;
    if (balance>=[[orderInfoDic objectForKey:@"price"] doubleValue]) {
        //------先判断支付金额是否充足
        [[PayMMSingleton sharedInstance] showPayMMUi:parentView result:^(BOOL isRight){
            if (isRight) {
                [Waiting show];
                NSString *sourceStr = [NSString stringWithFormat:@"%@|%@|%@", loginId,[orderInfoDic objectForKey:@"tradeNO"],[orderInfoDic objectForKey:@"price"]];
                NSString *key = [NSString stringWithCString:"abcdef1234567890" encoding:NSUTF8StringEncoding];
                NSString *aesstr = [AES128Util AES128Encrypt:sourceStr key:key];
                NSLog(@"jfoewjfiojgioregiore-------%@,%@",sourceStr,aesstr);
                //[orderInfoDic setObject:tradeNO forKey:@"tradeNO"];
                NSDictionary * params = @{@"apiid": @"0116",@"aesstr" :aesstr};
                if (priceData.length>0) {
                    params = @{@"apiid": @"0116",@"aesstr" :aesstr,@"priceData" :priceData};
                }
                NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                  path:@""
                                                            parameters:params];
                AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [Waiting dismiss];
                    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];//json解析
                    NSLog(@"hiweoqeotrjnonrjiewiocheuevihuiqw----%@--%@",tempDic,params);
                    NSString *resultInfo = @"数据有误:0116";
                    if (tempDic) {
                        //完成支付------
                        if([[tempDic objectForKey:@"result"] isEqualToString:@"true"]){
                            resultBlock(YES);
                        }else{
                            resultBlock(NO);
                        }
                        resultInfo = [tempDic objectForKey:@"info"];
                    }
                    [parentView makeToast:resultInfo duration:2.0 position:@"center"];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"jtorijhirojoief---%@--%@",error,params);
                    [Waiting dismiss];
                    [parentView makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
                }];
                [operation start];
            }
        } cancle:^(BOOL isCancle){
            if (isCancle&&canclable) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单已生成,取消支付后可到订单中心支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
                [alertView show];
                alertView.tag = 12;
            }
        }];
    }else{
        resultBlock(NO);
        [parentView makeToast:@"账户余额不足" duration:2.0 position:@"center"];
    }
}

-(NSString *)func_getBalance:(UIView *)parentView{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0108&memloginid=%@",loginId];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSString *result;
    if (![requestOperation error]) {
        result = requestOperation.responseString;
    }else{
        [parentView makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
    }
    return result;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //点击确定之后
    if ([alertView tag] == 12){
        if(buttonIndex==0){
            resultBlockCallBack(NO);
        }else if(buttonIndex==1){
            [[[PayMMSingleton sharedInstance] maskV] setHidden:NO];
        }
    }
}

@end
