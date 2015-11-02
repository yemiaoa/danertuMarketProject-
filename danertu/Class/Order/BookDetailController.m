//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "BookDetailController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataModle.h"
#import "UIImageView+WebCache.h"

@interface BookDetailController() {
    NSMutableData *receivedData;
    NSMutableArray *addressArray;
    DataModle *clickModle;
    BOOL isFromBookOrder;
}

@end

@implementation BookDetailController
@synthesize defaults;
@synthesize bookOrderInfo;

- (id)initWithBookDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        bookOrderInfo = [[NSDictionary alloc] initWithDictionary:dict];
        isFromBookOrder = NO;
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];//没有词句,会执行多次
    [self initialization];   //初始化
}

- (void)initialization
{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = VIEWBGCOLOR;
    
    if ([[bookOrderInfo objectForKey:@"isFromBookOrder"] isEqualToString:@"1"]) {
        NSLog(@"isFromBookOrder");
        isFromBookOrder = YES;
    }
    //----中间滑动区域-------125-----之后是商品列表------
    
    int itemHeight = 201; //每条商品信息的高度
    int addItemHeight = 0;
    if (isFromBookOrder) {
         addItemHeight = 110;
    }else{
        for (int i = 0; i < [[bookOrderInfo valueForKey:@"orderproductbean"] count]; i++) {
            NSString *other1 = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other1"];
            NSString *other2 = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other2"];
            if (!([other1 isEqualToString:@""] || other1 == nil) && !([other2 isEqualToString:@""] || other2 == nil)) {
                itemHeight = 261;
            }
            else if (!([other1 isEqualToString:@""] || other1 == nil)){
                itemHeight = 231;
            }
            else if (!([other2 isEqualToString:@""] || other2 == nil)){
                itemHeight = 231;
            }
            else{
                itemHeight = 201;
            }
            addItemHeight = addItemHeight + itemHeight;
        }
//       addItemHeight = (int)[[bookOrderInfo valueForKey:@"orderproductbean"] count] *itemHeight;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];//上半部分
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, addItemHeight + 130 + 40);
    [self.view addSubview:scrollView];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50 + 40+addItemHeight)];//上半部分
    contentView.backgroundColor = VIEWBGCOLOR;
    [scrollView addSubview:contentView];
    
    //送货地址
    UIView *addressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80)];
    addressBgView.backgroundColor = [UIColor colorWithRed:230.0/255 green:160.0/255 blue:22.0/255 alpha:1];
    [contentView addSubview:addressBgView];
    //230  160   22
    
    //标题
    UILabel *userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 170, 40)];
    userNameLb.textColor = [UIColor whiteColor];
    userNameLb.backgroundColor = [UIColor clearColor];
    userNameLb.text = [NSString stringWithFormat:@"收货人:  %@",[bookOrderInfo objectForKey:@"Name"]];
    [addressBgView addSubview:userNameLb];
    
    //电话
    UILabel *mobileLb = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, MAINSCREEN_WIDTH-200, 40)];
    mobileLb.font = TEXTFONT;
    mobileLb.textColor = [UIColor whiteColor];
    mobileLb.text = [bookOrderInfo objectForKey:@"Mobile"];
    mobileLb.backgroundColor = [UIColor clearColor];
    [addressBgView addSubview:mobileLb];
    
    //地址图标----
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 46, 20, 27)];
    [locationImg setImage:[UIImage imageNamed:@"addressLocation"]];
    [addressBgView addSubview:locationImg];
    
    //地址
    UILabel *adrLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 248, 40)];
    adrLb.font = TEXTFONT;
    if ([[bookOrderInfo objectForKey:@"isAllSpringGoods"] boolValue]) {
        adrLb.text = @"注意:此商品请直接到店消费";
        adrLb.textColor = [UIColor redColor];
    }else{
        adrLb.text = [NSString stringWithFormat:@"收货地址:  %@",[bookOrderInfo objectForKey:@"Address"]];
        adrLb.textColor = [UIColor whiteColor];
    }
    adrLb.backgroundColor = [UIColor clearColor];
    adrLb.numberOfLines = 2;
    [addressBgView addSubview:adrLb];
    
    //每家超市的view
    UIView *shopItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MAINSCREEN_WIDTH, contentView.frame.size.height-90 +90)]; //
    NSLog(@"%f",contentView.frame.size.height-90 +90);
    [contentView addSubview:shopItemView];
    shopItemView.backgroundColor = [UIColor whiteColor];
    
    //订单号---
    UILabel *orderNo = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 20)];
    [shopItemView addSubview:orderNo];
    orderNo.font = TEXTFONT;
    orderNo.textColor = [UIColor orangeColor];
    orderNo.text = [NSString stringWithFormat:@"订单号: %@", [bookOrderInfo objectForKey:@"OrderNumber"]] ;
    
    //订单时间
    UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 20)];
    [shopItemView addSubview:orderTime];
    orderTime.font = TEXTFONTSMALL;
    orderTime.textColor = [UIColor grayColor];
    orderTime.text = [NSString stringWithFormat:@"创建时间: %@", [bookOrderInfo objectForKey:@"CreateTime"]];
    
    UILabel *orderStatusValue      = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-90,10, 80, 20)];
    [shopItemView addSubview:orderStatusValue];
    orderStatusValue.textAlignment = NSTextAlignmentRight;
    orderStatusValue.font          = TEXTFONT;
    orderStatusValue.textColor     = [UIColor redColor];
    
    //线
    UILabel *borderL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];
    borderL.backgroundColor = BORDERCOLOR;
    [shopItemView addSubview:borderL];
    
    CGFloat offsetY = 0;
    
    if (isFromBookOrder) {
        orderStatusValue.text      = [bookOrderInfo objectForKey:@"OrderStatus"];
        
        //线条
        UILabel *borderLine1_        = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MAINSCREEN_WIDTH, 1)];
        borderLine1_.backgroundColor = BORDERCOLOR;
        [shopItemView addSubview:borderLine1_];
        
        //-----超市名称----
        NSString *str                   = [[bookOrderInfo objectForKey:@"ShopName"] isEqualToString:@""] ? @"醇康" : [bookOrderInfo objectForKey:@"ShopName"];
        UILabel *shopName               = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 270, 30)];
        [shopItemView addSubview:shopName];
        [shopName setBackgroundColor:[UIColor clearColor]];
        shopName.userInteractionEnabled = YES;
        shopName.font                   = TEXTFONT;
        shopName.tag                    = 100;
        shopName.text                   = [NSString stringWithFormat:@"超市:  %@ %@",@">",str];
        //        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickGoShop:)];
        //        [shopName addGestureRecognizer:singleTap];//---添加点击事件
        
        UIView *itemsView         = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + 40, MAINSCREEN_WIDTH, 50)];
        itemsView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        itemsView.tag             = 500;
        [shopItemView addSubview:itemsView];
        
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGoodsDetailGes:)];
        [itemsView addGestureRecognizer:tapges];
        
        //商品图片
        AsynImageView *imageView         = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 33 + 40, 45, 45)];//商品图片 40,42
        [shopItemView addSubview:imageView];
        NSString *imageUrl = [bookOrderInfo objectForKey:@"SmallImage"];
        if ([imageUrl isMemberOfClass:[NSNull class]] || imageUrl == nil) {
            imageUrl = @"";
        }
        imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
        imageView.imageURL = imageUrl;
        
        //商品名称
        UILabel *woodsLabel      = [[UILabel alloc] initWithFrame:CGRectMake(70, 40 + 40, 130, 36)];
        [shopItemView addSubview:woodsLabel];
        [woodsLabel setBackgroundColor:[UIColor clearColor]];
        woodsLabel.font          = TEXTFONTSMALL;
        woodsLabel.numberOfLines = 2;
        woodsLabel.text          = [bookOrderInfo objectForKey:@"ProductName"];
        
        //单价符号,-----这里作为父标签的最后一个子标签,便于寻找
        UILabel *unitPriceSign        = [[UILabel alloc] initWithFrame:CGRectMake(200, 40 + 40, 100, 18)];
        [shopItemView addSubview:unitPriceSign];
        [unitPriceSign setBackgroundColor:[UIColor clearColor]];
        unitPriceSign.font            = TEXTFONTSMALL;
        unitPriceSign.textAlignment   = NSTextAlignmentRight;
        unitPriceSign.text            = [NSString stringWithFormat:@"¥ %@",[bookOrderInfo objectForKey:@"ProductPrice"]];
        unitPriceSign.backgroundColor = [UIColor clearColor];
        
        //数量
        int woodItemCount           = [[bookOrderInfo objectForKey:@"BuyCount"] intValue];
        UILabel *woodCountLb        = [[UILabel alloc] initWithFrame:CGRectMake(230, 60+ 40, 70, 18)];
        [shopItemView addSubview:woodCountLb];
        woodCountLb.font            = TEXTFONTSMALL;
        woodCountLb.textAlignment   = NSTextAlignmentRight;
        woodCountLb.text            = [NSString stringWithFormat:@"X %d",woodItemCount];
        woodCountLb.backgroundColor = [UIColor clearColor];
        
        //预订数量
        UILabel *variableCountLb    = [[UILabel alloc] initWithFrame:CGRectMake(10, 81 + 40, 300, 30)];
        [shopItemView addSubview:variableCountLb];
        variableCountLb.userInteractionEnabled = YES;
        variableCountLb.text        = @"预订数量";
        variableCountLb.font        = TEXTFONT;
        
        //预定数量的具体数目
        UILabel *countText          = [[UILabel alloc] initWithFrame:CGRectMake(200, 86 + 40, 100, 20)];
        [shopItemView addSubview:countText];//
        countText.text              = [bookOrderInfo objectForKey:@"BuyCount"];
        countText.textAlignment     = NSTextAlignmentRight;
        
        //-----后加线条----
        UILabel *bd        = [[UILabel alloc] initWithFrame:CGRectMake(0, 111 + 40 - 1, MAINSCREEN_WIDTH, 1)];
        [shopItemView addSubview:bd];
        bd.backgroundColor = BORDERCOLOR;
        
        int totallNums = 0;
        for (int i = 0; i < [[bookOrderInfo valueForKey:@"orderproductbean"] count]; i++) {
            totallNums += [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"BuyNumber"] intValue];
        }
        if (totallNums == 0) {
            //如果数量为0，那么可能是预定的商品，预定商品的数量字段为:BuyCount
            totallNums = [[bookOrderInfo objectForKey:@"BuyCount"] intValue];
        }
        UILabel *bottomView = [[UILabel alloc] initWithFrame:CGRectMake(0,itemHeight - 90+ 40, 300, 30)];
        [shopItemView addSubview:bottomView];
        bottomView.tag = 6000;//------特殊tag-------
        bottomView.textAlignment = NSTextAlignmentRight;
        //shopWoodsCount----shopTotalPrice
        bottomView.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %0.2f",totallNums,[[bookOrderInfo objectForKey:@"ShouldPayPrice"] doubleValue]];
    }else{
        self.topNaviView_topClass.backgroundColor = TOPNAVIBGCOLOR;  //不是预订单的时候，校准导航栏的颜色
        orderStatusValue.text          = [NSString stringWithFormat:@"%@",[self setOrderStatusWithType:[[bookOrderInfo objectForKey:@"orderTypeId"] intValue]]];
        
        CGFloat viewY = 0;
        CGFloat lastItemHeight = 0;
        
        for (int i = 0; i < [[bookOrderInfo valueForKey:@"orderproductbean"] count]; i++) {
            
            NSString *other1 = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other1"];
            NSString *other2 = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other2"];
            if (!([other1 isEqualToString:@""] || other1 == nil) && !([other2 isEqualToString:@""] || other2 == nil)) {
                itemHeight = 261;
            }
            else if (!([other1 isEqualToString:@""] || other1 == nil)){
                itemHeight = 231;
            }
            else if (!([other2 isEqualToString:@""] || other2 == nil)){
                itemHeight = 231;
            }
            else{
                itemHeight = 201;
            }
            offsetY = 0;
            //线条
            UILabel *borderLine1_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 40+ lastItemHeight + offsetY, MAINSCREEN_WIDTH, 1)];
            borderLine1_.backgroundColor = BORDERCOLOR;
            [shopItemView addSubview:borderLine1_];
            
            //-----超市名称----
            NSString *str = [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"ShopName"] isEqualToString:@""] ? @"醇康" : [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"ShopName"];
            UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + 40+ lastItemHeight + offsetY, 270, 30)];
            [shopItemView addSubview:shopName];
            shopName.backgroundColor = [UIColor clearColor];
            shopName.userInteractionEnabled = YES;
            shopName.font = TEXTFONT;
            shopName.tag = 100+i;
            shopName.text = [NSString stringWithFormat:@"超市:  %@ %@",@">",str];
            
            UIView *itemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + 40+ lastItemHeight + offsetY, MAINSCREEN_WIDTH, 50)];
            itemsView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
            itemsView.tag = 500 + i;
            [shopItemView addSubview:itemsView];
            
            //商品图片
            AsynImageView *imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 33 + 40+ lastItemHeight + offsetY, 45, 45)];//商品图片 40,42
            [shopItemView addSubview:imageView];
            NSString *imageUrl = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"SmallImage"];
            if ([imageUrl isMemberOfClass:[NSNull class]] || imageUrl == nil) {
                imageUrl = @"";
            }
            imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
            imageView.imageURL = imageUrl;
            
            UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGoodsDetailGes:)];
            [itemsView addGestureRecognizer:tapges];
            
            //商品名称
            UILabel *woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40 + 40+ lastItemHeight + offsetY, 130, 36)];
            [shopItemView addSubview:woodsLabel];
            woodsLabel.backgroundColor = [UIColor clearColor];
            woodsLabel.font = TEXTFONTSMALL;
            woodsLabel.numberOfLines = 2;
            woodsLabel.text = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"Name"];
            
            //单价符号,-----这里作为父标签的最后一个子标签,便于寻找
            UILabel *unitPriceSign = [[UILabel alloc] initWithFrame:CGRectMake(200, 40 + 40+ lastItemHeight + offsetY, 100, 18)];
            [shopItemView addSubview:unitPriceSign];
            unitPriceSign.font = TEXTFONTSMALL;
            unitPriceSign.textAlignment = NSTextAlignmentRight;
            unitPriceSign.text = [NSString stringWithFormat:@"¥ %@",[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"ShopPrice"]];
            unitPriceSign.backgroundColor = [UIColor clearColor];
            
            int BuyNumber = [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"BuyNumber"] intValue];
            
