//
//  alipayPostInfo.m
//  单耳兔
//
//  Created by administrator on 14-8-12.
//  Copyright (c) 2014年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "AlipayPostInfo.h"
@interface AlipayPostInfo (){
    //ASIFormDataRequest *aliPayHttpRequest;
}
@end
@implementation AlipayPostInfo
@synthesize aliPayQueue,orderInfoDic,defaults;
@synthesize result,PartnerID,SellerID,PartnerPrivKey,AlipayPubKey;

/////////--------------支付宝---------------
//-----调用支付宝
-(void)doPayByAlipay:(NSMutableDictionary*)orderInfoTmp resultBlock:(void (^)(BOOL isFinish))resultBlock{
    defaults =[NSUserDefaults standardUserDefaults];
    orderInfoDic = [orderInfoTmp mutableCopy];//-----参数
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://115.28.55.222:8085/RequestApi.aspx"]];
    NSDictionary * params = @{@"apiid": @"0054",@"uApiname" : @"admin",@"uApipas": @"admin"};
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray* temp = [[jsonData objectForKey:@"infoList"] objectForKey:@"infobean"];//数组
        //PartnerID,SellerID,PartnerPrivKey,AlipayPubKey;
        PartnerID = [[temp objectAtIndex:0] objectForKey:@"pId"];
        SellerID = [[temp objectAtIndex:1] objectForKey:@"seller"];
        PartnerPrivKey = [[temp objectAtIndex:2] objectForKey:@"mPrivateCode"];
        AlipayPubKey = [[temp objectAtIndex:3] objectForKey:@"publicCode"];
        [defaults setObject:AlipayPubKey forKey:@"publicKey"];//--公共密钥,appdelegate校验支付结果
        
        NSString *appScheme = @"AlipaySdkDanertu";//-----回调id,返回应用
        NSString *orderInfo = [self getOrderInfo];//------订单信息
        NSString *signedStr = [self doRsa:orderInfo];//---私钥签名订单信息
        
        NSString *orderString = nil;
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        if (signedStr != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderInfo, signedStr, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                    
                    resultBlock(YES);
                    //------发送通知-------
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"realRecharge" object:nil userInfo:@{@"result":@"true"}];//发送通知,重新加载未支付订单
                    
                    //----未支付订单支付完成------发送通知--------
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"initOrderList" object:nil userInfo:nil];//发送通知,重新加载未支付订单
                }else if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]){
                    //用户中途取消
                    resultBlock(NO);
                
                }
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //支付失败
        resultBlock(NO);
        NSLog(@"faild , error == %@ ", error);
    }];
    [operation start];
}
-(NSString*)getOrderInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	//Product *product = [_products objectAtIndex:index];
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [orderInfoDic objectForKey:@"tradeNO"]; //订单ID（由商家自行制定）
	order.productName = [orderInfoDic objectForKey:@"subject"]; //商品标题
	order.productDescription = [orderInfoDic objectForKey:@"body"]; //商品描述
	order.amount = [orderInfoDic objectForKey:@"price"]; //商品价格
	order.notifyURL =  @"http://115.28.55.222:8085/AppPayReturn.aspx"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"1m";
    order.showUrl = @"m.alipay.com";
    //---!!!!!!!!!---提交支付的金额,专供测试使用-------使用完毕请注释-------!!!!!!!!!!!!!
    //order.amount = @"0.01";
    if(isTestPayMoney){
        order.amount = @"0.01";
    }
	[defaults setObject:order.tradeNO forKey:@"tradeNO"];//--刚刚进行的交易号
	return [order description];
}
-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    //signer = CreateRSADataSigner(PartnerPrivKey);
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];//----通过私钥签名   订单信息
    NSLog(@"doRsa %@ , %@ , %@ , %@",signer,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"],orderInfo,signedString);
    return signedString;
    //return orderInfo;
}
@end
