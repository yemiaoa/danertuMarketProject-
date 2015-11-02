//
//  DetailViewController.h
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIView+Toast.h"

#import "UIDevice+IdentifierAddition.h"
//#import "MyKeyChainHelper.h"
#import "TopNaviViewController.h"

typedef enum stepNo{
    VERIFYSTEP,
    RESETSTEP,
    FINISHSTRP
} stepNo_enum;
@interface FindPwdController : TopNaviViewController
@property (nonatomic) stepNo_enum currentStep;//----当前步骤----1,2,3
@property (nonatomic, strong)NSUserDefaults *defaults;
@property (nonatomic, strong) UIView *scrollView;//页面内容的view
@property (nonatomic, strong) UITextField *userName;//用户名
@property (nonatomic, strong) UITextField *verifyCode;//短信验证码
@property (nonatomic, strong) UITextField *resetPwd;//新密码
@property (nonatomic, strong) UITextField *resetPwdAgain;//新密码确认

@property (nonatomic, strong) UIView *verifyView;
@property (nonatomic, strong) UIView *resetView;
@property (nonatomic, strong) UIView *finishView;

@property (nonatomic, strong) UILabel *confirmLb;
@property (nonatomic, strong) UILabel *verifyLb;
@property (nonatomic, strong) UILabel *resetLb;
@property (nonatomic, strong) UILabel *telNoLb;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *nextStep;
@property (nonatomic, strong) UIButton *verifyCodeBtn;//获取手机验证码

@property (nonatomic) int addStatusBarHeight;
@property (nonatomic) int timerNumber;
@property (nonatomic, strong) NSTimer *codeTimer;
@end
