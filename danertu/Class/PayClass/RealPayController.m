//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "RealPayController.h"
enum payType{
    DANERTUPAY,
    ALIPAY,
    WEBCHATPAY,
    UNIONPAY,
};
@interface RealPayController(){
    enum payType payOffType;

    NSString *Token;
    NSString *danertuPayPriceData;//-----账户支付的额外参数------
    //Token valid time
    long      token_time;
    BOOL isHaveAgentProduct;//---------是否有线下支付的产品,,,有无决定了支付方式------
}
@end
@implementation RealPayController
@synthesize defaults;
@synthesize addStatusBarHeight;

@synthesize payMoneyDic;

@synthesize orderInfoDic;
@synthesize productInfo;
@synthesize productInfoStr;
@synthesize isFromPayOff;
@synthesize productsArr;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isHaveAgentProduct = NO;
    
    NSLog(@"jaiorgegjoiejoith----%@--%@",orderInfoDic,productsArr);
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];//
    self.view.backgroundColor = VIEWBGCOLOR;
    defaults =[NSUserDefaults standardUserDefaults];//读取本地化存储
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    [self.view addSubview:contentView];
    //默认抵扣金萝卜,支付宝支付
    payOffType = DANERTUPAY;
    //收货信息
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 70)];
    [contentView addSubview:addressView];
    
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.layer.cornerRadius = 5;
    addressView.layer.borderColor = BORDERCOLOR.CGColor;
    addressView.layer.borderWidth = 0.6;

    NSString *orderNo = [orderInfoDic objectForKey:@"tradeNO"];
    NSString *orderDateStr = [orderNo substringToIndex:8];
    NSRange range = NSRangeFromString(@"(4,2)");
    NSRange range1 = NSRangeFromString(@"(6,2)");
    NSString *orderDate = [NSString stringWithFormat:@"%@-%@-%@",[orderDateStr substringToIndex:4],[orderDateStr substringWithRange:range],[orderDateStr substringWithRange:range1]];
    NSArray *infoArr = @[@"订单金额",@"订单编号",@"创建时间",[orderInfoDic objectForKey:@"price"] ,orderNo,orderDate];
    int infoArrCount = infoArr.count/2;
    for (int i=0; i<infoArrCount; i++) {
        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20*i, 300, 20)];
        [addressView addSubview:item];
        item.backgroundColor = [UIColor clearColor];
        item.font = TEXTFONT;
        if (i==0) {
            item.text = [NSString stringWithFormat:@"%@:  ￥%@",infoArr[i],infoArr[i+infoArrCount]];
        }else{
            item.text = [NSString stringWithFormat:@"%@:  %@",infoArr[i],infoArr[i+infoArrCount]];
        }
    }
    //支付方式
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(10, 110, 300, 160)];
    [contentView addSubview:payView];
    
    payView.backgroundColor = [UIColor whiteColor];
    payView.layer.cornerRadius = 5;
    payView.layer.borderColor = BORDERCOLOR.CGColor;
    payView.layer.borderWidth = 0.6;
    
    //NSArray *payTypeArr = @[@"支付宝支付",@"微信支付",@"银联支付",@"推荐已安装支付宝快捷支付的用户使用",@"推荐已安装微信的用户使用",@"有银行卡就可支付,无需开通网银",@"aliPay",@"webChatPay",@"unPay",];
    //-----商品数组-----
    if (productsArr.count>0) {
        for (NSDictionary* item in productsArr) {
            [self getPriceDataStr:[item objectForKey:@"Guid"] price:[item objectForKey:@"ShopPrice"]];
            //----有线下产品只能     单耳兔账户支付
            if ([[item objectForKey:@"AgentID"] length]>5||[[item objectForKey:@"agentID"] length]>5||[[item objectForKey:@"AgentId"] length]>5) {
                isHaveAgentProduct = YES;
            }
        }
    }
    
    NSArray *payTypeArr = @[@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon",@"支付宝支付",@"推荐已安装支付宝快捷支付的用户使用",@"aliPay"];
    if (isHaveAgentProduct) {
        payTypeArr = @[@"单耳兔账户支付",@"推荐单耳兔会员使用",@"icon"];
    }
    int payTypeCount = payTypeArr.count/3;
    int payItemheight = 50;
    
    //支付方式
    UIView *selectPayType = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, payItemheight*payTypeCount)];
    [payView addSubview:selectPayType];
    selectPayType.userInteractionEnabled = YES;
    for (int i=0; i<payTypeCount; i++) {
        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, 300, 50)];
        [selectPayType addSubview:selectView];
        selectView.tag = 100+i;
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPayType:)];
        [selectView addGestureRecognizer:singleTap];//---添加点击事件
        
        //选择框
        UIButton *setDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 20, 20)];
        [selectView addSubview:setDefaultBtn];
        setDefaultBtn.layer.cornerRadius = 2;
        setDefaultBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [setDefaultBtn.layer setBorderWidth:0.6];
        setDefaultBtn.enabled = NO;//这里不使用按钮的点击事件,禁用,防止截获事件响应
        setDefaultBtn.backgroundColor = [UIColor clearColor];
        if (i==0) {
            [setDefaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
        }
        //icon
        UIImageView *payIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [selectView addSubview:payIcon];
        payIcon.image = [UIImage imageNamed:payTypeArr[i*3+2]];
        
        //文字
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 18)];
        [selectView addSubview:nameLb];
        nameLb.backgroundColor = [UIColor clearColor];
        nameLb.font = TEXTFONT;
        nameLb.text = payTypeArr[i*3];
        
        //详细说明文字
        UILabel *addtionLb = [[UILabel alloc] initWithFrame:CGRectMake(50,18,220,12)];
        [selectView addSubview:addtionLb];
        addtionLb.backgroundColor = [UIColor clearColor];
        addtionLb.textColor = [UIColor grayColor];
        addtionLb.font = TEXTFONTSMALL;
        addtionLb.text = payTypeArr[i*3+1];
    }
    //支付按钮
    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CONTENTHEIGHT+49-60, 260, 40)];//高度--44
    [payBtn.layer setMasksToBounds:YES];
    [payBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    payBtn.backgroundColor = TOPNAVIBGCOLOR;
    [payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [payBtn addTarget:self action:@selector(onClickPay) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:payBtn];
    
    NSLog(@"gtretoejtornjoirjiho----%@",payMoneyDic);
    //注册通知,待支付完成时,通知订单中心重新加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickBack) name:@"finishPayment" object:nil];
}
//-----点击返回
-(void)onClickBack{
    if (isFromPayOff) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"----backLogin---图片被点击!------");
}
//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"支付中心";
}
//-----支付方式选择
-(void)selectPayType:(id)sender{
    UIView *selectView = [sender view];
    int tag = [selectView tag] - 100;
    if (tag==0&&payOffType!=DANERTUPAY) {
        //单耳兔
        payOffType = DANERTUPAY;
        
        UIButton *clickBtn = [[[[[selectView superview] subviews] objectAtIndex:1] subviews] firstObject];
        [clickBtn setImage:nil forState:UIControlStateDisabled];
        
        //被点击按钮
        UIButton *selfBtn = [[selectView subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }else if (tag==1&&payOffType!=ALIPAY) {
        //选择  支付宝
        payOffType = ALIPAY;
        
        UIButton *clickBtn = [[[[[selectView superview] subviews] objectAtIndex:0] subviews] firstObject];
        [clickBtn setImage:nil forState:UIControlStateDisabled];
        //被点击按钮
        UIButton *selfBtn = [[[[[selectView superview] subviews] objectAtIndex:1] subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }else if (tag==2&&payOffType!=WEBCHATPAY){
        [self.view makeToast:@"微信支付暂未开通,请使用其他支付方式" duration:1.2 position:@"center"];
        /*
        //选择  微信
        payOffType = WEBCHATPAY;
        UIButton *clickBtn = [[[[[selectView superview] subviews] firstObject] subviews] firstObject];
        [clickBtn setImage:nil forState:UIControlStateDisabled];
        UIButton *clickBtn_ = [[[[[selectView superview] subviews] objectAtIndex:2] subviews] firstObject];
        [clickBtn_ setImage:nil forState:UIControlStateDisabled];
        //被点击按钮
        UIButton *selfBtn = [[selectView subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
         */
    }else if (tag==3&&payOffType!=UNIONPAY){
        //选择  银联
        payOffType = UNIONPAY;
        
        UIButton *otherBtn = [[[[[selectView superview] subviews] firstObject] subviews] firstObject];
        [otherBtn setImage:nil forState:UIControlStateDisabled];
        UIButton *clickBtn_ = [[[[[selectView superview] subviews] objectAtIndex:1] subviews] firstObject];
        [clickBtn_ setImage:nil forState:UIControlStateDisabled];
        //被点击按钮
        UIButton *selfBtn = [[selectView subviews] firstObject];
        [selfBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateDisabled];
    }
}
-(void)getPriceDataStr:(NSString *)guid price:(NSString *)price{
    [Waiting show];
    NSDictionary * params = @{@"apiid": @"0134",@"proguid" :guid};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(score.length>0){
            NSLog(@"nbiergroejgreigoregorejohtorih---%@--%@",score,params);
            if (danertuPayPriceData.length==0) {
                danertuPayPriceData = [NSString stringWithFormat:@"%@,%@",score,price];
            }else{
                danertuPayPriceData = [NSString stringWithFormat:@"%@|%@,%@",danertuPayPriceData,score,price];
            }
            NSLog(@"jgoeijgoijthgreiogjeoi-------%@",danertuPayPriceData);
        }else{
            [self.view makeToast:@"系统错误,请稍后重试:0134" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}
//------支付----
//根据选择的支付方式支付
-(void)onClickPay{
    NSLog(@"khopthkptojfiwojooiejeiohtr------%d---%@",payOffType,orderInfoDic);
    if (payOffType==DANERTUPAY) {
        DanertupayPostInfo *payObj = [[DanertupayPostInfo alloc] init];
        [payObj doPayByDanertu:orderInfoDic priceData:danertuPayPriceData parentV:self.view canclable:NO resultBlock:^(BOOL isFinish){
            if (isFinish) {
                [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListPaySuccessNotification" object:nil];
            }
            //支付成功
        }];
    }else if (payOffType==ALIPAY) {
        //支付宝支付-------
        AlipayPostInfo *aliPayObj = [[AlipayPostInfo alloc]init];//初始化
        [aliPayObj doPayByAlipay:orderInfoDic resultBlock:^(BOOL isFinish){
            if (isFinish) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListPaySuccessNotification" object:nil];
            }
        }];//调用支付
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1];
    }else if (payOffType==WEBCHATPAY){
        //微信支付
        [self.view makeToast:@"微信支付暂未开通,请使用其他支付方式" duration:1.2 position:@"center"];
        //[self sendPay2];
    }else if (payOffType==UNIONPAY){
        //银联卡支付-------
        NSLog(@"unionPay--------%@",orderInfoDic);
        [Waiting show];
        //NSString *proname =
        NSString *price = [orderInfoDic objectForKey:@"price"];
        price = [NSString stringWithFormat:@"%d",(int)[[orderInfoDic objectForKey:@"price"] doubleValue] *100];
        //如果是测试支付的话,金额改成1分
        if (isTestPayMoney) {
            price = @"1";
        }
        NSDictionary * params = @{@"apiid": @"0089",@"ordernumber" : [orderInfoDic objectForKey:@"tradeNO"],@"proname":[orderInfoDic objectForKey:@"body"],@"orderAmount":price};
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loadin
            NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"hotrjnonrjiewiocheuevihuiqw----%@",score);
            if(score.length>0){
                [UPPayPlugin startPay:score mode:@"00" viewController:self delegate:self];
            }else{
                [self.view makeToast:@"系统错误,请稍后重试" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jtorijhirojoief---%@--%@",error,params);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }
}
//返回支付结果,,,,银联支付
- (void)UPPayPluginResult:(NSString *)result
{
    NSString *orderNoToPay = [orderInfoDic objectForKey:@"tradeNO"];
    //-----cancel----success
    NSLog(@"biortjhiojiohjytioh----%@--%@",result,orderNoToPay);
    if ([result isEqualToString:@"success"]) {
        int priceScore = 0;
        NSMutableArray *orderWoodsArray = [defaults objectForKey:@"NotPayedOrderWoodsArray"];//未购买商品--------本地存储
        NSMutableArray *orderWoodsArray1  = [[NSMutableArray alloc] init];
        NSMutableArray *_orderWoodsArray = [defaults objectForKey:@"PayedOrderWoodsArray"];//已购买商品--------本地存储
        NSMutableArray *_orderWoodsArray1  = [[NSMutableArray alloc] init];
        if(orderWoodsArray){
            orderWoodsArray1 = [orderWoodsArray mutableCopy];
        }
        if(_orderWoodsArray){
            _orderWoodsArray1 = [_orderWoodsArray mutableCopy];
        }
        NSLog(@"vewovopjgprjegpjregrep--qwe-----%@---%@",orderWoodsArray,_orderWoodsArray);
        for (NSDictionary *itemWood in orderWoodsArray1) {
            if ([[itemWood objectForKey:@"tradeNO"] isEqualToString:orderNoToPay]) {
                [orderWoodsArray1 removeObject:itemWood];//--移除旧的---
                [_orderWoodsArray1 addObject:itemWood];//--添加到已支付
                [defaults setObject:orderWoodsArray1 forKey:@"NotPayedOrderWoodsArray"];//
                [defaults setObject:_orderWoodsArray1 forKey:@"PayedOrderWoodsArray"];//
                break;
            }
        }
        NSLog(@"vewovopjgprjegpjregrep--qwe-----%@---%@",[defaults objectForKey:@"NotPayedOrderWoodsArray"],[defaults objectForKey:@"PayedOrderWoodsArray"]);
        
        NSDictionary * params = @{@"apiid": @"0061",@"score" :[NSString stringWithFormat:@"%d",priceScore],@"mid": [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"]};
        NSURLRequest * request1 = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                           path:@""
                                                     parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([source isEqualToString:@"true"]) {

            }
            NSLog(@"-----success1----%@",source);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
        }];
        [operation start];//-----发起请求------
        
        //发送通知,传递参数:订单号
        NSDictionary *userInfoDic = @{@"orderNo":orderNoToPay};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishPayment" object:nil userInfo:userInfoDic];//发送通知,重新加载未支付订单
        
        NSLog(@"vowejopfwejgpojepojgproejg----delegate------验证签名成功，交易结果无篡改---%@--%@----",result,orderNoToPay);
    }
}

//============================================================
// 支付流程模拟实现，
// 注意:此demo只适合开发调试，参数配置和参数加密需要放到服务器端处理
// 服务器端Demo请查看包的文件
// 更新时间：2013年12月5日
//============================================================

//- (void)sendPay2
//{
//    //商户号
//    NSString *PARTNER_ID    = @"1900000109";
//    //APPID
//    NSString *APPI_ID       = @"wxd930ea5d5a258f4f";
//    //appsecret
//    NSString *APP_SECRET	= @"db426a9829e4b49a0dcac7b4162da6b6";
//    //支付密钥
//    NSString *APP_KEY       = @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K";
//    
//    //支付结果回调页面
//    NSString *NOTIFY_URL    = @"http://localhost/pay/wx/notify_url.asp";
//    //订单标题
//    NSString *ORDER_NAME    = @"Ios客户端签名支付 测试";
//    //订单金额,单位（分）
//    NSString *ORDER_PRICE   = @"1";
//    
//    //创建支付签名对象
//    payRequsestHandler *req = [payRequsestHandler alloc];
//    //初始化支付签名对象
//    [req init:WXAPPI_ID app_secret:WXAPP_SECRET];
//    
//    //判断Token过期时间，10分钟内不重复获取,测试帐号多个使用，可能造成其他地方获取后不能用，需要即时获取
//    time_t  now;
//    time(&now);
//    //if ( (now - token_time) > 0 )//非测试帐号调试请启用该条件判断
//    {
//        //获取Token
//        Token                   = [req GetToken];
//        //设置Token有效期为10分钟
//        token_time              = now + 600;
//        //日志输出
//        NSLog(@"获取Token： %@\n",[req getDebugifo]);
//    }
//    if ( Token != nil){
//        //================================
//        //预付单参数订单设置
//        //================================
//        NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
//        [packageParams setObject: @"WX"                                             forKey:@"bank_type"];
//        [packageParams setObject: ORDER_NAME                                        forKey:@"body"];
//        [packageParams setObject: @"1"                                              forKey:@"fee_type"];
//        [packageParams setObject: @"UTF-8"                                          forKey:@"input_charset"];
//        [packageParams setObject: NOTIFY_URL                                        forKey:@"notify_url"];
//        [packageParams setObject: [NSString stringWithFormat:@"%ld",time(0)]        forKey:@"out_trade_no"];
//        [packageParams setObject: PARTNER_ID                                        forKey:@"partner"];
//        [packageParams setObject: @"192.168.1.1"                                    forKey:@"spbill_create_ip"];
//        [packageParams setObject: ORDER_PRICE                                       forKey:@"total_fee"];
//        
//        NSString    *package, *time_stamp, *nonce_str, *traceid;
//        //获取package包
//        package		= [req genPackage:packageParams];
//        
//        //输出debug info
//        NSString *debug     = [req getDebugifo];
//        NSLog(@"gen package: %@\n",package);
//        NSLog(@"生成package: %@\n",debug);
//        
//        //设置支付参数
//        time_stamp  = [NSString stringWithFormat:@"%ld", now];
//        nonce_str	= [TenpayUtil md5:time_stamp];
//        traceid		= @"mytestid_001";
//        NSMutableDictionary *prePayParams = [NSMutableDictionary dictionary];
//        [prePayParams setObject: APPI_ID                                            forKey:@"appid"];
//        [prePayParams setObject: APP_KEY                                            forKey:@"appkey"];
//        [prePayParams setObject: nonce_str                                          forKey:@"noncestr"];
//        [prePayParams setObject: package                                            forKey:@"package"];
//        [prePayParams setObject: time_stamp                                         forKey:@"timestamp"];
//        [prePayParams setObject: traceid                                            forKey:@"traceid"];
//        
//        //生成支付签名
//        NSString    *sign;
//        sign		= [req createSHA1Sign:prePayParams];
//        //增加非参与签名的额外参数
//        [prePayParams setObject: @"sha1"                                            forKey:@"sign_method"];
//        [prePayParams setObject: sign                                               forKey:@"app_signature"];
//        
//        //获取prepayId
//        NSString *prePayid;
//        prePayid            = [req sendPrepay:prePayParams];
//        //输出debug info
//        debug               = [req getDebugifo];
//        NSLog(@"提交预付单： %@\n",debug);
//        
//        if ( prePayid != nil) {
//            //重新按提交格式组包，微信客户端5.0.3以前版本只支持package=Sign=***格式，须考虑升级后支持携带package具体参数的情况
//            //package       = [NSString stringWithFormat:@"Sign=%@",package];
//            package         = @"Sign=WXPay";
//            //签名参数列表
//            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//            [signParams setObject: APPI_ID                                          forKey:@"appid"];
//            [signParams setObject: APP_KEY                                          forKey:@"appkey"];
//            [signParams setObject: nonce_str                                        forKey:@"noncestr"];
//            [signParams setObject: package                                          forKey:@"package"];
//            [signParams setObject: PARTNER_ID                                       forKey:@"partnerid"];
//            [signParams setObject: time_stamp                                       forKey:@"timestamp"];
//            [signParams setObject: prePayid                                         forKey:@"prepayid"];
//            
//            //生成签名
//            sign		= [req createSHA1Sign:signParams];
//            
//            //输出debug info
//            debug     = [req getDebugifo];
//            NSLog(@"调起支付签名： %@\n",debug);
//            
//            //调起微信支付
//            PayReq* req = [[PayReq alloc] init];
//            req.openID      = APPI_ID;
//            req.partnerId   = PARTNER_ID;
//            req.prepayId    = prePayid;
//            req.nonceStr    = nonce_str;
//            req.timeStamp   = now;
//            req.package     = package;
//            req.sign        = sign;
//            [WXApi safeSendReq:req];
//        }else{
//            /*long errcode = [req getLasterrCode];
//             if ( errcode == 40001 )
//             {//Token实效，重新获取
//             Token                   = [req GetToken];
//             token_time              = now + 600;
//             NSLog(@"获取Token： %@\n",[req getDebugifo]);
//             };*/
//            NSLog(@"获取prepayid失败\n");
//                    }
//    }else{
//        NSLog(@"获取Token失败\n");
//    }
//}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
