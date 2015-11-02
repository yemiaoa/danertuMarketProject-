//
//  HeGetCashVC.m
//  单耳兔
//
//  Created by Tony on 15/8/18.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//  提取现金

#import "HeGetCashVC.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "WebViewController.h"

@interface HeGetCashVC ()
{
    UITextField *sumNumbers;
    NSInteger currentClickTag;
    NSMutableDictionary *accountInfoDict;
    NSDictionary *keysTagDict;
}
@end

@implementation HeGetCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialization];
    [self loadData];
}

- (void)initialization
{
    self.view.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = YES;
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight] + TOPNAVIHEIGHT;
    accountInfoDict = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)loadData
{
    [Waiting show];
    NSString *memloginid = [Tools getUserLoginNumber];
    NSString *apiid = @"0150";
    NSDictionary *params = @{@"apiid":apiid,@"memloginid":memloginid};
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSDictionary *dict = [respondStr objectFromJSONString];
        NSString *bankCarkInfo = [dict objectForKey:@"WW"];
        NSString *alipayInfo = [dict objectForKey:@"CK_ZhiFuBaoNumber"];
        
        bankCarkInfo = [bankCarkInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        alipayInfo = [alipayInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (!([bankCarkInfo isMemberOfClass:[NSNull class]] || bankCarkInfo == nil || [bankCarkInfo isEqualToString:@""])) {
            [accountInfoDict setObject:bankCarkInfo forKey:@"bankCard"];
        }
        if (!([alipayInfo isMemberOfClass:[NSNull class]] || alipayInfo == nil || [alipayInfo isEqualToString:@""])) {
            [accountInfoDict setObject:alipayInfo forKey:@"alipay"];
        }
        if ([[accountInfoDict allValues] count] == 0) {
            [self showHint:@"你尚未绑定支付宝银行卡"];
        }
        else{
            [self initView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Waiting dismiss];
        [self showHint:REQUESTERRORTIP];
    }];
}

- (void)initView
{
    currentClickTag = 0;
    //银行卡,支付宝账号信息
    //根据账号信息的类别,来添加图标和对应的名称
    NSArray *imgArr = @[@"icon_card",@"icon_alipay"];
    NSArray *tipArr = @[@"银行卡",@"支付宝"];
    NSArray *keys = @[@"bankCard",@"alipay"];
    keysTagDict = @{@"bankCard":@"0",@"alipay":@"1"};
    
    NSDictionary *imgDict = [[NSDictionary alloc] initWithObjects:imgArr forKeys:keys];
    NSDictionary *tipDict = [[NSDictionary alloc] initWithObjects:tipArr forKeys:keys];
    NSArray *keyArray = accountInfoDict.allKeys;
    
    int itemHeight  = 60;
    
    UIView *accountBgView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight, MAINSCREEN_WIDTH, 30+itemHeight*imgArr.count)];
    accountBgView.tag = 100;
    [self.view addSubview:accountBgView];
    [accountBgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *accountL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    [accountBgView addSubview:accountL];
    accountL.text = @"存入账户";
    accountL.font = TEXTFONT;
    accountL.textColor = [UIColor grayColor];
    
    for (int i = 0; i < [keyArray count]; i++) {
        NSString *key = keyArray[i];
        
        NSString *tagStr = [keysTagDict objectForKey:key];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 30+itemHeight*i, MAINSCREEN_WIDTH, itemHeight)];
        [accountBgView addSubview:item];
        item.userInteractionEnabled = YES;
        item.tag = 200 + [tagStr integerValue];
        
        if (i == 0) {
            //默认选中第一个
            currentClickTag = [tagStr integerValue];
        }
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPayType:)];
        [item addGestureRecognizer:singleTap];//添加点击事件
        
        UIImageView *clickImg = [[UIImageView alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH-30, 20, 20, 20)];
        clickImg.tag = 300 + [tagStr integerValue];
        [item addSubview:clickImg];
        
        if (i == 0) {
            [clickImg setImage:[UIImage imageNamed:@"click"]];
        }
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 30, 30)];
        [item addSubview:img];
        img.image = [UIImage imageNamed:[imgDict objectForKey:key]];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 200, 20)];
        [item addSubview:tip];
        tip.text = [tipDict objectForKey:key];
        tip.font = TEXTFONT;
        
        UILabel *tipText = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, 200, 20)];
        [item addSubview:tipText];
        tipText.text = [accountInfoDict objectForKey:key];
        tipText.font = TEXTFONT;
        tipText.textColor = [UIColor grayColor];
        
        if (imgArr.count > 1 && i == 0) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, MAINSCREEN_WIDTH, 0.7)];
            [item addSubview:line];
            [line setBackgroundColor:BORDERCOLOR];
        }
    }
    
    //金额
    UIView *sumBgView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+50+itemHeight*keyArray.count, MAINSCREEN_WIDTH, 50)];
    [self.view addSubview:sumBgView];
    [sumBgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *sumL = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 40, 20)];
    [sumBgView addSubview:sumL];
    sumL.text = @"金额:";
    sumL.font = TEXTFONT;
    
    sumNumbers = [[UITextField alloc] initWithFrame:CGRectMake(50, 15, 250, 20)];//高度--44
    [sumBgView addSubview:sumNumbers];
    sumNumbers.delegate = self;
    sumNumbers.placeholder = @"请输入提现金额";
    sumNumbers.font = TEXTFONT;
    sumNumbers.keyboardType = UIKeyboardTypeNumberPad;
    sumNumbers.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;;
    sumNumbers.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, addStatusBarHeight+250, MAINSCREEN_WIDTH-60, 40)];
    [self.view addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    loginBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:101/255.0 blue:31/255.0 alpha:1.0];
    [loginBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(saveResult) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *TipL = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight+310, 300, 20)];
    [self.view addSubview:TipL];
    TipL.backgroundColor = [UIColor clearColor];
    TipL.text            = @"预计2小时内到账";
    TipL.font            = TEXTFONTSMALL;
    TipL.textColor       = [UIColor grayColor];
    TipL.textAlignment   = NSTextAlignmentCenter;
    
}