//            float ShopPrice = [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"ShopPrice"] intValue];
//            float ShouldPayPrice = [[bookOrderInfo valueForKey:@"ShouldPayPrice"] floatValue];
            //实际购买
            
            
            
            int isGiveScale = [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"iSGive"] intValue];
            int iSGive = 0;
            if (isGiveScale <= 0) {
                isGiveScale = 0;
            }
            
            if (isGiveScale == 0) {
                iSGive = 0;
            }
            else{
                int myNumber = BuyNumber % (isGiveScale + 1);
                if (myNumber == 0) {
                    iSGive = BuyNumber / (isGiveScale + 1);
                }
                else{
                    iSGive = (BuyNumber - 1) / (isGiveScale + 1);
                }
            }
            
            int realBuyNumber = BuyNumber - iSGive;
            
//            if ([[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"iSGive"] intValue] != 0) {
//                iSGive = BuyNumber / ([[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"iSGive"] intValue]);
//            }
            
            //数量-----
            int woodItemCount = BuyNumber;
            UILabel *woodCountLb = [[UILabel alloc] initWithFrame:CGRectMake(230, 60+ 40+ lastItemHeight + offsetY, 70, 18)];
            [shopItemView addSubview:woodCountLb];
            woodCountLb.font = TEXTFONTSMALL;
            woodCountLb.textAlignment = NSTextAlignmentRight;
            woodCountLb.text = [NSString stringWithFormat:@"X %d",woodItemCount];
            woodCountLb.backgroundColor = [UIColor clearColor];
            
            //预订数量
            UILabel *variableCountLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 81 + 40+ lastItemHeight + offsetY, 300, 30)];
            [shopItemView addSubview:variableCountLb];
            variableCountLb.userInteractionEnabled = YES;
            variableCountLb.text = @"预订数量";
            variableCountLb.font = TEXTFONT;
            
            //预定数量的具体数目
            UILabel *countText = [[UILabel alloc] initWithFrame:CGRectMake(200, 86 + 40+ lastItemHeight + offsetY, 100, 20)];
            [shopItemView addSubview:countText];//
            countText.text = [NSString stringWithFormat:@"%d",realBuyNumber];
            countText.font = TEXTFONT;
            countText.textAlignment = NSTextAlignmentRight;
            
            //后加线条
            UILabel *border1234 = [[UILabel alloc] initWithFrame:CGRectMake(10, 111 + 40+ lastItemHeight + offsetY - 0.7, 300, 0.7)];
            [shopItemView addSubview:border1234];//
            border1234.backgroundColor = BORDERCOLOR;
            
            //--------赠送数量
            UILabel *giveLb = [[UILabel alloc] initWithFrame:CGRectMake(10,111 + 40+ lastItemHeight + offsetY, 300, 30)];
            [shopItemView addSubview:giveLb];
            giveLb.text = @"赠送数量";
            giveLb.font = TEXTFONT;
            
            UILabel *giveLbValue      = [[UILabel alloc] initWithFrame:CGRectMake(200,111 + 40+ lastItemHeight + offsetY, 100, 30)];
            [shopItemView addSubview:giveLbValue];
            giveLbValue.textAlignment = NSTextAlignmentRight;
            giveLbValue.text          = [NSString stringWithFormat:@"%d",iSGive];
            giveLbValue.font          = TEXTFONT;
            
            UILabel *borderGive = [[UILabel alloc] initWithFrame:CGRectMake(10,111 + 40+ lastItemHeight + offsetY + 30 - 0.7, 300, 0.7)];
            [shopItemView addSubview:borderGive];
            borderGive.backgroundColor = BORDERCOLOR;
            
            //商家电话
            UILabel *storeTel = [[UILabel alloc] initWithFrame:CGRectMake(10,141 + 40 + lastItemHeight + offsetY, 300, 30)];
            [shopItemView addSubview:storeTel];
            storeTel.text = @"商家电话";
            storeTel.font = TEXTFONT;
            
            NSString *tel = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"tel"];
            if ([tel isMemberOfClass:[NSNull class]] || tel == nil || [tel isEqualToString:@""]) {
                tel = @"4009952220";
            }
            UILabel *storeTelValue      = [[UILabel alloc] initWithFrame:CGRectMake(100,141 + 40+ lastItemHeight + offsetY, 200, 30)];
            [shopItemView addSubview:storeTelValue];
            storeTelValue.textAlignment = NSTextAlignmentRight;
            storeTelValue.text          = tel;
            storeTelValue.font          = TEXTFONT;
            
            CGFloat subOffsetY = 0;
            NSString *arriveTimeStr = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other1"];
        
            CGFloat priceLabelY = 171 + 40 + lastItemHeight + offsetY;
            
            if ( [arriveTimeStr isMemberOfClass:[NSNull class]] || arriveTimeStr == nil) {
                arriveTimeStr = @"";
            }
            if (![arriveTimeStr isEqualToString:@""]) {
                subOffsetY = 30;
                UILabel *borderPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 171 + 40+ lastItemHeight + offsetY - 0.7, 300, 0.7)];
                [shopItemView addSubview:borderPrice];
                borderPrice.backgroundColor = BORDERCOLOR;
                //到达时间
                UILabel *arriveTime = [[UILabel alloc] initWithFrame:CGRectMake(10,171 + 40+ lastItemHeight + offsetY, 300, 30)];
                arriveTime.backgroundColor = [UIColor clearColor];
                [shopItemView addSubview:arriveTime];
                arriveTime.text = @"抵达时间";
                arriveTime.font = TEXTFONT;
                UILabel *arriveTimeValue      = [[UILabel alloc] initWithFrame:CGRectMake(100,171 + 40+ lastItemHeight + offsetY, 200, 30)];
                arriveTimeValue.backgroundColor = [UIColor clearColor];
                [shopItemView addSubview:arriveTimeValue];
                arriveTimeValue.textAlignment = NSTextAlignmentRight;
                arriveTimeValue.text          = arriveTimeStr;
                arriveTimeValue.font          = TEXTFONT;
            }
            
            NSString *leaveTimeStr = [[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"other2"];
              
            if ( [leaveTimeStr isMemberOfClass:[NSNull class]] || leaveTimeStr == nil) {
                leaveTimeStr = @"";
            }
            if (![leaveTimeStr isEqualToString:@""]) {
                UILabel *borderPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 171 + 40+ lastItemHeight + subOffsetY + offsetY - 0.7, 300, 0.7)];
                [shopItemView addSubview:borderPrice];
                borderPrice.backgroundColor = BORDERCOLOR;
                
                //到达时间
                UILabel *leaveTime = [[UILabel alloc] initWithFrame:CGRectMake(10,171 + 40+ lastItemHeight + subOffsetY + offsetY, 300, 30)];
                leaveTime.backgroundColor = [UIColor clearColor];
                [shopItemView addSubview:leaveTime];
                leaveTime.text = @"离开时间";
                leaveTime.font = TEXTFONT;
                UILabel *leaveTimeValue      = [[UILabel alloc] initWithFrame:CGRectMake(100,171 + 40+ lastItemHeight + subOffsetY + offsetY, 200, 30)];
                leaveTimeValue.backgroundColor = [UIColor clearColor];
                [shopItemView addSubview:leaveTimeValue];
                leaveTimeValue.textAlignment = NSTextAlignmentRight;
                leaveTimeValue.text          = leaveTimeStr;
                leaveTimeValue.font          = TEXTFONT;
                subOffsetY = subOffsetY + 30;
            }
            
            priceLabelY = priceLabelY + subOffsetY;
            
            UILabel *borderTel = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLabelY - 0.7, 300, 0.7)];
            [shopItemView addSubview:borderTel];
            borderTel.backgroundColor = BORDERCOLOR;
            
            //市场价
            UILabel *marketPrice = [[UILabel alloc] initWithFrame:CGRectMake(10,priceLabelY, 300, 30)];
            [shopItemView addSubview:marketPrice];
            marketPrice.text = @"市场价";
            marketPrice.font = TEXTFONT;
            UILabel *marketPriceValue      = [[UILabel alloc] initWithFrame:CGRectMake(200,priceLabelY, 100, 30)];
            [shopItemView addSubview:marketPriceValue];
            marketPriceValue.textAlignment = NSTextAlignmentRight;
            marketPriceValue.text          = [NSString stringWithFormat:@"¥ %@",[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"MarketPrice"]];
            marketPriceValue.font          = TEXTFONT;
            
            offsetY = subOffsetY;
            viewY = marketPrice.frame.origin.y + marketPrice.frame.size.height;
            lastItemHeight = lastItemHeight + itemHeight;
        }
        //-----后加线条----
        UILabel *bd = [[UILabel alloc] initWithFrame:CGRectMake(0, viewY - 1, MAINSCREEN_WIDTH, 1)];
        [shopItemView addSubview:bd];//
        bd.backgroundColor = BORDERCOLOR;
        
        int totallNums = 0;
        for (int i = 0; i < [[bookOrderInfo valueForKey:@"orderproductbean"] count]; i++) {
            int BuyNumber = [[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"BuyNumber"] intValue];
            int iSGive = 0;
//            if ([[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"iSGive"] intValue] != 0) {
//                iSGive = BuyNumber / ([[[[bookOrderInfo valueForKey:@"orderproductbean"] objectAtIndex:i] objectForKey:@"iSGive"] intValue]);
//            }
            totallNums += (BuyNumber + iSGive);
        }
        if (totallNums == 0) {
            //如果数量为0，那么可能是预定的商品，预定商品的数量字段为:BuyCount
            totallNums = [[bookOrderInfo objectForKey:@"BuyCount"] intValue];
        }
        UILabel *bottomView = [[UILabel alloc] initWithFrame:CGRectMake(0,viewY, 300, 30)];
        [shopItemView addSubview:bottomView];
        bottomView.tag = 6000;//------特殊tag-------
        bottomView.textAlignment = NSTextAlignmentRight;
        //shopWoodsCount----shopTotalPrice
        bottomView.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %0.2f",totallNums,[[bookOrderInfo objectForKey:@"ShouldPayPrice"] doubleValue]];
    }
}

