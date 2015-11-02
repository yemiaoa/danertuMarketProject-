//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//-----商品详细页----
#import "PayMMSingleton.h"
@interface PayMMSingleton(){
    NSUserDefaults *defaults;//本地存储
    UITextField *_userPwd ;
    void (^callback)(BOOL isRight);
    void (^callback_cancle)(BOOL isCancle);
}

@end

static PayMMSingleton *sharedObj = nil; //第一步：静态实例，并初始化。

@implementation PayMMSingleton
@synthesize alertV;
@synthesize maskV;
+ (PayMMSingleton*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        defaults =[NSUserDefaults standardUserDefaults];
        NSString *loginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
        if (loginId.length>2) {
            maskV = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
            maskV.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
            [maskV addGestureRecognizer:tapges];

            //-------弹出层-----
            alertV = [[UIView alloc] initWithFrame:CGRectMake(20, (maskV.frame.size.height-120)/2, 280, 120)];
            [maskV addSubview:alertV];
            alertV.backgroundColor = [UIColor whiteColor];
            alertV.layer.cornerRadius = 5;
            
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, alertV.frame.size.width, 30)];
            [alertV addSubview:titleLb];
            titleLb.text = @"支付密码";
            titleLb.backgroundColor = [UIColor clearColor];
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.textColor = [UIColor orangeColor];
            NSInteger borderGap = 5;
            
            UIView *borderLb = [[UIView alloc] initWithFrame:CGRectMake(borderGap, 40, alertV.frame.size.width-borderGap*2, 0.5)];
            [alertV addSubview:borderLb];
            borderLb.backgroundColor = BORDERCOLOR;
            
            //输入框
            _userPwd = [[UITextField alloc] initWithFrame:CGRectMake(borderGap, 45, alertV.frame.size.width-borderGap*2, 30)];
            _userPwd.delegate = self;
            [alertV addSubview:_userPwd];
            _userPwd.placeholder = @"请输入支付密码";
            _userPwd.secureTextEntry = YES;
            _userPwd.font = TEXTFONT;
            _userPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //    _userPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            //    _userPwd.borderStyle = UITextBorderStyleLine;
            _userPwd.layer.borderColor = VIEWBGCOLOR.CGColor;
            _userPwd.layer.borderWidth = 0.5;
            
            
            double btnWidth = (alertV.frame.size.width-borderGap*3)/2;
            NSArray *btnTitle = @[@"取消",@"确定"];
            for (int i=0; i<2; i++) {
                //按钮
                UIButton *addImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(borderGap*(i+1)+btnWidth*i, 80, btnWidth, 35)];
                [alertV addSubview:addImgBtn];
                addImgBtn.layer.cornerRadius = 3;
                addImgBtn.layer.borderColor = [UIColor grayColor].CGColor;
                addImgBtn.layer.borderWidth = 0.3;
                addImgBtn.tag = 100 + i;
                addImgBtn.titleLabel.font = TEXTFONT;
                [addImgBtn setTitle:btnTitle[i] forState:UIControlStateNormal];
                [addImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [addImgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted|UIControlStateSelected];
                [addImgBtn addTarget:self action:@selector(checkPayMMBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
        return self;
    }
}
-(void)showPayMMUi:(UIView *)parentView result:(void (^)(BOOL isRight))result cancle:(void (^)(BOOL isCancle))cancle{
    _userPwd.text = nil;
    [maskV setHidden:NO];
    [parentView addSubview:maskV];
    //block参数
    callback = result;
    callback_cancle = cancle;
}

-(void)hideKeyBoard{
    [_userPwd resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"begin");
    [UIView animateWithDuration:0.25 animations:^{
        [alertV setFrame:CGRectMake(20, MAINSCREEN_HEIGHT - 252 -120, 280, 120)];
    }];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    [UIView animateWithDuration:0.25 animations:^{
        [alertV setFrame:CGRectMake(20, (maskV.frame.size.height-120)/2 + 20, 280, 120)];
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
        [alertV setFrame:CGRectMake(20, (maskV.frame.size.height-120)/2 + 20, 280, 120)];
    }];
    [_userPwd resignFirstResponder];
    return YES;
}

-(void)checkPayMMBtn:(UIButton *)btn{
    NSInteger tag = [btn tag] - 100;
//    NSMutableArray *wrongTimesDicArr = [[defaults objectForKey:@"wrongPayMMTimes"] mutableCopy];
    if (tag==1) {
        NSString *payMM = _userPwd.text;
        if ([Crypto.MD5Encode([payMM dataUsingEncoding:NSUTF8StringEncoding]) isEqualToString:[self getPayMM]]) {
            [maskV setHidden:YES];
            /*
            //----输入正确,以往记录清零----
            if (wrongTimesDicArr.count>0) {
                for (NSDictionary *temp in wrongTimesDicArr) {
                    if ([[temp objectForKey:@"loginId"] isEqualToString:loginId]) {
                        [wrongTimesDicArr removeObject:temp];
                        [defaults setObject:wrongTimesDicArr forKey:@"wrongPayMMTimes"];
                        break;
                    }
                }
            }
             */
            callback(YES);
            NSLog(@"goprekgporepgekpoge");
        }else{
            callback(NO);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付密码不正确,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert setTag:1001];
            [alert show];
            /*
            NSString *wrongTimes ;//错误次
            NSString *firstTime;//第一次错误时间
            BOOL existRecord = NO;
            if (wrongTimesDicArr.count>0) {
                for (NSDictionary *temp in wrongTimesDicArr) {
                    if ([[temp objectForKey:@"loginId"] isEqualToString:loginId]) {
                        existRecord = YES;
                        wrongTimes = [temp objectForKey:@"times"] ;//错误次数
                        firstTime = [temp objectForKey:@"firstTime"];//第一次错误时
                        break;
                    }
                }
            }
            NSLog(@"hohgeughueigheui-----%@----%@",firstTime,wrongTimesDicArr);
            NSInteger times=0;
            if (existRecord) {
                if (wrongTimes) {
                    times = [wrongTimes intValue];
                    times++;
                    if (times==3) {
                        //输错3次密码,,,,清除登录状态,
                        [defaults removeObjectForKey:@"userLoginInfo"];
//                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }else{
                times = 1;
            }
            //----输错次数小于3-----
            if (times<3) {
                //----第一次出错,,wrongPayMMTimes没记录,,,,,firstTime当然没有值----
                if (!firstTime) {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyyMMddHHmm"];
                    firstTime = [dateFormat stringFromDate:[[NSDate alloc] init]];
                }
                NSLog(@"jgoreijgoeijgoie-----%d,%@,%@",times,loginId,firstTime);
                NSDictionary *wrongTimesDicItem = @{@"times":[NSString stringWithFormat:@"%d",times],@"loginId":loginId,@"firstTime":firstTime};
                if (!wrongTimesDicArr) {
                    wrongTimesDicArr = [[NSMutableArray alloc] init];
                }
                [wrongTimesDicArr addObject:wrongTimesDicItem];
                [defaults setObject:wrongTimesDicArr forKey:@"wrongPayMMTimes"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"支付密码不正确,你还可以输入%d次.超出错误次数将自动退出账户",3-times] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert setTag:1001];
                [alert show];
            }
            */
        }
    }else{
        //-----取消支付----
        callback_cancle(YES);
        //-----取消-----,这是隐藏-----
        [maskV setHidden:YES];
    }
}

//获取支付密码
-(NSString *)getPayMM{
    NSURL *url = [NSURL URLWithString:APIURL];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *loginId = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接是否正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    return result;
}

@end
