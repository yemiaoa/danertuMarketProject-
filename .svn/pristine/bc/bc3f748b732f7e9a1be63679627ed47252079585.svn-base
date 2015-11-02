//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "ShareViewController.h"
@implementation ShareViewController

@synthesize addStatusBarHeight;

@synthesize shareId;
@synthesize shareType;
@synthesize contentView;
@synthesize shareInfo;
@synthesize shareNumber;
@synthesize infoLb;
@synthesize myshopName;

//view即将显示时执行,每次都会执行
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userInfo) {
        if (contentView.hidden||contentView.subviews.count==0) {
            contentView.hidden = NO;
            [self shareQRCode];//生成分享
        }
    }else{
        contentView.hidden = YES;
        [self.view makeToast:@"请先登录才可以分享" duration:1.2 position:@"center"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    //注意这里的高度是45,不要改写成44,否则   二维码加载错误,不能够显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopNumber) name:@"loginSucceed" object:nil];
    int height = CONTENTHEIGHT;
    if (shareInfo) {
        height = CONTENTHEIGHT + 49;
    }
    //注意这里的高度是45,不要改写成44,否则   二维码加载错误,不能够显示
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, height)];
    [self.view addSubview:contentView];
    self.view.backgroundColor = [UIColor colorWithWhite:224.0 / 255.0 alpha:1.0];
    [self getShopName];
}

//修改标题,重写父类方法
-(NSString*)getTitle
{
    NSString *shopType = [shareInfo objectForKey:@"shareType"];
    if ([shopType isEqualToString:@"s"]) {
        //来着店铺的分享信息
        return [NSString stringWithFormat:@"店铺推广(%@)",[shareInfo objectForKey:@"shareTitle"]];
    }
    else if ([shopType isEqualToString:@"product"]){
        return @"商品分享";
    }
    else{
        return @"分享";
    }
}

//重写父类方法
-(void)onClickBack
{
    if (shareInfo) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if ([self.tabBarController selectedIndex]!=4) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.tabBarController setSelectedIndex:0];
            [self setBarItemSelectedIndex:0];
        }
    }
}

- (void)updateShopNumber
{
    //来着店铺的分享信息
    if (shareInfo) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    shareId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    shareType = @"p";
    [self getShopName];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0142",@"apiid",shareId,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *sharenumber = [dic objectForKey:@"sharenumber"];
        if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
            infoLb.text = @"店铺码: 暂无";
        }
        else{
            infoLb.text = [NSString stringWithFormat:@"店铺码: %@",sharenumber];
            self.shareNumber = sharenumber;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        infoLb.text = @"店铺码: 获取失败";
        NSLog(@"%@",error);
    }];
}

