//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

//-----商品详细页----


#import "FindPwdController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface FindPwdController (){
    UIImageView *confirmImage;
    UIImageView *verifyImage;
    UIImageView *resetImage;
}
@end

@implementation FindPwdController
@synthesize defaults;
@synthesize scrollView;
@synthesize addStatusBarHeight;

@synthesize userName;
@synthesize verifyCode;
@synthesize resetPwd;
@synthesize resetPwdAgain;

@synthesize verifyView;
@synthesize resetView;
@synthesize finishView;

@synthesize confirmLb;
@synthesize verifyLb;
@synthesize resetLb;

@synthesize telNoLb;

@synthesize backBtn;
@synthesize nextStep;
@synthesize verifyCodeBtn;
@synthesize currentStep;
@synthesize timerNumber;
@synthesize codeTimer;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}
//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"找回密码";
}

-(void)onClickBack
{
    //--停止timer--
    if (timerNumber != 0) {
        [codeTimer invalidate];
    }
    [verifyView removeFromSuperview];
    [resetView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    
    //----------页面表单
    scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height)];//上半部分
    scrollView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:scrollView];
    
    //登陆表单
    UIView *contentArea = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MAINSCREEN_WIDTH, 200)];//高度--134
    [scrollView addSubview:contentArea];
    contentArea.userInteractionEnabled = YES;//才可以点击它上面的textfield,
    contentArea.backgroundColor = [UIColor clearColor];
    
    //----标题显示完成步骤----
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 40)];
    [contentArea addSubview:infoView];
    
    confirmLb                 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    [infoView addSubview:confirmLb];
    confirmLb.font            = [UIFont fontWithName:@"Helvetica" size:13];
    confirmLb.textColor       = [UIColor grayColor];
    confirmLb.backgroundColor = [UIColor clearColor];
    confirmLb.textAlignment   = NSTextAlignmentCenter;
    confirmLb.text            = @"1.验证手机号码";
    confirmLb.textColor       = [UIColor colorWithRed:190.0/255 green:0.0 blue:7.0/255 alpha:1.0];//进行中步骤的  颜色标示
    
    confirmImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 21, 105, 10)];
    [infoView addSubview:confirmImage];
    [confirmImage setBackgroundColor:[UIColor clearColor]];
    [confirmImage setImage:[UIImage imageNamed:@"step_on"]];
    
    verifyLb                  = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 40)];
    [infoView addSubview:verifyLb];
    verifyLb.font             = [UIFont fontWithName:@"Helvetica" size:13];
    verifyLb.backgroundColor  = [UIColor clearColor];
    verifyLb.textColor        = [UIColor grayColor];
    verifyLb.textAlignment    = NSTextAlignmentCenter;
    verifyLb.text             = @"2.重置登录密码";
    
    verifyImage = [[UIImageView alloc] initWithFrame:CGRectMake(115, 21, 105, 10)];
    [infoView addSubview:verifyImage];
    [verifyImage setBackgroundColor:[UIColor clearColor]];
    [verifyImage setImage:[UIImage imageNamed:@"step_off"]];
    
    resetLb                   = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 90, 40)];
    [infoView addSubview:resetLb];
    resetLb.font              = [UIFont fontWithName:@"Helvetica" size:13];
    resetLb.textColor         = [UIColor grayColor];
    resetLb.backgroundColor   = [UIColor clearColor];
    resetLb.textAlignment     = NSTextAlignmentCenter;
    resetLb.text              = @"3.完成";
    
    resetImage = [[UIImageView alloc] initWithFrame:CGRectMake(230, 21, 80, 10)];
    [infoView addSubview:resetImage];
    [resetImage setBackgroundColor:[UIColor clearColor]];
    [resetImage setImage:[UIImage imageNamed:@"step_off"]];
    
    //--------------------安全验证view----
    verifyView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MAINSCREEN_WIDTH, 80)];
    [contentArea addSubview:verifyView];
    verifyView.userInteractionEnabled = YES;
    
    //----手机号
    telNoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 40)];
    [verifyView addSubview:telNoLb];
    [telNoLb setText:@"手机号码:"];
    [telNoLb setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(90, 4, 140, 40)];
    [verifyView addSubview:userName];
    userName.placeholder = @"请输入手机号码";
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //----获取验证码按钮
    verifyCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 2, 80, 36)];
    [verifyView addSubview:verifyCodeBtn];
    [verifyCodeBtn.layer setMasksToBounds:YES];
    [verifyCodeBtn.layer setCornerRadius:3];//设置矩形四个圆角半径
    verifyCodeBtn.backgroundColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
    verifyCodeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [verifyCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [verifyCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *verifyCodeNoLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 80, 40)];
    [verifyView addSubview:verifyCodeNoLb];
    [verifyCodeNoLb setText:@"验证码:"];
    [verifyCodeNoLb setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    
    verifyCode = [[UITextField alloc] initWithFrame:CGRectMake(90, 54, 200, 40)];
    [verifyView addSubview:verifyCode];
    verifyCode.placeholder = @"请输入验证码(30分内有效)";
    verifyCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    verifyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //-----边线
    UILabel *border1_v = [[UILabel alloc] initWithFrame:CGRectMake(10, 49, MAINSCREEN_WIDTH-20, 1)];
    [verifyView addSubview:border1_v];
    border1_v.backgroundColor = VIEWBGCOLOR;
    UILabel *border2_v = [[UILabel alloc] initWithFrame:CGRectMake(10, 99, MAINSCREEN_WIDTH-20, 1)];
    [verifyView addSubview:border2_v];
    border2_v.backgroundColor = VIEWBGCOLOR;
    
    //--------------------安全验证view----
    resetView = [[UIView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH, 50, MAINSCREEN_WIDTH, 80)];
    [contentArea addSubview:resetView];
    resetView.userInteractionEnabled = YES;
    
    UILabel *pwdLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 40)];
    [resetView addSubview:pwdLb];
    pwdLb.text = @"新密码:";
    pwdLb.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    resetPwd = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 40)];
    [resetView addSubview:resetPwd];
    resetPwd.font = [UIFont fontWithName:@"Helvetica" size:14];
    resetPwd.placeholder = @"请设置6-15位数字或字母";
    resetPwd.secureTextEntry = YES;
    resetPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    resetPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *pwdAgainLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 100, 40)];
    [resetView addSubview:pwdAgainLb];
    pwdAgainLb.text = @"新密码确认:";
    pwdAgainLb.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    resetPwdAgain = [[UITextField alloc] initWithFrame:CGRectMake(100, 54, 220, 40)];
    [resetView addSubview:resetPwdAgain];
    resetPwdAgain.font = [UIFont fontWithName:@"Helvetica" size:14];
    resetPwdAgain.placeholder = @"请再次输入新的登录密码";
    resetPwdAgain.secureTextEntry = YES;
    resetPwdAgain.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    resetPwdAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //-----边线
    UILabel *border1_r = [[UILabel alloc] initWithFrame:CGRectMake(10, 49, MAINSCREEN_WIDTH-20, 1)];
    [resetView addSubview:border1_r];
    border1_r.backgroundColor = VIEWBGCOLOR;
    
    UILabel *border2_r = [[UILabel alloc] initWithFrame:CGRectMake(10, 99, MAINSCREEN_WIDTH-20, 1)];
    [resetView addSubview:border2_r];
    border2_r.backgroundColor = VIEWBGCOLOR;
    
    nextStep = [[UIButton alloc] initWithFrame:CGRectMake(40, 190, MAINSCREEN_WIDTH-80, 50)];//高度--1
    [scrollView addSubview:nextStep];
    [nextStep.layer setMasksToBounds:YES];
    [nextStep.layer setCornerRadius:5];//设置矩形四个圆角半径
    nextStep.backgroundColor = TOPNAVIBGCOLOR;
    [nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStep setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [nextStep addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 260, MAINSCREEN_WIDTH-80, 50)];//高度--1
    [scrollView addSubview:backBtn];
    [backBtn.layer setMasksToBounds:YES];
    [backBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    backBtn.backgroundColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBackRootView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHidden:YES];
    
    //-----3.完成 view
    finishView = [[UIView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH, 50, MAINSCREEN_WIDTH, 80)];
    [contentArea addSubview:finishView];
    finishView.userInteractionEnabled = YES;
    
    UILabel *finishLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, MAINSCREEN_WIDTH-40, 40)];
    [finishView addSubview:finishLb];
    finishLb.textAlignment = NSTextAlignmentCenter;
    finishLb.text = @"恭喜你,密码设置成功!";
    finishLb.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 54, MAINSCREEN_WIDTH-40, 1)];
    [finishView addSubview:lineView];
    [lineView setImage:[UIImage imageNamed:@"line_success"]];
    
    UILabel *tipLb      = [[UILabel alloc] initWithFrame:CGRectMake(40, 44, MAINSCREEN_WIDTH-80, 80)];
    [finishView addSubview:tipLb];
    tipLb.numberOfLines = 2;
    tipLb.textAlignment = NSTextAlignmentCenter;
    tipLb.text          = @"为了您的账户安全\n请牢记登录密码并妥善保管";
    tipLb.textColor     = [UIColor grayColor];
    tipLb.font          = [UIFont fontWithName:@"Helvetica" size:14];
    
    //点击空白处关闭键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