-(void)selectPayType:(id)sender{
    
    UIView *selectView = [sender view];
    NSInteger tag = [selectView tag] - 200.;
    if (currentClickTag == tag) {
        return;
    }
    UIView *accountBgView = [self.view viewWithTag:100];
    //取消选中的选项
    UIImageView *clickedImg = (UIImageView *)[[accountBgView viewWithTag:currentClickTag + 200] viewWithTag:currentClickTag + 300];
    [clickedImg setImage:[UIImage imageNamed:@""]];
    
    currentClickTag = tag;
    
    //选中点击的选项
    UIImageView *clickImg = (UIImageView *)[[accountBgView viewWithTag:currentClickTag + 200] viewWithTag:currentClickTag + 300];
    [clickImg setImage:[UIImage imageNamed:@"click"]];
}

//确定
- (void)saveResult
{
    NSString *moneyStr = sumNumbers.text;
    float money = [moneyStr floatValue];
    if (money <= 0) {
        [self showHint:@"请输入转账金额"];
        return;
    }
    if (money <= 0.01) {
        [self showHint:@"请输入正确的转账金额"];
        return;
    }
    NSString *sumMoney = [NSString stringWithFormat:@"%.2f",money];
    NSString *type = @"0";
    if (currentClickTag == 1) {
        type = @"1";
    }
    [[PayMMSingleton sharedInstance] showPayMMUi:self.view result:^(BOOL isRight){
        if (isRight) {
            NSArray *params = @[sumMoney,@"",type];
            [self parameter_withdraw:params];
        }
    } cancle:^(BOOL isCancle){
    }];
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getTitle
{
    return @"提现";
}

//重写父类方法
-(void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)parameter_withdraw:(NSArray *) inputArray{
    if (inputArray.count>1) {
        NSString *chargeMoney = @"";//----提现金额----
        NSString *payPwd = @"";
        NSString *type = @"";
        @try {
            chargeMoney = [inputArray firstObject];//----提现金额----
            payPwd = [inputArray objectAtIndex:1];
            type = inputArray[2];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        if (chargeMoney == nil) {
            chargeMoney = @"";
        }
        if (payPwd == nil) {
            payPwd = @"";
        }
        if (type == nil) {
            type = @"";
        }
        NSString *loginId = [Tools getUserLoginNumber];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        payPwd = Crypto.MD5Encode([payPwd dataUsingEncoding:NSUTF8StringEncoding]);
        BOOL passwordCorrect = YES;
        //支付密码前面已经验证[payPwd isEqualToString:[self getPayMM]]
        if (passwordCorrect) {
            [Waiting show];
            //先判断可提现的余额是否足够
            NSDictionary * params = @{@"apiid": @"0224",@"memloginid" : loginId};
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params];
            AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([result doubleValue]>=[chargeMoney doubleValue]) {
                    NSString *key = [NSString stringWithCString:"abcdef1234567890" encoding:NSUTF8StringEncoding];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyyMMddHHmm"];
//                    NSString *theDate = [dateFormat stringFromDate:[[NSDate alloc] init]];
//                    NSString *RechargeCode = [NSString stringWithFormat:@"%@%d",theDate,arc4random()/1000];
                    //----版本号-----
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                    NSString *remark = [NSString stringWithFormat:@"Ios(%@)提现",appVersion];
                    NSString *sourcePostStr = [NSString stringWithFormat:@"%@|%@|%@|0",loginId,chargeMoney,remark];
                    NSString *encryptPostStr = [AES128Util AES128Encrypt:sourcePostStr key:key];
                    [Waiting show];
                    NSDictionary * params = @{@"apiid": @"0105",@"strDetinfo" : encryptPostStr};
                    NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
                    AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [Waiting dismiss];//隐藏loading
                        
                        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
                            [self showHint:@"提现成功"];
                            [self.getCashDelegate getCashSucceed];
                            [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.0];
                            
                        }else{
                            [self.view makeToast:[resultDic objectForKey:@"info"] duration:1.2 position:@"center"];
                        }
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
                        [Waiting dismiss];//隐藏loading
                    }];
                    [operation start];
                }else{
                    [self.view makeToast:@"余额不足" duration:1.2 position:@"center"];
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
                [Waiting dismiss];//隐藏loading
            }];
            [operation start];
        }else{
            [self showHint:@"支付密码错误"];
        }
    }else{
        [self showHint:@"数据出错"];
    }
}

#pragma mark - method 获取支付密码
-(NSString *)getPayMM{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSString *loginId = [Tools getUserLoginNumber];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"apiid=0111&memloginid=%@",loginId];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSString *result;
    if (![requestOperation error]) {
        result = requestOperation.responseString;
    }else{
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
    }
    return result;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