- (void)getShopName
{
    self.myshopName = @"单耳兔商城";
    shareId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    //来着店铺的分享信息
    if (shareInfo) {
        shareId = [shareInfo objectForKey:@"shareId"];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0141",@"apiid",shareId,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        id respondObj = [respondStr objectFromJSONString];
        id valObj = [respondObj objectForKey:@"val"];
        @try {
            id respondDic = [valObj firstObject];
            myshopName = [respondDic objectForKey:@"ShopName"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        if ([myshopName isMemberOfClass:[NSNull class]] || myshopName == nil) {
            myshopName = @"单耳兔商城";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

-(void)shareQRCodeInnerversion
{
    shareId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    shareType = @"p";
    //来着店铺的分享信息
    if (shareInfo) {
        shareId = [shareInfo objectForKey:@"shareId"];
        shareType = [shareInfo objectForKey:@"shareType"];
    }
    CGFloat height = (contentView.frame.size.height - 80)/2.0;
    NSString *ios =  @"http://115.28.55.222:8085/indexios.aspx";
    NSString *android =  @"http://115.28.55.222:8085/doShare.aspx";
    
    infoLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    infoLb.backgroundColor = [UIColor whiteColor];
    infoLb.textColor = [UIColor redColor];
    infoLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [contentView addSubview:infoLb];
    infoLb.textAlignment = NSTextAlignmentCenter;
    infoLb.text = @"店铺码: 获取中...";
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0142",@"apiid",shareId,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *sharenumber = [dic objectForKey:@"sharenumber"];
        
        if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
            infoLb.text = @"店铺码: 暂无";
        }
        else{
            infoLb.text = [NSString stringWithFormat:@"店铺码: %@",sharenumber];
            self.shareNumber = sharenumber;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
    }];
    
    UILabel *iosArea = [[UILabel alloc]initWithFrame:CGRectMake(20, infoLb.frame.origin.y + infoLb.frame.size.height + 10, MAINSCREEN_WIDTH - 40, height)];
    iosArea.userInteractionEnabled = YES;
    iosArea.layer.cornerRadius = 8.0;
    iosArea.layer.masksToBounds = YES;
    iosArea.backgroundColor = [UIColor whiteColor];
    iosArea.userInteractionEnabled = YES;
    [contentView addSubview:iosArea];
    
    if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"product"]) {
        shareType = @"s";
    }
    NSString *imgUrl = [NSString stringWithFormat:@"%@?shopid=%@&type=%@",ios,shareId,shareType];
    

    CGFloat buttonY = 10;
    CGFloat buttonH = height - 50;
    CGFloat buttonW = buttonH;
    CGFloat buttonX = (iosArea.frame.size.width - buttonW) / 2.0;
    
    CGFloat scale = 40 / 46.0;
    CGFloat imageW = 30;
    CGFloat imageX = 20;
    CGFloat imageH = imageW / scale;
    CGFloat imageY = height - 10 - imageH;
    
    UIImageView *appleIcon = [[UIImageView alloc] init];
    appleIcon.image = [UIImage imageNamed:@"icon_ios"];
    appleIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [iosArea addSubview:appleIcon];
    
    UIButton *code = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    code.tag = 0;
    code.accessibilityIdentifier = imgUrl;
    [code setBackgroundColor:[UIColor clearColor]];
    [iosArea addSubview:code];
    [code addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
    [code setImage:[QRCodeGenerator qrImageForString:imgUrl imageSize:code.bounds.size.width * 2] forState:UIControlStateNormal];
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(imageX + imageW + 10, imageY + 3, 150, imageH)];
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentLeft;
    text.text = @"iOS客户端";
    [iosArea addSubview:text];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 150, imageY + 5, 90, imageH - 5)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [iosArea addSubview:shareButton];
    shareButton.tag = 0;
    shareButton.accessibilityIdentifier = imgUrl;
    [shareButton setImage:[UIImage imageNamed:@"shareButtonBG"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
    
    //Android
    UILabel *androidArea = [[UILabel alloc]initWithFrame:CGRectMake(20, iosArea.frame.origin.y + iosArea.frame.size.height + 5, MAINSCREEN_WIDTH - 40, height)];
    androidArea.userInteractionEnabled = YES;
    androidArea.layer.cornerRadius = 8.0;
    androidArea.layer.masksToBounds = YES;
    androidArea.backgroundColor = [UIColor whiteColor];
    androidArea.userInteractionEnabled = YES;
    [contentView addSubview:androidArea];
    
    if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"product"]) {
        shareType = @"s";
    }
    NSString *imgUrl_an = [NSString stringWithFormat:@"%@?shopid=%@&type=%@",android,shareId,shareType];
    
    UIImageView *androidIcon = [[UIImageView alloc] init];
    androidIcon.image = [UIImage imageNamed:@"icon_andriod"];
    androidIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [androidArea addSubview:androidIcon];
    
    UIButton *code_an = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    code_an.tag = 1;
    code_an.accessibilityIdentifier = imgUrl_an;
    [code_an setBackgroundColor:[UIColor clearColor]];
    [androidArea addSubview:code_an];
    [code_an addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
    [code_an setImage:[QRCodeGenerator qrImageForString:imgUrl_an imageSize:code.bounds.size.width * 2] forState:UIControlStateNormal];
    
    UILabel *text_an = [[UILabel alloc]initWithFrame:CGRectMake(imageX + imageW + 10, imageY + 3, 150, imageH)];
    text_an.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    text_an.backgroundColor = [UIColor clearColor];
    text_an.textAlignment = NSTextAlignmentLeft;
    text_an.text = @"安卓客户端";
    [androidArea addSubview:text_an];
    
    UIButton *an_shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 150, imageY + 5, 90, imageH - 5)];
    [an_shareButton setBackgroundColor:[UIColor clearColor]];
    [androidArea addSubview:an_shareButton];
    an_shareButton.tag = 1;
    an_shareButton.accessibilityIdentifier = imgUrl_an;
    [an_shareButton setImage:[UIImage imageNamed:@"shareButtonBG"] forState:UIControlStateNormal];
    [an_shareButton addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)shareQRCode
{
    HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
    NSDictionary *dict = singleModel.versionDict;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //有更新，但是需要判断是否AppStore上面的版本
    NSString *checkStatus = [dict objectForKey:@"checkstatus"];
    if ([checkStatus isMemberOfClass:[NSNull class]]) {
        checkStatus = @"";
    }
    
    BOOL isAppStoreVersion = ([UPDATEMARK isEqualToString:@""] && (checkStatus == nil || [checkStatus isEqualToString:@""] || [checkStatus compare:@"NO" options:NSCaseInsensitiveSearch] == NSOrderedSame));
    isAppStoreVersion = YES;
    if (isAppStoreVersion) {
        if (shareId == nil) {
            shareId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
        }
        shareType = @"p";
        //来着店铺的分享信息
        if (shareInfo) {
            shareId = [shareInfo objectForKey:@"shareId"];
            shareType = [shareInfo objectForKey:@"shareType"];
        }
        CGFloat height = (contentView.frame.size.height - 80) / 2.0;
        NSString *ios = SHAREURL;
        
        infoLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        infoLb.backgroundColor = [UIColor whiteColor];
        infoLb.textColor = [UIColor redColor];
        infoLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        [contentView addSubview:infoLb];
        infoLb.textAlignment = NSTextAlignmentCenter;
        infoLb.text = @"店铺码: 获取中...";
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0142",@"apiid",shareId,@"shopid", nil];
        [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *respondStr = operation.responseString;
            NSDictionary *dic = [respondStr objectFromJSONString];
            NSString *sharenumber = [dic objectForKey:@"sharenumber"];
            if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil) {
                infoLb.text = @"店铺码: 暂无";
            }
            else{
                infoLb.text = [NSString stringWithFormat:@"店铺码: %@",sharenumber];
                self.shareNumber = sharenumber;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            infoLb.text = @"店铺码: 获取失败";
        }];
        
        UILabel *iosArea = [[UILabel alloc]initWithFrame:CGRectMake(20, infoLb.frame.origin.y + infoLb.frame.size.height + 40, MAINSCREEN_WIDTH - 40, height)];
        iosArea.userInteractionEnabled = YES;
        iosArea.layer.cornerRadius = 8.0;
        iosArea.layer.masksToBounds = YES;
        iosArea.backgroundColor = [UIColor whiteColor];
        iosArea.userInteractionEnabled = YES;
        [contentView addSubview:iosArea];
        
        if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"product"]) {
            shareType = @"s";
        }
        NSString *imgUrl = [NSString stringWithFormat:@"%@?shopid=%@&type=%@",ios,shareId,shareType];
        
        CGFloat buttonY = 10;
        CGFloat buttonH = height - 50;
        CGFloat buttonW = buttonH;
        CGFloat buttonX = (iosArea.frame.size.width - buttonW) / 2.0;
        
        CGFloat scale = 40 / 46.0;
        CGFloat imageW = 30;
        CGFloat imageX = 20;
        CGFloat imageH = imageW / scale;
        CGFloat imageY = height - 10 - imageH;
        
        UIImageView *appleIcon = [[UIImageView alloc] init];
        appleIcon.image = [UIImage imageNamed:@"icon_ios"];
        appleIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