//发送验证码
-(void)sendVerifyCode{
    // 发送验证码时先验证手机号是否注册
    NSString *regex_userName = @"^1[0-9]{10}$";//手机号
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_userName];
    //----点击确定隐藏键盘
    [userName resignFirstResponder];
    if(![pred evaluateWithObject:userName.text]){
        [userName becomeFirstResponder];//获取焦点
        [self.view makeToast:@"请填写正确手机号" duration:2.0 position:@"center"];
        return;
    }
    
    NSString *mobile = userName.text;
    [Waiting show];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0029",@"uId" : mobile};
    NSLog(@"hhthtgjiroejgoreoigeroi------%@",params);
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([temp isEqualToString:@"True"]) {
            //已注册
            //发送验证码
            [Waiting show];
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params = @{@"apiid": @"0077",@"mobile" : mobile};
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([temp isEqualToString:@"true"]) {
                    timerNumber = 60;
                    [self.view makeToast:@"验证码已发送,请注意查收" duration:1.2 position:@"center"];
                    verifyCodeBtn.layer.borderColor = [UIColor grayColor].CGColor;//灰色禁用
                    verifyCodeBtn.enabled = NO;
                    codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerShow) userInfo:nil repeats:YES];
                }else{
                    [self.view makeToast:@"发送失败,请稍后重试" duration:1.2 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"jgrioejgirejoige-----%@",error);
                [Waiting dismiss];//隐藏loading
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation start];
            
        }else{
            //未注册
            [self.view makeToast:@"此手机号尚未注册,请仔细核对" duration:1.2 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"jgrioejgirejoige-----%@",error);
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

//----1分钟倒计时
-(void)timerShow{
    if (timerNumber>0) {
        [verifyCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒",timerNumber] forState:UIControlStateDisabled];
        timerNumber--;
    }else{
        verifyCodeBtn.layer.borderColor = [UIColor redColor].CGColor;
        verifyCodeBtn.enabled = YES;
        [verifyCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [codeTimer invalidate];//--停止timer--
    }
    NSLog(@"timer:%d",timerNumber);

}

//----下一步---
-(void) goNext{
    switch (currentStep) {
        case VERIFYSTEP:{
            //--停止timer--
            if (timerNumber != 0) {
                [codeTimer invalidate];
            }
            //----点击确定隐藏键盘
            [self closeKeyboard];
            if ([userName.text isEqualToString:@""]) {
                [self.view makeToast:@"请输入正确的手机号码" duration:2.0 position:@"center"];
            } else if ([verifyCode.text isEqualToString:@""]) {
                [self.view makeToast:@"请输入正确的验证码" duration:2.0 position:@"center"];
            }else{
                [self checkVerifyCode];
            }
            break;
        }
        case RESETSTEP:{
            //----点击确定隐藏键盘
            [self closeKeyboard];
            [self modifyPwd];//重置密码
            break;
        }
        case FINISHSTRP:{
            //返回登录界面
            [verifyView removeFromSuperview];
            [resetView removeFromSuperview];
            [self onClickBack];
            break;
        }
    }
}
//------验证码校验
-(void)checkVerifyCode{
    NSString *mobile = userName.text;
    NSString *vcode = verifyCode.text;
    NSString * regex_code = @"[a-zA-Z0-9]{4}";//密码
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_code];
    if ([pred evaluateWithObject:vcode]) {
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0078",@"mobile" : mobile,@"vcode" : vcode};
        NSLog(@"rewrwgjiroejgoreoigeroi------%@",params);
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString *temp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"fewfwjgirejiogejoig-----%@",temp);
            if ([temp isEqualToString:@"true"]) {
                //-----动画,view左滑-------
                [UIView animateWithDuration:0.4 animations:^{
                    CGRect frame = verifyView.frame;
                    frame.origin.x = -MAINSCREEN_WIDTH;
                    verifyView.frame = frame;
                    
                    CGRect frame1 = resetView.frame;
                    frame1.origin.x = 0;
                    resetView.frame = frame1;
                } completion:^(BOOL finished){
                    verifyLb.textColor = [UIColor colorWithRed:190.0/255 green:0.0 blue:7.0/255 alpha:1.0];
                    confirmLb.textColor       = [UIColor grayColor];
                    [confirmImage setImage:[UIImage imageNamed:@"step_off"]];
                    [verifyImage setImage:[UIImage imageNamed:@"step_on"]];
                    [nextStep setTitle:@"完成" forState:UIControlStateNormal];
                    currentStep = RESETSTEP;
                }];
            }else{
                [verifyCode becomeFirstResponder];//获取焦点
                [self.view makeToast:@"验证码错误,请重新输入" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"jgrioejgirejoige-----%@",error);
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }else{
        [verifyCode becomeFirstResponder];//获取焦点
        [self.view makeToast:@"验证码错误,请重新输入" duration:2.0 position:@"center"];
    }

}
//------修改密码
-(void)modifyPwd{
    NSString *username = userName.text;
    NSString *pwd = resetPwd.text;
    NSString *pwdAgain = resetPwdAgain.text;
    NSString * regex_userPwd = @"[a-zA-Z0-9@=_+]{6,20}";//密码
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_userPwd];
    if(![pred evaluateWithObject:pwd]){
        [self.view makeToast:@"请填写6-20位密码数字,字母或@_+符号" duration:2.0 position:@"center"];
    }else if(![pwd isEqualToString:pwdAgain]){
        [self.view makeToast:@"两次输入密码不一致" duration:2.0 position:@"center"];
    }else{
        [Waiting show];
        //--所有字段格式都正确,可以注册
        NSLog(@"-------checkLogin-------%@,%@",pwd,pwdAgain);
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0048",@"mid" : username,@"pwd": pwd};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"eowpiqpiepqeq-----%@--%@",source,params);
            if([source isEqualToString:@"true"]){
                //-----动画,view左滑-------
                [UIView animateWithDuration:0.4 animations:^{
                    CGRect frame = resetView.frame;
                    frame.origin.x = -MAINSCREEN_WIDTH;
                    resetView.frame = frame;
                    
                    CGRect frame1 =finishView.frame;
                    frame1.origin.x = 0;
                    finishView.frame = frame1;
                } completion:^(BOOL finished){
                    resetLb.textColor = [UIColor colorWithRed:190.0/255 green:0.0 blue:7.0/255 alpha:1.0];
                    verifyLb.textColor        = [UIColor grayColor];
                    [verifyImage setImage:[UIImage imageNamed:@"step_off"]];
                    [resetImage setImage:[UIImage imageNamed:@"step_on"]];
                    [nextStep setTitle:@"马上登录" forState:UIControlStateNormal];
                    currentStep = FINISHSTRP;
                    [backBtn setHidden:NO];
                }];
            }else{
                [self.view makeToast:@"修改密码失败,请稍后重试" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            [Waiting dismiss];//隐藏loading
        }];
        [operation start];
    }
}

//关闭键盘
-(void)closeKeyboard{
    if ([userName isFirstResponder]) {
        [userName resignFirstResponder];
    }else if ([verifyCode isFirstResponder]){
        [verifyCode resignFirstResponder];
    }else if ([resetPwd isFirstResponder]){
        [resetPwd resignFirstResponder];
    }else if([resetPwdAgain isFirstResponder]){
        [resetPwdAgain resignFirstResponder];
    }
}

-(void)goBackRootView{
    [verifyView removeFromSuperview];
    [resetView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
