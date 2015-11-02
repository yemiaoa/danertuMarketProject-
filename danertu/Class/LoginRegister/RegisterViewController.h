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

@interface RegisterViewController : TopNaviViewController
@property (nonatomic, strong)NSUserDefaults *defaults;
@property (nonatomic, strong) UIView *scrollView;//页面内容的view
@property (nonatomic, strong) UITextField *_userName;
@property (nonatomic, strong) UITextField *_userPwd;
@property (nonatomic, strong) UITextField *_userPwdAgain;
@property (nonatomic) int addStatusBarHeight;
@end
