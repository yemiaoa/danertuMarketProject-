//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "BookProductController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataModle.h"
#import "UIImageView+WebCache.h"
#import "Waiting.h"
@interface BookProductController() {
    NSMutableData *receivedData;
    NSMutableArray *addressArray;
    NSString *shouldPayPrice;
    NSDictionary *bookOrderInfo;
}

@end

@implementation BookProductController
@synthesize defaults;

@synthesize addStatusBarHeight;
@synthesize arrays;
@synthesize bookWood;

@synthesize clickAdd;

@synthesize itemSelect;
@synthesize userNameLb;
@synthesize mobileLb;
@synthesize adrLb;

@synthesize isAddAddress;
@synthesize payBtn;

@synthesize orderInfoDic;
@synthesize addressInfo;
@synthesize canGoAddressView;

@synthesize contentView;
@synthesize shouldPayTextLb;
- (void)viewDidLoad
{
    
    [super viewDidLoad];//没有词句,会执行多次
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = VIEWBGCOLOR;
    
    NSLog(@"gkreopribjirohoy--------%@",bookWood);
    
    
    //----中间滑动区域-------125-----之后是商品列表------
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, self.view.frame.size.width, CONTENTHEIGHT)];//上半部分
    contentView.backgroundColor = VIEWBGCOLOR;
    [self.view addSubview:contentView];
    canGoAddressView = YES;
    //送货地址
    UIView *addressLb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 81)];
    addressLb.backgroundColor = [UIColor colorWithRed:230.0/255 green:160.0/255 blue:22.0/255 alpha:1];
    addressLb.userInteractionEnabled = YES;
    [contentView addSubview:addressLb];
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAddPlace)];
    [addressLb addGestureRecognizer:singleTap1];//---添加大图片点击事
    //230  160   22
    //送货地址 --点击添加
    clickAdd = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80)];
    clickAdd.backgroundColor = BORDERCOLOR;
    clickAdd.text = @"点击添加收货信息";
    clickAdd.textAlignment = NSTextAlignmentCenter;
    clickAdd.textColor = [UIColor redColor];
    [addressLb addSubview:clickAdd];//
    
    //送货地址 --当前选择的地址
    itemSelect = [[UIView alloc] initWithFrame:CGRectMake(0,0, MAINSCREEN_WIDTH, 80)];
    [itemSelect setHidden:YES];//----首先隐藏
    [addressLb addSubview:itemSelect];
    
    //标题
    userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 170, 40)];
    userNameLb.textColor = [UIColor whiteColor];
    userNameLb.backgroundColor = [UIColor clearColor];
    [itemSelect addSubview:userNameLb];
    //电话
    mobileLb = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 98, 40)];
    mobileLb.font = TEXTFONT;
    mobileLb.textColor = [UIColor whiteColor];
    mobileLb.backgroundColor = [UIColor clearColor];
    [itemSelect addSubview:mobileLb];
    
    //地址图标----
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 46, 20, 27)];
    [locationImg setImage:[UIImage imageNamed:@"addressLocation"]];
    [itemSelect addSubview:locationImg];
    //地址
    adrLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 248, 40)];
    adrLb.font = TEXTFONTSMALL;
    adrLb.textColor = [UIColor whiteColor];
    adrLb.backgroundColor = [UIColor clearColor];
    adrLb.numberOfLines = 2;
    [itemSelect addSubview:adrLb];
    //向右箭头
    UIImageView *right2 = [[UIImageView alloc] initWithFrame:CGRectMake(298, 30, 12, 19)];
    [right2 setImage:[UIImage imageNamed:@"arrowRight"]];
    [itemSelect addSubview:right2];
    //线条
    UILabel *borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, MAINSCREEN_WIDTH, 1)];
    borderLine1.backgroundColor = BORDERCOLOR;
    [addressLb addSubview:borderLine1];
    
    //---每家超市---的view
    UIView *shopItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MAINSCREEN_WIDTH, contentView.frame.size.height-90)];
    [contentView addSubview:shopItemView];//
    shopItemView.backgroundColor = [UIColor whiteColor];
    
    //-----超市名称----
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 270, 30)];
    [shopItemView addSubview:shopName];//
    shopName.text = [NSString stringWithFormat:@"超市:  %@",[bookWood objectForKey:@"shopName"]];
    //线条
    UILabel *borderLine1_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    borderLine1_.backgroundColor = BORDERCOLOR;
    [shopItemView addSubview:borderLine1_];
    
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(10, 29.3, 300, 0.7)];
    [shopItemView addSubview:border];//
    border.backgroundColor = BORDERCOLOR;
    //每个店铺的商品总和,价格总和
    int shopWoodsCount = 0;
    double shopTotalPrice = 0;
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 150)];
    [shopItemView addSubview:itemView];
    itemView.tag = 3000;
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 40, 42)];//商品图片
    [itemView addSubview:imageView];
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 0.6;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[bookWood objectForKey:@"img"]]];
    //商品名称
    UILabel *woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 130, 36)];
    [itemView addSubview:woodsLabel];//
    woodsLabel.font = TEXTFONTSMALL;
    woodsLabel.numberOfLines = 2;
    woodsLabel.text = [bookWood objectForKey:@"name"];
    
    //单价符号,-----这里作为父标签的最后一个子标签,便于寻找
    UILabel *unitPriceSign = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 100, 18)];
    [itemView addSubview:unitPriceSign];
    unitPriceSign.font = TEXTFONTSMALL;
    unitPriceSign.textAlignment = NSTextAlignmentRight;
    unitPriceSign.text = [NSString stringWithFormat:@"¥ %@",[bookWood objectForKey:@"price"]];
    unitPriceSign.backgroundColor = [UIColor clearColor];
    
    //数量-----
    int woodItemCount = [[bookWood objectForKey:@"count"] intValue];
    UILabel *woodCountLb = [[UILabel alloc] initWithFrame:CGRectMake(230, 30, 70, 18)];
    [itemView addSubview:woodCountLb];
    woodCountLb.font = TEXTFONTSMALL;
    woodCountLb.textAlignment = NSTextAlignmentRight;
    woodCountLb.text = [NSString stringWithFormat:@"X %d",woodItemCount];
    woodCountLb.backgroundColor = [UIColor clearColor];
    //---累加商品数量----累加商品价格
    shopWoodsCount += woodItemCount;
    shopTotalPrice += woodItemCount*[[bookWood objectForKey:@"price"] doubleValue];
    
    //-------购买数量-----
    UILabel *variableCountLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 300, 30)];
    [itemView addSubview:variableCountLb];
    variableCountLb.userInteractionEnabled = YES;
    variableCountLb.text = @"购买数量";
    variableCountLb.font = TEXTFONT;
    //-----后加线条----
    UILabel *border123 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 300, 0.7)];
    [itemView addSubview:border123];//
    border123.backgroundColor = BORDERCOLOR;
    
    //------购买数量----
    UIButton *minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 5, 60, 20)];
    [variableCountLb addSubview:minusBtn];//
    [minusBtn setBackgroundColor:[UIColor whiteColor]];
    [minusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    minusBtn.layer.cornerRadius = 3;
    minusBtn.layer.borderWidth = 0.4;
    minusBtn.accessibilityIdentifier = @"m";
    [minusBtn addTarget:self action:@selector(changeWoodCount:) forControlEvents:UIControlEventTouchUpInside];
    //数字
    UILabel *countText = [[UILabel alloc] initWithFrame:CGRectMake(205, 5, 30, 20)];
    [variableCountLb addSubview:countText];//
    countText.text = [bookWood objectForKey:@"count"];
    countText.textAlignment = NSTextAlignmentCenter;
    countText.layer.cornerRadius = 3;
    countText.layer.borderWidth = 0.4;
    countText.tag = 2000;
    
    //++++++++++++++++
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 60, 20)];
    [variableCountLb addSubview:addBtn];//
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.borderWidth = 0.4;
    addBtn.accessibilityIdentifier = @"a";
    [addBtn addTarget:self action:@selector(changeWoodCount:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----后加线条----
    UILabel *border1234 = [[UILabel alloc] initWithFrame:CGRectMake(0, 89.3, 300, 0.7)];
    [itemView addSubview:border1234];//
    border1234.backgroundColor = BORDERCOLOR;
    
    UILabel *bottomView = [[UILabel alloc] initWithFrame:CGRectMake(0,90, 300, 30)];
    [itemView addSubview:bottomView];
    bottomView.tag = 6000;//------特殊tag-------
    bottomView.textAlignment = NSTextAlignmentRight;
    //shopWoodsCount----shopTotalPrice
    shouldPayPrice = [NSString stringWithFormat:@"%0.2f",shopTotalPrice];
    bottomView.text = [NSString stringWithFormat:@"共%@件商品  合计: ¥ %@",countText.text,shouldPayPrice];
    
    
    
    //----底部部分
    UIView *bottomNavi = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, MAINSCREEN_WIDTH, 49)];
    bottomNavi.backgroundColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1];
    bottomNavi.userInteractionEnabled = YES;
    [self.view addSubview:bottomNavi];
    
    //应付金额
    shouldPayTextLb = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 160, 49)];
    shouldPayTextLb.backgroundColor = [UIColor clearColor];
    shouldPayTextLb.textColor = TOPNAVIBGCOLOR_G;
    shouldPayTextLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    shouldPayTextLb.text = [NSString stringWithFormat:@"合计: ¥ %@",shouldPayPrice];
    shouldPayTextLb.textAlignment = NSTextAlignmentRight;
    [bottomNavi addSubview:shouldPayTextLb];
    
    //------支付
    payBtn = [[UIButton alloc]initWithFrame:CGRectMake(240, 7, 60, 35)];//高度--44
    [payBtn.layer setMasksToBounds:YES];
    [payBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    payBtn.enabled = NO;
    payBtn.backgroundColor = VIEWBGCOLOR;
    [payBtn setTitle:@"确认" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [payBtn addTarget:self action:@selector(onClickCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomNavi addSubview:payBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"getNewDefaultAddress" object:nil];//选中地址view 之间的消息传递
    [self getAddressData];//获取默认收货人地址
    
    
    
    
}
//-----修改标题
-(NSString*)getTitle{
    return @"确认预订";
}
//-----修改标题栏背景颜色
-(UIColor *)getTopNaviColor{
    return TOPNAVIBGCOLOR_G;
}
//-----提交预订-------
-(void)onClickCreateOrder{
    
//    NSString *MemLoginID = [MyKeyChainHelper getUserNameWithService:USERNAME_KEY];
    NSString * MemLoginID = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (MemLoginID.length>0) {
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0091",@"MemLoginID": MemLoginID,@"AgentID":[bookWood objectForKey:@"AgentId"],@"ProductGuid":[bookWood objectForKey:@"Guid"] ,@"Name": [userNameLb.text stringByReplacingOccurrencesOfString:@"收货人: " withString:@""],@"Address":[adrLb.text stringByReplacingOccurrencesOfString:@"收货地址: " withString:@""] ,@"Mobile":mobileLb.text,@"BuyCount":[bookWood objectForKey:@"count"],@"ShouldPayPrice":shouldPayPrice,@"ProductPrice":[bookWood objectForKey:@"price"],@"productName":[bookWood objectForKey:@"name"],@"ShopName":[bookWood objectForKey:@"shopName"]};
        NSLog(@"gjoeirjgirlocationString---------:%@",params);
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"gkrpoekoprjnptyyt--------%@",source);
            if(![source isEqualToString:@"false"]){
                [self.view makeToast:@"预订成功" duration:1.2 position:@"center"];
                bookOrderInfo = @{@"bookOrderNo":source,@"bookOrderPrice":shouldPayPrice};
                
                BookFinishController *anew = [[BookFinishController alloc] init];
                anew.hidesBottomBarWhenPushed = YES;
                anew.bookOrderInfo = bookOrderInfo;
                [self.navigationController pushViewController:anew animated:YES];
            }else{
                [self.view makeToast:@"预订失败,请稍后重试" duration:1.2 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
            [Waiting dismiss];
            //[Waiting dismiss];//----隐藏loading----
        }];
        [operation start];//-----发起请求------
        NSLog(@"---start to getDanData------");
    }else{
        [self.view makeToast:@"数据有误,请回退重试" duration:1.2 position:@"center"];
    }
    
}
//改变数字,加减按钮,
-(void)changeWoodCount:(UIButton*)sender{
    NSLog(@"kgpogkorpeitn------");
    
    NSString *flag = sender.accessibilityIdentifier;
    
    UILabel *countLb = (UILabel *)[[sender superview] viewWithTag:2000];
    int currentCount = [[bookWood objectForKey:@"count"] intValue];
    double changePrice = [[bookWood objectForKey:@"price"] doubleValue];
    int changeCount = 1;
    if ([flag isEqualToString:@"a"]) {
        currentCount +=1;
    }else{
        currentCount -=1;
        //变化量
        changeCount = -changeCount;
        changePrice = -changePrice;
    }
    
    NSLog(@"fjejgiorjeiogt---%d--%f----",currentCount,changePrice);
    
    if (currentCount>0) {
        countLb.text = [NSString stringWithFormat:@"%d",currentCount];
        [bookWood setObject:countLb.text forKey:@"count"];
        
        //-----修改底部总金额-----
        UILabel *bottomV = (UILabel *)[[[sender superview] superview] viewWithTag:6000];
        NSRange range = [bottomV.text rangeOfString:@"件商品  合计: ¥ "];
        NSString *sourceStr = [bottomV.text substringFromIndex:1];
        double oldPrice = [[sourceStr substringFromIndex:(range.location+range.length-1)] doubleValue] + changePrice;
        bottomV.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %0.2f",currentCount,oldPrice];
        shouldPayPrice = [NSString stringWithFormat:@"%0.2f",oldPrice];
        shouldPayTextLb.text = [NSString stringWithFormat:@"合计: ¥ %@",shouldPayPrice];
    }else{
        [self.view makeToast:@"商品数量至少是1" duration:1.2 position:@"center"];
    }
}
//-----初次加载地址信息------加载  获取 默认收货人地址
-(void)getDefaultAddress{
     NSDictionary *addressDic = [addressArray firstObject];
    if (addressArray.count > 1) {
        for (NSDictionary *tempDic in addressArray) {
            if([[tempDic objectForKey:@"ck"] isEqualToString:@"1"]){
                addressDic = [tempDic copy];
                break;
            }
        }
    }
    [clickAdd setHidden:YES];
    [itemSelect setHidden:NO];
    isAddAddress = YES;//添加了地址
    payBtn.enabled = YES;
    payBtn.backgroundColor = TOPNAVIBGCOLOR_G;
    userNameLb.text = [NSString stringWithFormat:@"收货人: %@",[addressDic objectForKey:@"name"]];
    userNameLb.accessibilityIdentifier = [addressDic objectForKey:@"guid"];;
    mobileLb.text = [addressDic objectForKey:@"mobile"];
    adrLb.text = [NSString stringWithFormat:@"收货地址: %@",[addressDic objectForKey:@"adress"]];
    addressInfo = addressDic;
}
//-----通过消息  获取 收货人地址
-(void)getAddress:(NSNotification *) notification{
    [clickAdd setHidden:YES];
    [itemSelect setHidden:NO];
    isAddAddress = YES;//添加了地址
    payBtn.enabled = YES;
    payBtn.backgroundColor = TOPNAVIBGCOLOR_G;
    NSDictionary *tempDic = [notification userInfo];
    userNameLb.text = [NSString stringWithFormat:@"收货人: %@",[tempDic objectForKey:@"name"]];
    userNameLb.accessibilityIdentifier = [tempDic objectForKey:@"guid"];//没有值
    mobileLb.text = [tempDic objectForKey:@"mobile"];
    adrLb.text = [NSString stringWithFormat:@"收货地址: %@",[tempDic objectForKey:@"adress"]];
    addressInfo = tempDic;
}
//-------获取地址
-(void)getAddressData{
//    NSString *_userName = [MyKeyChainHelper getUserNameWithService:USERNAME_KEY];
//    NSString *_password = [MyKeyChainHelper getPasswordWithService:PASSWORD_KEY];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if (userName.length>0) {
        [Waiting show];
        
        NSURL *url = [NSURL URLWithString:APIURL];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"apiid=0030&&uid=%@",userName];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        NSError *error;
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (!error) {
            [Waiting dismiss];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];//json解析
            //            NSArray* temp = [jsonData objectForKey:@"val"];//数组
            NSArray* temp = [[jsonData objectForKey:@"adress"] objectForKey:@"adresslist"];//数组
            if(temp.count>0){
                //                NSMutableDictionary *rootDic = [[defaults objectForKey:@"userLoginInfo"] mutableCopy];
                //                [rootDic setObject:temp forKey:@"adr"];
                //                [defaults setObject:rootDic forKey:@"userLoginInfo"];//本地存储
                addressArray = [temp mutableCopy];
                NSLog(@"khotrkophotrkphkr-------%@",addressArray);
                if (addressArray.count>0) {
                    [self getDefaultAddress];
                }
                canGoAddressView = YES;
            }else{
                [self.view makeToast:@"获取地址失败" duration:2.0 position:@"center"];
            }
        }else{
            [Waiting dismiss];
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }
    }else{
//        [Waiting dismiss];
        [self.view makeToast:@"获取地址失败,请登录" duration:1.2 position:@"center"];
        canGoAddressView = NO;
    }
}
//-----点击添加收货地址
-(void)onClickAddPlace{
    
    //更换默认地址
    if (canGoAddressView) {
        if (isAddAddress) {
            AddressListController *alist = [[AddressListController alloc]init];
            alist.hidesBottomBarWhenPushed = YES;
            alist.isFromOrderForm = YES;
            alist.prevAddressGuid = userNameLb.accessibilityIdentifier;
            [self.navigationController pushViewController:alist animated:YES];
        }else{
            //没有地址,弹出提示
            
            AddressNewController *alist = [[AddressNewController alloc] init];
            alist.hidesBottomBarWhenPushed = YES;
            alist.isFromOrderForm = YES;
            [self.navigationController pushViewController:alist animated:YES];
        }
    }
    NSLog(@"----onClickAddPlace---图片被点击!------%d,%d",canGoAddressView,isAddAddress);
}
//-----跳转前作的准备
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addressList"]) {
        AddressListController *alist = [segue destinationViewController];
        alist.isFromOrderForm = YES;
    }else if ([segue.identifier isEqualToString:@"addressNew"]){
        AddressNewController *anew = [segue destinationViewController];
        anew.isFromOrderForm = YES;
    }else if ([segue.identifier isEqualToString:@"bookFinish"]){
        BookFinishController *anew = [segue destinationViewController];
        anew.bookOrderInfo = bookOrderInfo;
    }
}
//-----------内存不足报警------
@end
