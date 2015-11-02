//
//  SellOrderDetailViewController.m
//  单耳兔
//
//  Created by yang on 15/7/1.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//
//卖家中心->订单详情

#import "SellOrderDetailViewController.h"
#import "Waiting.h"
#import "UIView+Toast.h"
#import "AFHTTPRequestOperation.h"
#import "AsynImageView.h"

@interface SellOrderDetailViewController ()
{
    int addStatusBarHeight;
    int currentOrderState;//待付款,0,待发货,1,退款中,2
    UIWindow *_window;
    UITextField *expressageText;
    UITextField *expCompanyText;
    UILabel *mobileLb;
    UILabel *buyerMesLb;
    UILabel *reasonTextLabel;
    UILabel *instructionTextLabel;
    float totalMoney;
    int totalWoodsNum;
}
@end

@implementation SellOrderDetailViewController
@synthesize sellOrderDic;
@synthesize currentOrderStype;
- (void)viewDidLoad {
    
    //当前订单状态
    currentOrderState = currentOrderStype;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self loadData];
}

-(NSString*)getTitle{
    return @"订单详情";
}

-(BOOL)isShowFinishButton{
    BOOL isShowBt = (currentOrderState == 1) ? YES : NO;
    return isShowBt;
}

//完成按钮标题
-(NSString*)getFinishBtnTitle{
    return @"发货";
}
//发货
-(void) clickFinish{
    [_window setHidden:NO];
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    self.view.backgroundColor = VIEWBGCOLOR;
    
    totalMoney = 0;
    totalWoodsNum = 0;
    
    NSArray *orderStateArr = @[@"待付款",@"待发货",@"退款中",@"已退款",@"已取消",@"未确认",@"已完成"];
    
    int itemsCount  = [[sellOrderDic valueForKey:@"productList"] count] > 1 ? (int)[[sellOrderDic valueForKey:@"productList"] count] : 1; //目前数据有问题 暂时定为1
    int itemsHeight = 80 * itemsCount;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - addStatusBarHeight - TOPNAVIHEIGHT)];//上半部分
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, itemsHeight + 180 + 60);
    [self.view addSubview:scrollView];
    
    //地址相关信息
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 150)];
    addressView.backgroundColor = [UIColor colorWithRed:230.0/255 green:160.0/255 blue:22.0/255 alpha:1];
    [scrollView addSubview:addressView];
    
    UIButton *dealBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 10, 80, 25)];
    [addressView addSubview:dealBtn];
    [dealBtn.layer setMasksToBounds:YES];
    [dealBtn.layer setCornerRadius:2];
    dealBtn.titleLabel.font = TEXTFONT;
    dealBtn.backgroundColor = [UIColor whiteColor];
    [dealBtn setTitle:@"处理退款" forState:UIControlStateNormal];
    [dealBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [dealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [dealBtn addTarget:self action:@selector(showDealBtnAciton) forControlEvents:UIControlEventTouchUpInside];
    [dealBtn setHidden:YES];
    if (currentOrderState == 2) [dealBtn setHidden:NO];
    
    UILabel *stateTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    [addressView addSubview:stateTip];
    [stateTip setBackgroundColor:[UIColor clearColor]];
    [stateTip setText:@"状态:"];
    [stateTip setFont:[UIFont systemFontOfSize:16]];
    
    UILabel *stateTipText = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
    [addressView addSubview:stateTipText];
    [stateTipText setBackgroundColor:[UIColor clearColor]];
    [stateTipText setText:[NSString stringWithFormat:@"%@",[orderStateArr objectAtIndex:currentOrderState]]];
    [stateTipText setFont:[UIFont systemFontOfSize:16]];
    [stateTipText setTextColor:[UIColor redColor]];
    
    UILabel *userNameLb        = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 170, 30)];
    [addressView addSubview:userNameLb];
    userNameLb.textColor       = [UIColor whiteColor];
    [userNameLb setBackgroundColor:[UIColor clearColor]];
    userNameLb.text            = [NSString stringWithFormat:@"收货人:  %@",[sellOrderDic valueForKey:@"Name"]];
    //电话
    mobileLb          = [[UILabel alloc] initWithFrame:CGRectMake(210, 40, 98, 30)];
    [addressView addSubview:mobileLb];
    [mobileLb setBackgroundColor:[UIColor clearColor]];
    mobileLb.font              = TEXTFONT;
    mobileLb.textColor         = [UIColor whiteColor];
    
    //地址图标
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 20, 27)];
    [addressView addSubview:locationImg];
    [locationImg setImage:[UIImage imageNamed:@"addressLocation"]];
    
    //地址
    UILabel *adrLb      = [[UILabel alloc] initWithFrame:CGRectMake(38, 74, 270, 40)];
    [addressView addSubview:adrLb];
    adrLb.font          = TEXTFONT;
    [adrLb setBackgroundColor:[UIColor clearColor]];
    adrLb.textColor         = [UIColor whiteColor];
    adrLb.numberOfLines = 2;
    adrLb.text          = [NSString stringWithFormat:@"%@",[sellOrderDic valueForKey:@"Address"]];
    
    //买家留言
    buyerMesLb          = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 200, 30)];
    [addressView addSubview:buyerMesLb];
    [buyerMesLb setBackgroundColor:[UIColor clearColor]];
    buyerMesLb.font              = TEXTFONT;
    buyerMesLb.textColor         = [UIColor whiteColor];
    
    UIView *woodsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, MAINSCREEN_WIDTH, 30)];
    [scrollView addSubview:woodsBgView];
    [woodsBgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *woodsTipLb          = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    [woodsBgView addSubview:woodsTipLb];
    [woodsTipLb setBackgroundColor:[UIColor clearColor]];
    woodsTipLb.font              = TEXTFONT;
    woodsTipLb.text              = @"商品信息";
    
    UIView *woodItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, MAINSCREEN_WIDTH, itemsHeight)];
    [scrollView addSubview:woodItemsView];
    [woodItemsView setBackgroundColor:[UIColor whiteColor]];
    
    for (int i = 0; i < itemsCount; i++) {
        
//        NSDictionary *tempDic;
//        if (itemsCount > 1) {
//            [NSDictionary dictionaryWithDictionary:[[sellOrderDic valueForKey:@"productList"] objectAtIndex:i]];
//        }else{
//            [NSDictionary dictionaryWithDictionary:[[sellOrderDic valueForKey:@"productList"] objectAtIndex:i]];
//        }
        
         NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:[[sellOrderDic valueForKey:@"productList"] objectAtIndex:i]];
        
        AsynImageView *woodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 12 + i * 80, 55, 55)];
        [woodItemsView addSubview:woodImage];
    
        NSString *imageUrl = [NSString stringWithFormat:@"%@",[Tools getGoodsImageUrlWithData:tempDic]];
        if ([[tempDic valueForKey:@"SmallImage"] isEqualToString:@""]) {
            woodImage.image         = [UIImage imageNamed:@"noData1"];
        }else{
            woodImage.placeholderImage = [UIImage imageNamed:@"noData1"];
            woodImage.imageURL         = imageUrl;
        }
        
        UILabel *nameTip = [[UILabel alloc] initWithFrame:CGRectMake(75, 8 + i * 80, 50, 20)];
        [woodItemsView addSubview:nameTip];
        [nameTip setText:@"名称:"];
        [nameTip setFont:TEXTFONT];
        [nameTip setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *nameTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 8 + i * 80, 190, 20)];
        [woodItemsView addSubview:nameTextLabel];
        [nameTextLabel setFont:TEXTFONT];
        [nameTextLabel setTextAlignment:NSTextAlignmentLeft];
        [nameTextLabel setText:[tempDic valueForKey:@"productName"]];
        
        UILabel *countTip = [[UILabel alloc] initWithFrame:CGRectMake(75, 28 + i * 80, 50, 20)];
        [woodItemsView addSubview:countTip];
        [countTip setText:@"数量:"];
        [countTip setFont:TEXTFONT];
        [countTip setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *countTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 28 + i * 80, 150, 20)];
        [woodItemsView addSubview:countTextLabel];
        [countTextLabel setFont:TEXTFONT];
        [countTextLabel setTextAlignment:NSTextAlignmentLeft];
        [countTextLabel setText:[tempDic valueForKey:@"BuyNumber"]];
        
        totalWoodsNum = totalWoodsNum + [[tempDic valueForKey:@"BuyNumber"] intValue];
        
        UILabel *priceTip = [[UILabel alloc] initWithFrame:CGRectMake(75, 48 + i * 80, 50, 20)];
        [woodItemsView addSubview:priceTip];
        [priceTip setText:@"价格:"];
        [priceTip setFont:TEXTFONT];
        [priceTip setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *priceTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 48 + i * 80, 150, 20)];
        [woodItemsView addSubview:priceTextLabel];
        [priceTextLabel setFont:TEXTFONT];
        [priceTextLabel setTextAlignment:NSTextAlignmentLeft];
        [priceTextLabel setTextColor:[UIColor redColor]];
        [priceTextLabel setText:[NSString stringWithFormat:@"￥%@",[tempDic valueForKey:@"BuyPrice"]]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79 + i * 80, MAINSCREEN_WIDTH, 0.6)];
        [woodItemsView addSubview:lineView];
        [lineView setBackgroundColor:BORDERCOLOR];
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 190 + itemsHeight, MAINSCREEN_WIDTH, 40)];
    [scrollView addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    totalMoney = [[sellOrderDic valueForKey:@"ShouldPayPrice"] floatValue];
    
    UILabel *bottomLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH-10, 40)];
    [bottomView addSubview:bottomLb];
    bottomLb.textAlignment = NSTextAlignmentRight;
    bottomLb.text = [NSString stringWithFormat:@"共%d件商品  合计: ¥ %0.2f",totalWoodsNum,totalMoney];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    [_window makeKeyAndVisible];
    //白色背景
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, MAINSCREEN_WIDTH-40, 160)];
    [_window addSubview:view];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:5.0];
    //关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-35, 85, 30, 30)];
    [_window addSubview:closeBt];
    [closeBt setBackgroundImage:[UIImage imageNamed:@"sell_close"] forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(onClickCloseView) forControlEvents:UIControlEventTouchUpInside];
    //默认隐藏
    [_window setHidden:YES];
    //发货弹出框
    if (currentOrderState == 1){
        [view setFrame:CGRectMake(20, 100, MAINSCREEN_WIDTH-40, 280)];
        
        UILabel *wayTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 80, 20)];
        [view addSubview:wayTip];
        [wayTip setText:@"发货方式:"];
        [wayTip setFont:[UIFont systemFontOfSize:16]];
        [wayTip setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *wayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 160, 20)];
        [view addSubview:wayTextLabel];
        [wayTextLabel setFont:[UIFont systemFontOfSize:16]];
        [wayTextLabel setTextAlignment:NSTextAlignmentLeft];
        [wayTextLabel setText:[NSString stringWithFormat:@"%@",@"快递"]];
        
        UILabel *expressageTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 80, 20)];
        [view addSubview:expressageTip];
        [expressageTip setText:@"快递单号:"];
        [expressageTip setFont:[UIFont systemFontOfSize:16]];
        [expressageTip setTextAlignment:NSTextAlignmentLeft];
        
        expressageText = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 240, 30)];
        [view addSubview:expressageText];
        [expressageText setBorderStyle:UITextBorderStyleRoundedRect];
        [expressageText setFont:[UIFont systemFontOfSize:16]];
        [expressageText setPlaceholder:@"请输入快递单号"];
        [expressageText setKeyboardType:UIKeyboardTypeASCIICapable];
        [expressageText setClearButtonMode:UITextFieldViewModeWhileEditing];
        [expressageText setTag:1];
        expressageText.delegate = self;
        
        UILabel *expCompanyTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 80, 20)];
        [view addSubview:expCompanyTip];
        [expCompanyTip setText:@"快递公司:"];
        [expCompanyTip setFont:[UIFont systemFontOfSize:16]];
        [expCompanyTip setTextAlignment:NSTextAlignmentLeft];
        
        expCompanyText = [[UITextField alloc] initWithFrame:CGRectMake(20, 165, 240, 30)];
        [view addSubview:expCompanyText];
        [expCompanyText setBorderStyle:UITextBorderStyleRoundedRect];
        [expCompanyText setFont:[UIFont systemFontOfSize:16]];
        [expCompanyText setPlaceholder:@"请输入快递公司名称"];
        [expCompanyText setKeyboardType:UIKeyboardTypeNamePhonePad];
        [expCompanyText setClearButtonMode:UITextFieldViewModeWhileEditing];
        [expCompanyText setTag:2];
        expCompanyText.delegate = self;
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 230, 100, 30)];
        [view addSubview:agreeBtn];
        [agreeBtn.layer setMasksToBounds:YES];
        [agreeBtn.layer setCornerRadius:3];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        agreeBtn.backgroundColor = [UIColor redColor];
        [agreeBtn setTitle:@"确定发货" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(goToConsignment) forControlEvents:UIControlEventTouchUpInside];
        
        //点击空白处关闭键盘
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [_window addGestureRecognizer:tapGes];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
    //退款处理弹出框
    if (currentOrderState == 2) {
        UILabel *reasonTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 80, 20)];
        [view addSubview:reasonTip];
        [reasonTip setText:@"退款原因:"];
        [reasonTip setFont:[UIFont systemFontOfSize:16]];
        [reasonTip setTextAlignment:NSTextAlignmentLeft];
        
        reasonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 160, 20)];
        [view addSubview:reasonTextLabel];
        [reasonTextLabel setFont:[UIFont systemFontOfSize:16]];
        [reasonTextLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *instructionTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 20)];
        [view addSubview:instructionTip];
        [instructionTip setText:@"退款说明:"];
        [instructionTip setFont:[UIFont systemFontOfSize:16]];
        [instructionTip setTextAlignment:NSTextAlignmentLeft];
        
        instructionTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 160, 20)];
        [view addSubview:instructionTextLabel];
        [instructionTextLabel setFont:[UIFont systemFontOfSize:16]];
        [instructionTextLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *numberTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 20)];
        [view addSubview:numberTip];
        [numberTip setText:@"退款金额:"];
        [numberTip setFont:[UIFont systemFontOfSize:16]];
        [numberTip setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *numberTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, 160, 20)];
        [view addSubview:numberTextLabel];
        [numberTextLabel setFont:[UIFont systemFontOfSize:16]];
        [numberTextLabel setTextAlignment:NSTextAlignmentLeft];
        [numberTextLabel setTextColor:[UIColor redColor]];
        [numberTextLabel setText:[NSString stringWithFormat:@"%0.2f",totalMoney]];
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 110, 100, 30)];
        [view addSubview:agreeBtn];
        [agreeBtn.layer setMasksToBounds:YES];
        [agreeBtn.layer setCornerRadius:3];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        agreeBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
        [agreeBtn setTitle:@"同意退款" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(showAgreeBtnAciton) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 110, 100, 30)];
        [view addSubview:refuseBtn];
        [refuseBtn.layer setMasksToBounds:YES];
        [refuseBtn.layer setCornerRadius:3];
        refuseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        refuseBtn.backgroundColor = [UIColor redColor];
        [refuseBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
        [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refuseBtn addTarget:self action:@selector(showRefuseBtnAciton) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)loadData{
    
    [Waiting show];
    
    NSDictionary * params  = @{@"apiid": @"0036",
                               @"ordernumber" : [sellOrderDic valueForKey:@"OrderNumber"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        if ([[[tempDic valueForKey:@"orderinfolist"] valueForKey:@"orderinfobean"] count] > 0) {
            
            //电话
            [mobileLb setText:[[[[tempDic valueForKey:@"orderinfolist"] valueForKey:@"orderinfobean"] objectAtIndex:0] valueForKey:@"Mobile"]];
            //留言
            if ([[[[[tempDic valueForKey:@"orderinfolist"] valueForKey:@"orderinfobean"] objectAtIndex:0] valueForKey:@"ClientToSellerMsg"] isEqualToString:@""]) {
                [buyerMesLb setText:@"买家留言: --"];
            }else{
                [buyerMesLb setText:[NSString stringWithFormat:@"买家留言:%@",[[[[tempDic valueForKey:@"orderinfolist"] valueForKey:@"orderinfobean"] objectAtIndex:0] valueForKey:@"ClientToSellerMsg"]]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

//关闭键盘
-(void)closeKeyboard{
    if ([expressageText isFirstResponder]) {
        [expressageText resignFirstResponder];
    }else if ([expCompanyText isFirstResponder]){
        [expCompanyText resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [_window setFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    }];
}

//发货
-(void)goToConsignment{
    NSLog(@"发货");
    if ([expressageText.text length] == 0 || [[expCompanyText text] length] == 0) {
        [self showHint:@"请输入正确订单信息"];
        return;
    }
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0234",@"orderNumber" : [sellOrderDic valueForKey:@"OrderNumber"],@"DispatchModeName" : expCompanyText.text,@"ShipmentNumber" : expressageText.text};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSDictionary *dataDic = [respondStr objectFromJSONString];
        
        if ([[dataDic valueForKey:@"result"] isEqualToString:@"true"]){
            [self onClickCloseView]; //关闭提示框
            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.0];
            [self.view makeToast:@"已成功发货" duration:1.0 position:@"center"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShopOrderListNotification" object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}
//关闭
-(void)onClickCloseView{
    if (currentOrderState == 1) {
        //关闭键盘
        [self closeKeyboard];
    }
    [_window setHidden:YES];
}

//同意退款
-(void)showAgreeBtnAciton{
    NSLog(@"同意退款");
    
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0235",@"OrderNumber" : [sellOrderDic valueForKey:@"OrderNumber"],@"memloginid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSDictionary *dataDic = [respondStr objectFromJSONString];
        
        if ([[dataDic valueForKey:@"result"] isEqualToString:@"true"]){
            [self onClickCloseView]; //关闭提示框
            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.0];
            [self.view makeToast:@"已成功退款" duration:1.0 position:@"center"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShopOrderListNotification" object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
    
}
//拒绝退款
-(void)showRefuseBtnAciton{
    NSLog(@"拒绝退款");
    [self onClickCloseView]; //关闭提示框
    [self showHint:@"此功能暂未开放,请期待"];

}
//获取退款信息
-(void)showDealBtnAciton{
    if (currentOrderState == 2) {
        // 请求退款信息
        [Waiting show];
        NSDictionary * params  = @{@"apiid": @"0240",@"ordernumber" : [sellOrderDic valueForKey:@"OrderNumber"]};
        NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:params];
        AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            [_window setHidden:NO];
            NSString *respondStr = operation.responseString;
            NSDictionary *tempDic = [respondStr objectFromJSONString];
            if ([[tempDic valueForKey:@"val"] count] > 0) {
                [reasonTextLabel setText:[[[tempDic valueForKey:@"val"] objectAtIndex:0] valueForKey:@"reason"]];
                [instructionTextLabel setText:[[[tempDic valueForKey:@"val"] objectAtIndex:0] valueForKey:@"remark"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        
        [operation start];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
    CGFloat moveHeight = -80;
    if (result.height <= 960.0f){
        //iPhone 4,4S iPhone 1,3,3GS
        moveHeight = -150;
    }
    
    switch (textField.tag) {
        case 1:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [_window setFrame:CGRectMake(0, moveHeight, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
                }];
            }
            break;
        case 2:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [_window setFrame:CGRectMake(0, moveHeight-30, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
                }];
            }
            break;
        default:
            break;
    }
}

//键盘关闭时触发
-(void)keyboardWillHide{
    [UIView animateWithDuration:0.5 animations:^{
        [_window setFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