//-----修改标题
-(NSString*)getTitle{
    return @"订单详情";
}

-(NSString *)setOrderStatusWithType:(int)type
{
    NSString *OrderStatusStr = @"";
    switch (type) {
        case 0:
            OrderStatusStr = @"待付款";
            break;
        case 1:
            OrderStatusStr = @"已付款";
            break;
        case 2:
            OrderStatusStr = @"待收货";
            break;
        case 3:
            OrderStatusStr = @"交易成功";
            break;
        case 4:
            OrderStatusStr = @"已取消";
            break;
        default:
            break;
    }
    return OrderStatusStr;
}

/*
//点击跳转到店铺
-(void)onClickGoShop:(id)sender{
    NSInteger index = [[sender view] tag] - 100;
    clickModle = [[DataModle alloc] init];
    clickModle.id = [[[[bookOrderInfo objectForKey:@"orderproductbean"] objectAtIndex:index] objectForKey:@"AgentID"] isEqualToString:@""]?CHUNKANGSHOPID:[[[bookOrderInfo objectForKey:@"orderproductbean"] objectAtIndex:index] objectForKey:@"AgentID"];
    clickModle.s = [[[bookOrderInfo objectForKey:@"orderproductbean"] objectAtIndex:index] objectForKey:@"ShopName"];
    if ([clickModle.id  isEqual: @""] || [clickModle.s  isEqual: @""]) {
        return;
    }
    DetailViewController *detailController = [[DetailViewController alloc] init];
    detailController.modle = clickModle;
    [self.navigationController pushViewController:detailController animated:YES];
    
}
*/

//浏览商品详情
- (void)gotoGoodsDetailGes:(id)sender
{
    NSInteger index = [[sender view] tag] - 500;
    NSDictionary *itemDic = [[bookOrderInfo objectForKey:@"orderproductbean"] objectAtIndex:index];
    NSString *guid = [itemDic objectForKey:@"Guid"];
    if (guid == nil) {
        guid = [bookOrderInfo objectForKey:@"ProductGuid"];
    }
    if ([guid isMemberOfClass:[NSNull class]] || guid == nil) {
        guid = @"";
    }
    GoodsDetailController *woodsDettail = [[GoodsDetailController alloc] initGoodsWithShopDict:nil];
    woodsDettail.danModleGuid = guid;
    woodsDettail.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:woodsDettail animated:YES];
}

//-----修改标题栏背景颜色
-(UIColor *)getTopNaviColor{
    return TOPNAVIBGCOLOR_G;
}

@end
