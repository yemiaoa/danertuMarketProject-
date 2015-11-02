//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

//-----商品详细页----


#import "AccountSecurityController.h"
@interface AccountSecurityController (){
}
@end

@implementation AccountSecurityController
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
    scrollView.backgroundColor = VIEWBGCOLOR;;//淡灰色
    [self.view addSubview:scrollView];
    
    //登陆表单
    UIView *loginFormArea = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN_WIDTH, 40)];//高度--134
    [scrollView addSubview:loginFormArea];
    loginFormArea.userInteractionEnabled = YES;//才可以点击它上面的textfield,
    loginFormArea.backgroundColor = [UIColor whiteColor];
    
    UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 40)];
    [loginFormArea addSubview:item];
    item.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goModifyPwd)];
    [item addGestureRecognizer:singleTap];//---添加点击事件
    
    UILabel *modifyPwd = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 40)];
    [item addSubview:modifyPwd];//
    modifyPwd.text = @"修改密码";
    
    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(290, 0, 10, 40)];
    [item addSubview:arrow];
    arrow.text = @">";
    //边线
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 1)];//高度--1
    [item addSubview:borderLine];
    borderLine.backgroundColor = BORDERCOLOR;
    //边线
    UILabel *borderLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MAINSCREEN_WIDTH, 1)];//高度--1
    [item addSubview:borderLine1];
    borderLine1.backgroundColor = BORDERCOLOR;
}

//-----修改标题,重写父类方法----
-(NSString*)getTitle{
    return @"账户安全";
}
//----跳转忘记密码页面页面---
-(void) goModifyPwd{
    ModifyPwdController *findV = [[ModifyPwdController alloc]init];
    findV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findV animated:YES];
}
//----跳转注册页面---
-(void) goForgetPwd{
    
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
