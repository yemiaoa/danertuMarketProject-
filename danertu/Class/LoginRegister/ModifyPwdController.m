//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

//-----商品详细页----


#import "ModifyPwdController.h"
#import <QuartzCore/QuartzCore.h>

@interface ModifyPwdController (){
}
@end

@implementation ModifyPwdController
@synthesize defaults;
@synthesize scrollView;
@synthesize _userName;
@synthesize _userPwd;
@synthesize _userPwdAgain;
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
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    defaults =[NSUserDefaults standardUserDefaults];
    
    //----------页面表单
    scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height)];//上半部分
    scrollView.backgroundColor = [UIColor whiteColor];;//淡灰色
    [self.view addSubview:scrollView];
    
    //登陆表单
    UIView *loginFormArea = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN_WIDTH, 300)];//高度--134
    [scrollView addSubview:loginFormArea];
    loginFormArea.userInteractionEnabled = YES;//才可以点击它上面的textfield,
    loginFormArea.backgroundColor = [UIColor clearColor];
    
    UIFont *testFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    UIView *loginInput = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 135)];
    [loginFormArea addSubview:loginInput];
    loginInput.userInteractionEnabled = YES;//才可以点击它上面的textfield,
    
    UILabel *unameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [loginInput addSubview:unameLb];
    [unameLb setFont:testFont];
    unameLb.text = @"旧密码:";
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];//高度--44
    [loginInput addSubview:_userName];
    [_userName setFont:testFont];
    _userName.delegate = self;
    _userName.placeholder = @"请输入旧密码";
    _userName.secureTextEntry = YES;
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //边线
    UILabel *borderLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 280, 0.8)];//高度--1
    [loginInput addSubview:borderLine2];
    borderLine2.backgroundColor = BORDERCOLOR;
    
    UILabel *upwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 60, 44)];
    [loginInput addSubview:upwdLb];
    [upwdLb setFont:testFont];
    upwdLb.text = @"新密码:";
    //密码
    _userPwd = [[UITextField alloc] initWithFrame:CGRectMake(60,45, 200, 44)];//高度--44
    [loginInput addSubview:_userPwd];
    [_userPwd setFont:testFont];
    _userPwd.delegate = self;
    _userPwd.placeholder = @"6-15位数字或字母";
    _userPwd.secureTextEntry = YES;
    _userPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //边线
    UILabel *borderLine3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, 280, 0.8)];//高度--1
    [loginInput addSubview:borderLine3];
    borderLine3.backgroundColor = BORDERCOLOR;
    
    UILabel *upwdAgainLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 80, 44)];
    [loginInput addSubview:upwdAgainLb];
    [upwdAgainLb setFont:testFont];
    upwdAgainLb.text = @"确认密码:";
    //密码
    _userPwdAgain = [[UITextField alloc] initWithFrame:CGRectMake(80,90, 180, 44)];//高度--44
    [loginInput addSubview:_userPwdAgain];
    [_userPwdAgain setFont:testFont];
    _userPwdAgain.delegate = self;
    _userPwdAgain.placeholder = @"请再次输入新密码";
    _userPwdAgain.secureTextEntry = YES;
    _userPwdAgain.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userPwdAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *borderLine4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 134, 280, 0.8)];//高度--1
    [loginInput addSubview:borderLine4];
    borderLine4.backgroundColor = BORDERCOLOR;

    //login  button
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 200, MAINSCREEN_WIDTH-80, 40)];//高度--44
    [loginFormArea addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    
    loginBtn.backgroundColor = TOPNAVIBGCOLOR;
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onClickRegister) forControlEvents:UIControlEventTouchUpInside];

}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"修改密码";
}
//----跳转忘记密码页面页面---
-(void) goRegister{
    NSLog(@"goRegister------");
}
//----跳转注册页面---
-(void) goForgetPwd{
    NSLog(@"goForgetPwd------");
}
//-----注册
-(void) onClickRegister{
    NSString *uName = _userName.text;
    NSString *uPwd = _userPwd.text;
    NSLog(@"-------uName:%@-----uPwd:%@----",uName,uPwd);
    [self checkRegister];
}
-(void) checkRegister{
    NSString *userNameVal = _userName.text;
    NSString *userPwdVal = _userPwd.text;
    NSString *userPwdAgainVal = _userPwdAgain.text;
    NSString * regex_userPwd = @"[a-zA-Z0-9]{6,15}";//密码
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_userPwd];
    //----点击确定隐藏键盘
    [_userName resignFirstResponder];
    [_userPwd resignFirstResponder];
    NSString *telNo = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
    if(userNameVal.length==0){
        if ([_userName isFirstResponder]) {
            [_userName resignFirstResponder];
        }
//        [_userName becomeFirstResponder];//获取焦点
        [self.view makeToast:@"请填写正确旧密码" duration:2.0 position:@"center"];
    }else{
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_userPwd];
        if(![pred evaluateWithObject:userPwdVal]){
            [self.view makeToast:@"请填写6-15位密码数字或字母" duration:2.0 position:@"center"];
        }else if([userPwdVal isEqualToString:userNameVal]){
            [self.view makeToast:@"新密码与旧密码相同,请更换" duration:2.0 position:@"center"];
        }else if(![userPwdVal isEqualToString:userPwdAgainVal]){
            [self.view makeToast:@"两次输入密码不一致" duration:2.0 position:@"center"];
        }else{
            [Waiting show];
            //--所有字段格式都正确,可以注册
            NSLog(@"-------checkLogin-------%@,%@",_userName.text,_userPwd.text);
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params = @{@"apiid": @"0048",@"mid" : telNo,@"pwd": userPwdVal,@"oldpwd":userNameVal};
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];//隐藏loading
                NSString* source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"eowpiqpiepqeq-----%@",source);
                if([source isEqualToString:@"true"]){
                    /*
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResultInfo" object:_userName userInfo:nb];//object 和 userInfo都可以传值
                     */
                    [_userName resignFirstResponder];
                    [_userPwd resignFirstResponder];
                    [_userPwdAgain resignFirstResponder];
                    [self.view makeToast:@"修改密码成功,请使用新密码重新登录" duration:2.0 position:@"center"];
                    [defaults removeObjectForKey:@"userLoginInfo"] ;//删除当前登录状态
                    //-----注册成功切换到登陆-----
                    [self performSelector:@selector(backTo) withObject:nil afterDelay:2.0f];
                }else{
                    [_userName becomeFirstResponder];
                    [self.view makeToast:@"修改密码失败,请重新输入旧密码" duration:2.0 position:@"top"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"gkerojtriojhirhor------%@--%@",error,params);
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"top"];
                [Waiting dismiss];//隐藏loading
            }];
            [operation start];
        }
    }
}
-(void)backTo{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