//        [iosArea addSubview:appleIcon];
        
        UIButton *code = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [code setBackgroundColor:[UIColor clearColor]];
        code.tag = 0;
        code.accessibilityIdentifier = imgUrl;
        [code addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
        [iosArea addSubview:code];
        [code setImage:[QRCodeGenerator qrImageForString:imgUrl imageSize:code.bounds.size.width * 2] forState:UIControlStateNormal];
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(imageX + imageW + 10, imageY + 3, 150, imageH)];
        text.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        text.backgroundColor = [UIColor clearColor];
        text.textAlignment = NSTextAlignmentLeft;
        text.text = @"iOS客户端";
//        [iosArea addSubview:text];
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake((iosArea.frame.size.width - 90) / 2.0, imageY + 5, 90, imageH - 5)];
        [shareButton setBackgroundColor:[UIColor clearColor]];
        [iosArea addSubview:shareButton];
        shareButton.tag = 0;
        shareButton.accessibilityIdentifier = imgUrl;
        [shareButton setImage:[UIImage imageNamed:@"shareButtonBG"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
        
        return;
    }
    [self shareQRCodeInnerversion];
}

//分享应用
-(void)shareApp:(id)sender
{
    HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
    NSDictionary *dict = singleModel.versionDict;
    NSString *checkStatus = [dict objectForKey:@"checkstatus"];
    if ([checkStatus isMemberOfClass:[NSNull class]]) {
        checkStatus = @"";
    }
    BOOL isAppStoreVersion = ([UPDATEMARK isEqualToString:@""] && (checkStatus == nil || [checkStatus isEqualToString:@""] || [checkStatus compare:@"NO" options:NSCaseInsensitiveSearch] == NSOrderedSame));
    isAppStoreVersion = YES;
    
    if (isAppStoreVersion) {
        //如果是AppStore上的版本，而且还没通过审核
        NSString *url = SHAREURL;
        NSString *content = [NSString stringWithFormat:@"您身边的商城-单耳兔O2O商城。"];
        if ( shareNumber != nil) {
            content = [NSString stringWithFormat:@"%@店铺码: %@",content,self.shareNumber];
        }
        NSString *titleStr = [shareInfo objectForKey:@"shareTitle"];
        if (titleStr == nil) {
            titleStr = self.myshopName;
        }
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x"  ofType:@"png"];
        if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"product"]) {
            //商品的分享
            titleStr = [shareInfo objectForKey:@"shareTitle"];
            imagePath = [shareInfo objectForKey:@"shareImg"] ; //图片的链接地址
            NSString *shopid = [shareInfo objectForKey:@"shopid"];
            NSString *guid = [shareInfo objectForKey:@"guid"];
            url = [NSString stringWithFormat:@"%@?shopid=%@&guid=%@",GOODSDETAILSHAREURL,shopid,guid];
            //构造分享内容
            imagePath = [NSString stringWithFormat:@"%@",imagePath];
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithUrl:imagePath]
                                                        title:titleStr
                                                          url:url
                                                  description:content
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        }
                                    }];
            return;
            
        }
        else if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"s"]) {
            //店铺的分享
            titleStr = [shareInfo objectForKey:@"shareTitle"];
            imagePath = [shareInfo objectForKey:@"Mobilebanner"] ; //图片的链接地址
            NSString *levelTypeStr = [shareInfo objectForKey:@"leveltype"];
            if ([levelTypeStr isMemberOfClass:[NSNull class]]) {
                levelTypeStr = @"";
            }
            if ([imagePath isMemberOfClass:[NSNull class]] || imagePath == nil || [imagePath isEqualToString:@""]) {
                imagePath = [NSString stringWithFormat:@"%@/pptImage/default_banner.png",IMAGESERVER];
            }
            NSString *shopid = [shareInfo objectForKey:@"shareId"];
            if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil) {
                shopid = @"";
            }
            
            NSString *platform = @"ios";
            NSString *preAddress = @"http://www.danertu.com/mobile/shop";
            NSInteger levelType = [levelTypeStr integerValue];
            switch (levelType) {
                case 0:
                {
                    url = [NSString stringWithFormat:@"%@/oldshop.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 1:
                {
                    url = [NSString stringWithFormat:@"%@/oldshop.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    
                    break;
                }
                case 2:
                {
                    url = [NSString stringWithFormat:@"%@/food_shop.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 3:
                {
                    url = [NSString stringWithFormat:@"%@/food_shop.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 4:
                {
                    url = [NSString stringWithFormat:@"%@/food_shop.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 11:{
                    url = [NSString stringWithFormat:@"%@/shop_template_1.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 12:{
                    url = [NSString stringWithFormat:@"%@/shop_template_2.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 13:{
                    url = [NSString stringWithFormat:@"%@/shop_template_3.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 14:{
                    url = [NSString stringWithFormat:@"%@/shop_template_4.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 15:{
                    url = [NSString stringWithFormat:@"%@/shop_template_5.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 16:{
                    url = [NSString stringWithFormat:@"%@/shop_template_6.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                case 17:{
                    url = [NSString stringWithFormat:@"%@/shop_template_7.htm?shopid=%@&platform=%@",preAddress,shopid,platform];
                    break;
                }
                default:
                {
                    NSInteger templevelType = levelType - 10;
                    url = [NSString stringWithFormat:@"%@/shop_template_%ld.htm?shopid=%@&platform=%@",preAddress,templevelType,shopid,platform];
                    break;
                }
            }
//            if (levelType == 0) {
//                url = [NSString stringWithFormat:@"http://www.danertu.com/mobile/shop/oldshop.htm?shopid=%@&platform=%@",shopid,platform];
//            }
//            else(levelType == 2) {
//                url = [NSString stringWithFormat:@"http://www.danertu.com/mobile/shop/food_shop.htm?shopid=%@&platform=%@",shopid,platform];
//            }
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithUrl:imagePath]
                                                        title:titleStr
                                                          url:url
                                                  description:content
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                            [self showHint:[error errorDescription]];
                                        }
                                    }];
            return;
        }
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:titleStr
                                                      url:url
                                              description:content
                                                mediaType:SSPublishContentMediaTypeNews];
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        return;
    }
    [self innerVersionShareApp:sender];
}

- (void)innerVersionShareApp:(id)sender
{
    NSString *url = ((UIButton*)sender).accessibilityIdentifier;
    NSString *platformName;
    if ([sender tag]==0) {
        if ([UPDATEMARK isEqualToString:@""]) {
            //如果是AppStore上面的版本，分享出去的是AppStore上的下载连接地址
            HeSingleModel *singleModel = [HeSingleModel shareHeSingleModel];
            NSDictionary *respondObj = singleModel.versionDict;
            url = [respondObj objectForKey:@"url"];
            if ([url isMemberOfClass:[NSNull class]] || url == nil || [url isEqualToString:@""]) {
                url = SHAREURL;
            }
        }
        platformName = @"iOS(苹果版)";
    }else if ([sender tag]==1){
        platformName = @"Andriod(安卓版)";
    }
    NSString *content = [NSString stringWithFormat:@"您身边的商城-单耳兔O2O商城%@。",platformName];
    if ( shareNumber != nil) {
        content = [NSString stringWithFormat:@"%@店铺码: %@",content,self.shareNumber];
    }
    NSString *titleStr = [shareInfo objectForKey:@"shareTitle"];
    if (titleStr == nil) {
        titleStr = self.myshopName;
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x"  ofType:@"png"];
    if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"product"]) {
        titleStr = [shareInfo objectForKey:@"shareTitle"];
        imagePath = [shareInfo objectForKey:@"shareImg"] ; //图片的链接地址
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithUrl:imagePath]
                                                    title:titleStr
                                                      url:url
                                              description:content
                                                mediaType:SSPublishContentMediaTypeNews];
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        return;
    }
    else if ([[shareInfo objectForKey:@"shareType"] isEqualToString:@"s"]) {
        titleStr = [shareInfo objectForKey:@"shareTitle"];
        imagePath = [shareInfo objectForKey:@"Mobilebanner"] ; //图片的链接地址
        NSString *levelTypeStr = [shareInfo objectForKey:@"leveltype"];
        if ([levelTypeStr isMemberOfClass:[NSNull class]]) {
            levelTypeStr = @"";
        }
        if ([imagePath isMemberOfClass:[NSNull class]] || imagePath == nil || [imagePath isEqualToString:@""]) {
            imagePath = [NSString stringWithFormat:@"%@/pptImage/default_banner.png",IMAGESERVER];
        }
        NSString *shopid = [shareInfo objectForKey:@"shareId"];
        if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil) {
            shopid = @"";
        }
        NSInteger levelType = [levelTypeStr integerValue];
        NSString *platform = @"ios";
        if ([sender tag] == 1) {
            platform = @"android";
        }
        if (levelType == 0) {
            url = [NSString stringWithFormat:@"http://www.danertu.com/mobile/shop/oldshop.htm?shopid=%@&platform=%@",shopid,platform];
        }
        else{
            url = [NSString stringWithFormat:@"http://www.danertu.com/mobile/shop/food_shop.htm?shopid=%@&platform=%@",shopid,platform];
        }
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithUrl:imagePath]
                                                    title:titleStr
                                                      url:url
                                              description:content
                                                mediaType:SSPublishContentMediaTypeNews];
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        return;
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:titleStr
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//内存不足报警
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}

@end
