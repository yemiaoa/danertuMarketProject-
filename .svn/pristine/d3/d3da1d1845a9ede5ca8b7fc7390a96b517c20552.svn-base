//
//  UIXNChatViewController.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NTalkerChatViewController : UIViewController

@property (nonatomic,strong)NSString *appKey; //新加参数 【必填】请联系小能的技术人员获取！
@property (nonatomic,strong)NSString *titleName;//客服聊窗标题[自定]
@property (nonatomic,strong)NSString *siteid;//平台ID【必填】
@property (nonatomic,strong)NSString *settingid;//客服配置id【必填】
@property (nonatomic,strong)NSString *sellerID;//商户id
@property (nonatomic,strong)NSString *userid;//访客ID【填写登录用户id，未登录用户可不填】
@property (nonatomic,strong)NSString *username;//访客名称【必填】
@property (nonatomic,assign)int userlevel;//是否是vip
@property (nonatomic,assign)BOOL pushOrPresent;//进入咨询界面的方式（YES:自下向上弹出  NO:自右向左弹出）
@property (nonatomic,assign)int issingle;// 是否请求独立用户，明确指定咨询某客服时值为1；不确定咨询客服组里那个客服时值为0；指定的客服如果不存在时，允许分配置其它客服时为-1（默认为—1）
@property(nonatomic,strong)NSString *erpparam;//erp参数【选填】  如果没有此参数，直接传空字符串 //strong-->copy
@property(nonatomic,strong)NSMutableDictionary *itemDic;//商品详情【选填】 (传商品ID或者商品URL，如果没有的参数，直接传空字符串) 
@property(nonatomic,strong)NSString *goodsID;//商品ID   
@property(nonatomic,strong)NSString *goodsURL;//商品url
@property(nonatomic,strong)NSString *jsonString;//商品详情(json型数据)【选填】如果没有此参数，直接传空字符串，但json必须符合文件中的规定格式。

//@property (nonatomic,strong)NSString *pcid;
//@property (nonatomic,strong)NSString *uids;
@end
