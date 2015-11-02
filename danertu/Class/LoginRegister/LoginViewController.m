//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

//-----商品详细页----


#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize defaults;
@synthesize scrollView;
@synthesize userName;
@synthesize userPwd;
@synthesize addStatusBarHeight;

- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];   //初始化
    [self initView];
}

//界面初始化的方法
- (void)initialization
{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
}

- (void)initView
{
    //----------页面表单
    scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height)];//上半部分
    scrollView.backgroundColor = [UIColor whiteColor];;//淡灰色
    [self.view addSubview:scrollView];
    
//    //登陆表单
//    UIView *loginFormArea = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN_WIDTH, 300)];//高度--134
//    [scrollView addSubview:loginFormArea];
//    loginFormArea.userInteractionEnabled = YES;//才可以点击它上面的textfield,
//    loginFormArea.backgroundColor = [UIColor clearColor];
//    
//    UIView *loginInput = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 90)];
//    [loginFormArea addSubview:loginInput];
//    loginInput.backgroundColor = [UIColor whiteColor];
//    loginInput.userInteractionEnabled = YES;//才可以点击它上面的textfield,
//    loginInput.layer.cornerRadius = 5;
//    loginInput.layer.borderWidth = 1;
//    loginInput.layer.borderColor = BORDERCOLOR.CGColor;
    
    CGFloat labelY = 10;
    CGFloat labelX = 10;
    CGFloat labelH = 60;
    UILabel *unameLb = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 80, labelH)];
    unameLb.backgroundColor = [UIColor clearColor];
    unameLb.textAlignment = NSTextAlignmentLeft;
    unameLb.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [scrollView addSubview:unameLb];//
    unameLb.text = @"登录账户:";
    //userName
    userName = [[UITextField alloc] initWithFrame:CGRectMake(labelX + unameLb.frame.size.width, labelY, SCREENWIDTH - 5 - (labelX + unameLb.frame.size.width), labelH)];//高度--44
    [scrollView addSubview:userName];
    userName.delegate = self;
    userName.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    userName.backgroundColor = [UIColor clearColor];
    userName.layer.borderColor = [UIColor clearColor].CGColor;
    userName.layer.borderWidth = 0;
    userName.placeholder = @"请输入登录账户";
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    userName.keyboardType = UIKeyboardTypeNamePhonePad;
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    labelY = labelY + labelH;
    //边线
    UILabel *borderLine2 = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, SCREENWIDTH - labelX, 0.5)];//高度--1
    [scrollView addSubview:borderLine2];
    borderLine2.backgroundColor = [UIColor colorWithWhite:137.0 / 255.0 alpha:1.0];
    
    UILabel *upwdLb = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 80, labelH)];
    upwdLb.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:upwdLb];//
    upwdLb.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    upwdLb.text = @"登录密码:";
    //密码
    userPwd = [[UITextField alloc] initWithFrame:CGRectMake(labelX + upwdLb.frame.size.width,labelY, SCREENWIDTH - 5 - (labelX + upwdLb.frame.size.width), labelH)];//高度--44
    userPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scrollView addSubview:userPwd];
    userPwd.delegate = self;
    userPwd.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    userPwd.placeholder = @"请输入密码";
    userPwd.backgroundColor = [UIColor clearColor];
    userPwd.layer.borderColor = [UIColor clearColor].CGColor;
    userPwd.layer.borderWidth = 0;
    userPwd.secureTextEntry = YES;
    userPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    labelY = labelY + labelH;
    //边线
    UILabel *borderLine3 = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, SCREENWIDTH - labelX, 0.5)];//高度--1
    [scrollView addSubview:borderLine3];
    borderLine3.backgroundColor = [UIColor colorWithWhite:137.0 / 255.0 alpha:1.0];
    
    //忘记密码按钮
    UIButton *forPwdText = [[UIButton alloc] initWithFrame:CGRectMake(labelX, labelY, 100, labelH)];//高度--1
    [forPwdText.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:forPwdText];
    forPwdText.titleLabel.font = TEXTFONT;
    [forPwdText.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    forPwdText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forPwdText setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    [forPwdText setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forPwdText setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [forPwdText addTarget:self action:@selector(goForgetPwd) forControlEvents:UIControlEventTouchUpInside];
    
    labelY = labelY + labelH + 20;
    CGFloat buttonX = 20;
    CGFloat buttonW = SCREENWIDTH - 2 * buttonX;
    CGFloat buttonH = 40;
    
    //login  button
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, labelY, buttonW, buttonH)];//高度--44
    [scrollView addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    labelY = labelY + buttonH + 20;
    //免费注册
    UIButton *registerText = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, labelY, buttonW, buttonH)];//高度--1
    [scrollView addSubview:registerText];
    [registerText.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [registerText.layer setMasksToBounds:YES];
    [registerText.layer setCornerRadius:5];//设置矩形四个圆角半径
    registerText.backgroundColor = [UIColor colorWithWhite:213.0 / 255.0 alpha:1.0];
//    registerText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerText setTitle:@"免费注册" forState:UIControlStateNormal];
    [registerText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerText setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [registerText addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    //self.view的触摸手势，触摸弹下键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishEdit:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

//取消键盘第一响应者
- (void)finishEdit:(UITapGestureRecognizer *)ges
{
    if ([userName isFirstResponder]) {
        [userName resignFirstResponder];
    }
    else if ([userPwd isFirstResponder]) {
        [userPwd resignFirstResponder];
    }
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"登录";
}

//----跳转忘记密码页面页面---
-(void) goForgetPwd{
    
    FindPwdController *findV = [[FindPwdController alloc]init];
    findV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findV animated:YES];
}

//----跳转注册页面---
-(void) goRegister{
    
    RegisterViewController *findV = [[RegisterViewController alloc]init];
    findV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findV animated:YES];
    NSLog(@"goRegister------");
}

//-----登录
-(void) onClickLogin
{
    [self performSelector:@selector(finishEdit:) withObject:nil afterDelay:0];
    [self checkLogin];
}
-(void) checkLogin{
    NSString *userNameVal = userName.text;
    NSString *userPwdVal = userPwd.text;

    if(userNameVal.length>0&&userPwdVal.length>5&&userPwdVal.length<16){
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0038",@"uid" : userName.text,@"pwd": userPwd.text};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loading
            
            NSString *jsonDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            jsonDataStr = [jsonDataStr stringByReplacingOccurrencesOfString:@"•	" withString:@""];
            NSData *jsonDataTmp = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
            NSArray* temp = [jsonData objectForKey:@"val"];//数组
            
            if(temp.count > 0){
                NSDictionary *rootDic = temp[0];
                [defaults setObject:rootDic forKey:@"userLoginInfo"];//本地存储
                [[NSUserDefaults standardUserDefaults] synchronize];//强制写入,保存数据

                [self cleanOldAccountInfo];
                //登录成功,返回之前页面
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginSucceed" object:nil]];
                [self.view makeToast:@"登录成功" duration:1 position:@"center"];
                [self performSelector:@selector(backTo) withObject:nil afterDelay:1.0f];
                [self checkFirstInstall];   //-------登录成功-----检测是否第一次安装,加分
                
            }else{
                [self.view makeToast:@"登录失败,请确认用户名或密码" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            [Waiting dismiss];  //隐藏loading
        }];
        [operation start];
    }else{
        [self.view makeToast:@"请正确填写用户名或密码登录" duration:2.0 position:@"center"];
    }
}

//清除上一个账号在本地缓存的头像信息
- (void)cleanOldAccountInfo{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    if ([fileManager fileExistsAtPath:filePath]) {
        if ([Tools isUserAccountChanged]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}

//返回
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
//-------检测是否第一次安装--------
- (void) checkFirstInstall{
    [Waiting show];//----loading-----
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0062",@"mcode" :[[UIDevice currentDevice] uniqueDeviceIdentifier]};
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([source isEqualToString:@"false"]) {
            //------063-----
            AFHTTPClient * client_a = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params_a = @{@"apiid": @"0063",@"mcode" :[[UIDevice currentDevice] uniqueDeviceIdentifier]};
            NSURLRequest * request_a = [client_a requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params_a];
            AFHTTPRequestOperation * operation_a = [client HTTPRequestOperationWithRequest:request_a success:^(AFHTTPRequestOperation *operation_a, id responseObject_a) {
                [Waiting dismiss];//隐藏loading
                NSString* source_a = [[NSString alloc] initWithData:responseObject_a encoding:NSUTF8StringEncoding];
                NSLog(@"jovjeopbjopgjepr-----AAA--%@-----%@",source_a,[[UIDevice currentDevice] uniqueDeviceIdentifier]);
            }failure:^(AFHTTPRequestOperation *operation_a, NSError *error) {
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation_a start];
            //-----061------接口
            AFHTTPClient * client_b = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params_b = @{@"apiid": @"0061",@"mid" :userName.text,@"score" :@"500"};
            NSURLRequest * request_b = [client_b requestWithMethod:@"POST"
                                                              path:@""
                                                        parameters:params_b];
            AFHTTPRequestOperation * operation_b = [client_b HTTPRequestOperationWithRequest:request_b success:^(AFHTTPRequestOperation *operation_b, id responseObject_b) {
                [Waiting dismiss];//隐藏loading
                NSString* source_b = [[NSString alloc] initWithData:responseObject_b encoding:NSUTF8StringEncoding];
               
                if ([source_b isEqualToString:@"true"]) {
                    int gameScore = 500;
                    gameScore = gameScore + [[[defaults objectForKey:@"userLoginInfo"] objectForKey:@"Score"] intValue];
                    NSDictionary *nb = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:gameScore],@"Score", nil];
                    NSMutableDictionary *tmp = [[defaults objectForKey:@"userLoginInfo"] mutableCopy] ;
                    [tmp setObject:[NSString stringWithFormat:@"%d",gameScore] forKey:@"Score"];//----修改分数---
                    [defaults setObject:tmp forKey:@"userLoginInfo"];//----保存登录信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlareScore" object:nil userInfo:nb];//刷新Myview上显示的-------分数
                }
            }failure:^(AFHTTPRequestOperation *operation_b, NSError *error) {
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation_b start];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
