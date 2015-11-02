

#ifndef EAssistant_BKDefine_h
#define EAssistant_BKDefine_h

/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
#define WXAppId @"wx58f1866c456080f3"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//#define WXAppKey @"p2VrmhaGg2vlskmnhfTse1JGcrkR5KNbQ3zsUJ5PToveHuIWdhLXirvSN1nO2soYy3kCn8Y5GIxpbN5oqyJnvtdw9CnGsh6NyDeBgmONnQ8I8P8G8SrA9MBlEjEuTyFw"

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//#define WXAppSecret @"0abc5046bdb28b767c636cbf10fc0ff8"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//#define WXPartnerKey @"0c8ebebb06a2cd518ebd7272ceca9683"

/**
 *  微信公众平台商户模块生成的ID
 */
#define WXPartnerId @"1274110001"

#define ORDER_PAY_NOTIFICATION @"OrderPayNotification"

#define AccessTokenKey @"access_token"
#define PrePayIdKey @"prepayid"
#define errcodeKey @"errcode"
#define errmsgKey @"errmsg"
#define expiresInKey @"expires_in"

#endif
